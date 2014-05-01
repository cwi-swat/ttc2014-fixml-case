module Plugin

import lang::xml::DOM;
import IO;
import ParseXML;

loc testLoc(int i, str extension) = |project://ttc2014-fixml-case/examples/test<"<i>">.<extension>|;

test bool runTestSuiteParsing() = runTestSuite(parsingTest, 1, 8);

test bool runTestSuite(bool(int) testFunction, int lower, int upper) =
	(true | {print("Running test <i>...");  r = testFunction(i); println(r?"ok":"bad"); it && r;} | i <- [lower..upper+1]);

test bool parsingTest(int i){
	try{
		Node root = parseXMLDOM(testLoc(i, "xml"));
		return true;
	}
	catch e:{
		println(e);
		return false;
	}
}

/*
loc programLoc(int i, str lang) = |project://ttc2014-fixml-case/examples/test<"<i>"><lang>.txt|;

test bool runTestSuiteGeneration() = runTestSuite(generationTest, 1, 2);

test bool generationTest(int i) =
	(true | {print("Running generation test <i> for language <lang>..."); r = generationTest(i, lang); println(r);r;} | lang <- {"java", "c++", "csharp"});

test bool generationTest(int i, str lang) =
	removeSpaces(serializer(lang)(xml2oo(parseXMLDOM(testLoc(i, "xml")))))
	== removeSpaces(readFile(programLoc(i, lang)));
	
str removeSpaces(str s) =
	visit(s){
		case /\s/ => ""
	};

str(OOModel) serializer("java") = model2java;
str(OOModel) serializer("c++") = model2cpp;
str(OOModel) serializer("csharp") = model2csharp;

*/

