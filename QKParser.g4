parser grammar QKParser; 

options { 
        tokenVocab=QKLexer; 
} 

script: STATEMENT_SEPARATOR? statement? (STATEMENT_SEPARATOR statement)* EOF; 

comment: (ML_COMMENT | SL_COMMENT); 
statement: expr; 

expr: expr PLUS<assoc=right> expr
      | expr QMARK<assoc=right> expr
      | expr EMARK<assoc=right> expr
      | ID COLON<assoc=right> expr
      | expr expr
      | alist
      | atom;


atom: asymbol
    | achar
    | aguid
    | aboolean
    | abyte
    | ashort
    | aint
    | areal
    | afloat
    | along
    | amonth
    | adate
    ;

asymbol: SYMBOL;
achar: CHAR;
aguid: GUID;
aboolean: BOOLEAN;
abyte: BYTE;
aint: INT;
ashort: SHORT ;
areal: REAL;
afloat: FLOAT | FLOAT_SUFFIXED;
along: LONG | LONG_SUFFIXED;
amonth: MONTH;
adate: DATE;
    

alist: symbollist
     | charlist
     | booleanlist
     | bytelist
     | shortlist
     | intlist
     | reallist
     | monthlist
     | floatlist
     | longlist
     | datelist
     ; 

//Order is important
symbollist: SYMBOL_LIST;
charlist: EMPTY_CHAR_LIST | CHAR_LIST_START CHAR_LIST_PART+? CHAR_LIST_END;
booleanlist: BOOLEAN_LIST;
bytelist: BYTE_LIST;
shortlist: LONG<assoc=right>+? SHORT;
intlist: LONG<assoc=right>+? INT;
reallist: (LONG<assoc=right>|FLOAT<assoc=right>)+? REAL;
monthlist: FLOAT<assoc=right>+? MONTH; //if FLOATS can be read as MONTHS
floatlist: FLOAT<assoc=right>+ (LONG<assoc=right>|FLOAT<assoc=right>)+ FLOAT_SUFFIXED?
         | LONG<assoc=right>+? FLOAT<assoc=right>+ (LONG<assoc=right>|FLOAT<assoc=right>)* FLOAT_SUFFIXED?
         | LONG<assoc=right>+ (LONG<assoc=right>|FLOAT<assoc=right>)* (FLOAT|FLOAT_SUFFIXED);
longlist: LONG<assoc=right>+ (LONG | LONG_SUFFIXED);
datelist: DATE<assoc=right>+ (DATE | DATE_SUFFIXED);

//statement: (ML_STATEMENT | SL_STATEMENT); 
//statement: (ML_STATEMENT_START ML_STATEMENT_LINE* ML_STATEMENT_END? | SL_STATEMENT); 

