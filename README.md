# 🏢 Sistema de Gerenciamento - Cunty TI

## 📄 Sobre o Projeto
Este projeto é um sistema de gerenciamento corporativo de recursos humanos, serviços e folha de pagamento desenvolvido para a empresa fictícia Cunty TI. O banco de dados controla departamentos, pagamentos de salários e classifica os funcionários de forma disjunta nas categorias CLT, Estagiário e PJ. Foi desenvolvido como trabalho prático da disciplina GCC263 - Introdução a Sistemas de Banco de Dados da UFLA.

## ⚙️ Estrutura e Funcionalidades
O modelo relacional foi estruturado de forma normalizada, atendendo às regras da 1ª, 2ª e 3ª Formas Normais para garantir a consistência. O script completo reflete um ambiente de produção e implementa as seguintes funcionalidades:
*   **DDL e DML:** Criação das tabelas com chaves primárias e estrangeiras, além da inserção de dados, atualizações e exclusões lógicas.
*   **Consultas Avançadas:** Mapeamento de dados utilizando `INNER JOIN`, `OUTER JOIN`, subconsultas, funções agregadas e operadores como `EXISTS` e `HAVING`.
*   **Visões (Views):** Criação de relatórios virtuais para otimizar buscas recorrentes, como a visualização da folha de pagamento por funcionário.
*   **Stored Procedures e Functions:** Rotinas automatizadas para tradução de status cadastrais e cálculo de somatórios financeiros.
*   **Triggers:** Gatilhos configurados para cálculo automático do salário líquido antes de inserções e para o registro de logs em uma tabela de auditoria após atualizações ou exclusões.
*   **Controle de Acesso:** Criação de usuários distintos (RH e Consulta) com definição e revogação de privilégios via `GRANT` e `REVOKE`.

## 🚀 Como Executar
1. Clone este repositório para o seu ambiente local.
2. Abra a sua ferramenta de administração de banco de dados (ex: MySQL Workbench ou DBeaver).
3. Importe e execute o arquivo `TRABALHO-BANCODEDADAOS.sql`.
4. O script se encarregará de criar o schema `cuntyti`, construir as tabelas e popular o banco com a massa de dados de teste automaticamente.

## 👥 Autores e Participações
Projeto colaborativo desenvolvido pelos seguintes alunos:
*   **Arthur Veiga** [@ArtJamis1208] (https://github.com/ArtJamis1208)
*   **Giovana Zacaroni** [@gigi-zacaroni] (https://github.com/gigi-zacaroni)
*   **Karol Guimarães** [@KarolGSMiranda] (https://github.com/KarolGSMiranda)
*   **Lívia Fagundes** [@liviafgs] (https://github.com/liviafgs)
*   **Maria Luiza Pestana**
*   **Raíssa Fernandes** 