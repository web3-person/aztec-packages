// Shim module to force the use of the CJS build of source-resolver & noir_wasm
type SourceResolver = {
  initializeResolver: (resolver: (source_id: string) => string) => void;
};

type NoirWasm = {
  compile: (entrypoint: string, contract: boolean, deps: string[]) => Promise<any>;
};

const sourceResolver: SourceResolver = require('@noir-lang/source-resolver');
const noirWasm: NoirWasm = require('@noir-lang/noir_wasm');

export const initializeResolver = sourceResolver.initializeResolver;
export const compile = noirWasm.compile;
