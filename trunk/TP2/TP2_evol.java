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

        static char [] tab = new char 10?;

    // Autres méthodes s'il y a lieu
    public static int saisir (char[] tab2){
        String chaineS;
        int nbElem = 0;
        int longueur = 0;
//         char [] tab;
       
        System.out.println( "Donnez une chaîne: " );
        chaineS = Clavier.lireString();
       
        longueur = chaineS.length() - 1;
        tab = new char longueur + 1?;

        for ( int i = 0; i <= longueur; i++ ){
            if ( chaineS.charAt( i ) != 0) {
                 tabi? = epurer( chaineS.charAt( i ) );
                nbElem ++;
            }
        }
        return nbElem;
    }
   
    public static  char epurer ( int c ){        
       
            if (( c >= 65 && c <= 90 ) || ( c >= 192  &&  c <= 223 )) {
                c += 32;
//             } else if ( c < 48 || c > 57 ){
//                 c = 0;
            }
           
            if ( c >= 224 &&  c  <= 229 ){
                c = 97;
            } else if ( c >= 232 && c <= 235 ){
                c = 101;
            } else if ( c >= 236 && c <= 239 ){
                c = 105;
            } else if ( c >= 242 && c <= 246 ){
                c = 111;
            } else if ( c >= 249 && c <= 252 ){
                c = 117;
            } else if ( c 231 ){
                c = 99;
            } else if ( c 241 ){
                c = 110;
            } else if ( c == 255 ){
                c = 121;
            }
            return (char)c;
        }
     
           
    public static boolean palin ( int n, char [] tab){
        boolean egal = true;
       
        for( int i = 0; i <= n && egal; i++ ){
           
            if ( tabi? != tabn - i? ){
                egal = false;
            }
        }
        return egal;
    }

    public static void main (String[] params) {
       
        int n = 1;
        String chaineS = "";
        String chaineT = "";
       
        n = saisir(tab) - 1; 

        while ( n >= 0 ){
               
            if ( palin ( n, tab)){
                System.out.println( "Ceci est un palindrome." );
            } else {
                System.out.println( "Ceci n'est pas un palindrome." );
            }

             n = saisir(tab) - 1; 
        }                    
   
    } // main
   
} // TP2_evol
