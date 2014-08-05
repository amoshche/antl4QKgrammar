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

alist: symbollist
     | charlist
     | booleanlist
     | bytelist
     | shortlist
     | intlist
     | reallist
     | monthlist
     | floatlist
     | datelist
     | timelist
     | secondlist
     | minutelist
     | longlist
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
floatlist: (LONG<assoc=right>|FLOAT<assoc=right>)+ FLOAT_SUFFIXED
         | FLOAT<assoc=right>+ (LONG<assoc=right>|FLOAT<assoc=right>)+
         | LONG<assoc=right>+? FLOAT<assoc=right> (LONG<assoc=right>|FLOAT<assoc=right>)*
         | (LONG<assoc=right>|FLOAT<assoc=right>)+ FLOAT;
datelist: DATE<assoc=right>+ (DATE | DATE_SUFFIXED);
minutelist: MINUTE<assoc=right>+ ((LONG<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)*? MINUTE_SUFFIXED
             | (LONG<assoc=right>|MINUTE<assoc=right>)+)
          | LONG<assoc=right>+? MINUTE<assoc=right>
            ((LONG<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)*? MINUTE_SUFFIXED
             | (LONG<assoc=right>|MINUTE<assoc=right>)*)
          | (LONG<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)+? MINUTE_SUFFIXED
          ;
secondlist: SECOND<assoc=right>+ ((LONG<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)*? SECOND_SUFFIXED
             | (LONG<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>)+)
          | (LONG<assoc=right>|MINUTE<assoc=right>)+? SECOND<assoc=right>
            ((LONG<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)*? SECOND_SUFFIXED
             |(LONG<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>)*)
          | (LONG<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)+? SECOND_SUFFIXED
          ;
timelist:   TIME<assoc=right>+ ((LONG<assoc=right>|FLOAT<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)*? TIME_SUFFIXED
             | (LONG<assoc=right>|FLOAT<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)+)
          | (LONG<assoc=right>|FLOAT<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>)+? TIME<assoc=right>
            ((LONG<assoc=right>|FLOAT<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)*? TIME_SUFFIXED
             |(LONG<assoc=right>|FLOAT<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)*) 
          | (LONG<assoc=right>|FLOAT<assoc=right>|MINUTE<assoc=right>|SECOND<assoc=right>|TIME<assoc=right>)+? TIME_SUFFIXED
          ;
longlist: LONG<assoc=right>+ (LONG | LONG_SUFFIXED);

atom: asymbol
    | achar
    | aguid
    | aboolean
    | abyte
    | ashort
    | aint
    | areal
    | amonth
    | afloat
    | adate
    | aminute
    | asecond
    | atime
    | along
    ;

asymbol: SYMBOL;
achar: CHAR;
aguid: GUID;
aboolean: BOOLEAN;
abyte: BYTE;
aint: INT;
ashort: SHORT ;
areal: REAL;
amonth: MONTH;
afloat: FLOAT | FLOAT_SUFFIXED;
adate: DATE | DATE_SUFFIXED;
aminute: MINUTE | MINUTE_SUFFIXED;
asecond: SECOND | SECOND_SUFFIXED;
atime: TIME | TIME_SUFFIXED;
along: LONG | LONG_SUFFIXED;
    
//statement: (ML_STATEMENT | SL_STATEMENT); 
//statement: (ML_STATEMENT_START ML_STATEMENT_LINE* ML_STATEMENT_END? | SL_STATEMENT); 

