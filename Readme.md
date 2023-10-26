<h1>Deploy to Azure Provider with Terraform</h1>

<h3 align="justify">Neste repositório você encontra um exemplo de deploy de um container apache no provider Azure utilizando o Terraform.</h3>

<h4 align="justify">Aspectos Principais:</h4>

- <p align="justify">Criação dos parâmetros resource group, virtual network, subnet, public ip, security group, network interface e virtual machine;</p>

- <p align="justify">Instância Standard_B1ls com Ubuntu Server 20.04-LTS;</p>

- <p align="justify">Instalação do Docker e Docker-Compose;</p>

- <p align="justify">Acesso ao servidor por chaves assimétricas;</p>

- <p align="justify">Provisioner local-exec para a criação do arquivo index.html;</p>

- <p align="justify">Provisioner file para o envio dos arquivos pkgs.sh, docker-compose.yml e index.html para a instância;</p>

- <p align="justify">Provisioner remote-exec para a execução do script pkgs.sh, docker-compose, permissão do diretório "storage_app" e atualização do servidor apache;</p>

<hr>

<p align="center">
    <img src="img/apache_server.png" alt="logos_all"/>
</p>




