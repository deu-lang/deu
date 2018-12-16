/**
 *  Main script.  
 *
 /+ ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― +/
 *  This script is part of the open-source Deu (http://www.github.com/deu-lang)
 *  Licensed under the BSL License (https://github.com/deu-lang/deu/blob/master/LICENSE).
 *  
 */

import deu.utils;
import std.file;
import std.process : spawnProcess, execute, wait;
import core.thread;
import std.datetime;

enum execution
{
	NORUN,
	LEX,
	PARSE,
	RUN,
	MAX
}

struct Flags
{
	/// If true, execute phelp().
	bool phelp = false;
	bool pversion = false;

	/// Whether to exit
	bool exit = false;
	/// Exit code 
	ubyte exitCode = 0;

	/// What the VM is going to do.
	execution exec = execution.RUN; // execution.RUN;

	/// Error Message
	string delegate() ermsg;
	/// Script to be evaluated
	string script;
	/// Path to the script file.
	string path_to_script = "./main.df";
	
	/// Remove the files generated
	bool keep = false;

	string toString()
	{
		return "\tprintHelp: " ~ to!string(phelp) ~ "\n" ~ 
			   "\tprintVersion: " ~ to!string(pversion) ~ "\n" ~ 
			   "\texit: " ~ to!string(exit) ~ "\n" ~ 
			   "\texitCode: " ~ to!string(exitCode) ~ "\n" ~ 
			   "\terrorMessage: \"" ~ raw(ermsg()) ~ "\"\n" ~ 
			   "\texecution: " ~ to!string(exec) ~ "\n" ~ 
			   "\tscript: \"\"\"" ~ raw(repr(script, "<CODE>")) ~ "\"\"\"\n" ~ 
			   "\tpathToScript: `" ~ repr((path_to_script), "<PATH>") ~ "'\n" ~ 
			   "\tverbose: " ~ to!string(verbose) ~ "\n";
	}
}

int main(string[] args)
{
	Flags* flags = new Flags;

	get_flags(args[1 .. $], flags);

	pverbose("Running ");

	if (verbose)
		pversion(false);
	else if (flags.pversion)
		pversion(true);

	// if (verbose || flags.pversion)
	// 	pversion(!verbose && flags.pversion);

	pverbose(" with flags: \n");
	pverbose(*flags);

	if (flags.phelp)
		phelp();

	if (flags.exit)
	{
		perror(flags.ermsg());
		return flags.exitCode;
	}

	if (flags.exec != execution.NORUN && flags.script == "")
	{
		flags.script = readText(flags.path_to_script);
	}

	if (flags.exec == execution.LEX)
	{
		import deu.lex.lexer;
		import deu.lex.tokens;

		auto lexer = new Lexer(flags.script);
		lexer.tokenize();

		write(UNDER, "Tokens", OFF, ": \n");
		print(lexer.tokens);
	}
	else if (flags.exec == execution.PARSE)
	{
		write("TODO: execution.PARSE at line ", __LINE__, " of ", __FILE__, ".\n");
		/* NOTE: 
			* CODE:	```
			* 	function main()	{
			* 		let x = 368 + 43 - 4
			* 	    x = sum(x, 4)
			* 		print(x)
			*
			*  		return 0
			* 	}
			*
			*	function sum(val1, val2) {
			*		return val1 + val2
			*	}
			* ```
			* AST REPRESENTATION:
			* Program [2]
			*	├─┬ DECLARE FUNC: 
			*	│ ├─ ID: main
			*	│ ├─ ARG: 
			*   │ └─┬ BODY:
			*	│	├─┬ DECLARE VAR: x ; expr: ((368 + 43) - 4)
			*	│	│ ├─ ID:  x
			*	│	│ └─ VAL: expr: ((368 + 43) - 4)
			*	│	├─┬ SET:
			*	│	│ ├─ ID:  x
			*	│	│ └─┬ VAL:
			*	│	│	└─┬ FUNCTION_CALL:
			*	│	│     ├─ ID: sum
			*	│	│     └─ ARG: x, 4
			*	│	├─┬ FUNCTION_CALL:
			*	│	│ ├─ ID: print
			*	│	│ └─ ARG: x
			*	│	└─┬ RETURN:
			*	│	  └─ ARG: 0
			*   └─┬ DECLARE_FUNC:
			*     ├─ ID: sum
			*     ├─ ARG: val1, val2
			*     └─┬ BODY:
			*	  	└─┬ RETURN:
			*	  	  └─ expr: (val1 + val2)
		 */
	}
	else if (flags.exec == execution.RUN)
	{
		import deu.lex.lexer, deu.lex.tokens, deu.parser;

		auto lexer = new Lexer(flags.script);
		lexer.tokenize();

		auto parser = new Parser(lexer.tokens);
		auto program = parser.parse();
		
		const string output_d = 
			pathGetRootName(flags.path_to_script) ~
			pathGetFileName(flags.path_to_script) ~ ".d";
		const string output_o = 
			pathGetRootName(flags.path_to_script) ~
			pathGetFileName(flags.path_to_script) ~ ".o";
		

		{
			File output_file = File(output_d, "w");
			string output = toUTF8(program.generateProgram());
			output_file.write(output);
		}

		auto compile_cmd = spawnProcess(["dmd", output_d]);
		wait(compile_cmd);

		if(!flags.keep) {
			auto remove_cmd  = spawnProcess(["rm",  output_o, output_d]);
			wait(remove_cmd);
		}
		// writeln(output_nFile);
		// writeln(cmd);
	}

	return 0;
}

