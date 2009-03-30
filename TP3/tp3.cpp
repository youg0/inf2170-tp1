#include <iostream>
#include <fstream>
#include "tp3.h"

#define FILENAME "fichier.txt" // Fichier a utiliser

using namespace std;

int main() {
	char * mot;
	PtrNoeud premier = new NoeudArbre;
	fEntree.open(FILENAME, ios::in);

	ProchainMot(mot);
	premier->mot = mot;
	premier->compte = 1;
	premier->droite = NULL;
	premier->gauche = NULL;

	while(ProchainMot(mot) != 1) 
		Inserer(mot, premier);


	Afficher(premier);

	return 0;
}

int Comparaison(char *Mot1, char *Mot2) // Comparer deux mots du tampon global.
{
	int i = 0;
	int j = 0;
	while(true){
		if(Mot1[i] != Mot2[j])        // non identiques
			if(Mot1[i] < Mot2[j])
				return -1;                // plus petit
			else
				return 1;                 // plus grand
		else if(Mot1[i] == FINCHAINE)
			return 0;                   // identiques
		i++; j++;
	}
} // Comparaison;

bool Chercher(char * Mot, PtrNoeud Arbre) // Chercher un élément dans l'arbre
{ 
	int compar;
	if(Arbre == NULL)
		return false;
	else{
		compar = Comparaison(Mot, Arbre->mot);
		if(compar == -1)
			return Chercher(Mot, Arbre->gauche);
		else if(compar == 1)
			return Chercher(Mot, Arbre->droite);
		else if(compar == 0)
			return true;
	}
	return false;
}// Chercher



void Inserer(char * Mot, PtrNoeud & Arbre) // insérer un élément dans l'arbre
{
	if(Arbre == NULL){
		Arbre = new NoeudArbre;    // nouveau noeud rattaché à l’arbre
		Arbre->mot = Mot;          // adresse du mot
		Arbre->compte = 1;         // première occurrence
		Arbre->gauche = NULL;      // pas de descendant gauche
		Arbre->droite = NULL;      // pas de descendant droit
	}
	else
		if(Comparaison(Mot, Arbre->mot) == -1) // + petit, à gauche
			Inserer(Mot, Arbre->gauche);
		else
			if(Comparaison(Mot, Arbre->mot) == 1)// + grand, à droite
				Inserer(Mot, Arbre->droite);
			else
				Arbre->compte++; // déjà là, mise à jour compteur
}// Inserer



int ProchainMot(char * &Mot)
{ 
	int fdf;
	Mot = &Tampon[IndexTamp];
	bool valide;
	unsigned char carac;
	do
	{
		carac = fEntree.get();
		if(!fEntree.eof()){
			fdf = 0;
			valide = (carac >= 'A' && carac <= 'Z')||
				(carac >= 'a' && carac <= 'z')||carac =='-'||
				(carac >= 192 && carac <= 255); // négatifs 'À' à 'ÿ'
			if(valide){
				Tampon[IndexTamp] = carac;
				IndexTamp++;
			}else{
				Tampon[IndexTamp] = 0;
				IndexTamp++;
			}
		}else{
			Tampon[IndexTamp] = 0;
			IndexTamp++;
			fdf = 1;
		}
	} 
	while(valide && fdf == 0);
	
	return fdf;
}


void Afficher(PtrNoeud Arbre) // traversée infixe
{
	if(Arbre != NULL){
		Afficher(Arbre->gauche);
		cout << Arbre->mot << " utilisé " << Arbre->compte << " fois." << endl;
		Afficher(Arbre->droite);
	}
}// Afficher

