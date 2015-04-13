grammar Src2;

@header {
    import java.util.*;
}

@members {
    static int addr_index = 0;
    static int gen_address() {
        return (addr_index ++);
    }
    static int label_index = 0;
    static int gen_label() {
        return (label_index ++);
    }

    // a class for bytecode instructions
    static String iload(int addr) {
        return "iload " + addr;
    }
    static String istore(int addr) {
        return "istore " + addr;
    }
    static String iadd() { return "iadd"; }
    static String isub() { return "isub"; }
    static String imul() {
        return "imul";
    }
    static String ldc(int x) {
        return "ldc " + x;
    }
    static String iflt(int l) { return "iflt LABEL_" + l; }
    static String ifeq(int l) { return "ifeq LABEL_" + l; }
    static String ifgt(int l) { return "ifeq LABEL_" + l; }
    static String go(int l) {
        return "goto LABEL_" + l;
    }

    static String label(int l) {
        return "LABEL_" + l + ":";
    }

    static HashMap<String, Integer> symbolTable 
        = new HashMap<String, Integer>();


    // generated code fragments
    static class Code {
        List<String> block;
        int addr;
        public Code() {
            this.block = new ArrayList<String>();
        }
        public void extend(List<String> block) {
            this.block.addAll(block);
        }
        public void append(String... stmts) {
            for(String stmt : stmts)
                this.block.add(stmt);
        }

        public void gen() {

echo(".class public sample");
echo(".super java/lang/Object");
echo("");
echo(".method public <init>()V");
echo("aload_0");
echo("invokenonvirtual java/lang/Object/<init>()V");
echo("return");
echo(".end method");
echo("");
echo(".method public static main([Ljava/lang/String;)V");
echo(".limit stack 10");
echo(".limit locals 100");
echo("");

for(String i : this.block) echo(i);
echo("return");
echo(".end method");
        }
    }


    public static void echo(String message) {
        System.out.println(message);
    }
}


prog : s=stmtList {$s.code.gen();}
    ;

expr returns [Code code]
@init { $code = new Code(); }
    : t=term '+' e=expr
            {
                int addr = gen_address();
                $code.extend($t.code.block);
                $code.extend($e.code.block);

                $code.append(
                    iload($t.code.addr),
                    iload($e.code.addr),
                    iadd(),
                    istore(addr));
                $code.addr = addr;
            }
    | t=term { $code = $t.code; }
    ;

term returns [Code code]
@init { $code = new Code(); }
    : f=factor '*' t=term
        {
            int addr = gen_address();
            $code.extend($f.code.block);
            $code.extend($t.code.block);
            $code.append(
                iload($f.code.addr),
                iload($t.code.addr),
                imul(),
                istore(addr));
            $code.addr = addr;
        }
    | f=factor {$code = $f.code;}
    ;

factor returns [Code code]
@init { $code = new Code(); }
    : '(' expr ')'
        {
            $code = $expr.code;
        }
    | NUM
        {
            int addr = gen_address();
            $code.append(
                ldc($NUM.int),
                istore(addr));
            $code.addr = addr;
        }
    | ID
        {
            String name = $ID.text;
            if(symbolTable.containsKey(name))
              $code.addr = symbolTable.get(name);
            else {
              int addr = gen_address();
              $code.addr = addr;
              $code.append(
                  ldc(0),
                  istore(addr));
            }
        }
    ;
    
stmtList returns [Code code]
@init {$code = new Code();}
    : (s=stmt {$code.extend($s.code.block);}) +
    ;

stmt returns [Code code]
    : printStmt  { $code = $printStmt.code; }
    | assignStmt  { $code = $assignStmt.code; }
    | repeatStmt {$code = $repeatStmt.code;}
    | whileStmt {$code = $whileStmt.code;}
    ;

printStmt returns [Code code]
@init { $code = new Code(); }
    : 'print' '(' expr
            { $code.extend($expr.code.block);
              $code.append(
                "getstatic java/lang/System/out Ljava/io/PrintStream;",
                iload($expr.code.addr),
                "invokevirtual java/io/PrintStream/println(I)V");
            } ')'
    | 'print' '(' expr 
            { $code.extend($expr.code.block);
              $code.append(
                "getstatic java/lang/System/out Ljava/io/PrintStream;",
                iload($expr.code.addr),
                "invokevirtual java/io/PrintStream/println(I)V");
            } ',' expr
            { $code.extend($expr.code.block);
              $code.append(
                "getstatic java/lang/System/out Ljava/io/PrintStream;",
                iload($expr.code.addr),
                "invokevirtual java/io/PrintStream/println(I)V");
            } ')'
    ;

