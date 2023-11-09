import { PublicExecution, PublicExecutionResult } from './execution.js';
import { Fr, GlobalVariables, HistoricBlockData } from '@aztec/circuits.js';

export class PublicVmExecutionContext {
  readonly MEM_WORDS = 1024;
  public fieldMem: Fr[] = new Array<Fr>(this.MEM_WORDS);
  public readonly calldata: Fr[];

  constructor(
    public readonly execution: PublicExecution,
    //public readonly historicBlockData: HistoricBlockData,
    //public readonly globalVariables: GlobalVariables,
  ) {
    this.calldata = execution.args; // rename
  }
}