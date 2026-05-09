# PayUp

PayUp é um aplicativo iOS para organizar cobranças de clientes. O app permite cadastrar clientes, registrar valor e data de cobrança, listar lançamentos por dia, calcular recebimentos do dia e agendar lembretes locais para cobranças recorrentes.

O projeto foi desenvolvido com UIKit, Swift e interface programática, sem Storyboards para as telas principais.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7b586846-0dd2-4c9c-9e74-3a04cf9a01ea" />

## Visão Geral

Principais funcionalidades:

- Cadastro de clientes com nome, contato, telefone, CNPJ, endereço, valor e data de cobrança.
- Edição e exclusão de clientes cadastrados.
- Listagem horizontal de clientes na Home.
- Visualização de lançamentos por dia da semana.
- Cálculo do total de recebimentos do dia atual.
- Filtro de lançamentos por nome do cliente.
- Agendamento de notificações locais para cobranças recorrentes.
- Identidade visual própria com cores, fontes K2D e assets customizados.

## Tecnologias

- Swift 5
- UIKit
- Auto Layout programático
- SQLite3
- UserNotifications
- Xcode 16.3
- Assets.xcassets
- Fonte K2D

## Estrutura do Projeto

```text
PayUp.xcodeproj
PayUp/
  AppDelegate.swift
  SceneDelegate.swift
  Info.plist
  Resources/
    Assets.xcassets
    K2D/
  Sources/
    Core/
      Colors/
      Components/
      Database/
      Extensions/
      Model/
      Typography/
    Features/
      Form/
      Home/
      Splash/
```

## Arquitetura

O projeto segue uma organização próxima de MVVM usando UIKit:

- `ViewController`: coordena ciclo de vida da tela, eventos do usuário, apresentação de telas e conexão entre view e view model.
- `View`: monta a interface visual usando UIKit e Auto Layout.
- `ViewModel`: concentra regras de apresentação, formatação e acesso aos dados.
- `Model`: representa as entidades e estruturas usadas pelo app.
- `DatabaseManager`: centraliza persistência local em SQLite.
- `NotificationManager`: centraliza o agendamento e cancelamento de notificações locais.

## Ciclo de Inicialização

O ponto de entrada do app fica em `AppDelegate.swift`, marcado com `@main`.

Durante a inicialização, o app solicita permissão para notificações locais:

```swift
UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
```

A janela principal é configurada em `SceneDelegate.swift`. O app cria uma `UIWindow`, instancia uma `UINavigationController` e define a `HomeViewController` como tela inicial.

## Features

### Home

Arquivos principais:

- `Sources/Features/Home/View/HomeView.swift`
- `Sources/Features/Home/View/HomeViewController.swift`
- `Sources/Features/Home/ViewModel/HomeViewModel.swift`

A Home é a tela principal do aplicativo. Ela exibe:

- Cabeçalho com logo, botão de notificação e imagem de perfil.
- Seletor horizontal de dias da semana.
- Card com recebimentos de hoje.
- Botão para adicionar cliente.
- Lista horizontal de clientes.
- Seção de lançamentos.
- Botão de filtro por nome.

Responsabilidades principais:

- Buscar clientes no banco local.
- Transformar clientes em modelos de exibição.
- Calcular o total de recebimentos do dia atual.
- Filtrar lançamentos por nome.
- Atualizar a lista quando dados de cliente mudam.

### Formulário de Cliente

Arquivos principais:

- `Sources/Features/Form/View/ClientFormView.swift`
- `Sources/Features/Form/View/ClientFormViewController.swift`
- `Sources/Features/Form/View/ClientFormViewDelegate.swift`
- `Sources/Features/Form/ViewModel/ClientFormViewModel.swift`

O formulário funciona em dois modos:

- `.add`: adiciona um novo cliente.
- `.edit(Client)`: edita ou exclui um cliente existente.

Campos do formulário:

- Valor
- Data de cobrança
- Cobrança recorrente
- Frequência da recorrência
- Dia selecionado
- Nome do cliente
- Contato
- Telefone
- CNPJ
- Endereço

Ao salvar, os dados são convertidos em um `Client` e enviados ao `ClientFormViewModel`, que usa o `DatabaseManager` para persistir. Caso o cliente tenha cobrança recorrente, o `NotificationManager` agenda os lembretes.

### Splash

Arquivos principais:

- `Sources/Features/Splash/View/SplashView.swift`
- `Sources/Features/Splash/View/SplashViewController.swift`
- `Sources/Features/Splash/ViewModel/SplashViewModel.swift`

A feature de Splash contém uma animação inicial com logo e triângulo. Atualmente, a tela inicial configurada no `SceneDelegate` é a `HomeViewController`; então, a Splash existe no projeto, mas não está conectada ao fluxo inicial.

## Core

### Components

Componentes reutilizáveis do app:

