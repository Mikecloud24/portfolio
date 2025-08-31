# Infra demo using Terraform to provision ACR, AKS and aks role assignment


# The complete demo code CICD end-to-end Terraform automation workflow is in my private repo.  The project involves:

1. create Azure Resources [AKS, ACR, Storage, Networking, Azure key Vault...]
  
2. configure RBAC
  
3. Deploy a .NET App to AKS
   
4. Integrate Terraform into Azure DevOps
  
5. A custom shell script that performs kubernetes health check (nodes and pods) CPU, Memory and disk. This is integrated as a post-deployment step via kubernetes manifest using Bash task.
    
6.  Before the Dockerized app is deployed to AKS cluster, SonarQube is integrated for code quality analysis
   
7. deployment manifest file
   
8. service file
   
9. Dockerfile
    
10. etc


# ![image](https://github.com/user-attachments/assets/04cc2373-dc49-4676-806c-665696787fa0)


# ![image](https://github.com/user-attachments/assets/ac3cc0ed-940b-494f-baa3-ac8391becb2e)



# You can use the following Terraform command to destroy the infra provision via this code, first run

1. <terraform plan -destroy -out main.destroy.tfplan>   (This is important if you used -out flag to save your plan before you provision the infra, otherwise use terraform destroy)

2. <terraform apply main.destroy.tfplan>   (This is important if you used -out flag to save your plan before you provision the infra, otherwise use terraform destroy)   
