resource "aws_db_instance" "rds" {
    count = length(var.db_instance[*])
    allocated_storage    = element(var.db_instance[*]["allocated_storage"],count.index)
    engine               = element(var.db_instance[*]["engine"],count.index)
    engine_version       = element(var.db_instance[*]["engine_version"],count.index)
    instance_class       = element(var.db_instance[*]["instance_class"],count.index)
    db_name              = element(var.db_instance[*]["db_name"],count.index)
    db_subnet_group_name = element(var.db_instance[*]["db_subnet_grp_name"],count.index)
    username             = element(var.db_instance[*]["username"],count.index)
    password             = element(var.db_instance[*]["password"],count.index)
    availability_zone    = var.availability_zone
    skip_final_snapshot  = true
    identifier = element(var.db_instance_uae[*]["db_name"],count.index)
    multi_az = true
    tags = {
        name = element(var.db_instance_uae[*]["db_name"],count.index)
        Environment = var.environment
    }
}