## Finding sur Cagnotte

### Control d'acces
.Titre: Owner public et non immutable
.Gravite : Informatif, manipulation de la variable owner par tout le monde ;
.Desciption: La variable Owner etant public peut etre remplacer par n'importe qui(un attaquqnt) pour prendre le controle du contrat et manipuler d'autres fonction
.Preuve (PoC) : 
.Correction recommandée. Mettre Owner en private et immutable

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
.Preuve (PoC):
.Correction recommandee:

### Operation 
.Titre: Division par 0
.Gravite: High, Impact sur les retrait
.Description: Il n y a aucune verification sur le cas ou les frais sur retrait seront a zero et donc l'operation uint256 frais = montant / (10000 * fraisBps); peut devenir un probleme dans le cas ou on priorise la multiplication a la division
.Preuve (PoC):
.Correction recommandee:

### Autorisation
.Titre: Autorisation sur le changement de frais
.Gravite: Informatif 
. Description: la syntaxe tx.origin pour faire passer une autorisation peut aboutri sur un phushing et ne garantit rien
.PoC:
.Correction Recommandee: Utiliser un modifiers pour valider l'autorisartiion

### Event
.Titre: Event Manquant 
.Gravite: Low,
.Description: Aucune event n'est emit pour signaler le changement des frais.
.Poc:
.Correction Recommandee: Emettre un event avant la mise a jour du frais

### Vulnerabilite
.Titre: Vulnerabilite dans la fonction de distribution
.Gravite: High, DoS attaque
.Description: Utilisation de la fonction transfer limite a 2300 gas, utilisation d'un tableau pour gerer les participant pourrait depasser la limite de gas et pas de CEI.
PoC:
.Correction Recommandee: Utiliser la fonction call pour la distribution des bonus, faire un Checks-Effects-Interactions et gerer les participants autrement.


### Pragma flottant
. Titre: Pragma flottant
. Gravite: Informatif 
. Desciption: Le contrat Cagnotte utilise un pragma flottant ^0.8.20 ce qui permet de l'execute sur (0.8.20 à 0.9.0 exclu) ce n'est pas en soi un finding critique mais mettre le Contrat sur une version fixe est la meilleur solution
.Preuve (PoC) : La deuxieme ligne du contrat Cagnotte
.Correction recommandée. Mettre un pragma fixe.
