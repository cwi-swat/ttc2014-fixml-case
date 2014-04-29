module ParseXML

import lang::xml::DOM;
import IO;

Node parseXMLDOM(loc src) = parseXMLDOMTrim(readFile(src));