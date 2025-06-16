
### HashiCorp (HCL) Vault Implementation Steps,
### this is an enterprise edition Vault KV v2 Injection

- Create Namespace for Vault

- Add Helm Repo and Install Vault with Raft HA

- Expose Vault Using LoadBalancer

- Initialize Vault (Run Once)

- Unseal Vault on All Pods

- Login to Vault

- Enable Kubernetes Authentication

- Create Service Account for App Pods

- Configure Kubernetes Auth in Vault

- Create Vault Policy

- Create Role in Vault to Map Pod to Policy

- Store Secrets in Vault

- Create YAML Manifest File (With Below Configurations)

   -  Example annotation block for a pod


annotations:
  vault.hashicorp.com/agent-inject: "true"
  vault.hashicorp.com/role: "vault-role"
  vault.hashicorp.com/agent-inject-secret-MYSQL_ROOT_PASSWORD: "secret/mysql"
  vault.hashicorp.com/agent-inject-template-MYSQL_ROOT_PASSWORD: |
    {{- with secret "secret/mysql" -}}
    export MYSQL_ROOT_PASSWORD="{{ .Data.data.MYSQL_ROOT_PASSWORD }}"
    {{- end }}



- The sidecar Vault Agent will:
  - Authenticate using service account token
  - Fetch secrets from Vault
  - Write them to /vault/secrets/...in the pod


# For other prerequisite and configurations, please contact me.