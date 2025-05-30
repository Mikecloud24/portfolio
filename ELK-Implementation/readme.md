# This document provides a step-by-step guide to setting up the ELK Stack (Elasticsearch, Logstash, 
# Kibana) with Filebeat to monitor logs from a Java application running on AWS EC2 instance (Ubuntu). 


# 1. Overview of ELK Stack 
# The ELK Stack consists of: 

- Elasticsearch >>> Stores and indexes logs. 
- Logstash >>> Processes and transforms logs before storing them in Elasticsearch. 
- Kibana >>> Provides visualization and analysis of logs. 
- Filebeat >>> Forwards logs from the application to Logstash. 


# 2. Infrastructure Setup 
# We are using two EC2 Ubuntu machines, the third one is optional: 

1. ELK Server >>> Hosts Elasticsearch, Logstash, Kibana. 
2. Client Machine >>> Hosts Java application and Filebeat. 
3. Web Server (Optional) >>> Hosts an additional application for testing logs. 

## Check out the step-by-step implementation doc (ELK.md)

# Note: Be sure to configure the necessary Security Group of the EC2 instances for ELK server, Client Machine (Inbound Rule) etc 
# Port 22 for ssh, 443 for https, custom tcp port range, etc