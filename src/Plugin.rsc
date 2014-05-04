module Plugin

import lang::xml::DOM;
import IO;
import ParseXML;
import OOModel;
import XMLModel2OOModel;
import OOModel2Java;
import OOModel2CPlusPlus;
import OOModel2CSharp;
import List;
import String;


bool FROM_IDE = true;

int main(list[str] args) {
  FROM_IDE = false;
  if (args == []) {
    println("Running smoke test.");
    smokeTest();
  }
  else if (size(args) >= 2, args[0] == "generate", /([0-9]+[,]?)+/ := args[1]) {
    println("Generating for examples: <args[1]>. After generation, check the \"output\" directory.");
    
    for (testNumber <- [ toInt(x) | x <- split(",", args[1]) ]) {
      l = |cwd:///examles/<"<testNumber>">.xml|;
      println("Generating files for example <testNumber>...");
      generationTest(true, testNumber);
    }
    println("Done.");
  }
  else {
    println("Usage: java -Xmx2G -Xss32m -jar rascal-shell.jar generate 2,3,4");
    println("or: java -Xmx2G -Xss32m -jar rascal-shell.jar to run smoke test.");
    return 1;
  }
  return 0;
}

void smokeTest() {
	runTestSuiteParsing();
	runTestSuiteGeneration(true);
}

/**
	Main entry points:
	
	runTestSuiteParsing()   : Tests whether all test files parse.
	runTestSuiteGeneration(): Tests whether all test files generate code in the three different
							  source languages. To see if the generated code is correct, the 
							  generated files must be compared to the expected results
**/
test bool runTestSuiteParsing() = runTestSuite(parsingTest, 1, 8);
test bool runTestSuiteGeneration(bool generateFiles) = runTestSuite(generationTest(generateFiles), 1, 6);

test bool runTestSuite(bool(int) testFunction, int lower, int upper) =
	(true | {print("Running test <i>...");  r = testFunction(i); println(r?"ok":"bad"); it && r;} | i <- [lower..upper+1]);

loc outputRoot() = FROM_IDE?|project://ttc2014-fixml-case/output/|:|cwd:///output/|;
loc inputRoot() = FROM_IDE?|project://ttc2014-fixml-case/examples/|:|cwd:///examples/|;

loc testLoc(int i, str extension) = inputRoot()+"test<"<i>">.<extension>";

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

loc programLoc(int i, str lang) = inputRoot()+ "test<"<i>"><lang>.txt";
loc outputLoc(int i, str lang) = outputRoot() + "generated<"<i>"><lang>.txt";

bool(int) generationTest(bool generateFiles) =
	bool(int i){
		return generationTest(generateFiles, i);
	};

test bool generationTest(bool generateFiles, int i) =
	(true | {print("Running generation test <i> for language <lang>..."); r = generationTest(i, lang, generateFiles); println(r?"ok":"bad");r;} | lang <- {"java", "c++", "csharp"});

test bool generationTest(int i, str lang, bool generateFiles){
	try{
		str code = serializer(lang)(xml2oo(parseXMLDOM(testLoc(i, "xml"))));
		try{
			if (generateFiles){
				writeFile(outputLoc(i, lang), code);
			};
		}
		catch:{ };
		return true;
	}
	catch:{
		return false;
	}
}

str(OOModel) serializer("java") = model2java;
str(OOModel) serializer("c++") = model2cpp;
str(OOModel) serializer("csharp") = model2csharp;
