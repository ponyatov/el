%option noyywrap main
%%
src\/([a-z]+\/)*    {printf("tmp/");}
\.(S)               {printf(".o");}
