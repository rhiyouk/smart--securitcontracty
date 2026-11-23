## Finding sur storage Factory

### Verification sur les index
. Titre: Finding sur l'index de stockage 
. Gravite: Eleve car le stockage se fait en desordre et un attaquant peut utiliser cette faille
. Desciption: La fonction sfStore laisse passer le stockage dans le tableau listOfSimpleStorageContract a n'importe quel index sans verification, faudra verifier la taille du tableau pour inserer l'element suivant a la bonne place
.Preuve (PoC) : testSfstoreOutOfBoundsEmptyArray, testSfstoreOutOfBoundshighIndex
.Correction recommandée. Verifier la taille du tableau et stocker a l'index qui convient

### Control d'acces
.Titre: Stockage via Factory
.Gravite : Eleve car il n'y a pas de control sur celui qui peut sotocker, c'est une faille critique qui peut etre utiliser par un attaquant
.Desciption: Il n y a de controle sur La fonction sfStore laisse et donc n'importe qui peut stocker des donnees dans listOfSimpleStorageContract et dans utiliser la fonction store de Simple storage.
.Preuve (Poc) : test_AnyoneCanStoreViaFactory
.Correction recommandée. 2 choix possible 
    - Ajouter un onlyOwner sur factory si seul l'admin doit gerer tous les contrats;
    - Enregistrer qui a enregistrer qui a créé chaque contrat (mapping(uint256 => address) creatorOf) et vérifier msg.sender == creatorOf[index] dans sfStore


