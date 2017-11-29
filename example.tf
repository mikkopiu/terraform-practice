provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "example" {
  # NOTE: S3 bucket names must be unique across _all_ AWS accounts, so
  # this name must be changed before applying this example to avoid naming
  # conflicts.
  bucket = "mipiuhol-terraform-example-bucket"
  acl    = "private"
}

resource "aws_instance" "example" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"

  depends_on = ["aws_s3_bucket.example"]

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} > ip_address.txt"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}

output "ami" {
  value = "${lookup(var.amis, var.region)}"
}
output "ip" {
  value = "${aws_eip.ip.public_ip}"
}
