##### variables.tf

variable "region" {
  type        = string
  description = "The default region to create the resources."
}

variable "networking" {
  type = object({
    cidr_block          = string
    region              = string
    vpc_name            = string
    i_gateway_name      = string
    i_gateway           = bool    
    azs                 = list(string)
    public_subnets      = list(string)
    public_subnet_names  = list(string)
    private_subnets     = list(string)
    private_subnet_names = list(string)
    private_subnet_tags = map(string)
    public_subnet_tags  = map(string)
    nat_gateways        = bool
  })
}

variable "security_groups" {
  type = list(object({
    name        = string
    sg-name     = string
    description = string   
    ingress = list(object({
      description      = string
      protocol         = string
      from_port        = number
      to_port          = number
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
    egress = list(object({
      description      = string
      protocol         = string
      from_port        = number
      to_port          = number
      cidr_blocks      = list(string)
      ipv6_cidr_blocks = list(string)
    }))
  }))
}
