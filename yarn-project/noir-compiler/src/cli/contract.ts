import { ContractArtifact } from '@aztec/foundation/abi';
import { LogFn } from '@aztec/foundation/log';

import { Command } from 'commander';
import { mkdirSync, writeFileSync } from 'fs';
import { mkdirpSync } from 'fs-extra';
import path, { resolve } from 'path';

import {
  ProgramArtifact,
  compileUsingNargo,
  compileUsingNoirWasm,
  generateNoirContractInterface,
  generateTypescriptContractInterface,
} from '../index.js';

/**
 * CLI options for configuring behavior
 */
interface options {
  // eslint-disable-next-line jsdoc/require-jsdoc
  outdir: string;
  // eslint-disable-next-line jsdoc/require-jsdoc
  typescript: string | undefined;
  // eslint-disable-next-line jsdoc/require-jsdoc
  interface: string | undefined;
  // eslint-disable-next-line jsdoc/require-jsdoc
  compiler: string | undefined;
}
/**
 * Registers a 'contract' command on the given commander program that compiles an Aztec.nr contract project.
 * @param program - Commander program.
 * @param log - Optional logging function.
 * @returns The program with the command registered.
 */
export function compileContract(program: Command, name = 'compile', log: LogFn = () => {}): Command {
  return program
    .command(name)
    .argument('<project-path>', 'Path to the bin or Aztec.nr project to compile')
    .option('-o, --outdir <path>', 'Output folder for the binary artifacts, relative to the project path', 'target')
    .option('-ts, --typescript <path>', 'Optional output folder for generating typescript wrappers', undefined)
    .option('-i, --interface <path>', 'Optional output folder for generating an Aztec.nr contract interface', undefined)
    .option('-c --compiler <string>', 'Which compiler to use. Either nargo or wasm. Defaults to nargo', 'wasm')
    .description('Compiles the Noir Source in the target project')

    .action(async (projectPath: string, options: options) => {
      const { compiler } = options;
      if (typeof projectPath !== 'string') throw new Error(`Missing project path argument`);
      if (compiler !== 'nargo' && compiler !== 'wasm') throw new Error(`Invalid compiler: ${compiler}`);

      const compile = compiler === 'wasm' ? compileUsingNoirWasm : compileUsingNargo;
      log(`Compiling noir projects...`);
      const results = await compile(projectPath, { log });
      for (const result of results) {
        log(JSON.stringify(result, null, 2));
        generateOutput(projectPath, result, options, log);
      }
    });
}

/**
 *
 * @param contract - output from compiler, to serialize locally.  branch based on Contract vs Program
 */
function generateOutput(
  projectPath: string,
  _result: ContractArtifact | ProgramArtifact,
  options: options,
  log: LogFn,
) {
  const contract = _result as ContractArtifact;
  if (contract.name) {
    return generateContractOutput(projectPath, contract, options, log);
  } else {
    const program = _result as ProgramArtifact;
    if (program.abi) {
      return generateProgramOutput(projectPath, program, options, log);
    }
  }
}
/**
 *
 * @param program - output from compiler, to serialize locally
 */
function generateProgramOutput(projectPath: string, contract: ProgramArtifact, options: options, log: LogFn) {
  const currentDir = process.cwd();
  const { outdir, typescript, interface: noirInterface } = options;
  const artifactPath = resolve(projectPath, outdir, `main.json`);
  log(`Writing ${'main.json'} artifact to ${path.relative(currentDir, artifactPath)}`);
  mkdirSync(path.dirname(artifactPath), { recursive: true });
  writeFileSync(artifactPath, JSON.stringify(contract, null, 2));

  if (noirInterface) {
    // not implemented
  }

  if (typescript) {
    // not implemented
  }
}

/**
 *
 * @param contract - output from compiler, to serialize locally
 */
function generateContractOutput(projectPath: string, contract: ContractArtifact, options: options, log: LogFn) {
  const currentDir = process.cwd();
  const { outdir, typescript, interface: noirInterface } = options;
  const artifactPath = resolve(projectPath, outdir, `${contract.name}.json`);
  log(`Writing ${contract.name} artifact to ${path.relative(currentDir, artifactPath)}`);
  mkdirSync(path.dirname(artifactPath), { recursive: true });
  writeFileSync(artifactPath, JSON.stringify(contract, null, 2));

  if (noirInterface) {
    const noirInterfacePath = resolve(projectPath, noirInterface, `${contract.name}_interface.nr`);
    log(`Writing ${contract.name} Aztec.nr external interface to ${path.relative(currentDir, noirInterfacePath)}`);
    const noirWrapper = generateNoirContractInterface(contract);
    mkdirpSync(path.dirname(noirInterfacePath));
    writeFileSync(noirInterfacePath, noirWrapper);
  }

  if (typescript) {
    const tsPath = resolve(projectPath, typescript, `${contract.name}.ts`);
    log(`Writing ${contract.name} typescript interface to ${path.relative(currentDir, tsPath)}`);
    let relativeArtifactPath = path.relative(path.dirname(tsPath), artifactPath);
    log(`Relative path: ${relativeArtifactPath}`);
    if (relativeArtifactPath === `${contract.name}.json`) {
      // relative path edge case, prepending ./ for local import - the above logic just does
      // `${contract.name}.json`, which is not a valid import for a file in the same directory
      relativeArtifactPath = `./${contract.name}.json`;
    }
    log(`Relative path after correction: ${relativeArtifactPath}`);
    const tsWrapper = generateTypescriptContractInterface(contract, relativeArtifactPath);
    mkdirpSync(path.dirname(tsPath));
    writeFileSync(tsPath, tsWrapper);
  }
}
