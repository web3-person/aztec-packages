variable "DEPLOY_TAG" {
  type = string
}

variable "RPC_URL" {
  type = string
}

variable "INFURA_API_KEY" {
  type = string
}

variable "API_PREFIX" {
  type = string
}

variable "CHAIN_ID" {
  type    = string
  default = 31337
}

variable "PRIVATE_KEY" {
  type = string
}

variable "ECR_URL" {
  type = string
}
