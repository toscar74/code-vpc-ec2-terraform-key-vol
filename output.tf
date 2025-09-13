output "public-ip" {
    value = aws_instance.server.public_ip
}

output "username" {
    value = "ec2-user"
}

output "vpc_id" {
    value = aws_vpc.Utc_vpc_vpc.id
}