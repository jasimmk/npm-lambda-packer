variable "package" {
  type        = "string"
  description = "The NPM package to be bundled for use as a Lambda function."
}

variable "package_version" {
  type        = "string"
  default     = "*"
  description = "The package version."
}

resource "null_resource" "runner" {
  triggers {
    filepath = ".terraform/npm-lambda-packer/${md5("${var.package}${var.package_version}")}.zip"
  }

  provisioner "local-exec" {
    command = <<COMMAND
mkdir -p "$(dirname "${null_resource.runner.triggers.filepath}")"
${path.module}/bin/package -o "${null_resource.runner.triggers.filepath}" "${var.package}@${var.package_version}"
COMMAND
  }
}

output "filepath" {
  value = "${null_resource.runner.triggers.filepath}"
}
