import org.antlr.v4.runtime.*;
import java.io.File;
import java.io.FileInputStream;

public class Compiler1{
    // the executable main
    public static void main(String[] args) 
                                throws Exception {
        ANTLRInputStream input = 
            new ANTLRInputStream(new FileInputStream(new File(args[0])));

        Src1Lexer lexer = new Src1Lexer(input);

        CommonTokenStream tokens =
            new CommonTokenStream(lexer);

        Src1Parser parser = new Src1Parser(tokens);

        parser.prog();
    }
}
