📌 DueTime
📱 DueTime

DueTime é um aplicativo Flutter desenvolvido para auxiliar no gerenciamento e controle de prazos importantes relacionados a documentos e processos pessoais.

O app permite cadastrar documentos com datas de validade e receber notificações automáticas antes do vencimento, ajudando o usuário a evitar atrasos e esquecimentos.

🎯 Objetivo

O DueTime foi criado para:

Organizar datas de vencimento

Alertar automaticamente antes do prazo

Centralizar controle de documentos importantes

Reduzir riscos de perda de validade

Facilitar planejamento pessoal

🚀 Funcionalidades Principais
📄 Cadastro de Documentos

O usuário pode registrar documentos com:

Nome do documento

Número do documento

Data de emissão

Data de validade

Observações adicionais

🔔 Notificações Automáticas

O aplicativo envia notificações locais:

Antes do vencimento

No dia do vencimento

De forma automática via agendamento interno

Tecnologia utilizada:

flutter_local_notifications

timezone

WorkManager (quando aplicável)

🗂 Listagem Inteligente

Os documentos cadastrados são exibidos em lista organizada, permitindo:

Visualização rápida do status

Identificação de documentos próximos do vencimento

Atualização ou exclusão de registros

🔐 Validação de Campos

Campos obrigatórios validados

Controle de formato de entrada

Tratamento para evitar dados inválidos

🛠 Tecnologias Utilizadas

Flutter

Dart

Android SDK 35+

Android App Bundle (AAB)

Google Play App Signing

Notificações locais

🏗 Arquitetura

O projeto segue estrutura padrão Flutter:

lib/
 ├── main.dart
 ├── screens/
 ├── models/
 ├── services/
 └── widgets/


Separação por responsabilidade:

UI (Screens)

Lógica de negócio

Serviços de notificação

Modelos de dados

📦 Build e Publicação
🔧 Requisitos

Flutter SDK atualizado

Android SDK 35+

Java 17+

▶️ Executar em modo debug
flutter run

📦 Gerar Android App Bundle (Play Store)
flutter clean
flutter pub get
flutter build appbundle --release


Arquivo gerado:

build/app/outputs/bundle/release/app-release.aab

🔒 Configuração Android

compileSdk = 36

targetSdk = 35

Assinatura via Google Play App Signing

Package:

com.guilhermegoulart.duetime

📈 Controle de Versão

O versionamento segue padrão:

version: 1.0.1+3


Onde:

1.0.1 → versão visível ao usuário

3 → versionCode interno da Play Store

📲 Compatibilidade

Android 7.0+ (API 24 ou superior)

Compatível com:

Smartphones

Tablets

Chromebooks

Android Automotive (limitado)

🔮 Possíveis Evoluções Futuras

Backup em nuvem

Sincronização entre dispositivos

Exportação de dados

Filtros avançados

Interface aprimorada

Dark Mode automático

Histórico de renovações

🧠 Boas Práticas Implementadas

Atualização para targetSdk 35

Ajustes para políticas Play 2026

Notificações compatíveis com Android 13+

Controle de versionCode incremental

Estrutura de pacotes Android correta

👨‍💻 Desenvolvedor

Guilherme Goulart

📄 Licença

Este projeto é de uso privado / educacional.