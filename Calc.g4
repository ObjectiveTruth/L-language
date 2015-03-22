grammar Calc;

@header {
package test;
import java.util.HashMap;
}

@members {
/** Map variable name to Integer object holding value */
HashMap memory = new HashMap();
}

prog:   stat+ ;

stat:   expr NEWLINE {System.out.println($expr.value);}
    |   ID ASSIGN expr NEWLINE
        {memory.put($ID.text, new Integer($expr.value));}
    |   NEWLINE
    ;

expr returns [int value]
    :   e=var {$value = $e.value;}
        (   PLUS e=var {$value += $e.value;}
        |   MINUS e=var {$value -= $e.value;}
        )*
    ;

var returns [int value]
    :   DIG {$value = Integer.parseInt($DIG.text);}
    |   ID
        {
        Integer v = (Integer)memory.get($ID.text);
        if ( v!=null ) $value = v.intValue();
        else System.err.println("undefined variable "+$ID.text);
        }
    |   LPAREN  e=expr RPAREN  {$value = $e.value;}
    ;

ID  :   ('a'..'z'|'A'..'Z')+ ;
DIG :   '0'..'9'+ ;
NEWLINE:'\r'? '\n' ;
LPAREN: '(';
RPAREN: ')';
PLUS: '+';
MINUS: '-';
ASSIGN: '=';
WS  :   (' '|'\t')+ {skip();} ;
