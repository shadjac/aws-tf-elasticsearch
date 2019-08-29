# How to use the repository

## Introduction
The terraform template will launch elastic search cluster on AWS using EC2 VM.

### Pre-requisites
1. Install terraform binary and add to `PATH`
2. Create AWS ACCESS and SECRET key pair and edit the `main.tf` `aws` provider section.
3. Create `aws pem file` so that you can login to instances using `ssh`.
4. All files under `conf` directory are to be uploaded to S3 bucket for e.g `s3://elasticsearch-config`. This are  
   referred by `bootstrap.sh` at runtime.
5. Script `upload-files-to-s3.sh` can do this for you. It uploads files to S3 for 
   first time usage privided you have `awscli` configured with access/secret keys. This can be done from aws console too.

### Files
1. `main.tf` : terraform file
2. `bootstrap.sh` : script that bootstraps the server at boot. The content should be base64 encoded which is then used in `main.tf` under `resource "aws_launch_configuration" "es-launch-conf"`

### Steps
- `git clone https://github.com/shadjac/elasticsearch-terraform.git`
- `cd elasticsearch-terraform`
- `terraform init`
- `terraform plan` for viewing the changes
- `terraform apply -auto-approve`

### How to test
1. add `public_ip` of the elastic search node in /etc/hosts as follows:
`10.2.13.120 myelasticsearch.com`

2. run curl command using elasticsearch APIs-
`$ curl https://myelasticsearch.com:9200/_cluster/health?pretty --key dev.key --cert dev.crt --cacert myCA.pem -u devops:rX4OhbsPOyPRLSrwCcMi`
Response should be:
`
{
  "cluster_name" : "star-cluster",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 0,
  "active_shards" : 0,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}`
3. make sure you switch to directory `new-certs`
4. devops user is preconfigured for testing purpose


### Implementation

1. Elastic search uses `file` based authentication.
2. For testing purpose, the certificates are created using openssl CA
ref: https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/
3. The cenrtificate has two domains 1. localhost 2. myelasticsearch.com
   In real world, the certificates will be provided by known CA with authentic domain.