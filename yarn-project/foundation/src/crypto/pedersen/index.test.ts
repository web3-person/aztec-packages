import { toBufferBE } from '../../bigint-buffer/index.js';
import { pedersenCommit, pedersenHash } from './index.js';

describe('pedersen', () => {
  it('pedersen commit', () => {
    const r = pedersenCommit([toBufferBE(1n, 32), toBufferBE(1n, 32)]);
    expect(r).toEqual([
      Buffer.from('2f7a8f9a6c96926682205fb73ee43215bf13523c19d7afe36f12760266cdfe15', 'hex'),
      Buffer.from('01916b316adbbf0e10e39b18c1d24b33ec84b46daddf72f43878bcc92b6057e6', 'hex'),
    ]);
  });

  it('pedersen commit with zero', () => {
    const r = pedersenCommit([toBufferBE(0n, 32), toBufferBE(1n, 32)]);
    expect(r).toEqual([
      Buffer.from('054aa86a73cb8a34525e5bbed6e43ba1198e860f5f3950268f71df4591bde402', 'hex'),
      Buffer.from('209dcfbf2cfb57f9f6046f44d71ac6faf87254afc7407c04eb621a6287cac126', 'hex'),
    ]);
  });

  it('pedersen hash', () => {
    const r = pedersenHash([toBufferBE(1n, 32), toBufferBE(1n, 32)]);
    expect(r).toEqual(Buffer.from('07ebfbf4df29888c6cd6dca13d4bb9d1a923013ddbbcbdc3378ab8845463297b', 'hex'));
  });

  it('pedersen hash with index', () => {
    const r = pedersenHash([toBufferBE(1n, 32), toBufferBE(1n, 32)], 5);
    expect(r).toEqual(Buffer.from('1c446df60816b897cda124524e6b03f36df0cec333fad87617aab70d7861daa6', 'hex'));
  });
});
