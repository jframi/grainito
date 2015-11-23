# grainito
Grainito automatise l'analyse avec ImageJ (http://imagej.nih.gov/ij/) d'images de grains (sorgho, mil) scannés sur un scanner à plat.

Le programme analyse l'ensemble des images contenues dans un répertoire.

## Installation

Sauvegarder le fichier grainito.ijm dans le répertoire macro de ImageJ (ou là où bon vous semble)

Dans ImageJ, choisir Plugins>Macros>Install...  
et sélectionner le fichier grainito.ijm

Puis  Plugins>Macros>grainito pour lancer le programme


## Analyse

Choisir la couleur de fond des images (Black or White)

Choisir une méthode de seuillage automatique (voir doc ImageJ)

L'analyse de toutes les images (*.jpg) contenues dans le répertoire se fait automatiquement.

Le programme sauve pour chaque image :
- un fichier image.mask.jpg : image seuillée qui contient les grains détectés
- un fichier image.txt : tableau avec une ligne par grain et les caractéristiques de chaque grain

## Post analyse

Le script perl postgrainito.pl permet de concaténer tous les fichiers txt en un seul en rajoutant le nom du fichier en première colonne.

Une fois importé dans R ce fichier peut etre analysé pour avoir les statistiques de chaque image;
