
#terraform.tfvars

networking=  {
    cidr_block           = "10.1.0.0/16"
    region               = var.region
    vpc_name             = "custom-vpc"
    i_gateway_name       = "custom-igw"
    nat_gateways         = true
    i_gateway            = true
    azs                  = ["sa-east-1a", "sa-east-1b"]
    public_subnets       = ["10.1.16.0/20", "10.1.32.0/20"]
    public_subnet_names  = ["subnet-16", "subnet-32"]  
  
    private_subnets      = ["10.1.48.0/20", "10.1.64.0/20"]
    private_subnet_names = ["subnet-48", "subnet-64"]    

    private_subnet_tags  = {"kubernetes.io/role/internal-elb" = "1"}
    public_subnet_tags   = {"kubernetes.io/role/elb" = "1"}       
  }


 #####     DEFINE ALL THE SECURITY GROUPS THAT WILL BE USED BY RESOURCES ON THIS VPC     #####
 #####     THE BEST PRATICE IS CREATING A SECURITY GROUP FOR EACH TYPE OF ACCESS         #####
 #####     EXAMPLE: A SECURITY GROUP FOR DATABASE, ANOTHER FOR WEB SERVERS, ETC         #####

 security_groups= [{
    name        = "http-https-traffic"
    description = "Http and Https application trafic."
    sg-name     = "http-elb-for-eks-sg"
    ingress = [
      {
        description      = "Allow HTTPS"
        protocol         = "tcp"
        from_port        = 443
        to_port          = 443
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = null
      },
      {
        description      = "Allow HTTP"
        protocol         = "tcp"
        from_port        = 80
        to_port          = 80
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = null
      },
    ]
    egress = []
    },
    {
    name        = "icmp-ssh-traffic"
    description = "Troubleshooting (icmp, ssh) application trafic."
    sg-name     = "icmp-elb-for-eks-sg"     
    ingress = [
      {
        description      = "Allow ICMP"
        protocol         = "icmp"
        from_port        = 8
        to_port          = 0
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = null
      },
      {
        description      = "Allow SSH"
        protocol         = "tcp"
        from_port        = 22
        to_port          = 22
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = null
      },
    ] 
    egress = []        
    }  
  ]
