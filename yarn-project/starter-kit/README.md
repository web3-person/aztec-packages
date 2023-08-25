This is a minimal [Aztec3]() noir smart contract and frontend bootstrapped with [`aztec-cli unbox`](https://github.com/AztecProtocol/aztec-packages/tree/master/yarn-project/aztec-cli). It is recommended you use the `aztec-cli unbox` command so that the repository is cloned with an example noir smart contract from the [`noir-contracts`](https://github.com/AztecProtocol/aztec-packages/tree/master/yarn-project/noir-contracts) repostiroy.# React + TypeScript + Vite

This was probably created by running the command `aztec-cli unbox {CONTRACT_NAME}`.
That command copied an example noir contract from `https://github.com/AztecProtocol/aztec-packages/tree/master/yarn-project/noir-contracts` into `/src/contracts` as well as this entire subpackage from `https://github.com/AztecProtocol/aztec-packages/tree/master/yarn-project/starter-project`.

## Setup

This project requires `nargo` and `noir` in addition to `@aztec/aztec-cli`.

The former two can be installed with

```bash
# install noirup
curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash

noirup -v aztec
# install package dependencies
yarn install
```

## Getting started

This folder should have the following directory structure:

```
|— README.md
|— package.json
|- .env (autogenerated)
|— src
       |— app
              |— [frontend TSX code]
       |- scripts
              |- [helpers for frontend to interact with the sandbox]
       |— contracts
              |- [noir-lib helper contracts]
              |— src
                     |— main.nr - the cloned noir contract
                     |- [other .nr contract files]
               |— Nargo.toml
       |— artifacts
              |- these are generated by the compile command
              |— private_token_contract.json
              |— private_token.ts
       |— test
```

The `src/artifacts` folder can be generated from the command line with

```bash
aztec-cli compile src/contracts --outdir ../artifacts --typescript ../artifacts
```

Then you can deploy the noir smart contract with

```bash
aztec-cli deploy src/artifacts/PrivateToken.json  --args 1000000 $ALICE --salt 0
```

The command should succeed and return the address of the deployed contract. This will need
to be updated in the `.env` file's `VITE_CONTRACT_ADDRESS` value if you are using a different contract or have changed the deploy command.

Lastly, launch the frontend:

```bash

npm run dev
# or
yarn dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see a minimal smart contract frontend.

We will also need to setup a local instance of the Aztec Network, via

```bash
/bin/bash -c "$(curl -fsSL 'https://up.aztec.network')"
```

(note: command is currently gated by an auth token)

## Learn More

To learn more about Noir Smart Contract development, take a look at the following resources:

- [Awesome Noir](https://github.com/noir-lang/awesome-noir) - learn about the Noir programming language.

## Deploy on Aztec3

TBD

# Vite README

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react/README.md) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type aware lint rules:

- Configure the top-level `parserOptions` property like this:

```js
   parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    project: ['./tsconfig.json', './tsconfig.node.json'],
    tsconfigRootDir: __dirname,
   },
```

- Replace `plugin:@typescript-eslint/recommended` to `plugin:@typescript-eslint/recommended-type-checked` or `plugin:@typescript-eslint/strict-type-checked`
- Optionally add `plugin:@typescript-eslint/stylistic-type-checked`
- Install [eslint-plugin-react](https://github.com/jsx-eslint/eslint-plugin-react) and add `plugin:react/recommended` & `plugin:react/jsx-runtime` to the `extends` list