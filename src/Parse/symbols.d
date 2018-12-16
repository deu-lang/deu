/**
 *  Symbol and SymbolTable classes.
 *  see https://en.wikipedia.org/wiki/Symbol_(programming)
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

module deu.storage;

import deu.dobject;
import deu.errors;
import deu.utils : to, log;

struct Symbol {
    
    enum TYPE {
        MODULE,
        VAR    
    }

    string name;
    TYPE type;
    DObject obj;
    
    string toString() {
        return isVar() ? 
            ("<" ~ name ~ ":" ~ to!string(type) ~ " = " ~ to!string(obj) ~ ">") : 
            ("<" ~ name ~ ">");
    }

    bool isVar() {
        return this.type == TYPE.VAR;
    }
}

class SymbolTable {

    private Symbol*[] symbols;
    private ulong[string] locations;
    private ulong[] buffer;

    this() {
        // this.symbols = [];
    }

    // void init_builtins() {
    //     declare(DREAL);
    // }

    ulong* isDeclared(string name) {
        return name in locations;
    }

    void declare(Symbol sym) {
        if(this.buffer.length == 0) {
            this.locations[sym.name] = this.symbols.length;
            this.symbols ~= [&sym];
        } else {
            ulong address = this.buffer[$ - 1];
            this.locations[sym.name] = address;
            this.buffer = this.buffer[0 .. $ - 1];
            this.symbols[address] = &sym;
        }
    }

    void undeclare(string name) {
        ulong* symptr = isDeclared(name);
        if(!symptr) return;

        this.buffer ~= [*symptr];
        symbols[*symptr] = null;
    }

    // Symbol lookup(string name) {
    //     return this.symbols[name];
    // }

    override string toString() {
        string output = "[";

        foreach (k; this.symbols) {
            if (k is null) continue;
            output ~= k.toString() ~ ",\n";
        } 
        
        if (output == "[") {
            return "EMPTY SCOPE";
        }
        
        return output[0 .. $ - 2] ~ "]";
    }
}

unittest {
    import deu.utils;
    import std.typecons;

    bool passed = true;
    
    Symbol int_val = {"int_val", Symbol.TYPE.VAR, make_dint(53)};
    
    SymbolTable table = new SymbolTable;

    table.declare(int_val);
    uprint(table.toString(), "\n");

    table.undeclare("int_val");
    uprint(table.toString(), "\n");

    if (passed) 
        uprint("\t", GREEN, (__FILE__), OFF, "\t- ", GREEN, BOLD, "DONE\n", OFF);
    else 
        writeln("--= ", CYAN, "UNITTEST ", OFF, __FILE__, ": ", RED, "failed", OFF, " =--");
}