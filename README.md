# 📞 Call System

Un système d'appel d'urgence moderne et intuitif pour FiveM, permettant aux joueurs de signaler des incidents et de recevoir des alertes en temps réel avec navigation GPS intégrée.

## 🗂️ Sommaire
- [Fonctionnalités](#-fonctionnalités)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
- [Build de l'UI](#️-build-de-lui)
- [Compatibilité](#-compatibilité)

## ✨ Fonctionnalités
- 🎯 Menu interactif (TypeScript/NUI) pour créer des appels d'urgence
- 📍 Positionnement automatique de l'appelant
- 🔔 Notifications en temps réel pour tous les joueurs
- 🗺️ Création automatique d'un waypoint GPS
- 📏 Calcul de distance en temps réel
- 🎨 Interface moderne et responsive

## 📋 Prérequis
- [bulletin](https://github.com/Mobius1/bulletin) — système de notifications
- FiveM Build 2802+ recommandé

## 📦 Installation
1) Téléchargez ou clonez la ressource dans votre dossier `resources` :
   ```bash
   # via git (exemple)
   git clone https://github.com/Noums75/call-system.git
   ```
2) Assurez-vous d’avoir la dépendance **bulletin** dans `resources`.
3) Dans `server.cfg`, ajoutez :
   ```cfg
   ensure bulletin
   ensure call-system
   ```
4) Redémarrez votre serveur.

## 🎮 Utilisation
Commande principale :
```
/appel
```
Depuis le menu NUI, vous pouvez :
- 📝 Choisir le motif de l'urgence
- 🙋‍♂️ Renseigner votre identité
- 📄 Décrire la situation

Lorsqu'un appel est émis :
1. 🔔 Tous les joueurs en ligne reçoivent une notification via bulletin.
2. 📏 La distance entre le joueur et l'incident est affichée.
3. 🗺️ Appuyez sur **Y** pour créer un point GPS vers l'incident.

## 🛠️ Build de l’UI
L’interface est écrite en TypeScript. Pour recompiler :
```bash
npm install
npm run build
```

## ⚙️ Compatibilité
- ✅ FiveM Build 2802+
- ✅ Lua 5.4
- ✅ bulletin (dernière version recommandée)
