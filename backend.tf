terraform {
    backend "s3" {
        bucket         = "utc-s3bucket-2"
        key            = "code-vpc-ec2-terraform-key-vol/terraform.tfstate"
        region         = "us-east-1"
        encrypt        = false
    }
}