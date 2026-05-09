# PayUp

PayUp e um aplicativo iOS para organizar cobrancas de clientes. O app permite cadastrar clientes, registrar valor e data de cobranca, listar lancamentos por dia, calcular recebimentos do dia e agendar lembretes locais para cobrancas recorrentes.

O projeto foi desenvolvido com UIKit, Swift e interface programatica, sem Storyboards para as telas principais.

## Visao Geral

Principais funcionalidades:

- Cadastro de clientes com nome, contato, telefone, CNPJ, endereco, valor e data de cobranca.
- Edicao e exclusao de clientes cadastrados.
- Listagem horizontal de clientes na Home.
- Visualizacao de lancamentos por dia da semana.
- Calculo do total de recebimentos do dia atual.
- Filtro de lancamentos por nome do cliente.
- Agendamento de notificacoes locais para cobrancas recorrentes.
- Identidade visual propria com cores, fontes K2D e assets customizados.

## Tecnologias

- Swift 5
- UIKit
- Auto Layout programatico
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

O projeto segue uma organizacao proxima de MVVM usando UIKit:

- `ViewController`: coordena ciclo de vida da tela, eventos do usuario, apresentacao de telas e conexao entre view e view model.
- `View`: monta a interface visual usando UIKit e Auto Layout.
- `ViewModel`: concentra regras de apresentacao, formatacao e acesso aos dados.
- `Model`: representa as entidades e estruturas usadas pelo app.
- `DatabaseManager`: centraliza persistencia local em SQLite.
- `NotificationManager`: centraliza o agendamento e cancelamento de notificacoes locais.

## Ciclo de Inicializacao

O ponto de entrada do app fica em `AppDelegate.swift`, marcado com `@main`.

Durante a inicializacao, o app solicita permissao para notificacoes locais:

```swift
UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
```

A janela principal e configurada em `SceneDelegate.swift`. O app cria uma `UIWindow`, instancia uma `UINavigationController` e define a `HomeViewController` como tela inicial.

## Features

### Home

Arquivos principais:

- `Sources/Features/Home/View/HomeView.swift`
- `Sources/Features/Home/View/HomeViewController.swift`
- `Sources/Features/Home/ViewModel/HomeViewModel.swift`

A Home e a tela principal do aplicativo. Ela exibe:

- Cabecalho com logo, botao de notificacao e imagem de perfil.
- Seletor horizontal de dias da semana.
- Card com recebimentos de hoje.
- Botao para adicionar cliente.
- Lista horizontal de clientes.
- Secao de lancamentos.
- Botao de filtro por nome.

Responsabilidades principais:

- Buscar clientes no banco local.
- Transformar clientes em modelos de exibicao.
- Calcular o total de recebimentos do dia atual.
- Filtrar lancamentos por nome.
- Atualizar a lista quando dados de cliente mudam.

### Formulario de Cliente

Arquivos principais:

- `Sources/Features/Form/View/ClientFormView.swift`
- `Sources/Features/Form/View/ClientFormViewController.swift`
- `Sources/Features/Form/View/ClientFormViewDelegate.swift`
- `Sources/Features/Form/ViewModel/ClientFormViewModel.swift`

O formulario funciona em dois modos:

- `.add`: adiciona um novo cliente.
- `.edit(Client)`: edita ou exclui um cliente existente.

Campos do formulario:

- Valor
- Data de cobranca
- Cobranca recorrente
- Frequencia da recorrencia
- Dia selecionado
- Nome do cliente
- Contato
- Telefone
- CNPJ
- Endereco

Ao salvar, os dados sao convertidos em um `Client` e enviados ao `ClientFormViewModel`, que usa o `DatabaseManager` para persistir. Caso o cliente tenha cobranca recorrente, o `NotificationManager` agenda os lembretes.

### Splash

Arquivos principais:

- `Sources/Features/Splash/View/SplashView.swift`
- `Sources/Features/Splash/View/SplashViewController.swift`
- `Sources/Features/Splash/ViewModel/SplashViewModel.swift`

A feature de Splash contem uma animacao inicial com logo e triangulo. Atualmente, a tela inicial configurada no `SceneDelegate` e a `HomeViewController`, entao a Splash existe no projeto, mas nao esta conectada ao fluxo inicial.

## Core

### Components

Componentes reutilizaveis do app:

