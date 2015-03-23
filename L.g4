grammar L;

@header {
import java.util.HashMap;
}

@members {
/** Map variable name to Integer object holding value */
HashMap memory = new HashMap();
}

prog:   stat+ ;

stat:   LPAREN expr RPAREN NEWLINE {System.out.println($expr.value);}
    |   NEWLINE
    ;

expr returns [double value]
    :   MULTIPLY {$value = 1;}
        ( e=var {$value *= $e.value;})* 
    |   PLUS {$value = 0;}
        ( e=var {$value += $e.value;})* 
    |   MINUS {$value = 0;}
        ( e=var {$value =  $e.value;}) 
        ( e=var {$value -= $e.value;})* 
    |   DIVIDE {$value = 0;}
        ( e=var {$value =  $e.value;}) 
        ( e=var {$value /= $e.value;})* 
    |   SIN {$value = 0;}
        ( e=var {$value = Math.sin($e.value);})
    |   SIN {System.err.println("sin only takes 1 argument");}
        ( var )+
    |   e=var {$value = $e.value;}
        (   PLUS e=var {$value += $e.value;}
        |   MINUS e=var {$value -= $e.value;}
        )*
    ;

var returns [double value]
    :   NUMBER {$value = Double.parseDouble($NUMBER.text);}
    |   '-'NUMBER {$value = -Integer.parseInt($NUMBER.text);}
    |   ID
        {
        Integer v = (Integer)memory.get($ID.text);
        if ( v!=null ) $value = v.intValue();
        else System.err.println("undefined variable "+$ID.text);
        }
    |   LPAREN  e=expr RPAREN  {$value = $e.value;}
    ;

SIN: 'sin';
COS: 'cos';
ID  :   ('a'..'z'|'A'..'Z')+ ;
NUMBER :  ('0'..'9')+ ('.' ('0'..'9')+)?;
NEWLINE:'\r'? '\n' ;
LPAREN: '(';
RPAREN: ')';
PLUS: '+';
MULTIPLY: '*';
DIVIDE: '/';
MINUS: '-';
ASSIGN: '=';
WS  :   (' '|'\t')+ {skip();} ;
