parser grammar QKParser; 

options { 
        tokenVocab=QKLexer; 
} 

script: STATEMENT_SEPARATOR? statement? (STATEMENT_SEPARATOR statement)* EOF; 

comment: (ML_COMMENT | SL_COMMENT); 
statement: expr; 

expr: ID COLON<assoc=right> expr
      | expr PLUS<assoc=right> expr
      | expr expr
      | LONG; 




//statement: (ML_STATEMENT | SL_STATEMENT); 
//statement: (ML_STATEMENT_START ML_STATEMENT_LINE* ML_STATEMENT_END? | SL_STATEMENT); 

