## Finding sur Cagnotte

### Checks-Effects-Interactions
.Titre: Reentracy faille sur la fonction retirerTout
.Gravite: High, le finding reentrancy peut vider le contract
.Description: La procedure Checks-Effects-Interactions n'a pas ete applique dans la fonction retirerTout
Il n'y a pas de mis a jour avant des variables totalDepots et depots[msg.sender] = 0 avant l'envoi des fonds ce qui ouvre un finding de Reentracy
.Preuve (PoC) :testAttaque
.Correction recommandée: Faire le CEI, mettre a jour les variables avnt l'envoi des fonds

### Operation 
.Titre: Ordre sur l'operation des frais
.Gravite: Low, Impact sur les frais preleve
.Description: Dans la fonction retirerTout sur le calcul des frais il y a une division sur le montant avant la multiplication, sachant que la division tronque les frais attendu sur une transaction peuvent differer.
.Preuve (PoC): testPerteDePrecisionDansCalculFrais
.Correction recommandee: montant * fraisBps / 10000

### Autorisation
.Titre: Autorisation sur le changement de frais
.Gravite: High 
.Description: la syntaxe tx.origin pour faire passer une autorisation peut aboutri sur un phushing et ne garantit rien
.PoC:
.Correction Recommandee: Utiliser msg.sender == owner

### Audit Comptable
.Titre: Mauvaise Gestion comptable
.Gravite: High, Impact sur les depot
.Descriptiom: Lors du retrait les frais sont depuis qui reste sur le contrat mais ne sont pas prise en compte lors de la mise a jour de la variable totalDepots, tout le montant est deduit de cette variable ce qui a pour consequence sur sur la balance du contat et totalDepots qui differe ce qui impact le depot via l'instruction  require(address(this).balance - msg.value == totalDepots, "Etat incoherent"); dans la fonction deposer
PoC: testRetraitAvecFraisFaitEchouerDepot
.Correction Recommandee: Inclure les frais lors de la mise a jour de Depot total

### Event
.Titre: Event Manquant 
.Gravite: Low,
.Description: Aucune event n'est emit pour signaler le changement des frais.
.Poc:
.Correction Recommandee: Emettre un event avant la mise a jour du frais

### Vulnerabilite
.Titre: Vulnerabilite dans la fonction de distribution
.Gravite: Medium, DoS attaque
.Description: Utilisation de la fonction transfer limite a 2300 gas, utilisation d'un tableau pour gerer les participant pourrait depasser la limite de gas.
PoC:
.Correction Recommandee: Utiliser la fonction call pour la distribution des bonus.

### Control d'acces
.Titre: Owner public et non immutable
.Gravite : Informatif, manipulation de la variable owner par tout le monde ;
.Desciption: La variable Owner est public et non immutable 
.Preuve (PoC) : NaN
.Correction recommandée. Mettre Owner en private et immutable

### Pragma flottant
. Titre: Pragma flottant
. Gravite: Informatif 
. Desciption: Le contrat Cagnotte utilise un pragma flottant ^0.8.20 ce qui permet de l'execute sur (0.8.20 à 0.9.0 exclu) ce n'est pas en soi un finding critique mais mettre le Contrat sur une version fixe est la meilleur solution
.Preuve (PoC) : NaN
.Correction recommandée. Mettre un pragma fixe.
