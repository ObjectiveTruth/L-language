grammar L;

@header {
import java.util.HashMap;
}

@members {
/** Map variable name to Integer object holding value */
HashMap memory = new HashMap();
}

prog:   stat+ ;

stat:   expr NEWLINE {System.out.println($expr.value);}
    |   LPAREN STRING LPAREN expr RPAREN RPAREN NEWLINE {System.out.println($STRING.text + ' ' + $expr.value);}
    |   NEWLINE
    ;

expr returns [double value]
    :   LPAREN MULTIPLY {$value = 1;}
        ( f = expr {$value *= $f.value;})+ 
        RPAREN
    |   LPAREN PLUS {$value = 0;}
        ( e=expr {$value += $e.value;})+ 
        RPAREN
    |   LPAREN MINUS {$value = 0;}
        ( h=expr {$value =  $h.value;}) 
        ( i=expr {$value -= $i.value;})* 
        RPAREN
    |   LPAREN DIVIDE {$value = 0;}
        ( j=expr {$value =  $j.value;}) 
        ( k=expr {$value /= $k.value;})* 
        RPAREN
    |   LPAREN SIN {$value = 0;}
        ( l=expr {$value = Math.sin($l.value);})
        RPAREN
    |   LPAREN SIN {System.err.println("sin only takes 1 argument");}
        ( var )+
        RPAREN
    |   LPAREN SQRT {$value = 0;}
        ( m=expr {$value = Math.sqrt($m.value);})
        RPAREN
    |   LPAREN SQRT {System.err.println("sqrt only takes 1 argument");}
        ( var )+
        RPAREN
    |   LPAREN STRING g = expr RPAREN {
            $value = $g.value;
            System.out.println($STRING.text + " " + $g.value);
        }
    |   n=var {$value = $n.value;}
    ;

var returns [double value]
    :   NUMBER {
            String removedCommas = ($NUMBER.text).replace(",", "");
            $value = Double.parseDouble(removedCommas);
        }
    |   '-'NUMBER {
            String removedCommas = ($NUMBER.text).replace(",", "");
            $value = Double.parseDouble(removedCommas);
        }
    |   ID
        {
        Integer v = (Integer)memory.get($ID.text);
        if ( v!=null ) $value = v.intValue();
        else System.err.println("undefined variable "+$ID.text);
        }
    |   LPAREN  e=expr RPAREN  {$value = $e.value;}
    ;

STRING
    : '"' (~[\r\n"] | '""')* '"'
    ;

SIN: 'sin';
COS: 'cos';
SQRT: 'sqrt';
ID  :   ('a'..'z'|'A'..'Z')+ ;
NUMBER :  ('0'..'9'|',')+ ('.' ('0'..'9')+)?;
NEWLINE:'\r'? '\n' ;
LPAREN: '(';
RPAREN: ')';
DBLQUOTES: '"';
PLUS: '+';
MULTIPLY: '*';
DIVIDE: '/';
MINUS: '-';
ASSIGN: '=';
WS  :   (' '|'\t')+ {skip();} ;
