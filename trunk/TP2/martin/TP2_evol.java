/**
 * I N F x 1 2 0
 *
 * Décrivez votre classe TP2_evol ici.
 *
 * @author (votre nom)
 * @version (une date)
 *
 * (votre code permanent)
 * (votre adresse de courriel)
 */
 
public class TP2_evol {

        static char [] tab;
       
    public static String saisir (){
        String chaineS;      
        System.out.println( "Donnez une chaîne: " );
        chaineS = Clavier.lireString();
        
    return chaineS;
    }
    

    public static int traiter (String chaineS){
        int nbElem = 0;
        int longueur = 0;       
        longueur = chaineS.length();
        tab = enleverEspaces(longueur, chaineS.toCharArray());
        
        longueur = tab.length;
        
        for ( int i = 0; i < longueur; i++ ){
            tab[i] = epurer(tab[i]);
            System.out.println( "tab[" + i + "] : " +  tab[i]);
            nbElem ++;
            }
        
        System.out.println("saisir: " + nbElem);
        return nbElem;
    }
    // Methode pour enlever les espaces et les caracteres de ponctuation
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
   // Methode pour enlever les accents et les majuscules. (caractere par caractere)
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
     
    
    // Methode qui verifie si la chaine est un palindrome
    public static boolean palin ( int n, char [] tab){
        boolean egal = true;
        System.out.println("palin: " + n);
        for(int i = 0; i <= n && egal; i++, n--){ // Analyse du tableau de caracteres
            System.out.println("n =" + (n - 1) + " i =" + i);
            System.out.println("n =" +tab[n - 1] + " i =" + tab[i]);
           if (tab[i] != tab[n - 1]) {
               egal = false;
            }
        }
        return egal;
    }
    
    public static void main (String[] params) {
       
        int n = 0;
        String chaineS = "";
       
        chaineS = saisir(); 
        n = traiter(chaineS);
        
        System.out.println("Apres saisir:" + n);
        while ( n > 0 ){
            System.out.println(tab);
            System.out.println("main: " + n);
            if ( palin ( n, tab)){
                System.out.println( chaineS + " est un palindrome." );
            } else {
                System.out.println( chaineS + " n'est pas un palindrome." );
            }

            chaineS = saisir(); 
            n = traiter(chaineS);
        } 
        System.out.println( "Arr�t du programme" );
   
    } // main
   
} // TP2_evol

