import { LogFn, createDebugLogger } from '@aztec/foundation/log';

import { isAbsolute, join } from 'node:path';

import { NoirCompilationArtifacts } from '../../noir_artifact.js';
import { NoirDependencyManager } from './dependencies/dependency-manager.js';
import { GithubDependencyResolver as GithubCodeArchiveDependencyResolver } from './dependencies/github-dependency-resolver.js';
import { LocalDependencyResolver } from './dependencies/local-dependency-resolver.js';
import { OnDiskFileManager } from './file-manager/on-disk-file-manager.js';
import { compile, initializeResolver } from './noir-wasm-shim.cjs';
import { NoirPackage } from './package.js';

/** Compilation options */
export type NoirWasmCompileOptions = {
  /** Logging function */
  log?: LogFn;
};

/**
 * Noir Package Compiler
 */
export class NoirWasmContractCompiler {
  #projectPath: string;
  #log: LogFn;
  public constructor(projectPath: string, opts: NoirWasmCompileOptions) {
    if (!isAbsolute(projectPath)) throw new Error('projectPath must be an absolute path');
    this.#projectPath = projectPath;
    this.#log = opts.log ?? createDebugLogger('aztec:noir-compiler:wasm');
  }

  /**
   * Compiles the project.
   */
  public async compile(): Promise<NoirCompilationArtifacts[]> {
    const cacheRoot = process.env.XDG_CACHE_HOME ?? join(process.env.HOME ?? '', '.cache');
    const fileManager = new OnDiskFileManager(join(cacheRoot, 'noir_wasm'));

    const noirPackage = NoirPackage.new(this.#projectPath, fileManager);
    if (noirPackage.getType() !== 'contract') {
      throw new Error('This is not a contract project');
    }

    this.#log(`Compiling contract at ${noirPackage.getEntryPointPath()}`);

    const dependencyManager = new NoirDependencyManager(
      [
        new LocalDependencyResolver(fileManager),
        new GithubCodeArchiveDependencyResolver(fileManager),
        // TODO support actual Git repositories
      ],
      noirPackage,
    );

    await dependencyManager.resolveDependencies();

    this.#log(`Dependencies: ${dependencyManager.getPackageNames().join(', ')}`);

    initializeResolver((sourceId: any) => {
      try {
        const libFile = dependencyManager.findFile(sourceId);
        return fileManager.readFileSync(libFile ?? sourceId, 'utf-8');
      } catch (err) {
        return '';
      }
    });

    try {
      const contract = await compile(noirPackage.getEntryPointPath(), true, {
        /* eslint-disable camelcase */
        root_dependencies: dependencyManager.getEntrypointDependencies(),
        library_dependencies: dependencyManager.getLibraryDependencies(),
        /* eslint-enable camelcase */
      });

      return [{ contract }];
    } catch (err) {
      this.#log('Error compiling contract', {
        err: (err as any).message,
        diagnostics: (err as any).diagnostics,
      });
    }
    return [];
  }
}