void get_flags(string[] args, Flags* flags)
{
	uint position = 0;

	if (args.length == 0)
	{
		flags.exitCode = 1;
		flags.exit = true;
		flags.ermsg = { return "No action to be done: use `deu -h' for help.\n"; };

		return;
	}
	else
	{
		flags.ermsg = { return ""; };
	}

	string next()
	{
		if (position >= (args.length - 1))
		{
			flags.exitCode = 1;
			flags.ermsg = { return "Expected argument."; };
			return null;
		}
		return args[position += 1];
	}

	pverbose(args);

	void interpret(string op)
	{
		switch (op)
		{
		case "v":
		case "verbose":
			verbose = true;
			break;
		case "V":
		case "version":
			flags.pversion = true;
			flags.exec = execution.NORUN;
			break;
		case "h":
		case "help":
			flags.phelp = true;
			flags.exec = execution.NORUN;
			break;
		case "c":
		case "code":
			flags.path_to_script = "\0";
			flags.script = next();
			break;
		case "k":
		case "keep":
			flags.keep = true;
			break;
		case "w":
		case "no-warn":
			warn = false;
			break;
		case "l":
		case "lex":
			flags.exec = execution.LEX;
			break;
		case "C":
		case "no-color":
			// OFF = "";
			RED = "";
			GREEN = "";
			GOLD = "";
			BLUE = "";
			PURPLE = "";
			CYAN = "";
			YELLOW = "";
			BOLD = "";
			UNDER = "";
			break;

		default:
			flags.exit = true;
			flags.exitCode = 1;
			flags.ermsg = { return "Unknown flag '" ~ BLUE ~ op ~ OFF ~ "'.\n"; };
			break;
		}
	}

	for (; position < args.length; position++)
	{
		char[] op = args[position].dup();

		if (op.length && op[0] == '-')
		{
			if (op[1] == '-')
				interpret(to!string(op[2 .. $]));
			else
				foreach (v; op[1 .. $])
				{
					interpret(to!string(v));
				}
		}
		else
		{
			import regex = std.regex;
			flags.path_to_script = to!string(op);

			if(!regex.match(flags.path_to_script, r"(.*)\.df")) {
				auto extension = regex.match(flags.path_to_script, r".*(\..+)");

				flags.exit = true;
				flags.exitCode = 1;
				flags.ermsg = {
					return "Unrecognized file extension '" ~ BLUE ~ extension.captures[1] ~ OFF ~ "'.";
				};
			}
		}
	}
}

void phelp()
{
	string[] helpinfo = [
		"Usage: deu [OPTION]... [FILE]...\n", "\n",
		"Options and arguments:\n", "-h, --help        Print this help.\n",
		"-c, --code [CMD]  Program passed in as string.\n",
		"-C, --no-color    Turn colored console output off.\n",
		"-v, --verbose     Use verbose output.\n",
		"-V, --version     Print Deu version.\n", "-w, --no-warn     Do not print warnings.\n",
	];

	foreach (l; helpinfo)
	{
		write(l);
	}
}

void pversion(bool endl = true)
{
	write("Deu v", VERSION[0], ".", VERSION[1], ".", VERSION[2]);
	if (endl)
		write("\n");
}
