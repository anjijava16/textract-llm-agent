module "s3" {
  source = "./modules/s3"
  project = var.project_name
  env     = var.environment
}

module "sns" {
  source = "./modules/sns"
}

module "sqs" {
  source = "./modules/sqs"
  sns_topic_arn = module.sns.topic_arn
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "iam" {
  source = "./modules/iam"
  sns_topic_arn     = module.sns.topic_arn
  upload_bucket_arn = module.s3.upload_bucket
}

