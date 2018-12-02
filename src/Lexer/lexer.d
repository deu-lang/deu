/**
 *  Lexer class used for lexing.
 *  see https://en.wikipedia.org/wiki/Lexical_analysis
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.lex.lexer;

import deu.lex.tokens;
import deu.errors;

import deu.utils;
import std.ascii : isAlpha, isDigit, isAlphaNum, isWhite;


/// Return true if the character is a built-in operator.
static bool isOperator(char c) {
    return ((c == '+') || (c == '-') || (c == '*') || (c == '/') ||
            (c == '<') || (c == '>') || (c == ';') || (c == '=') ||
            // (c == '|') || (c == '&') || (c == '^') || (c == '%') ||
            // (c == '~') || (c == '.') || (c == '!') || (c == ':') ||
            // (c == '?') || (c == ',') || (c == '{') || (c == '}') ||
            (c == '[') || (c == ']') || (c == '(') || (c == ')'));
}

static bool isEOF(char c) {
    return c == '\0';
}

static bool isCommentStart(char c) {
    return c == '#';
}


class Lexer {
    
    /// Source code
    char[] input;
    /// Current Line used for debuggin
    string line;
    
    /// Output tokens
    Token*[] tokens;

    /// Length of input
    size_t inputSize;

    /// Total position in the input array
    size_t position;
    /// Current Character in the input
    char currentChar;

    /// Position in the current line for debugin
    size_t LINEPOS;
    /// Line position in the file for debugin
    size_t LINE;

    /// constructor function
    this(string input) {        
        this.input = input.dup();
        this.inputSize = input.length;

        this.position = 0;
        this.LINEPOS = 1;
        this.LINE = 1;
        this.line = getLine(input.dup(), this.position);
        this.currentChar = notEOF(0) ? this.input[this.position] : '\0';
    }

    /// Check if end of file has been reached.
    bool notEOF(size_t pos) {
        return pos < this.inputSize;
    }
    /// Overloading function.
    bool notEOF() {
        return notEOF(this.position);
    }

    /// Advance the position in the input source.
    void advance() {
        if(notEOF(++this.position)) {
            this.currentChar = this.input[this.position];
            
            if(this.currentChar == '\n') {
                this.LINE++;
                this.LINEPOS = 1;
                this.line = getLine(input, this.position);
            } else {
                this.LINEPOS++;
            }
        } else {
            // If end of file has been reached, this.currentChar = null;
            this.currentChar = '\0';
        }
    }
    
    /// Get the next character without advancing.
    char peek() {
        return notEOF(1 + this.position) ? this.input[this.position] : '\0';
    }
    
    /// LexNumber: Match '[0-9]+\.?[0-9]*'.
    Token* lexNumber() {
        char[] snum;
        size_t POSI = this.LINEPOS;
        size_t LINE = this.LINE;

        while(notEOF() && isDigit(this.currentChar)) {
            snum = snum ~ this.currentChar;
            advance();
        }

        if(this.currentChar == '.') {
            do {
                snum = snum ~ this.currentChar;
                advance();
            } while(notEOF() && isDigit(this.currentChar));
    
            return new Token(tType.REAL, snum, this.line, POSI, LINE);
        }

        return new Token(tType.INT, snum, this.line, POSI, LINE);
    }

    /// LexOperator: Match any of '+-*/[]()'.
    Token* lexOperator() {
        char c = this.currentChar;
        const(size_t) POSI = this.LINEPOS;
        const(size_t) LINE = this.LINE;

        this.advance();

        switch(c) {
            case '+': return new Token(tType.PLUS , ['+'], this.line, POSI, LINE);
            case '-': return new Token(tType.MINUS, ['-'], this.line, POSI, LINE);
            case '*': {
                if(this.currentChar == '*') {
                    this.advance();
                    return new Token(tType.DMULT , ['*', '*'], this.line, POSI, LINE);
                } else return new Token(tType.MULT , ['*'], this.line, POSI, LINE);
                
            }
            case '/': return new Token(tType.DIV  , ['/'], this.line, POSI, LINE);
            case '(': return new Token(tType.LPAR , ['('], this.line, POSI, LINE);
            case ')': return new Token(tType.RPAR , [')'], this.line, POSI, LINE);
            case '=': return new Token(tType.EQ   , ['='], this.line, POSI, LINE);
            case ';': return new Token(tType.SEMI , [';'], this.line, POSI, LINE);

            default: 
            throw new DException("Expecting operator, recived: '" ~ c ~ "'.");
        }
    }

    /// LexId: Match '[A-z_][A-z_0-9]'.
    Token* lexId() {
        char[] id;
        const(size_t) POSI = this.LINEPOS;
        const(size_t) LINE = this.LINE;

        while(isAlphaNum(this.currentChar)) {
            id ~= [this.currentChar];
            advance();
        }
        
        if(is_keyword(id)) {
            return new Token(get_keywordType(id), id, this.line, POSI, LINE);
        }

        return new Token(tType.ID, id, this.line, POSI, LINE);
    }
    


    /// NextToken: Lex any token.
    Token* nextToken() {

        /+ See https://en.wikipedia.org/wiki/ASCII +/
        if(isCommentStart(this.currentChar)) {
            while(this.currentChar != '\n' && this.currentChar != '\0')
                advance();

            return nextToken();
        }
        if(isWhite(this.currentChar)) {
            if(this.currentChar == '\n') {
                //const(size_t) pos = 
                const(size_t) LINE = this.LINE;
                this.advance();
                this.LINEPOS--;

                return new Token(tType.EOL, ['\n'], this.line, 0, LINE);
            }
            this.advance();
            return nextToken();
        }

        if(isDigit(this.currentChar)) return lexNumber();
        if(isOperator(this.currentChar)) return lexOperator();
        if(isAlpha(this.currentChar)) return lexId();
        if(isEOF(this.currentChar)) return new Token(tType.EOF, [], this.line, this.LINEPOS, this.LINE);

        throw new DException("Unrecognized character: '" ~ GREEN ~ this.currentChar ~ OFF ~ "'.");
    }

    /// Tokenize: transform source script to tokens.
    void tokenize() {
        // this.position = this.LINEPOS = this.LINE = 0;
        // this.currentChar = notEOF(0) ? this.input[this.position] : '\0';

        if(isEOF(this.currentChar)) {
            this.tokens ~= [new Token(tType.EOF, [], "", -1, -1)];
            return;
        }

        this.tokens = [nextToken()];
        while(notEOF()) {
            this.tokens ~= [nextToken()];
        }

        this.tokens ~= [new Token(tType.EOF, [], "", -1, -1)];
        /// print(this.tokens);
    }

    /// Force the tokenizing process.
    void retokenize() {
        this.position = 0;
        this.LINEPOS = this.LINE = 1;
        this.currentChar = notEOF(0) ? this.input[this.position] : '\0';
        this.tokenize();
    }
}


