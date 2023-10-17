import { LogFn, createDebugOnlyLogger } from '@aztec/foundation/log';

import { join } from 'node:path';

import { NoirDependencyConfig } from '../package-config.js';
import { NoirPackage } from '../package.js';
import { DependencyResolver } from './dependency-resolver.js';

/**
 * Noir Dependency Resolver
 */
export class NoirDependencyManager {
  dependencies = new Map<string, NoirPackage>();
  #log: LogFn;
  #resolvers: readonly DependencyResolver[];

  /**
   * Creates a new dependency resolver
   * @param resolvers - A list of dependency resolvers to use
   */
  constructor(resolvers: readonly DependencyResolver[] = []) {
    this.#log = createDebugOnlyLogger('noir:dependency-resolver');
    this.#resolvers = resolvers;
  }

  /**
   * Resolves dependencies for a package.
   * @param noirPackage - The package to resolve dependencies for
   */
  public async recursivelyResolveDependencies(noirPackage: NoirPackage): Promise<void> {
    for (const [name, config] of Object.entries(noirPackage.getDependencies())) {
      // TODO what happens if more than one package has the same name but different versions?
      if (this.dependencies.has(name)) {
        this.#log(`skipping already resolved dependency ${name}`);
        continue;
      }

      const dependency = await this.#resolveDependency(noirPackage, config);
      if (dependency.getType() !== 'lib') {
        this.#log(`Non-library package ${name}`, config);
        throw new Error(`Dependency ${name} is not a library`);
      }

      this.dependencies.set(name, dependency);

      await this.recursivelyResolveDependencies(dependency);
    }
  }

  async #resolveDependency(pkg: NoirPackage, config: NoirDependencyConfig) {
    let dependency: NoirPackage | null = null;
    for (const resolver of this.#resolvers) {
      dependency = await resolver.resolveDependency(pkg, config);
      if (dependency) {
        break;
      }
    }

    if (!dependency) {
      throw new Error('Dependency not resolved');
    }

    return dependency;
  }

  /**
   * Gets the names of the crates in this dependency list
   */
  public getPackageNames() {
    return [...this.dependencies.keys()];
  }

  /**
   * Looks up a dependency
   * @param sourceId - The source being resolved
   * @returns The path to the resolved file
   */
  public findFile(sourceId: string): string | null {
    const [lib, ...path] = sourceId.split('/').filter(x => x);
    const pkg = this.dependencies.get(lib);
    if (pkg) {
      return join(pkg.getSrcPath(), ...path);
    } else {
      return null;
    }
  }
}
