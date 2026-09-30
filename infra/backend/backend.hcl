# Configuração do backend Terraform — Remote State em S3 + DynamoDB
# ATENÇÃO: Substitua <account-id> pelo ID real da sua conta AWS antes de usar.
# Este arquivo NÃO deve ser versionado com valores reais de conta.

bucket         = "technova-tfstate-<account-id>"
key            = "technova-reservas-api/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "technova-tfstate-lock"
encrypt        = true
