import "dart:async";

import "package:build/build.dart";
import "package:gql_code_gen/src/builders/utils/reader.dart";
import "package:gql_code_gen/src/builders/utils/writer.dart";
import "package:gql_code_gen/src/code_builders/op.dart";
import "package:gql_code_gen/src/config.dart";

class OpBuilder implements Builder {
  final AssetId schemaId;

  OpBuilder(
    this.schemaId,
  );

  @override
  Map<String, List<String>> get buildExtensions => {
        sourceExtension: [opExtension],
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final doc = await readDocument(buildStep);
    final schema = await readDocument(buildStep, schemaId);

    final library = buildOpLibrary(
      doc,
      schema,
      buildStep.inputId.changeExtension(astExtension).uri.toString(),
      schemaId.changeExtension(schemaExtension).uri.toString(),
    );

    return writeDocument(
      library,
      buildStep,
      opExtension,
    );
  }
}
