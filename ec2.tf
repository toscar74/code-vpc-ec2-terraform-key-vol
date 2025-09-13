resource "aws_instance" "server" {
  ami                         = "ami-0f319f7ad9a109982" # Replace with your desired AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = aws_key_pair.key1.key_name
  user_data                   = file("setup.sh")

  tags = {
    Name = "Terraform-projet-server"
    env  = "dev"
  }
}

# Extra EBS Volume
resource "aws_ebs_volume" "extra" {
  availability_zone = aws_instance.server.availability_zone
  size              = 20    # Size in GB
  type              = "gp3" # General purpose SSD
  tags = {
    Name = "Extra-disk"
  }
}

# Attach EBS Volume to the Instance
resource "aws_volume_attachment" "extra_attach" {
  device_name = "/dev/sdh" # Linux device name (shows as /dev/xvdh inside the instance)
  volume_id   = aws_ebs_volume.extra.id
  instance_id = aws_instance.server.id
}
  