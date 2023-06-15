variable "guardduty_enabler" {
    description = "Guardduty enable or disable"
}
variable "s3_logs_enabler" {
    description = "S3 logs enable or disable" 
}
variable "kubernetes_audit_logs_enabler" {
    description = "Kubernetes logs enable or disable"
}
variable "malware_protection_enabler" {
    description = "Malware Protection enable or disable"    
}
variable "environment" {
    description = "Name of the Environment" 
}