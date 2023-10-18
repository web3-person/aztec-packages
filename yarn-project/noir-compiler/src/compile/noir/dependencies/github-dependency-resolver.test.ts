import { fileURLToPath } from '@aztec/foundation/url';

import { jest } from '@jest/globals';
import { readFile } from 'node:fs/promises';
import { dirname, join } from 'node:path';

import { FileManager } from '../file-manager/file-manager.js';
import { InMemoryFileManager } from '../file-manager/in-memory-file-manager.js';
import { NoirPackage } from '../package.js';
import { DependencyResolver } from './dependency-resolver.js';
import { GithubDependencyResolver } from './github-dependency-resolver.js';

describe('GithubDependencyResolver', () => {
  let resolver: DependencyResolver;
  let fm: FileManager;
  let pkg: NoirPackage;
  let _fetchMock: jest.SpiedFunction<typeof fetch>;

  beforeEach(async () => {
    const fixtures = join(dirname(fileURLToPath(import.meta.url)), '../../../fixtures');
    fm = new InMemoryFileManager({
      '/test_contract/Nargo.toml': await readFile(join(fixtures, 'test_contract/Nargo.toml')),
      '/test_contract/src/main.nr': await readFile(join(fixtures, 'test_contract/src/main.nr')),
      '/test_lib/Nargo.toml': await readFile(join(fixtures, 'test_lib/Nargo.toml')),
      '/test_lib/src/lib.nr': await readFile(join(fixtures, 'test_lib/src/lib.nr')),
    });

    pkg = NoirPackage.atPath('/test_contract', fm);
    resolver = new GithubDependencyResolver(fm);

    // cut off outside access
    _fetchMock = jest
      .spyOn(globalThis, 'fetch')
      .mockImplementation(async () => new Response(await readFile(join(fixtures, 'test_lib.zip')), { status: 200 }));
  });

  it("returns null if it can't resolve a dependency", async () => {
    const dep = await resolver.resolveDependency(pkg, {
      path: '/test_lib',
    });

    expect(dep).toBeNull();
  });

  it('resolves remote dependency', async () => {
    const dep = await resolver.resolveDependency(pkg, {
      git: 'https://github.com/example/lib.nr',
      tag: 'v1.0.0',
    });
    expect(dep).toBeDefined();
  });
});
