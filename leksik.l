%{
#include <stdio.h>
#include <stdlib.h>
#include "komp.tab.h"

FILE *yyin;

int linionum = 1;

double MIN_NUM = -2147483648.0;
double MAKS_NUM = 2147483647.0;
int MAKS_S = 30;

int yyerror(char *);
%}

%option noyywrap
%option yylineno

natura_cifero [1-9]
cifero (0|{natura_cifero})
majuskla_litero [A-ZĈĜĤĴŜŬ]
minuskla_litero [a-zĉĝĥĵŝŭ]
litero ({majuskla_litero}|{minuskla_litero})

citilo \"

malpli "-"

punkto "."
punktokom ";"

op_sum "+"
op_mul ("*"|"×"|"·")
op_asig ("<-"|":=")

valida_signo ({litero}|{cifero}|" "|[¿?¡!])

malferma_komento "/*"
ferma_komento "*/"

komento {malferma_komento}{valida_signo}*{ferma_komento}

id {litero}(_?({litero}|{cifero}))*

nk {malpli}?({cifero}+({punkto}{cifero}*)?|{cifero}*{punkto}{cifero}+)
sk {citilo}{valida_signo}*{citilo}

malferma_krampo "("
ferma_krampo ")"

%%
{malferma_krampo} {
  return malferma_krampo;
}
{ferma_krampo} {
  return ferma_krampo;
}

{punktokom} {
  return punktokom;
}

{op_sum} {
  return op_sum;
}
{op_mul} {
  return op_mul;
}

{op_asig} {
  return op_asig;
}

{id} {
  int S_LONGECO = strlen(yytext);

  char msg[S_LONGECO + MAKS_S];

  if(S_LONGECO > MAKS_S) {
    sprintf(
      msg,
      "id ekster interval: %s, longeco: %d, maks: %d",
      yytext, S_LONGECO, MAKS_S
    );

    yyerror(msg);
  }

  yylval.s_val = strdup(yytext);

  return id;
}

{nk} {
  double valor = atof(yytext);

  char msg[MAKS_S + strlen(yytext)];

  if (valor < MIN_NUM || valor > MAKS_NUM) {
    sprintf(
      msg,
      "numero konstant ekster interval: %s, min: %f, maks: %f",
      yytext, MIN_NUM, MAKS_NUM
    );

    yyerror(msg);
  }

  yylval.num_val = valor;

  return nk;
}

{sk} {
  int S_LONGECO = strlen(yytext);

  char msg[S_LONGECO + MAKS_S];

  if(S_LONGECO > MAKS_S) {
    sprintf(
      msg,
      "signoĉeno ekster inverval: %s, longeco: %d, maks: %d",
      yytext, S_LONGECO, MAKS_S
    );

    yyerror(msg);
  }

  yylval.s_val = yytext;

  return sk;
}

{komento} /* preterpasi komentojn */

" "
"\n" {
  ++linionum;
}
"\t"
"\n\t"
"\r\n"

. {
  char s[150];

  sprintf(s, "nevalida signo: %s\n", yytext);

  yyerror(s);
}
%%
