# How to use the repository

## Introduction
The terraform template will launch elastic search cluster on AWS using EC2 VM.

### Pre-requisites
1. Install terraform binary and add to `PATH`
2. Create a user and AWS ACCESS and SECRET key pair and edit the `main.tf` `aws` 
   provider section. This is the user with which terraform will create resources. This needs to have `ec2 full access`, `iam full access`, `s3 access` broadly. This can be narrowed down based on least privileges. `s3 full access` is required if you choose to upload dependencies on S3 using the script provided below.
3. Create `aws pem file` so that you can login to instances using `ssh`. Provide its name in `variables.tf`
4. All files under `conf` directory are to be uploaded to S3 bucket for e.g 
   `s3://elasticsearch-config`. These are referred by `init.tpl` at runtime.
5. Script `upload-files-to-s3.sh` can do this for you. It uploads files to S3 for 
   first time usage provided you have `awscli` configured with access/secret keys. This can be done from aws console too.
6. Have your machine's public IP handy!

### Files
1. `main.tf` : terraform root module
2. `files/init.tpl` : script that bootstraps the server at boot.
3. `iam.tf` : In case of more than one node in cluster, using ec2 discovery plugin, 
    certain permissions to be given to each node. 
4. `variables.tf` : Edit this file as per requirement. For now, traffic is allowed from only `whitelisted cidr`.

### Steps
- `git clone https://github.com/shadjac/elasticsearch-terraform.git`
- `cd elasticsearch-terraform`
- `terraform init`
- `terraform plan` for viewing the changes
- `terraform apply -auto-approve`

### How to test
1. add `public_ip` of the elastic search node in /etc/hosts as follows:
`10.2.13.120 myelasticsearch.com`

2. make sure you switch to directory `new-certs` before running following curl 
   command:
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
3. devops user is preconfigured for testing purpose


### Implementation

1. Elastic search uses `file` based authentication.
2. For testing purpose, the certificates are created using openssl CA
ref: https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/
3. The cenrtificate has two domains 1. localhost 2. myelasticsearch.com
   In real world, the certificates will be provided by known CA with authentic domain.
