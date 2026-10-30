# AMVE Flow

### Organize suas tarefas. Acompanhe seu progresso. Tenha o controle do seu dia.

O **AMVE Flow** é um aplicativo mobile de gerenciamento de tarefas desenvolvido com Flutter, Python (FastAPI) e PostgreSQL.

O projeto nasceu com o objetivo de oferecer uma maneira simples, organizada e intuitiva de gerenciar atividades por meio de quadros, listas e tarefas, combinando uma interface minimalista com uma API própria e persistência de dados em banco de dados relacional.

Mais do que desenvolver um aplicativo funcional, o AMVE Flow também é um projeto de aprendizado e evolução contínua, com foco em boas práticas de desenvolvimento, organização de código, arquitetura de software e integração entre frontend e backend.

---

## Sobre o projeto

O AMVE Flow permite organizar atividades em diferentes quadros, separar tarefas em listas e acompanhar seu andamento.

A aplicação foi desenvolvida utilizando uma arquitetura dividida entre frontend e backend:

- **Frontend:** aplicativo mobile desenvolvido em Flutter.
- **Backend:** API REST desenvolvida com Python e FastAPI.
- **Banco de dados:** PostgreSQL.
- **Comunicação:** integração HTTP entre o aplicativo e a API.

A separação dessas responsabilidades permite que cada parte do sistema evolua independentemente, facilitando futuras melhorias e novas funcionalidades.

## Funcionalidades implementadas

Atualmente, o projeto conta com:

- [x] Criação de quadros para organização de atividades.
- [x] Criação de listas dentro dos quadros.
- [x] Criação de tarefas dentro das listas.
- [x] Edição de tarefas existentes.
- [x] Exclusão de tarefas.
- [x] Exclusão de listas e quadros.
- [x] Marcação de tarefas como concluídas.
- [x] Organização visual entre tarefas pendentes e concluídas.
- [x] Interface minimalista e intuitiva.
- [x] Tema claro.
- [x] Tema escuro.
- [x] Tema automático, seguindo as configurações do dispositivo.
- [x] Integração do aplicativo com a API FastAPI.
- [x] Persistência de dados utilizando PostgreSQL.
- [x] Separação do código em camadas e arquivos organizados.

## Tecnologias utilizadas

### Frontend

**Flutter**

Framework utilizado para o desenvolvimento da aplicação mobile, permitindo a construção de uma interface multiplataforma com componentes reutilizáveis.

Principais recursos utilizados:
- Dart.
- Material Design.
- Gerenciamento de estado com `ChangeNotifier`.
- `ListenableBuilder` para atualização reativa da interface.
- Integração HTTP com o backend.
- Organização da interface em widgets reutilizáveis.

### Backend

**Python + FastAPI**

O backend é responsável por receber as requisições do aplicativo, processar as operações e realizar a comunicação com o banco de dados.

Tecnologias utilizadas:
- Python 3.13.
- FastAPI.
- SQLAlchemy.
- Psycopg 3.
- Python-dotenv.
- Uvicorn.

### Banco de dados

**PostgreSQL**

Banco de dados relacional utilizado para armazenar as informações da aplicação.

A integração é realizada por meio do SQLAlchemy, utilizando o driver Psycopg para comunicação com o PostgreSQL.

---

## Arquitetura do projeto

O projeto possui uma estrutura separada entre frontend e backend.

```text
projeto-tarefas/
│
├── app_mobile/
│   ├── lib/
│   │   ├── controllers/
│   │   │   └── task_controller.dart
│   │   │
│   │   ├── models/
│   │   │   ├── board.dart
│   │   │   ├── task.dart
│   │   │   └── task_list.dart
│   │   │
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   │
│   │   ├── services/
│   │   │   └── task_api.dart
│   │   │
│   │   └── widgets/
│   │       ├── board_header.dart
│   │       ├── task_form_dialog.dart
│   │       ├── task_list_card.dart
│   │       └── text_input_dialog.dart
│   │
│   └── android/
│
├── .venv/
├── .env
├── .gitignore
├── database.py
├── main.py
├── models.py
└── test_db.py
```

### Organização do Flutter

| Diretório | Responsabilidade |
|---|---|
| `controllers/` | Gerenciamento de estado e regras de interação da aplicação. |
| `models/` | Representação dos dados utilizados pelo aplicativo. |
| `screens/` | Telas principais da aplicação. |
| `services/` | Comunicação com a API. |
| `widgets/` | Componentes reutilizáveis da interface. |

### Organização do backend

| Arquivo | Responsabilidade |
|---|---|
| `main.py` | Inicialização da API e definição das rotas. |
| `database.py` | Configuração da conexão com o banco de dados. |
| `models.py` | Modelos utilizados para representar as entidades no banco. |
| `test_db.py` | Testes de conexão e interação com o banco de dados. |
| `.env` | Configurações e variáveis de ambiente. |

---

## Como executar o projeto

### 1. Pré-requisitos

Antes de executar o projeto, é necessário ter instalado:

- Python 3.13 ou superior.
- Flutter SDK.
- Dart SDK (incluído na instalação do Flutter).
- PostgreSQL.
- Git.
- Android Studio ou outro ambiente configurado para desenvolvimento Flutter.

### 2. Clonar o repositório