unittest {
    import deu.utils;
    import deu.lex.tokens;


    string code = `
        let a = 4 + 32 * 1
        a = (a / 5.3);
    `;

    auto lexer = new Lexer(code);
    lexer.tokenize();
    // uprint("\n", repr(lexer.tokens), "\n");

    bool passed = true;
    passed &= unassert(lexer.tokens[ 1].type == tType.LET,    "Error detecting type `let'.");
    passed &= unassert(lexer.tokens[ 2].type == tType.ID,     "Error detecting type IDs.");
    passed &= unassert(lexer.tokens[ 6].type == tType.INT,    "Error detecting type integers.");
    passed &= unassert(lexer.tokens[ 7].type == tType.MULT,   "Error detecting type `*'.");
    passed &= unassert(lexer.tokens[ 9].type == tType.EOL,    "Error detecting type end of lines.");
    passed &= unassert(lexer.tokens[15].type == tType.REAL,   "Error detecting type real.");

    passed &= unassert(lexer.tokens[ 0].value == "\n".dup(),  "Error detecting values for `EOF'.");
    passed &= unassert(lexer.tokens[ 3].value == "=".dup(),   "Error detecting values for `EQ'.");
    passed &= unassert(lexer.tokens[ 5].value == "+".dup(),   "Error detecting values for `PLUS'.");
    passed &= unassert(lexer.tokens[15].value == "5.3".dup(), "Error detecting values for `REAL'.");

    passed &= unassert(lexer.tokens[ 6].linepos == 1, "Error detecting lines.");
    passed &= unassert(lexer.tokens[10].linepos == 2, "Error detecting lines.");
    passed &= unassert(lexer.tokens[13].linepos == 2, "Error detecting lines.");

    passed &= unassert(lexer.tokens[ 0].position == 0,  "Error detecting positions.");
    passed &= unassert(lexer.tokens[ 8].position == 26, "Error detecting positions.");

    if (passed) 
        uprint("\t", YELLOW, __FILE__, OFF, "\t- ", GREEN, BOLD, "DONE\n", OFF);
    else 
        writeln("--= ", BLUE, "UNITTEST ", OFF, __FILE__, ": ", RED, "failed", OFF, " =--");

}