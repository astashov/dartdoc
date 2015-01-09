// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartdoc.model_test;

import 'dart:io';

import 'package:dartdoc/src/model.dart';
import 'package:grinder/grinder.dart' as grinder;
import 'package:unittest/unittest.dart';

import 'package:analyzer/src/generated/element.dart';
import 'package:analyzer/src/generated/engine.dart';
import 'package:analyzer/src/generated/java_io.dart';
import 'package:analyzer/src/generated/java_engine_io.dart';
import 'package:analyzer/src/generated/sdk.dart';
import 'package:analyzer/src/generated/sdk_io.dart';
import 'package:analyzer/src/generated/source_io.dart';

const SOURCE1 = r'''
library ex;

static int function1(String s, bool b) => 5;

get y => 2;

class A {
  const int n = 5;
  static  String s = 'hello';
  String s2;

  A(this.m);

  get m => 0;
}
class B extends A { 
  void m(){}
}
abstract class C {}
''';


tests() {

  AnalyzerHelper helper = new AnalyzerHelper();
  Source source = helper.addSource(SOURCE1);
     LibraryElement e = helper.resolve(source);
     var l = new Library(e);

  group('Library', () {

    test('name', () {
      expect(l.name, 'ex');
    });
  });

  group('Class', () {

    var classes = l.getTypes();
    Class A = classes[0];
    var B = classes[1];
    var C = classes[2];

    test('no of classes', () {
      expect(classes.length, 3);
    });

    test('name', () {
      expect(A.name, 'A');
    });

    test('abstract', () {
      expect(C.isAbstract, true);
    });

    test('supertype', () {
      expect(B.hasSupertype, true);
    });

    test('interfaces', () {
      expect(A.interfaces.length, 0);
    });

    test('mixins', () {
      expect(A.mixins.length, 0);
    });

    test('get ctors', () {
      expect(A.getCtors().length, 1);
    });

    test('get static fields', () {
      expect(A.getStaticFields().length, 1);
    });

    test('get instance fields', () {
      expect(A.getInstanceFields().length, 3);
    });

    test('get accessors', () {
      expect(A.getAccessors().length, 1);
    });

    test('get methods', () {
      expect(B.getMethods().length, 1);
    });

    test('has correct type name', () {
      expect(A.typeName, equals('Classes'));
    });
  });

  group('Function', () {

    ModelFunction f1 = l.getFunctions()[0];

    test('local element', () {
      expect(f1.isLocalElement, true);
    });

    test('is executable', () {
      expect(f1.isExecutable, true);
    });

    test('is static', () {
      expect(f1.isStatic, true);
    });

    test('has correct type name', () {
      expect(f1.typeName, equals('Functions'));
    });
  });

  group('TypeParameter', () {

    test('has correct type name', () {
      var t = new TypeParameter(null, null);
      expect(t.typeName, equals('Type Parameters'));
    });
  });

}

class AnalyzerHelper {
  AnalysisContext context;

  AnalyzerHelper() {
    _initAnalyzer();
  }

  void _initAnalyzer() {
    Directory sdkDir = grinder.getSdkDir(['']);
    DartSdk sdk = new DirectoryBasedDartSdk(new JavaFile(sdkDir.path));
    List<UriResolver> resolvers = [new DartUriResolver(sdk), new FileUriResolver()];

    SourceFactory sourceFactory = new SourceFactory(resolvers);
    context = AnalysisEngine.instance.createAnalysisContext();
    context.sourceFactory = sourceFactory;
  }

  Source addSource(String contents) {

    Source source = _cacheSource("/test.dart", contents);
    ChangeSet changeSet = new ChangeSet();
    changeSet.addedSource(source);
    context.applyChanges(changeSet);
    return source;
  }

  Source _cacheSource(String filePath, String contents) {
    Source source = new FileBasedSource.con1(FileUtilities2.createFile(filePath));
    context.setContents(source, contents);
    return source;
  }

  LibraryElement resolve(Source librarySource) => context.computeLibraryElement(librarySource);
}