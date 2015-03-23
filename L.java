import org.antlr.v4.runtime.*;
import java.io.FileInputStream;

public class L {
    public static void main(String[] args) throws Exception {

        ANTLRInputStream input = new ANTLRInputStream(new FileInputStream(args[0]));

        // Construct a lexer and use it to perform lexical analysis
        // on the ANTLR input stream
        LLexer lexer = new LLexer(input);

        // Obtain the token stream from the lexer
        CommonTokenStream tokens = new CommonTokenStream(lexer);

        // Parse the token stream using the parser
        LParser parser = new LParser(tokens);

        // Start parsing, starting with the `start` rule.
        parser.prog();
    }
}
