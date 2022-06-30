#!/bin/bash

mkdir circuits/Jakaroo
cd circuits/Jakaroo
if [ -f powersOfTau28_hez_final_12.ptau ]; then
    echo "powersOfTau28_hez_final_12.ptau already exists. Skipping."
else
    echo 'Downloading powersOfTau28_hez_final_12.ptau'
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau
fi

echo "Compiling Jakaroo.circom..."

cd ..

# compile circuit

circom Jakaroo.circom --r1cs --wasm --sym -o Jakaroo
snarkjs r1cs info Jakaroo/Jakaroo.r1cs

# Start a new zkey and make a contribution

snarkjs groth16 setup Jakaroo/Jakaroo.r1cs Jakaroo/powersOfTau28_hez_final_12.ptau Jakaroo/circuit_0000.zkey
snarkjs zkey contribute Jakaroo/circuit_0000.zkey Jakaroo/circuit_final.zkey --name="1st Contributor Name" -v -e="random text"
snarkjs zkey export verificationkey Jakaroo/circuit_final.zkey Jakaroo/verification_key.json

# generate solidity contract
snarkjs zkey export solidityverifier Jakaroo/circuit_final.zkey ../JakarooVerifier.sol

cd ..