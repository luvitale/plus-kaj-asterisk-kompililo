%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define KOLOR_RUGA "\033[1;31m"
#define COLOR_REKOMENCIGITA "\033[0m"

#define DOSIERNOM "prog"

int linionum;

int yystopparser = 0;

FILE *yyin;

char *yyltext;
char *yytext;

int yylex();
int yyerror(char *);
%}

%union {
  double num_val;
  char *s_val;
}

%%
P: KOD;
%%

int main(int argc, char *argv[]) {
  const char* dosiernom = argv[1];
  FILE* arg_dosiero = fopen(dosiernom, "rt");

  if (arg_dosiero == NULL) {
    printf("Dosiero ne povas esti malfermita: %s\n", dosiernom);
    printf("Uzante norman enigon\n\n");
  }
  else {
    yyin = arg_dosiero;
  }

  yyparse();

  fclose(yyin);

  return EXIT_SUCCESS;
}

int yyerror(char *eraro) {
  fprintf(stderr, KOLOR_RUGA "\nlinio %d: %s\n" KOLOR_REKOMENCIGITA, linionum, eraro);
  fclose(yyin);
  exit(1);
}
