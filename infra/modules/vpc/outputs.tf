output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID da subnet pública"
  value       = aws_subnet.public.id
}

output "private_subnet_a_id" {
  description = "ID da subnet privada A"
  value       = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
  description = "ID da subnet privada B"
  value       = aws_subnet.private_b.id
}
