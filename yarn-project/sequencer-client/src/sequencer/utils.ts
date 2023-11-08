import { Fr, GlobalVariables, HistoricBlockData } from '@aztec/circuits.js';
import { computeGlobalsHash } from '@aztec/circuits.js/abis';
import { MerkleTreeOperations } from '@aztec/world-state';

/**
 * Fetches the private, nullifier, contract tree and l1 to l2 messages tree roots from a given db and assembles a CombinedHistoricTreeRoots object.
 */
export async function getHistoricBlockData(
  db: MerkleTreeOperations,
  prevBlockGlobalVariables: GlobalVariables = GlobalVariables.empty(),
) {
  const prevGlobalsHash = computeGlobalsHash(prevBlockGlobalVariables);
  const roots = await db.getTreeRoots();

  return new HistoricBlockData(
    Fr.fromBuffer(roots.noteHashTreeRoot),
    Fr.fromBuffer(roots.nullifierTreeRoot),
    Fr.fromBuffer(roots.contractDataTreeRoot),
    Fr.fromBuffer(roots.l1Tol2MessagesTreeRoot),
    Fr.fromBuffer(roots.blocksTreeRoot),
    Fr.ZERO,
    Fr.fromBuffer(roots.publicDataTreeRoot),
    prevGlobalsHash,
  );
}
