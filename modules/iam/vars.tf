variable "user_1_name" {
}
variable "user_2_name" {
}
variable "path" {
    default = "/system/"
}
variable "path_2" {
    default = "/users/"
}
variable "iam_group_name" {
}
variable "group_policy_name" {
    default = "adminaccess"
}
variable "user_policy_name" {
    default = "AmazonSesSendingAccess"
}
variable "policy_attachment_name" {
    default = "user_policy_attachment"
}
variable "group-membership" {
    default = "admin-group-membership"
}