import org.antlr.v4.runtime.*;
import java.io.FileInputStream;

public class L2 {
    public static void main(String[] args) throws Exception {

        ANTLRInputStream input = new ANTLRInputStream(new FileInputStream(args[0]));

        // Construct a lexer and use it to perform lexical analysis
        // on the ANTLR input stream
        L2Lexer lexer = new L2Lexer(input);

        // Obtain the token stream from the lexer
        CommonTokenStream tokens = new CommonTokenStream(lexer);

        // Parse the token stream using the parser
        L2Parser parser = new L2Parser(tokens);

        // Start parsing, starting with the `start` rule.
        parser.prog();
    }
}
