# Carnet de failles

1. Contrôle d’accès: la gravité dépend de ce que contrôle la variable. Si number servait de prix, de taux ou d’adresse de propriétaire, un setNumber ouvert à tous serait une faille critique : n’importe qui pourrait vider les fonds. En audit, on signale l’absence de contrôle d’accès dans tous les cas, puis on évalue la gravité selon l’impact.

2. Overflow. Le panic 0x11 vient du fait que depuis Solidity 0.8, l’arithmétique est vérifiée automatiquement. Avant la 0.8, la valeur repartait silencieusement à 0. Cette faille a coûté très cher à plusieurs tokens. Retiens aussi qu’on peut encore désactiver cette vérification avec un bloc unchecked { }. C’est la première chose à regarder quand tu en vois un dans un audit.