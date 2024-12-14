module "kubernetes"{
    source="git::https://github.com/venugopal8878/aws-eks-terraform-module.git?ref=main"
    instance_name  = var.instance_name
    instance_type =var.instance_type
    security_group_name="allow_ssh"
    tags=var.tags
}