- `AuthenticationView`: tela/componente visual de autenticacao.
- `CompanyCell`: celula da lista horizontal de empresas/clientes.
- `CompanyListView`: collection view horizontal para clientes.
- `CurrencyTextField`: campo customizado para valor monetario.
- `DatePickerTextField`: campo customizado com seletor de data.
- `DaySelectorView`: seletor horizontal de dias da semana.
- `InputTextFieldView`: campo de texto padronizado com mascaras por tipo.
- `PaymentCardView`: card visual para valores e lancamentos.

### Models

Modelos principais:

- `Client`: representa um cliente/cobranca persistida.
- `ClientFormMode`: define modo de abertura do formulario.
- `CompanyItemModel`: modelo visual para item da lista de clientes.
- `InputTextFieldType`: define o tipo de campo e mascaras.
- `PaymentCardModel`: modelo visual para cards de pagamento.
- `PaymentCardType`: define tipo, icone e subtitulo do card.

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

Operacoes disponiveis:

- Inserir cliente.
- Atualizar cliente.
- Buscar todos os clientes.
- Buscar cliente por ID.
- Excluir cliente.

### Notifications

Arquivo principal:

- `Sources/Core/Database/NotificationManager.swift`

O `NotificationManager` agenda notificacoes locais para clientes recorrentes usando `UNUserNotificationCenter`.

Frequencias tratadas:

- `Diariamente`
- `Semanalmente`
- `Mensalmente`

Observacao: o formulario tambem apresenta a opcao `Anualmente`, mas a logica atual de notificacao ainda nao possui tratamento para essa frequencia.

### Colors

Arquivo:

- `Sources/Core/Colors/Colors.swift`

Centraliza a paleta visual do app. A interface usa fundo escuro e cor de destaque verde.

### Typography

Arquivo:

- `Sources/Core/Typography/Fonts.swift`

Centraliza os estilos tipograficos com a fonte K2D:

- `K2D-Bold`
- `K2D-Regular`
- `K2D-SemiBold`

As fontes sao registradas no `Info.plist` em `UIAppFonts`.

### Extensions

Extensoes utilitarias:

- `UITextField+Ext.swift`: adiciona padding lateral ao `UITextField`.
- `UIView+Ext.swift`: permite encontrar o view controller pai de uma view.

## Recursos

### Assets

Os assets ficam em:

```text
PayUp/Resources/Assets.xcassets
```

Incluem:

- App icon
- Cor de destaque
- Logo principal
- Icones de cobranca
- Imagens de perfil
- Assets da Splash
- Assets de Face ID/autenticacao

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

1. Clone o repositorio:

```bash
git clone https://github.com/Guilherme006/PayUp.git
```

2. Abra o projeto no Xcode:

```bash
open PayUp.xcodeproj
```

3. Selecione o scheme `PayUp`.

4. Escolha um simulador ou dispositivo fisico.

5. Rode o app com `Cmd + R`.

## Permissoes

O app solicita permissao para notificacoes locais no primeiro launch. Essa permissao e necessaria para os lembretes de cobrancas recorrentes.

## Persistencia de Dados

Os dados sao armazenados localmente no dispositivo. Nao ha backend remoto, sincronizacao em nuvem ou autenticacao externa implementada no fluxo atual.

## Pontos de Atencao

- A Splash existe, mas nao esta definida como tela inicial no fluxo atual.
- A opcao `Anualmente` aparece no formulario, mas ainda nao e tratada no calculo de proximas notificacoes.
- O filtro da Home atualmente filtra lancamentos por nome.
- O banco SQLite nao possui migracoes versionadas.
- O projeto ainda nao possui testes automatizados versionados.
- Arquivos de produto compilado, como `PayUp.app`, nao devem ser versionados.

## Convencoes do Projeto

- Interfaces sao criadas por codigo usando UIKit.
- Views customizadas ficam em `Sources/Core/Components`.
- Features ficam isoladas em `Sources/Features`.
- Estilos globais ficam em `Colors` e `Typography`.
- Persistencia e notificacoes ficam centralizadas em managers.

## Status Atual

O app contem a base funcional para cadastro, edicao, exclusao, listagem e notificacoes locais de cobrancas. A estrutura atual permite evoluir o produto adicionando autenticacao real, dashboard financeiro, historico de pagamentos, status de cobranca, migracoes de banco e testes automatizados.
