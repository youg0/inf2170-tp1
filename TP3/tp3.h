using namespace std;

const int LONGUEURTAMPON = 20000;
const char FINCHAINE = 0;
char Tampon[LONGUEURTAMPON]; // tampon de mots global
int IndexTamp = 0;           // index global du tampon global

ifstream fEntree;            // fichier d'entrée global

struct NoeudArbre;
typedef NoeudArbre *PtrNoeud;
struct NoeudArbre{char * mot;         // adresse du mot
                   int compte;        // nombre d’apparitions du mot
                   PtrNoeud gauche;   // pointeur gauche
                   PtrNoeud droite;}; // pointeur droit

int ProchainMot(char * &Mot);
void Inserer(char * Mot, PtrNoeud & Arbre);
bool Chercher(char * Mot, PtrNoeud Arbre);
int Comparaison(char *Mot1, char *Mot2);
void Afficher(PtrNoeud Arbre);