```bash
git clone https://github.com/SEU-USUARIO/SEU-REPOSITORIO.git
```

Entre na pasta do projeto:

```bash
cd SEU-REPOSITORIO
```

### 3. Configurar o backend

Entre na pasta principal do projeto e crie um ambiente virtual:

```bash
python -m venv .venv
```

Ative o ambiente virtual no Windows:

```powershell
.\.venv\Scripts\Activate.ps1
```

Instale as dependências:

```bash
pip install fastapi uvicorn sqlalchemy psycopg[binary] python-dotenv
```

Configure o arquivo `.env` com os dados de conexão do PostgreSQL, seguindo as variáveis utilizadas em `database.py`.

**Importante:** não compartilhe seu arquivo `.env` nem credenciais de banco de dados. Utilize valores próprios no ambiente local.

### 4. Configurar o PostgreSQL

Crie um banco de dados chamado:

```sql
CREATE DATABASE tarefas;
```

Configure a conexão no arquivo `.env` de acordo com a implementação do backend.

### 5. Iniciar a API

Com o ambiente virtual ativado:

```bash
uvicorn main:app --reload
```

Por padrão, a API ficará disponível em:

```text
http://127.0.0.1:8000
```

A documentação interativa do FastAPI pode ser acessada em:

```text
http://127.0.0.1:8000/docs
```

### 6. Configurar o aplicativo Flutter

Abra outro terminal e entre na pasta do aplicativo:

```bash
cd app_mobile
```

Instale as dependências:

```bash
flutter pub get
```

Configure o endereço da API no serviço responsável pela comunicação HTTP, localizado em:

```text
lib/services/task_api.dart
```

Para executar em um dispositivo físico, o endereço deve apontar para o IP local do computador na rede, desde que ambos estejam conectados à mesma rede Wi-Fi.

### 7. Executar o aplicativo

Verifique os dispositivos disponíveis:

```bash
flutter devices
```

Execute:

```bash
flutter run
```

Para gerar uma versão de lançamento para Android:

```bash
flutter build apk --release
```

O arquivo APK será gerado em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Interface e experiência do usuário

O AMVE Flow segue uma proposta visual minimalista, priorizando clareza, organização e facilidade de utilização.

A interface possui suporte a três modos de aparência:

- **Claro:** interface com fundos claros.
- **Escuro:** interface com fundos escuros.
- **Automático:** acompanha o tema configurado no dispositivo.

A proposta é manter uma experiência consistente, com elementos visuais simples e foco nas atividades do usuário.

---

## Decisões técnicas e aprendizado

Durante o desenvolvimento, algumas decisões foram tomadas pensando na organização e na evolução do projeto.

### Separação de responsabilidades

A aplicação Flutter foi organizada em diferentes camadas, evitando concentrar toda a lógica em um único arquivo.

### Gerenciamento de estado

O `ChangeNotifier` é utilizado para centralizar o estado e permitir que a interface reaja às alterações realizadas nos dados.

### Comunicação com a API

A comunicação com o backend foi isolada em um serviço próprio (`task_api.dart`), evitando misturar requisições HTTP diretamente com os componentes visuais.

### Persistência de dados

O PostgreSQL foi escolhido para oferecer armazenamento relacional e permitir a evolução do modelo de dados conforme novas necessidades surgirem.

### Organização e manutenção

O projeto utiliza uma estrutura modular para facilitar a manutenção, os testes e a implementação de novas funcionalidades.

---

## Próximos passos

O AMVE Flow está em desenvolvimento e novas funcionalidades estão sendo avaliadas a partir dos testes de utilização.

Entre as melhorias planejadas estão:

- [ ] Implementação de autenticação e cadastro de usuários.
- [ ] Suporte a múltiplos usuários.
- [ ] Separação dos dados por usuário.
- [ ] Hospedagem da API e do banco de dados na nuvem.
- [ ] Acesso ao aplicativo independentemente da rede local.
- [ ] Evolução das regras de negócio para gerenciamento de tarefas.
- [ ] Fluxo de trabalho baseado em etapas (Kanban).
- [ ] Criação automática de listas padrão nos quadros.
- [ ] Melhorias na experiência do usuário.
- [ ] Testes automatizados.
- [ ] Evolução da arquitetura do backend.

As funcionalidades listadas nesta seção são planejadas e ainda não devem ser consideradas disponíveis na versão atual.

---

## Status do projeto

**Em desenvolvimento.**

O aplicativo já possui integração entre Flutter, FastAPI e PostgreSQL, além das principais operações de gerenciamento de quadros, listas e tarefas.

O desenvolvimento continua com foco em aprimorar as regras de negócio, fortalecer a arquitetura e preparar a aplicação para uma futura disponibilização online.

---

## Sobre a AMVE

O AMVE Flow é o primeiro projeto do ecossistema **AMVE**, uma iniciativa voltada ao desenvolvimento de soluções tecnológicas com propósito.

A identidade AMVE representa a união de quatro nomes importantes, trazendo um significado pessoal para a criação da marca.

**AMVE | Tecnologia com propósito.**

---

## Autor

Desenvolvido como projeto de aprendizado e evolução em desenvolvimento de software, com foco em Flutter, Python, FastAPI e PostgreSQL.

---

## Licença

A licença do projeto ainda não foi definida.

