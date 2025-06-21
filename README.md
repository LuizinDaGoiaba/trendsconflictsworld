# 🧠 ACLED Event Monitor - Flutter + Firebase

Aplicativo Flutter para monitorar eventos de conflitos globais via API ACLED, com autenticação Firebase, watchlist pessoal com comentários, e mapa interativo usando Mapbox.

---

## ✅ Funcionalidades

- Login com **e-mail/senha** e **Google** via Firebase Authentication  
- Consulta de eventos com filtros (país e palavra-chave)  
- Marcação de eventos como favoritos (watchlist)  
- Adição de **comentários pessoais** em ordem cronológica para cada evento  
- Visualização dos eventos no mapa interativo (Flutter Map + Mapbox)  
- Sincronização e armazenamento em tempo real com Firebase Firestore  

---

## 🧩 Tecnologias Utilizadas

- **Flutter** (SDK 3.8)  
- **Firebase** (Authentication + Firestore)  
- **Google Sign-In**  
- **Flutter Map** com API do **Mapbox**  
- Arquitetura **MVC** (models, views, controllers)  

---

## 📁 Organização do Projeto

![image](https://github.com/user-attachments/assets/fa86f6fc-99ae-4386-8917-4c24e93b0c1e)


## 🔧 Configuração do Firebase
1. Crie um projeto no Firebase Console
2. Ative os serviços:
   - Authentication: ative os métodos "Email/senha" e "Login com Google"
   - Crie um app Flutter
     • Gere o firebase_options.dart com: flutterfire configure
3. Adicione o domínio autorizado
   - Se estiver testando via Firebase Hosting ou Workstation, adicione o domínio em: Authentication > Método de login > Google > Domínios autorizados

## 🖥️ Prints do Emulator Suite
• Dashboard do Emulator Suite
![firebase emulator suite - dashboard](https://github.com/user-attachments/assets/a4017a2e-e3ab-4fdb-a968-79c24e5c551c)

• Firestore mostrando coleções - users/{uid}/watchlist/{eventId}
![firebase emulator suite - users](https://github.com/user-attachments/assets/515a1291-e555-43dc-8de0-1276805af074)
![firebase emulator suite - watchlist](https://github.com/user-attachments/assets/696bf7d2-a4e7-4643-bb27-478b506251e6)
![firebase emulator suite - notes](https://github.com/user-attachments/assets/352cae54-1acb-4589-9927-74101b1b5c9d)


## ▶️ Como executar o projeto
• Pré-requisitos:
  - Flutter instalado
  - Conta no Firebase
  - Chave de API do Mapbox (se estiver usando)
### Passos para rodar

1. Clone o repositório:
   ```bash
   git clone https://github.com/LuizinDaGoiabaa/trendsconflictsworld.git
   cd trendsconflictsworld
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Execute o app Flutter no dispositivo ou emulador:
   ```bash
   flutter run
   ```
4. Faça login com e-mail/senha e utilize o aplicativo normalmente.

## 📝 Observações finais
Este projeto utiliza a arquitetura MVC para organização do código, facilitando a manutenção e escalabilidade.
