#!/bin/bash

# Démarrer le worldserver en arrière-plan
/wodcore/build/src/server/worldserver/worldserver &

# Démarrer le authserver en arrière-plan
/wodcore/build/src/server/authserver/authserver &

echo "Les serveurs sont en cours d'exécution."