A)	AKS Secret Key vault:
Create resource group:
az group create --name akssecret_rg --location australiaeast

B)	AKS Creation and Configuration:
Create an AKS cluster with Azure Key Vault provider for Secrets Store CSI Driver support:
az aks create --name ethagbeaks -g akssecret_rg --node-count 1 --enable-addons azure-keyvault-secrets-provider --enable-oidc-issuer --enable-workload-identity --generate-ssh-key 

C)	Get the Kubernetes cluster credentials (Update kubeconfig):

1.	az aks get-credentials --resource-group akssecret_rg --name ethagbeaks

2.	kubectl config current-context           ( to know the current context you are working on)


D)	Verify that each node in your cluster's node pool has a Secrets Store CSI Driver pod and a Secrets Store Provider Azure pod running:
kubectl get pods -n kube-system -l 'app in (secrets-store-csi-driver,secrets-store-provider-azure)' -o wide

E)	Keyvault creation and configuration:
Create a key vault with Azure role-based access control (Azure RBAC):
az keyvault create -n eruaakskeyvault -g akssecret_rg -l australiaeast --enable-rbac-authorization

F)	Connect your Azure ID to the Azure Key Vault Secrets Store CSI Driver:
Configure workload identity (setting your variables):
export SUBSCRIPTION_ID=< your subscription ID>
export RESOURCE_GROUP=akssecret_rg
export UAMI=azurekeyvaultsecretsprovider-ethagbeaks
export KEYVAULT_NAME=eruaakskeyvault
export CLUSTER_NAME=ethagbeaks

az account set --subscription $SUBSCRIPTION_ID

G)	Create a managed identity:
az identity create --name $UAMI --resource-group $RESOURCE_GROUP

export USER_ASSIGNED_CLIENT_ID="$(az identity show -g $RESOURCE_GROUP --name $UAMI --query 'clientId' -o tsv)"
export IDENTITY_TENANT=$(az aks show --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --query identity.tenantId -o tsv)

H)	Create a role assignment that grants the workload ID access to the key vault:
export KEYVAULT_SCOPE=$(az keyvault show --name $KEYVAULT_NAME --query id -o tsv)

az role assignment create --role "Key Vault Administrator" --assignee $USER_ASSIGNED_CLIENT_ID --scope $KEYVAULT_SCOPE

I)	Get the AKS cluster OIDC Issuer URL:
export AKS_OIDC_ISSUER="$(az aks show --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME --query "oidcIssuerProfile.issuerUrl" -o tsv)"
echo $AKS_OIDC_ISSUER

J)	Create the service account for the pod using MS Doc:
export SERVICE_ACCOUNT_NAME="workload-identity-sa"
export SERVICE_ACCOUNT_NAMESPACE="default"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: ${USER_ASSIGNED_CLIENT_ID}
  name: ${SERVICE_ACCOUNT_NAME}
  namespace: ${SERVICE_ACCOUNT_NAMESPACE}
EOF

K)	Setup Federation:

export FEDERATED_IDENTITY_NAME="myaksfederatedidentity" 

az identity federated-credential create --name $FEDERATED_IDENTITY_NAME --identity-name $UAMI --resource-group $RESOURCE_GROUP --issuer ${AKS_OIDC_ISSUER} --subject system:serviceaccount:${SERVICE_ACCOUNT_NAMESPACE}:${SERVICE_ACCOUNT_NAME}


L)	Create the Secret Provider Class:

cat <<EOF | kubectl apply -f -
# This is a SecretProviderClass example using workload identity to access your key vault
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: eruaakskeyvault-ki           # needs to be unique per namespace
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    clientID: "${USER_ASSIGNED_CLIENT_ID}" # Setting this to use workload identity
    keyvaultName: ${KEYVAULT_NAME}       # Set to the name of your key vault
    cloudName: ""                         # [OPTIONAL for Azure] if not provided, the Azure environment defaults to AzurePublicCloud
    objects:  |
      array:
        - |
          objectName: ethagbesecret             # Set to the name of your secret
          objectType: secret              # object types: secret, key, or cert
          objectVersion: ""               # [OPTIONAL] object versions, default to latest if empty
        - |
          objectName: ethagbeKeys                # Set to the name of your key
          objectType: key
          objectVersion: ""
    tenantId: "${IDENTITY_TENANT}"        # The tenant ID of the key vault
EOF


M)	Verify Keyvault AKS Integration:
Create a sample pod to mount the secrets or you can use an existing pods if any and make sure the volume is mounted properly and use the right SecretProviderClass:

cat <<EOF | kubectl apply -f -
# This is a sample pod definition for using SecretProviderClass and workload identity to access your key vault
kind: Pod
apiVersion: v1
metadata:
  name: busybox-secrets-store-inline-ki
  labels:
    azure.workload.identity/use: "true"
spec:
  serviceAccountName: "workload-identity-sa"
  containers:
    - name: busybox
      image: registry.k8s.io/e2e-test-images/busybox:1.29-4
      command:
        - "/bin/sleep"
        - "10000"
      volumeMounts:
      - name: secrets-store01-inline
        mountPath: "/mnt/secrets-store"
        readOnly: true
  volumes:
    - name: secrets-store01-inline
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: "eruaakskeyvault-ki"
EOF


List the contents of the volume:

kubectl exec busybox-secrets-store-inline-wi -- ls /mnt/secrets-store/

Verify the contents in the file:
kubectl exec busybox-secrets-store-inline -- cat /mnt/secrets-store/foo-secret
# change <foo-secret> to your secret name


NB:
If there are any issue creating the pods (eg, container status creating), use the following to troubleshoot
1.	kubectl get pods
2.	kubectl describe pods <pod name>



Delete Everything if you no longer need the resources:
az group delete --name <your resource group name>


One of my POC