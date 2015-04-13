import org.antlr.v4.runtime.*;
import java.io.File;
import java.io.FileInputStream;

public class Compiler2{
    // the executable main
    public static void main(String[] args) 
                                throws Exception {
        ANTLRInputStream input = 
            new ANTLRInputStream(new FileInputStream(new File(args[0])));

        Src2Lexer lexer = new Src2Lexer(input);

        CommonTokenStream tokens =
            new CommonTokenStream(lexer);

        Src2Parser parser = new Src2Parser(tokens);

        parser.prog();
    }
}
