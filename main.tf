module "template_files"{
  source = "hashicorp/dir/template"
  base_dir = "${path.module}/website"
}

# // -----------------VPCccccccccccccccccccc------------------------

# resource "aws_vpc" "sameep_terraform_vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags= {
#   Name = "sameep_terraform_vpc"
#     silo = "intern2"
#     owner = "sameep.sigdel"
#     terraform = "true"
#     environment = "dev"
#   }
# }

# // ----------------Security Groupssssssssssssssss-------------

# resource "aws_security_group" "sameep_sg" {
#   name        = "sameep_sg_vpc_1_terraform"
#   description = "sameep aws securitygroup built using terraform"
#   vpc_id      = aws_vpc.sameep_terraform_vpc.id

#   ingress{
#     description = "sameep security group from terraform http"
#     cidr_blocks   = ["0.0.0.0/0"]
#     from_port   = 80
#     protocol = "tcp"
#     to_port     = 80
#   }

#   ingress{
#     description = "sameep security group from terraform ssh"
#     cidr_blocks   = ["0.0.0.0/0"]
#     from_port   = 22
#     protocol = "tcp"
#     to_port     = 22
#   }

#   egress{
#     description = "egress for all traffic"
#     from_port = 0
#     to_port = 0
#     protocol = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "sameep-aws-sg-terraform"
#     terraform = "true"
#     silo = "intern2"
#     owner = "sameep.sigdel"
#     environment = "dev"
#   }
# }

# //-------------Subnetsssssssssssssssssss-----------

# resource "aws_subnet" "sameep_terraform_subnet_1" {
#   vpc_id     = aws_vpc.sameep_terraform_vpc.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "sameep_terraform_subnet_1"
#     silo = "intern2"
#     owner = "sameep.sigdel"
#     terraform = "true"
#     environment = "dev"
#   }
# }

/*
resource "aws_subnet" "sameep_terraform_subnet_private_1" {
  vpc_id     = aws_vpc.sameep_terraform_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "sameep_terraform_subnet_private_1"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

resource "aws_subnet" "sameep_terraform_subnet_private_2" {
  vpc_id     = aws_vpc.sameep_terraform_vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "sameep_terraform_subnet_private_2"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}
*/

// -----------------------EC2 Instance----------------------------

# resource "aws_instance" "sameep_terraform_ec2" {
#   ami           = var.ami
#   instance_type = var.instance_type
#   subnet_id = aws_subnet.sameep_terraform_subnet_1.id
#   vpc_security_group_ids = [aws_security_group.sameep_sg.id] # Attach the security group
#   associate_public_ip_address = true
#   key_name = var.key_name

#   tags = {
#     Name = "sameep-first-terraform-webserver"
#     silo = "intern2"
#     owner = "sameep.sigdel"
#     terraform = "true"
#     environment = "dev"
#   }
# }

# //----------------------Internet Gatewayyyyyyyyyyyyy------------------------------
# resource "aws_internet_gateway" "sameep_internet_gateway_1" {
#   vpc_id = aws_vpc.sameep_terraform_vpc.id

#   tags = {
#     Name = "sameep_internet_gateway_1_terraform"
#     silo = "intern2"
#     owner = "sameep.sigdel"
#     terraform = "true"
#     environment = "dev"
#   }
# }

/*
//----------------------Elastic Ippppppppppppppppppppppp---------------------
resource "aws_eip" "sameep_elastic_ip_1" {
  //instance = aws_instance.sameep_terraform_ec2.id
  domain   = "vpc"
}

//----------------------NAT Gatewayyyyyyyyyyyyyyyyyy------------------------------
resource "aws_nat_gateway" "sameep_nat_gateway_1" {
  allocation_id = aws_eip.sameep_elastic_ip_1.id
  subnet_id     = aws_subnet.sameep_terraform_subnet_private_1.id

  tags = {
    Name = "sameep gw NAT"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.sameep_internet_gateway_1]
}
*/


//----------------------Route Tableeeeeeeeeeeeeeeeeeee-----------------------------
# resource "aws_route_table" "sameep_route_table_public_1" {
#   vpc_id = aws_vpc.sameep_terraform_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.sameep_internet_gateway_1.id
#   }
# }

/*
resource "aws_route_table" "sameep_route_table_private_1" {
  vpc_id = aws_vpc.sameep_terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.sameep_nat_gateway_1.id
  }
}
*/

//----------------Route Table Associationnnnnnnnnnnn-----------------
# resource "aws_route_table_association" "sameep_association_route_table_public_1" {
#   subnet_id      = aws_subnet.sameep_terraform_subnet_1.id
#   route_table_id = aws_route_table.sameep_route_table_public_1.id
# }

/*
resource "aws_route_table_association" "sameep_association_route_table_private_1" {
  subnet_id      = aws_subnet.sameep_terraform_subnet_private_1.id
  route_table_id = aws_route_table.sameep_route_table_private_1.id
}

resource "aws_route_table_association" "sameep_association_route_table_private_2" {
  subnet_id      = aws_subnet.sameep_terraform_subnet_private_2.id
  route_table_id = aws_route_table.sameep_route_table_private_1.id
}
*/

/*
//------------------IAM Roleeeeeeeeeeeeeeeeeeeeeeee----------------------------------------
resource "aws_iam_role" "sameep_iam_role" {
  name = "sameep_test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
    Name = "sameep_IAM_role_terraform"
    silo = "intern2"
    owner = "sameep.sigdel"
    terraform = "true"
    environment = "dev"
  }
}

//-------------------IAM Role Policyyyyyyyyyyyyyyyy-----------------------
resource "aws_iam_policy" "sameep_policy" {
  name        = "sameep_iam_test_policy"
  description = "Sameep IAM test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
*/
//------------------S333333333333333333333333333333------------------------
resource "aws_s3_bucket" "sameep_static_website_s3_bucket" {
  bucket = "sameep-s3-static-website-bucket" #Should be globally unique
  # force_destroy = true

  tags = {
  Name        = "sameep_s3_bucket"
  owner = "sameep.sigdel"
  environment = "dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "sameep_s3_ownership_controls" {
  bucket = aws_s3_bucket.sameep_static_website_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "sameep_aws_s3_bucket_public_access_block" {
  bucket = aws_s3_bucket.sameep_static_website_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "sameep_aws_s3_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.sameep_s3_ownership_controls,
    aws_s3_bucket_public_access_block.sameep_aws_s3_bucket_public_access_block
  ]

  bucket = aws_s3_bucket.sameep_static_website_s3_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "sameep_hosting_aws_s3_bucket_policy" {
  bucket = aws_s3_bucket.sameep_static_website_s3_bucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" = "Allow",
        "Principal" = "*",
        "Action" = "s3:GetObject",
        "Resource" = "${aws_s3_bucket.sameep_static_website_s3_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_website_configuration" "sameep_hosting_bucket_website_configuration" {
  bucket = aws_s3_bucket.sameep_static_website_s3_bucket.id
  
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_object" "sameep_hosting_bucket_files" {
  bucket = aws_s3_bucket.sameep_static_website_s3_bucket.id

  for_each = module.template_files.files

  key = each.key
  content_type = each.value.content_type

  source = each.value.source_path
  content = each.value.content

  etag = each.value.digests.md5  
}