assignStmt returns [Code code]
@init {$code = new Code();}
    : 'let' ID '=' expr
        { int varAddr;
          String varName = $ID.text;
          if(symbolTable.containsKey(varName))
            varAddr = symbolTable.get(varName);
          else {
            varAddr = gen_address();
            symbolTable.put(varName, varAddr);
          }

          $code.extend($expr.code.block);
          $code.append(
            iload($expr.code.addr),
            istore(varAddr));
        }
    ;

repeatStmt returns [Code code]
@init {$code = new Code();}
    : 'repeat' c=NUM  '{'
        s=stmtList
       '}'
       {
            int beginLabel = gen_label();
            int endLabel = gen_label();

            if($c.int > 0){
                $code.append(label(beginLabel));

                for(int i = 0; i < $c.int; i++){
                    $code.extend($s.code.block);
                }

                $code.append(label(endLabel));
            }
       }
    ;

whileStmt returns [Code code]
@init {$code = new Code();}
    : 'while' '(' c=boolExpr ')' '{'
        s=stmtList
       '}'
       {
            int beginLabel = gen_label();
            int endLabel = gen_label();

            $code.append(label(beginLabel));
            $code.extend($c.code.block);
            $code.append(
                iload($c.code.addr),
                ifeq(endLabel));
            $code.extend($s.code.block);
            $code.append(go(beginLabel));
            $code.append(label(endLabel));
       }
    ;

boolExpr returns [Code code]
@init {$code = new Code();}
    : e1=expr REL  e2=expr 
        { 
          int addr = gen_address();
          int trueLabel = gen_label();
          int endLabel = gen_label();

          $code.extend($e1.code.block);
          $code.extend($e2.code.block);

          if( "<".equals($REL.text)){
              $code.append(
                iload($e1.code.addr),
                iload($e2.code.addr),
                isub(),
                iflt(trueLabel));
          }else if(">".equals($REL.text)){
              $code.append(
                iload($e2.code.addr),
                iload($e1.code.addr),
                isub(),
                iflt(trueLabel));
          }else if("==".equals($REL.text)){
              $code.append(
                iload($e2.code.addr),
                iload($e1.code.addr),
                isub(),
                ifeq(trueLabel));
          }
          $code.append(
            ldc(0),
            istore(addr),
            go(endLabel),
            label(trueLabel),
            ldc(1),
            istore(addr),
            label(endLabel));
          $code.addr = addr;
        }
    | b5=boolExpr LOGIC b4=boolExpr
        { 
          int addr = gen_address();
          int trueLabel = gen_label();
          int endLabel = gen_label();

          $code.extend($b4.code.block);
          $code.extend($b5.code.block);

          if("and".equals($LOGIC.text)){
              $code.append(

                iload($b4.code.addr),
                iload($b5.code.addr),
                iadd(),
                ldc(2),
                isub(),
                ifeq(trueLabel),

                ldc(0),
                istore(addr),
                go(endLabel),

                label(trueLabel),
                ldc(1),
                istore(addr),

                label(endLabel));
          }else if("or".equals($LOGIC.text)){
              $code.append(

                iload($b4.code.addr),
                iload($b5.code.addr),
                iadd(),
                ifgt(trueLabel),

                ldc(0),
                istore(addr),
                go(endLabel),

                label(trueLabel),
                ldc(1),
                istore(addr),

                label(endLabel));

          }
          $code.addr = addr;
        }

    | NEG b1=boolExpr
        { 
          int addr = gen_address();
          int secondLabel = gen_label();
          int endLabel = gen_label();

          $code.extend($b1.code.block);

          $code.append(

            iload($b1.code.addr),
            ifeq(secondLabel),
            ldc(0),
            istore(addr),
            go(endLabel),

            label(secondLabel),
            ldc(1),
            istore(addr),

            label(endLabel));
          $code.addr = addr;
        }
    ;

LOGIC : 'and'
      | 'or'
      ;

REL : '=='
    | '<'
    | '>'
    ;


NEG : 'not';
NUM : ('0' .. '9') + ;
ID : ('a' .. 'z') +;
WS : (' ' | '\t' | '\n' | '\r')+ { skip(); };

