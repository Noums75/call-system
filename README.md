# 📞 Call System

Un système d'appel d'urgence moderne et intuitif pour FiveM, permettant aux joueurs de signaler des incidents et de recevoir des alertes en temps réel avec navigation GPS intégrée.

## ✨ Fonctionnalités

- 🎯 Menu interactif pour créer des appels d'urgence
- 📍 Système de positionnement automatique ou manuel
- 🔔 Notifications en temps réel pour tous les joueurs
- 🗺️ Création automatique de waypoint GPS
- 📏 Calcul de distance en temps réel
- 🎨 Interface moderne et responsive

## 📋 Prérequis

Avant d'installer ce script, assurez-vous d'avoir les dépendances suivantes :

- [ox_lib](https://github.com/overextended/ox_lib) - Bibliothèque UI et utilitaires
- [bulletin](https://github.com/Mobius1/bulletin) - Système de notifications

## 📦 Installation

1. **Téléchargez** la ressource et placez-la dans votre dossier `resources`

2. **Installez les dépendances** (si ce n'est pas déjà fait) :
   ```bash
   # Assurez-vous d'avoir ox_lib et bulletin dans votre dossier resources
   ```

3. **Ajoutez** la ressource à votre `server.cfg` :
   ```cfg
   ensure ox_lib
   ensure bulletin
   ensure call-system
   ```

4. **Redémarrez** votre serveur

## 🎮 Utilisation

### Commande principale

```
/appel
```

Cette commande ouvre un menu interactif où vous pouvez : 
- 📝 Saisir une description détaillée de l'incident
- 📍 Spécifier une position (numérique) ou utiliser votre position actuelle
- ✅ Valider et envoyer l'appel à tous les joueurs

### Réception des appels

Lorsqu'un appel est émis : 
1. 🔔 Tous les joueurs en ligne reçoivent une notification via bulletin
2. 📏 La distance entre le joueur et l'incident est affichée
3. 🗺️ Appuyez sur la touche **Y** pour créer un point GPS vers l'incident

## ⚙️ Configuration

Le script est prêt à l'emploi sans configuration supplémentaire. Les paramètres par défaut sont optimisés pour une utilisation standard.

## 🛠️ Compatibilité

- ✅ FiveM Build 2802+
- ✅ Lua 5.4
- ✅ ox_lib (dernière version recommandée)
- ✅ bulletin (dernière version recommandée)

⭐ Si ce script vous est utile, n'hésitez pas à mettre une étoile sur le repository ! 
