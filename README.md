# TechNova Reservations API

**Aluno:** João Pedro Paulino Ferreira
**RA:** 6325175

## Descrição

Projeto desenvolvido para a prova prática do primeiro bimestre de DevOps.

A aplicação consiste em uma API REST de reservas da TechNova, desenvolvida com Node.js e Express, utilizando PostgreSQL como banco de dados.

A API implementa operações CRUD completas para reservas:

* `POST /reservas`
* `GET /reservas`
* `GET /reservas/:id`
* `PUT /reservas/:id`
* `DELETE /reservas/:id`
* `GET /health`

Os dados são persistidos em PostgreSQL, tanto no ambiente local com Docker Compose quanto no ambiente AWS utilizando Amazon RDS.

## Tecnologias

* Node.js
* Express
* PostgreSQL
* Docker
* Docker Compose
* Terraform
* AWS EC2
* AWS RDS
* AWS VPC
* Git e GitHub
* Kiro / ChatGPT como copiloto de desenvolvimento

## Ambiente local

O ambiente local utiliza Docker Compose com:

* Container da API
* Container PostgreSQL
* Volume nomeado para persistência do banco
* Rede Docker `technova-net`
* Healthcheck do PostgreSQL
* `depends_on` com condição de serviço saudável

Para executar localmente:

```bash
cp .env.example .env
docker compose up --build
```

A API fica disponível em:

```text
http://localhost:3000
```

## Infraestrutura AWS

A infraestrutura foi provisionada com Terraform na região `us-east-1`.

A arquitetura utiliza:

* VPC `10.0.0.0/16`
* Subnet pública para a EC2
* Duas subnets privadas em AZs distintas para o RDS subnet group
* Internet Gateway
* Security Group da EC2
* Security Group do RDS
* EC2 `t2.micro`
* RDS PostgreSQL `db.t3.micro`
* RDS privado e sem Multi-AZ
* Criptografia de armazenamento do RDS
* `LabInstanceProfile` fornecido pelo AWS Academy

O RDS aceita conexões PostgreSQL somente através do Security Group da EC2.

O estado do Terraform utiliza armazenamento remoto em S3 com versionamento e criptografia, além de locking com DynamoDB.

## Docker

A API possui Dockerfile baseado em `node:18-alpine` e executa o processo como usuário não-root.

Build da imagem:

```bash
docker build -t technova-reservas-api ./app
```
## Validação na AWS

A aplicação foi executada em um container Docker na EC2 e conectada ao PostgreSQL RDS privado.

Foram validados:

* Healthcheck da API
* Criação de reserva
* Listagem de reservas
* Consulta de reserva por ID
* Atualização de reserva
* Exclusão de reserva

A validação completa está registrada em:

evidencias/aws-api-crud.txt

Após a conclusão das validações, a infraestrutura temporária criada pelo Terraform foi removida com terraform destroy.

## Evidências

As principais evidências estão em:

* `evidencias/docker-build.txt`
* `evidencias/compose-ps.txt`
* `evidencias/terraform-plan.txt`
* `evidencias/aws-api-crud.txt`
* `evidencias/prompts.txt`
* `evidencias/prints/`

## Organização do projeto

prova-primeiro-bimestre-devops/
├── README.md
├── .gitignore
├── .env.example
├── app/
│   ├── src/
│   ├── package.json
│   ├── package-lock.json
│   ├── Dockerfile
│   └── .dockerignore
├── docker-compose.yml
├── infra/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── security-group/
│   │   ├── ec2/
│   │   └── rds/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── backend/
├── evidencias/
│   ├── docker-build.txt
│   ├── compose-ps.txt
│   ├── terraform-plan.txt
│   ├── aws-api-crud.txt
│   ├── prompts.txt
│   ├── aws-api-crud.txt
│   └── prints/
└── relatorio.md
