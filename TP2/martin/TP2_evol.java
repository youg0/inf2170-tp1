/**
 * I N F x 1 2 0
 *
 * DÃ©crivez votre classe TP2_evol ici.
 *
 * @author (votre nom)
 * @version (une date)
 *
 * (votre code permanent)
 * (votre adresse de courriel)
 */
 
public class TP2_evol {

        static char [] tab;
       
    /* Methode pour saisir unu chaine
     * @return chaine saisie
     */    
    public static String saisir (){
        String chaineS;      
        System.out.println( "Donnez une chaine: " );
        chaineS = Clavier.lireString();
        
    return chaineS;
    }
    
    /* Methode qui traite la chaine en appelant les methodes pour enlever les accents,
     * les espaces et les signes de ponctuation de la chaine d'origine.
     * @param chaineS chaine a traiter
     * @return longueur de la chaine apres traitement
     */
    public static int traiter (String chaineS){
        int nbElem = 0;
        int longueur = 0;       
        longueur = chaineS.length();
        tab = enleverEspaces(longueur, chaineS.toCharArray());
        longueur = tab.length;

        for ( int i = 0; i < longueur && longueur != 0; i++ ){
        		tab[i] = epurer(tab[i]);
        		nbElem ++;
            	}
        
      return nbElem;
    }
    
    /* Cette methode recevra en parametre un tableau de caracteres ainsi 
     * que sa longueur, il verifiera s'il y a des signes de ponctuation ou espaces 
     * et les enlevera. Caracteres: ' ! " ' , . : ; ? \s
     * @param longueur de la chaine a traiter
     * @param chaine de caractere a traiter
     * @return chaine de caractere apres traitement
    */
    public static char[] enleverEspaces(int n, char[] tab) {
        int[] notValidChars = { 39, 32, 33, 34, 39, 44, 46, 58, 59, 63 };
        final int nb = 10;  // Il y aura toujours 10 caracteres "invalides" (espaces, signes de pontuation);
        char[] newTab = new char[n];
        char[] finalTab;
        boolean found;
        int count = 0;

        for (int i = 0; i < n;i++) {
            found = false;          
            for (int j = 0; j < nb && !found; j++) {
                if ((int)tab[i] == notValidChars[j])
                    found = true;
            }
            if (!found) {
                newTab[count] = tab[i];
                count++;
            }
        }
        
        finalTab = new char[count];
    
        for (int i = 0; i < count; i++)
            finalTab[i] = newTab[i];
        
        return finalTab;
    }

   /* Cette methode recevra en parametre le caractere a traiter, il verifiera si c'est
    * une majuscule ou un caractere accentue, si tel est le cas, il retournera le meme
    * caractere dans sa forme normale.
    * @param caractere a verifier et remplacer (s'il le faut)
    * @return caractere apres traitement
    */
    public static  char epurer ( int c ){        
       
            if (( c >= 65 && c <= 90 ) || ( c >= 192  &&  c <= 223 )) { // Conversion a minuscule
                c += 32;
            }
           
            if ( c >= 224 && c <= 229 ){ // a + accent
                c = 97;
            } else if ( c >= 232 && c <= 235 ){ // e + accent 
                c = 101;
            } else if ( c >= 236 && c <= 239 ){ // i + accent
                c = 105;
            } else if ( c >= 242 && c <= 246 ){ // o + accent
                c = 111;
            } else if ( c >= 249 && c <= 252 ){ // u + accent
                c = 117;
            } else if ( c == 231 ){ // c + accent
                c = 99;
            } else if ( c == 241 ){ // n + accent
                c = 110;
            } else if ( c == 255 ){ // y + accent
                c = 121;
            }
            return (char)c;
        }
     
    
    
    /* Cette methode recoit en parametre une chaine de caractere sous
     * forme de tableau de caracteres, il verifiera si celui-ci est un
     * palindrome et retournera true si tel es le cas.
     * @param longueur de la chaine de caractere
     * @param chaine de caractere a traiter
     * @return true si le tableau est un palindrome
    */
    public static boolean palin ( int n, char [] tab){
        boolean egal = true;
        for(int i = 0; i <= n && egal; i++, n--){ // Analyse du tableau de caracteres
            if (tab[i] != tab[n - 1]) {
            	egal = false;
            }
        }
        return egal;
    }
    
    public static void main (String[] params) {
       
        int n = 0;
        String chaineS = new String();
      
        do {
        	chaineS = saisir(); 
        	n = traiter(chaineS);
        	if (n != 0)
        		System.out.println(chaineS + (palin(n,tab)?" est un palindrome":" n'est pas un palindrome"));
        	else {
        		System.out.println("Cette chaine ne contient que des caracteres invalides, veuillez reessayer");
        		n = 1;
        	}
        }
        while (n > 0);
        
        System.out.println( "Arrêt du programme" );
   
    } // main
   
} // TP2_evol

