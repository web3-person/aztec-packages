import { fileManagerTestSuite } from './file-manager-test-suite.js';
import { InMemoryFileManager } from './in-memory-file-manager.js';

describe('InMemoryFileManager', () => {
  fileManagerTestSuite(() => new InMemoryFileManager());
});
