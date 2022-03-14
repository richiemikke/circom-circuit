pragma circom 2.0.3;

include "mimcsponge.circom";


template Merkle_Tree (n) {  

   signal input leaves[n]; // taking in the input as a list of n leaves(in this case it is assumed that the number of leaves is 4)

   signal output root;  // output as a merkle root

   var N = n*2-1;

   signal hashes[N];

   component components[N];

    var j = 0;
    for(var i = 0; i < N; i++) {
        if(i < n) {
            // putting the hashes into leaves
            components[i] = MiMCSponge(1, 220, 1);
            components[i].k <== i;
            components[i].ins[0] <== leaves[i];
        } else {
            // constructing the merkle tree
            components[i] = MiMCSponge(2, 220, 1);
            components[i].k <== i;
            components[i].ins[0] <== hashes[j];
            components[i].ins[1] <== hashes[j+1];
            j+=2;
        }
        hashes[i] <== components[i].outs[0];
    }

    // getting the hash of the merkle root
    root <== hashes[N-1];
} 

component main {public [leaves]} = Merkle_Tree(4);