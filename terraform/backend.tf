terraform {
  backend "s3" {
    bucket = "prescriptive-data-interview"
    key    = "file.state"
    region = "us-east-1"
  }
}

