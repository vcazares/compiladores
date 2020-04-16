%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct _token{
    int clase;
    char valor[32];
    int line;
} token;

token TOKEN;

enum clase {ID=1, PR, OA, OR, OASIG, OL, SP, ENT, DEC};

void error(char *s);
%}

%option yylineno

letra [a-zA-Z]
digito [0-9]
id "#"({letra}|{digito})*
reservada ("@if"|"@else"|"@while")
entero ({digito})+
decimal {digito}*"."{digito}+
aritmetico [\+\-\*\/\%]
relacional (>|<|>=|<=|==|!=)
asignacion =
logico ["||"|&&|!]
puntuacion [{|}|(|)|;|,]
comentario (\/\*[^*/]*\*\/)
%%
{id}    { 
            TOKEN.clase = ID;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            printf("Encontré el token \"%s\"   Tipo: ID   Línea: %d \n\n", yytext, yylineno);
            return ID;
        }
{reservada}    { 
            TOKEN.clase = PR;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            printf("Encontré el token \"%s\"   Tipo: Palabra reservada   Línea: %d \n\n", yytext, yylineno);
            return PR;
        }
{aritmetico}    { 
            TOKEN.clase = OA;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            printf("Encontré el token \"%s\"   Tipo: Op. Aritmético   Línea: %d \n\n", yytext, yylineno);
            return OA;
        }
{relacional}    { 
            TOKEN.clase = OR;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            printf("Encontré el token \"%s\"   Tipo: Op. Relacional   Línea: %d \n\n", yytext, yylineno);
            return OR;
        }
{asignacion}    { 
            TOKEN.clase = OASIG;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            printf("Encontré el token \"%s\"   Tipo: Op. de Asignación   Línea: %d \n\n", yytext, yylineno);
            return OASIG;
        }
{logico}    { 
            TOKEN.clase = OL;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            printf("Encontré el token \"%s\"   Tipo: Op. Lógico   Línea: %d \n\n", yytext, yylineno);
            return OL;
        }
{puntuacion}    { 
            TOKEN.clase = SP;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            printf("Encontré el token \"%s\"   Tipo: Signo de Puntuación   Línea: %d \n\n", yytext, yylineno);
            return SP;
        }
{entero}    { 
                TOKEN.clase = ENT;
                strcpy(TOKEN.valor, yytext);
                TOKEN.line = yylineno;
                printf("Encontré el token \"%s\"   Tipo: Entero   Línea: %d \n\n", yytext, yylineno);
                return ENT;
            }
{decimal}    { 
            TOKEN.clase = DEC;
            strcpy(TOKEN.valor, yytext);
            TOKEN.line = yylineno;
            printf("Encontré el token \"%s\"   Tipo: Decimal   Línea: %d \n\n", yytext, yylineno);
            return DEC;
        }
{comentario} {/* Ignora los comentarios*/}

[ \t\n\r] {/* Ignora los espacios en blanco*/}

.   {error(yytext);}
%%
int yywrap(){
    return 1;
}

void error(char *s){
    printf("Error léxico: %s, en la línea %d\n",s,yylineno);
}

int main(int argc, char **argv){
    FILE *f;
    if(argc<2){
        printf("Falta archivo\n");
        exit(-1);
    }
    f = fopen(argv[1],"r");
    if(!f){
        printf("No se puede abrir el archivo\n");
        exit(-1);
    }
    yyin = f;
    int tok = yylex();
    while(tok != 0){
        tok = yylex();
    }    
    return 0;
}
