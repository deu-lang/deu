/**
 *  Symbol and SymbolTable classes.
 *  see https://en.wikipedia.org/wiki/Symbol_(programming)
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.storage;

import deu.errors;
import deu.utils : to;

struct Symbol {
    string name;
    string type; // use enum here
    bool   isVar = true;
    Object* obj = null;
    
    string toString() {
        return isVar ? ("<" ~ name ~ ":" ~ type ~ " = " ~ obj.toString() ~ ">") : ("<" ~ name ~ ">");
    }
}

class SymbolTable {

    Symbol[string] symbols;

    this() {
        // this.symbols = [];
    }

    // void init_builtins() {
        // define(DREAL);
    // }

    void define(Symbol sym) {
        this.symbols[sym.name] = sym;
    }

    Symbol lookup(string name) {
        return this.symbols[name];
    }

    override string toString() {
        return to!string(symbols);
    }
}

unittest {
    import deu.utils;
    import std.typecons;

    Symbol int_symbol = {"int", "iuasd", true};
    bool passed = true;

    uprint("\t", YELLOW, __FILE__, OFF, "\t- ", GREEN, BOLD, "DONE\n", OFF);
}