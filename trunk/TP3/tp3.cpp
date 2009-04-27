#include <iostream>
#include <fstream>
#include "tp3.h"

#define FILENAME "fichier.txt" // Fichier a utiliser

using namespace std;



int main() {
	char * mot;
	char motc;
	int fsize, i;
	PtrNoeud premier = new NoeudArbre;
	if (!verifierFichier((char *)FILENAME, fsize)) {
		cout << "Fichier invalide" << endl;
		fEntree.close();
		return 0;
	}
	if (fsize > LONGUEURTAMPON)
		cout << "Le fichier contient plus de caracteres que le maximum (" << LONGUEURTAMPON << ")" << endl;
	ProchainMot(mot);
	do {
		premier->mot = mot;
		premier->compte = 1;
		premier->droite = NULL;
		premier->gauche = NULL;
		motc = mot[0];
	} 
	while (motc == 0 && ProchainMot(mot) != -1);

	while((i = ProchainMot(mot)) != 1) {
		motc = mot[0];
		if ((int)motc != 0)
			Inserer(mot, premier);
	}
	Afficher(premier);

	return 0;
}

// Cette methode verifie que le fichier existe, qu'il contienne des caractere valide et qu'il a un taille > 0
bool verifierFichier(char * fichier, int &size) {
	bool found = false;
	unsigned char carac;
	
	fEntree.open(fichier, ios::in);
	fEntree.seekg(0, ios_base::end);
	size = fEntree.tellg();
	fEntree.seekg(0, ios_base::beg);
	
	while (fEntree.tellg() < size && !found)  {
		carac = fEntree.get();
		bool valide = (carac >= 'A' && carac <= 'Z')||
			(carac >= 'a' && carac <= 'z')||carac =='-'||
			(carac >= '0' && carac <= '9');
		if (valide) { // Il y a minimum UN caractere valide 
			found = true;
			fEntree.seekg(0, ios_base::beg);
		}
	}
	return found;
		

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
	bool nonEspace = false;
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
				(carac >= '0' && carac <= '9');
		
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

