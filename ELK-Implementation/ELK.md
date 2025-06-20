# 1. Step-by-Step Installation guide

# Step 1: Install & Configure Elasticsearch (ELK Server) 

# 1.1 Install Java (Required for Elasticsearch & Logstash) 

sudo apt update && sudo apt install openjdk-17-jre-headless -y 

# 1.2 Install Elasticsearch 

######
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - 
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee 
/etc/apt/sources.list.d/elastic-7.x.list 
######

sudo apt update 
sudo apt install elasticsearch -y 


# 1.3 Configure Elasticsearch 

sudo vi /etc/elasticsearch/elasticsearch.yml                       # open the .yml file and modify it according to your configuration

Modify: 
######
network.host: 0.0.0.0 
cluster.name: my-cluster  
node.name: node-1 
discovery.type: single-node
###### 

# 1.4 Start & Enable Elasticsearch 

sudo systemctl start elasticsearch 
sudo systemctl enable elasticsearch 
sudo systemctl status elasticsearch 


# 1.5 Verify Elasticsearch 

curl -X GET "http://localhost:9200" 



# Step 2: Install & Configure Logstash (ELK Server) 


# 2.1 Install Logstash 

sudo apt install logstash -y 

# 2.2 Configure Logstash to Accept Logs 

sudo vi /etc/logstash/conf.d/logstash.conf                             # modify the logstash config file and add the following code


Add: 

######
input { 
beats { 
port => 5044 
} 
} 
filter { 
grok { 
match => { "message" => "%{TIMESTAMP_ISO8601:log_timestamp} %{LOGLEVEL:log_level} 
%{GREEDYDATA:log_message}" } 
} 
} 
output { 
elasticsearch { 
hosts => ["http://localhost:9200"] 
index => "logs-%{+YYYY.MM.dd}" 
} 
stdout { codec => rubydebug } 
} 
######


# 2.3 Start & Enable Logstash 

sudo systemctl start logstash 
sudo systemctl enable logstash 
sudo systemctl status logstash 


# 2.4 Allow Traffic on Port 5044                                      # specify your desired port from SG

sudo ufw allow 5044/tcp 


# Step 3: Install & Configure Kibana (ELK Server) 

# 3.1 Install Kibana 

sudo apt install kibana -y 

# 3.2 Configure Kibana 

sudo vi /etc/kibana/kibana.yml                                            # open the kibana file and modify


Modify: 

######
server.host: "0.0.0.0" 
elasticsearch.hosts: ["http://localhost:9200"] 
######


# 3.3 Start & Enable Kibana 

sudo systemctl start kibana 
sudo systemctl enable kibana 
sudo systemctl status kibana 


# 3.4 Allow Traffic on Port 5601                                            # specify your port

sudo ufw allow 5601/tcp 


# 3.5 Access Kibana Dashboard 

Open a browser and go to: 

http://<ELK_Server_Public_IP>:5601                              # obtain your instance public IP and map it to your open port


# Step 4: Install & Configure Filebeat (Client Machine) 


# 4.1 Install Filebeat and clone your application repo to be monitor

######
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add - 
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee 
/etc/apt/sources.list.d/elastic-7.x.list 
sudo apt update 
sudo apt install filebeat -y 
######

# 4.2 Configure Filebeat to Send Logs to Logstash 

sudo vi /etc/filebeat/filebeat.yml                             # open the file to modify and take note of your target folder name

Modify: 

######
filebeat.inputs: - type: log 
enabled: true 
paths: - /home/ubuntu/<your app name>/target/app.log 
######


# 4.3 Start & Enable Filebeat 

sudo systemctl start filebeat 
sudo systemctl enable filebeat 
sudo systemctl status filebeat 


# 4.4 Verify Filebeat is Sending Logs 

sudo filebeat test output 


# Step 5: Deploy Java Application & Generate Logs 

# 5.1 Install Java (If Not Installed) 

sudo apt install openjdk-17-jre-headless -y 

# 5.2 Download & Run Sample Java App 

######
wget https://repo1.maven.org/maven2/org/springframework/boot/spring-boot-sample
simple/1.4.2.RELEASE/spring-boot-sample-simple-1.4.2.RELEASE.jar -O app.jar 
nohup java -jar app.jar > /home/ubuntu/<your app name>/target/app.log 2>&1 & 
######

# 5.3 Verify Java Application is Running 

# 5.4 Generate Logs for Testing 

echo "Test log entry $(date)" >> /home/ubuntu/<your app name>/target/app.log 



# Step 6: View & Analyze Logs in Kibana 

# 6.1 Open Kibana Discover 

1. Go to Kibana → Discover. 
2. Select log* index. 
3. Search for: 
log.file.path: "/home/ubuntu/<your app name>/target/app.log" 
4. View structured fields (log_timestamp, log_level, log_message). 


# 6.2 Create Kibana Visualizations 
1. Pie Chart → Log level distribution. 
2. Line Chart → Logs over time. 
3. Data Table → Structured log table. 


# 6.3 Create a Kibana Dashboard 
1. Go to Kibana → Dashboard → Create Dashboard. 
2. Add Pie Chart, Line Chart, Data Table. 
3. Save as "Java Application Log Monitoring". 



# Conclusion 
Successfully: 

Installed Elasticsearch, Logstash, Kibana, and Filebeat 
Set up a Java application to generate logs 
Parsed logs into structured fields using Grok 
Created a real-time Kibana dashboard for log monitoring              