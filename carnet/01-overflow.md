## Overflow

Contexte: Les variables de types int et uint possede un nombre maximal qu'il peuvent stocker. Au dela de ce nombre solidity nous sort un erreur de panic 0x11 qui vient de la version 0.8 de solidity et verifie qu'il n'y est pas d'erreur d'overflow meme sur les operations l’arithmétique.
Avant la version 0.8 de solidity la valeur repartait à 0, Cette faille a coûté très cher à plusieurs tokens.
La verification de l'overflow peux etre encore desactiver avec un bloc unchecked 

Premiere verification à faire lors d'un audit.