- `AuthenticationView`: tela/componente visual de autenticação.
- `CompanyCell`: célula da lista horizontal de empresas/clientes.
- `CompanyListView`: collection view horizontal para clientes.
- `CurrencyTextField`: campo customizado para valor monetário.
- `DatePickerTextField`: campo customizado com seletor de data.
- `DaySelectorView`: seletor horizontal de dias da semana.
- `InputTextFieldView`: campo de texto padronizado com máscaras por tipo.
- `PaymentCardView`: card visual para valores e lançamentos.

### Models

Modelos principais:

- `Client`: representa um cliente/cobrança persistida.
- `ClientFormMode`: define modo de abertura do formulário.
- `CompanyItemModel`: modelo visual para item da lista de clientes.
- `InputTextFieldType`: define o tipo de campo e máscaras.
- `PaymentCardModel`: modelo visual para cards de pagamento.
- `PaymentCardType`: define tipo, ícone e subtítulo do card.

### Database

O app usa SQLite localmente via `SQLite3`.

Arquivo principal:

- `Sources/Core/Database/DatabaseManager.swift`

Banco criado:

```text
clients.sqlite
```

Local:

```text
Documents directory do app
```

Tabela principal:

```text
clients
```

Campos:

- `id`
- `name`
- `contact`
- `phone`
- `cnpj`
- `address`
- `value`
- `due_date`
- `is_recurring`
- `frequency`
- `selected_day`

Operações disponíveis:

- Inserir cliente.
- Atualizar cliente.
- Buscar todos os clientes.
- Buscar cliente por ID.
- Excluir cliente.

### Notifications

Arquivo principal:

- `Sources/Core/Database/NotificationManager.swift`

O `NotificationManager` agenda notificações locais para clientes recorrentes usando `UNUserNotificationCenter`.

Frequências tratadas:

- `Diariamente`
- `Semanalmente`
- `Mensalmente`

Observação: o formulário também apresenta a opção `Anualmente`, mas a lógica atual de notificação ainda não possui tratamento para essa frequência.

### Colors

Arquivo:

- `Sources/Core/Colors/Colors.swift`

Centraliza a paleta visual do app. A interface usa fundo escuro e cor de destaque verde.

### Typography

Arquivo:

- `Sources/Core/Typography/Fonts.swift`

Centraliza os estilos tipográficos com a fonte K2D:

- `K2D-Bold`
- `K2D-Regular`
- `K2D-SemiBold`

As fontes são registradas no `Info.plist` em `UIAppFonts`.

### Extensions

Extensões utilitárias:

- `UITextField+Ext.swift`: adiciona padding lateral ao `UITextField`.
- `UIView+Ext.swift`: permite encontrar o view controller pai de uma view.

## Recursos

### Assets

Os assets ficam em:

```text
PayUp/Resources/Assets.xcassets
```

Incluem:

- Ícone do app
- Cor de destaque
- Logo principal
- Ícones de cobrança
- Imagens de perfil
- Assets da Splash
- Assets de Face ID/autenticação

### Fontes

As fontes ficam em:

```text
PayUp/Resources/K2D
```

Arquivos:

- `K2D-Bold.ttf`
- `K2D-Regular.ttf`
- `K2D-SemiBold.ttf`
- `OFL.txt`

## Como Rodar

1. Clone o repositório:

```bash
git clone https://github.com/Guilherme006/PayUp.git
```

2. Abra o projeto no Xcode:

```bash
open PayUp.xcodeproj
```

3. Selecione o scheme `PayUp`.

4. Escolha um simulador ou dispositivo físico.

5. Rode o app com `Cmd + R`.

## Permissões

O app solicita permissão para notificações locais no primeiro launch. Essa permissão é necessária para os lembretes de cobranças recorrentes.

## Persistência de Dados

Os dados são armazenados localmente no dispositivo. Não há backend remoto, sincronização em nuvem ou autenticação externa implementada no fluxo atual.

## Pontos de Atenção

- A Splash existe, mas não está definida como tela inicial no fluxo atual.
- A opção `Anualmente` aparece no formulário, mas ainda não é tratada no cálculo de próximas notificações.
- O filtro da Home atualmente filtra lançamentos por nome.
- O banco SQLite não possui migrações versionadas.
- O projeto ainda não possui testes automatizados versionados.
- Arquivos de produto compilado, como `PayUp.app`, não devem ser versionados.

## Convenções do Projeto

- Interfaces são criadas por código usando UIKit.
- Views customizadas ficam em `Sources/Core/Components`.
- Features ficam isoladas em `Sources/Features`.
- Estilos globais ficam em `Colors` e `Typography`.
- Persistência e notificações ficam centralizadas em managers.

## Status Atual

O app contém a base funcional para cadastro, edição, exclusão, listagem e notificações locais de cobranças. A estrutura atual permite evoluir o produto adicionando autenticação real, dashboard financeiro, histórico de pagamentos, status de cobrança, migrações de banco e testes automatizados.
