ttc2014-fixml-case
==================

Rascal submission to Transformation Tool Contest 2014 - The FIXML to Java, C# and C++ Case

To run the smoke test, where all the input files located in `examples` are tested for parsing and generation:

    ./run.sh
    
To generate the output files for C++, Java and C# from examples `test2.xml`, `test3.xml` and `test4.xml`, all located in directory `examples`:

    ./run.sh generate 2,3,4

All the output files are stored in the directory `output`.