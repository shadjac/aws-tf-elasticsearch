# first time usage
  aws s3 mb s3://mybucket s3://elasticsearch-config --region ap-south-1
  aws s3 cp conf/elasticsearch.yml  s3://elasticsearch-config/elasticsearch.yml --region ap-south-1
  aws s3 cp conf/elasticsearch s3://elasticsearch-config/elasticsearch  --region ap-south-1
  aws s3 cp conf/limits.conf s3://elasticsearch-config/limits.conf  --region ap-south-1
  aws s3 cp conf/jvm.options s3://elasticsearch-config/jvm.options --region ap-south-1
  aws s3 cp conf/role_mapping.yml s3://elasticsearch-config/role_mapping.yml  --region ap-south-1
  aws s3 cp conf/override.conf s3://elasticsearch-config/override.conf  --region ap-south-1
  aws s3 cp conf/new-certs/dev.key s3://elasticsearch-config/new-certs/dev.key  --region ap-south-1
  aws s3 cp conf/new-certs/dev.crt s3://elasticsearch-config/new-certs/dev.crt  --region ap-south-1
  aws s3 cp conf/new-certs/myCA.pem s3://elasticsearch-config/new-certs/myCA.pem  --region ap-south-1
  aws s3 cp conf/users s3://elasticsearch-config/users  --region ap-south-1
  aws s3 cp conf/users_roles s3://elasticsearch-config/users_roles  --region ap-south-1

