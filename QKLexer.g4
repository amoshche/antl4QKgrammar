lexer grammar QKLexer; 

@lexer::members {
    public static final int WHITESPACE = 1;
    public static final int COMMENTS = 2;

    boolean statementOpened = false; 
} 

fragment 
WS_TOKEN:' '|'\t'; 

fragment 
NOT_WS_TOKEN:~(' '|'\t'); 

fragment 
NL_TOKEN:'\r'?'\n'; 

fragment 
NOT_NL_TOKEN:~('\r'|'\n'); 

fragment 
WS_OR_NL_TOKEN:' '|'\t'|'\r'|'\n'; 

fragment 
NOT_WS_NOR_NL_TOKEN:~(' '|'\t'|'\r'|'\n'); 

fragment
DIGIT: '0'..'9' ;

fragment
LETTER: ('a'..'z'|'A'..'Z') ;

FUNS: '{' ;
FUNE: '}' ;
ARGS: '[' ; //args start in Q | table key defs start | block in if, while, $ map start in k)
ARGE: '[' ; //args end in Q | table key defs end | block end in if, while, $  map end in k)
LS: '(' ; //precedence, table, list start
LE: ')' ; //precedence, table, list end

NOT_EQUAL: '<>';
EQUAL: '=';
LESS_THAN: '<'{_input.LA(1) != '>'}?;
GREATER_THAN: {_input.LA(-1) != '<'}?'>';
MATCH: '~';

MAX: '|';
MIN: '&';

PLUS: '+';
MINUS: '-';
TIMES: '*';
DIVIDE: '%';
FILL: '^'; //coalesce

JOIN: ','; //enlist in some cases in k)
DROP_CUT: '_';
TAKE: '#';

SEPARATOR: ';';
SYMBOL: '`';

COLON: {_input.LA(-1) != '\'' && _input.LA(-1) != '\\' && _input.LA(-1) != '/' && _input.LA(-1) != ':'}?':';
COLON0: '0'':'; //TEXT FILE
COLON1: '1'':'; //BINARY FILE
COLON2: '2'':'; //LIB | PROC/MESSAGE
DOUBLECOLON: ':'':';
PEACH: '\''':';
EACHRIGHT: '/'':';
EACHLEFT: '\\'':';
EACH: '\''{_input.LA(1) != ':'}?; //each or throw

OVER:'/';
SCAN:'\\';
//system commands?

DOT: '.';
//DOT_AMEND_TRAP_MODE: '.';
AT: '@';
//AT_AMEND_TRAP_MODE: '.';
CAST: '$';
//TODO -1! 0! etc
EMARK: '!';
//UPDATE_QUERY_MODE: '!';
//ENUM
//KEY
//DICT
//0N ! etc...
QMARK: '?';
//QMARK_COND_QUERY_MODE: '?';
//FIND
//RAND
//`:sym?

//1 | -1 WS+ "asd" stdout
//2 | -2 WS+ "asd" stderr
//other pos/neg int followed by () or "" is handle call


ID: LETTER 
    | LETTER (DROP_CUT|LETTER|DIGIT)* (LETTER|DIGIT)
    | (DOT ID)+
    ;

fragment
NUM_DEC_PREFIX: ('-')? DIGIT+;

LONG: NUM_DEC_PREFIX | '0N' | '0W' | '-0W';	

STATEMENT_SEPARATOR: WS_TOKEN*? NL_TOKEN { System.out.println("" + (_input.LA(1) == '\n' ? "\\n" : java.lang.Character.toString((char)_input.LA(1))) ); if(_input.LA(1) == '/' || _input.LA(1) == '\r' || _input.LA(1) == '\n' || _input.LA(1) == ' ' || _input.LA(1) == '\t') { System.out.println("SEOS"); skip();} else { System.out.println("EOS");}; };

EL_COMMENT: {_input.LA(-1) != '\\' && _input.LA(-1) != '\n' && _input.LA(-1) != ' ' && _input.LA(-1) != '\t'}? WS_TOKEN+ '/' NOT_NL_TOKEN* -> channel(COMMENTS);

SL_COMMENT: ({getCharPositionInLine() == 0}?'/'NOT_WS_NOR_NL_TOKEN NOT_NL_TOKEN* 
            | {getCharPositionInLine() == 0}?'/'WS_TOKEN+ NOT_WS_NOR_NL_TOKEN NOT_NL_TOKEN*) -> channel(COMMENTS);

ML_COMMENT: {getCharPositionInLine() == 0}?'/' WS_TOKEN* NL_TOKEN .*?
            ('\\' WS_TOKEN* {_input.LA(1) == '\r' || _input.LA(1) == '\n'}? | EOF) -> channel(COMMENTS);

SKIP_WS: WS_TOKEN+ -> channel(WHITESPACE); 