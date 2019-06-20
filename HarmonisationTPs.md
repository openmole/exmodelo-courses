# Harmonisation TPs

## Instances OpenMOLE
### Instances de groupe: 
https://om.exmodelo.org/group1 (auth: xmodel01@myria.criann.fr)
https://om.exmodelo.org/group2 ...
https://om.exmodelo.org/group3 ...
https://om.exmodelo.org/group4 ...
https://om.exmodelo.org/group5 ...
https://om.exmodelo.org/group6 ...
https://om.exmodelo.org/group7 ...
https://om.exmodelo.org/group8 (auth: xmodel08@myria.criann.fr)

### Instances enseignants:
*Ne rien stocker dedans, c'est juste pour du débug et aider pendant les TPs*

https://om.exmodelo.org/teach1
https://om.exmodelo.org/teach2
https://om.exmodelo.org/teach3

### Instances élèves:
https://om.exmodelo.org/<firstname>

*Ex: https://om.exmodelo.org/hugo*

## Tps 
### Réplication / Stochasticité / Aggrégation (Paul)
    
**Replication.tgz**
    
- Mini présentation de 4 slides
- Fichiers dans l'archive replication.tgz:
    - Model.oms
    - Replication.oms (avec import de Model)
- Décrire le modèle + mesures
- Expliquer l'import (1 oms avec le modèle, puis 1 oms par methode ) 
- Lancer une fois (hook display)
- Lancer avec hook fichier.csv 
- Lancer  tâche de replication 
- Aggregation

### DOE / Analyse sensibilité
    
**DOESensibility.tgz**
    
- couplé avec cours DOE/DirectSampling
- Fichiers dans l'archive DOESensitivity.tgz : 
    - directsampling.oms
    - ? (replace Saltelli by morris if results are not consistent)
- Déroulé : 
    - à la suite du DirectSampling (complete plan and high dim samplings) : ouvrir directsampling.oms
    - montrer difference avec replication.oms seen proviously : syntaxe de `DirectSampling`
    - s'amuser avec run plan complet et LHS (comment/uncomment)
    - a la suite des methodes de sensitivity: ouvrir ?
    - jouer avec, puis comments d'une sortie (Saltelli ou Morris)
    
    
### Calibrage / Optimisation
    
**CalibrateOptimisation.tgz**
**medians.csv**
    
**Matériel:** 
- Les données temporelles brutes (100 courbes) sur des attaques répétées dans des stades
- La liste des médianes par time step sur les données brutes précédentes (à faire télécharger en 2ème temps: medians.csv)
- La fonction aggregation (valeurs absolues) dans un oms

**Éléments de contexte des données:**
- On a pu (quelle chance !) récupérer des données tous les 20 pas de temps sur le nombre de rescued,
- Les données ont été captées dans des stades avec tous la même configuration spatiale

**Première partie: NSGA2 pour calibrer un modèle**
- Les faire réfléchir sur comment calibrer le modèle à partir des données brutes
- Faire un calibrage pour fitter à la dynamique (distance en valeur absolue)
- Dire (juste une slide) que les résultats sur un calibrage avec un seul point de mesure (#rescued en fin de simu) ne permettent pas de calibrer le modèle: importance de bien définir sa mesure.
    
**Deuxième partie: NSGA2 pour optimiser: Politique de la ville de formation des habitants**
- Levier de la ville (recommandations publiques): 
    - humanFollowProbability (à encourager ou pas ?)
    - devez courrir le plus vite possible ou vous économiser ?
- Formation de la ville
    - savoir ou sont les rescues (humanInformedRatio) ou savoir expliquer où sont les issues (humanInformProbability)

    
### TP Libre: Plan complet / analyse de sensibilité
- présenter l'armée avec 3 paramètres libres
- les laisser se poser 

### PSE
- Faire écrire le script de PSE

avec les résultats : 
    
  /!\  selectionner les patterns suffisament répliqués
    
prendre 3 patterns : celui en bas à gauche , celui en haut à droit et celui au milieu des deux précédents
    
    
L'objectif est de discuter la **precision** des indicateurs retenus pour décrire la dynamique générale du run ainsi paramétré.

Si on obtient les même trajectoires qualitativement : on a de bonnes mesures pour qualifier l'évolution des pop , sinon ben non !

introduction d'une mesure nombre de 

    
### Profile


    
    



    
    
    
    