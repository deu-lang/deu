/**
 *  Parser class used for parsing.
 *  see https://en.wikipedia.org/wiki/Parsing
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.parser;

import deu.lex.lexer;
import deu.lex.tokens;

import deu.errors;
import deu.ast.generic;
import deu.utils;

class Parser
{

    /// List of tokens provided by lexers.
    Token*[] tokens;

    /// Current Token
    Token* currentToken;

    /// 
    uint counter;

    /// Constructing methods.
    this(Token*[] tokens)
    {
        this.counter = 0;
        this.tokens = tokens;
        this.currentToken = this.tokens[counter];
    }

    /// Get next token.
    void nextToken()
    {
        if (++this.counter < this.tokens.length)
            this.currentToken = this.tokens[this.counter];
        else
            this.currentToken = null;
    }

    /// Peak the next token
    Token* peak()
    {
        size_t c = this.counter;
        if (++c < this.tokens.length)
            return this.tokens[c];
        else
            return null;
    }

    /// Expect a tType.
    Token* expect(uint t)
    {
        if (this.currentToken.type == t)
        {
            Token* tmp = this.currentToken;
            nextToken();
            return tmp;
        }
        else
        {
            throw new DException(
                "Expected '" ~ to!string(cast(tType) t) ~ "', got '" ~ 
                to!string(cast(tType) this.currentToken.type) ~ "' at " ~ 
                to!string(this.currentToken.linepos) ~ ".");
        }
    }

    /// Accept a given token and return it.
    Token* accept(uint t)
    {
        if (this.currentToken.type == t)
        {
            nextToken();
            return currentToken;
        }
        return null;
    }

    /// Accept any token and return it.
    Token* acceptAny()
    {
        Token* tmp = this.currentToken;
        nextToken();
        return tmp;
    }

    /// Expect token type t or line break.
    Token* expectLOR(uint t)
    {
        if (this.currentToken.type == t || this.currentToken.type == tType.EOL)
        {
            Token* tmp = this.currentToken;
            nextToken();
            return tmp;
        }
        else
        {
            throw new DException("Expected '" ~ to!string(cast(tType) t) ~ 
                "', got '" ~ to!string(cast(tType) this.currentToken.type) ~ "' at " ~ 
                to!string(this.currentToken.linepos) ~ ".");
        }
    }

    /// Accept token type t or line break.
    Token* acceptLOR(uint t)
    {
        Token* tok;

        tok = accept(t);
        if (tok /*  != OFFTOKEN */ )
            return tok;

        tok = accept(tType.EOL);
        if (tok /*  != OFFTOKEN */ )
            return tok;

        return accept(t);
    }
    
    /// Parse Value.
    ASTExpression _pValue() {
        switch(this.currentToken.type) 
        {
        case tType.INT:
        case tType.REAL:
            Token* accepted = acceptAny();
            if (this.currentToken.type == tType.DMULT)
            {
                Token* operator = acceptAny();
                return new ASTBinOperator(new ASTNumber(accepted), parseExpression(), operator);
            }
            return new ASTNumber(accepted);
        case tType.STR:
            Token* accepted = expect(tType.STR);
            return new ASTString(accepted);
            /+ case tType.BOOL:
                Token accepted = expect(tType.BOOL);
                return new ASTBool(accepted); +/

        case tType.ID:
            Token* accepted = this.expect(tType.ID);
            return new ASTVar(accepted.value);

        case tType.LPAR:
            expect(tType.LPAR);
            ASTExpression node = parseExpression();
            expect(tType.RPAR);
            return node;
            /+ case tType.LST:
                return parseReference(); +/
        default:
            throw new DException(format("Expecting factor, not %s.", to!string(*this.currentToken)));
        }
    }

    /// Parse Factor.
    ASTExpression _pFactor()
    {
        /* Parse factor function */
        switch (this.currentToken.type)
        {
        case tType.PLUS:
            Token* accepted = expect(tType.PLUS);
            return new ASTUnOperator(_pFactor(), accepted);
        case tType.MINUS:
            Token* accepted = expect(tType.MINUS);
            return new ASTUnOperator(_pFactor(), accepted);

        case tType.INT:
        case tType.REAL:
        case tType.STR:
        case tType.ID:
        case tType.LPAR:
            ASTExpression fname = _pValue();
            if(this.currentToken.type == tType.LPAR) {
                this.expect(tType.LPAR);

                ASTExpression[] params;
                while (this.currentToken.type != tType.RPAR)
                {
                    params ~= this.parseExpression();
                    this.accept(tType.COMMA);
                }

                this.expect(tType.RPAR);
                return new ASTFuncCall(fname, params);
            }
            return fname;

        default:
            throw new DException(format("Expecting factor, not %s.", to!string(*this.currentToken)));
        }
    }

    /// Inter Function Parse Term.
    ASTExpression _pTerm()
    {
        /* Parse term function */
        ASTExpression node = _pFactor();
        while (this.currentToken.type != tType.EOF
                && (this.currentToken.type == tType.MULT || this.currentToken.type == tType.DIV)) /+ ||
            this.currentToken.type == tType.DPLUS || this.currentToken.type == tType.DAND ||
            this.currentToken.type == tType.DOR)) +/
        {
            Token* token = acceptAny();
            node = new ASTBinOperator(node, _pFactor(), token);
        }

        return node;
    }

    ///
    ASTExpression _pOTerm()
    {
        ASTExpression node = _pTerm();
        while (this.currentToken.type != tType.EOF
                && (this.currentToken.type == tType.LST || this.currentToken.type == tType.GRT ||
                    this.currentToken.type == tType.LTE || this.currentToken.type == tType.GTE))
        {
            Token* token = acceptAny();
            node = new ASTBinOperator(node, _pTerm(), token);
        }

        return node;
    }

    /// Parse Expression
    ASTExpression parseExpression()
    {
        /* Parse expression function */
        ASTExpression node = _pOTerm();
        while (this.currentToken && (this.currentToken.type == tType.PLUS
                || this.currentToken.type == tType.MINUS))
        {
            Token* token = acceptAny();
            node = new ASTBinOperator(node, _pOTerm(), token);
        }
        return node;
    }

    /// Parse if
    ASTIf parseIf()
    {
        /// ifStatement: IF expression | COLON statements
        ///                              | CRLL  statementss CRLR

        this.expect(tType.IF);
        
        ASTExpression expr = this.parseExpression();
        
        if(this.accept(tType.COLON) !is null)
            return new ASTIf(expr, [this.parseStatement()]);
        
        
        this.expect(tType.CRLL);

        AST[] statements = [];
        while (this.currentToken.type != tType.CRLR) {
            statements ~= this.parseStatement();
        }

        this.expect(tType.CRLR);

        
        return new ASTIf(expr, statements);
    }

    /// Parse return statement
    ASTReturn parseReturn()
    {
        /// returnStatement: RETURN expression SEMI

        this.expect(tType.RET);
        ASTExpression expr = this.parseExpression();
        this.expect(tType.SEMI);

        return new ASTReturn(expr);
    }

    /// Parse var
    ASTDeclaration parseVar()
    {
        /// varStatement: var ID | EOL
        ///                      | SEMI
        ///                      | EQ expression

        this.expect(tType.VAR);
        auto p = parseDeclaration(false);
        this.expectLOR(tType.SEMI);

        return p;
    }

    /// Parse declaration
    ASTDeclaration parseDeclaration(bool isfuncparam)
    {
        string id = to!string(this.expect(tType.ID).value);
        string type = "";
        
        if (this.accept(tType.COLON) !is null) {
            type = parseType();
        } else if(isfuncparam) {
            throw new DException(
                format("Expecting type for parameter '%s'.", id)
            );
        }

        ASTExpression expr;

        if (this.currentToken.type == tType.EQ)
        {
            this.expect(tType.EQ);
            expr = parseExpression();
        }

        // return null;
        return new ASTDeclaration(id, expr, type, isfuncparam);
    }

    /// Parse function
    ASTFunc parseFunction()
    {

        this.expect(tType.FUNC);
        string id = to!string(this.expect(tType.ID).value);
        this.expect(tType.LPAR);

        ASTDeclaration[] params;
        while (this.currentToken.type != tType.RPAR)
        {
            params ~= parseDeclaration(true);
        }

        this.expect(tType.RPAR);
        this.expect(tType.CRLL);

        AST[] statements = [];
        while (this.currentToken.type != tType.CRLR)
        {
            statements ~= parseStatement();
        }

        this.expect(tType.CRLR);

        return new ASTFunc(id, statements, params);
    }

    /// Parse type
    string parseType()
    {
        string id = to!string(this.expect(tType.ID).value);
        if(this.currentToken.type == tType.LBRC) {
            this.expect(tType.LBRC); // [
            this.expect(tType.RBRC); // ]
            
            return id ~ "[]";
        }
        return id;
    }

    /// Parse statement
    AST parseStatement()
    {
        /// Statement: | expression
        ///            | var_statement
        ///            | if_statement
        ///            | return_statement

        switch (this.currentToken.type)
        {
        case tType.EOL:
        case tType.EOF:
            this.accept(tType.EOL);
            return new ASTNo;

        case tType.VAR:
            return parseVar();
        case tType.FUNC:
            return parseFunction();
        case tType.IF:
            return parseIf();
        case tType.RET:
            return parseReturn();

        case tType.ID:
        case tType.REAL:
        case tType.INT:
            auto statement = parseExpression();
            this.accept(tType.SEMI);
            return statement;

        default:
            throw new DException("Unexpected token " ~ this.currentToken.toString());
        }

        // return null;
    }

    ASTProgram parse()
    {
        ASTProgram statements = new ASTProgram([]);

        while (this.currentToken.type != tType.EOF)
        {
            statements.append(this.parseStatement());
        }

        return statements;
    }
}
