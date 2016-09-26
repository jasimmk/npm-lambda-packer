variable "package" {
  description = "The name NPM package"
}

variable "version" {
  value = "*"
  description = "The version of the package"
}

variable "environment" {
  value = ""
  description = "Environment variables to use available"
}

resource "null_resource" "runner" {
  triggers {
    filepath = "${path.cwd}/tmp/${md5(concat(var.package, var.version, var.environment))}.zip"
  }

  provisioner "local-exec" {
    command = <<COMMAND
mkdir -p "${path.cwd}/tmp"
${path.module}/bin/package ${join(" ", formatlist("-e \"%s\"", compact(split("\n", var.environment))))} -o "${null_resource.runner.triggers.filepath}" "${var.package}@${var.version}"
COMMAND
  }
}

output "filepath" {
  value = "${null_resource.runner.triggers.filepath}"
}
