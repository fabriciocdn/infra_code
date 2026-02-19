# Projeto Iac + DevOPS + AWS

Este projeto utiliza:

- Kubernetes (EKS)
- Terraform deploy da infra na AWS
- Harbor para registry de imagens docker
- ArgoCD para gitops
- Github Actions para pipeline
- Trivy pata SCA e Container Security
- Semgrep para SAST
- Hadolint para boas praticas, linter e problemas de segurança.
- Gitleaks para verificação de senhas expostas

---

# Explicação do Projeto

### A ideia do projeto é apresentar o deploy de uma aplicação na infra kubernetes da AWS. <br>
1 - O desenvolvedor faz alteração no código da aplicação e faz o PUSH. <br> <br>
2 - Ao fazer PUSH, o código da aplicação e o Dockerfile passa por uma pipeline, que tem Scans de vulnerabilidades.<br> <br>
3 - BUILD, e Após o BUILD a imagem passa por um scan e depois PUSH para o Harbor, o registry de imagens docker privado, que está instalado no EKS. <br> <br>
4 - Após o BUILD e PUSH para o resgitry, então é feito um COMMIT e um PUSH para o repositório de gitops, alterando a TAG da imagem no values.yaml da aplicação, para que o ArgoCD, que está também instalado no EKS identifique a mudança e faça o Deploy no cluster EKS. Portanto o deploy fica automatizado.

---
#### A ideia de melhoria do projeto é aplicar Checkov + OPA (open policy agent) no código de setup da infra, ou seja nesse repo.
---

Repositório da aplicação deployada no EKS: <br>
https://github.com/fabriciocdn/simple_app

Repositório GitOps onde fica os manifestos helm de infra da aplicação.<br>
https://github.com/fabriciocdn/git_ops

Repositório da infra aws:<br>
https://github.com/fabriciocdn/infra_code

Módulo usado fazer o setup do EKS com Grupos de nós gerenciados, esse módulo eu desenvolvi.
https://github.com/fabriciocdn/terraform_aws_eks

---

### Diagrama de Arquitetura

![Arquitetura](images/aws-devops-project.drawio.png)