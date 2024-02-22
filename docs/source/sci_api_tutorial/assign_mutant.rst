==============================================
Assign Mutant
==============================================

Briefs
==============================================
The target for this tutorial to mutate the target protein at defined residue(s). The main function provided are ``assign_mutant()`` and ``mutate_stru()``, in which ``assign_mutant()`` assigns mutants targeted in the study. Decode the user assigned ``{pattern}`` based on the ``{stru}`` and get a list of mutants defined by a list of mutation objects each.

Input/Output
==============================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/mutation_assign_mutant_io.svg
        :width: 100%
        :alt: assign_mutant_io 

Input
------------------------------------------------

``stru``
    the target protein structure intended for mutation, represented as a  ``Structure()`` object.

    .. admonition:: How to obtain

        | A Strutcure() object can be obtained by these `APIs <obtaining_stru.html>`_.

``pattern``
   specifies the residue(s) targeted for mutation, need to be clarified.

``chain_sync_list``
    a list that identifies homologous chains in the multimer protein, need to be clarified.

``chain_index_mapper``
    a dictionary mapping the residue indices for each chain in the multimer protein, need to be clarified.

Output
------------------------------------------------

``mutation``
    a list of mutants defined each by a list of ``Mutation`` objects.
            
    *NOTE*: this function generates WT as ``[]`` or ``[Mutation(None, "WT", None, None)]`` unless directly indication. Act accordingly.

Arguments
==============================================

``stru``
    the target protein structure for mutation represented as Structure()

``pattern``: 
    the pattern that defines the mutation.

    .. dropdown:: :fa:`eye,mr-1` Click to see *pattern* example

        Defined single mutation on chain A, where R154 changes to W154: ``mutation_pattern = ("RA154W")``
        
        Defined double mutation on chain B, where R154 to W154 and D11 to G11: ``mutation_pattern = ("{RB154W, DB11G}")``
        
        Randomly generate 100 three-point mutations around residue 289 within a 4 Å radius, excluding residue 36: ``mutation_pattern = ("r:2[resi 289 around 4 and not resi 36:larger]100")``
        
        Apply mutations to all targets within the specified mutation set: ``mutation_pattern = ("a:2[resi 254 around 3:all not self]")``

    .. dropdown:: :fa:`eye,mr-1` Click to see *pattern* layers diagram

        .. image:: ../../figures/pattern_io.svg
            :width: 100%
            :alt: pattern_io 

    .. dropdown:: :fa:`eye,mr-1` Click to see *pattern* details

        - *Pattern Syntax:*
            
            *Mutant Space Layer*
                | ``"mutant_1,mutant_2,mutant_3,..."``
                | The top layer of the mutation_pattern specify mutants with comma seperated pattern.
                | In the pattern of each mutant, there could be more than one sections, but if multiple sections are used, ``{}`` is needed to     group those sections. ``"{section_a1,section_a2,section_a3},{section_b1,section_b2, section_b3},..."``
            
            *Mutation section Layer*
                Each section can be one of the format below:
    
                1. direct indication: 
                    | ``XA###Y`` ('WT' for just wild type)
                    | e.g. mutate G13 to R13 on chain A: ``GA13R``; mutate T55 to H55, no chain number: ``T55H``.
                2. random m, n-point mutation in a set: 
                    | ``r:n[mutation_esm_patterns]*m`` or ``r:nR[mutation_esm_patterns]*mR``
                    | (n and m are int, R stands for allowing repeating mutations in randomization)
                    | e.g. randomly generate 60 three-point mutations within the selected residues, and mutate them to redidues carry more formal positive charge: ``r:3[resi 255-301 :charge+]*60``
                3. all mutations in a set:             
                    | ``a:[mutation_esm_patterns]`` or ``a:M[mutation_esm_patterns]`` 
                    | (M stands for force mutate each position so that no mutation on any position is not allowed)
                    | e.g. force mutate all the residues around ligand (named 'LIG') within 5 Å to all kinds of AAs: ``a:M[byres LIG around 5 255-301 :all]``

            *Mutation Ensemble Patterns* (``[mutation_esm_patterns]``)
                    The mutation_esm_patterns is seperated by comma and each describes 2 things:
            
                    1. ``position_pattern``:
                        | a set of positions (check selection syntax in ``.mutation_pattern.position_pattern``) 
                        | adopt the same algebra as PyMOL (https://pymolwiki.org/index.php/Selection_Algebra)
                        | NOTE: all non polypeptide part are filtered out.
                    2. ``target_aa_pattern``:
                        | a set of target mutations apply to all positions in the current set (check syntax in ``.mutation_pattern.target_aa_pattern``)

                        .. dropdown:: :fa:`eye,mr-1` Click to see available ``target_aa_pattern`` key words

                            .. code:: python

                                (current supported keywords)
                                self:       the AA itself
                                all:        all 20 canonical amino acid (AA)
                                larger:     AA that is larger in size according to
                                            enzy_htp.chemical.residue.RESIDUE_VOLUME_MAPPER
                                smaller:    AA that is smaller in size
                                similar_size_20: AA that similar is size (cutoff: 20 Ang^3)
                                charge+:    AA that carry more formal positive charge
                                charge-:    AA that carry less formal positive charge
                                charge+1:   AA that carry 1 more positive charge
                                charge-1:   AA that carry 1 less positive charge
                                neutral:    AA that is charge neutral
                                positive:   AA that have positive charge
                                negative:   AA that have negative charge
                                {3-letter}: the AA of the 3-letter name
            
                    The two pattern are seperated by ``:`` and a mutation_esm_patterns looks like: ``position_pattern_0:target_aa_pattern_0, ...``
    
                    * In 2&3 the pattern may indicate a mutant collection, if more than one mutant collection are indicated in the same ``{}``, all combination of them is considered.
    
            Overall an example of pattern will be: ``"{RA154W, DA11G}, r:2[resi 289 around 4 and not resi 36:larger, proj(id 1000, id 2023, positive, 10) :more_negative_charge]*100"``
    
            * Here ``proj()`` is a hypothetical selection function
    
        - *Details:*
    
            | Which mutations should we study is a non-trivial question. Mutations could be assigned from a database or a site-saturation requirement. It reflexs the scientific question defined Assigning the mutation requires converting chemical/structural language to strict mutation definitions. Some fast calculations can also be done during the selection of mutations. (e.g.: calculating residues aligned with the projection line of the reacting bond [ref]) 
            | There are no existing software besides EnzyHTP addressing this challenge. 
            | A language that helps user to assign mutations is defined above.

``chain_sync_list``: 
    A list like ``[(A,C),(B,D)]`` to indicate homo-chains in enzyme ploymer (like dimer). Mutations will be **copied** to the correpondinhomo-chains as it is maybe experimentally impossible to only do mutations on one chain of a homo-dimer enzyme.

``random_state``: 
    The ``int()`` seed for the random number generator. Default value is 100.

``chain_index_mapper``: 
    need to be clarified in cases that residue index in each chain is not aligned.

    | e.g.: for a pair of homo-dimer below:
    | "A": ABCDEFG (start from 7)
    | "B": BCDEFGH (start from 14)
    | the chain_sync_mapper should be ``{"A":0, "B":6}`` and index conversion is done by A_res_idx - 0 + 6 = B_res_idx

``if_check``
    if or not checking if each mutation is valid. (This could be pretty slow if the mutant is >10^7 level)

Example Code
==============================================

Assign mutants for a target protein
---------------------------------------------------------

In this example, we perform assign mutations on a monomer or multimer protein structure. In these structures, ``test_A.pdb``, ``test_A_B.pdb``, and ``test_A_B_C_D.pdb``, A and B are homologous chains, and C and D are homologous chains distinct from A and B.

The ``stru`` is obtained by reading from a PDB file.

.. code:: python

    from enzy_htp.structure import PDBParser
    import enzy_htp.mutation.api as mapi
    #mutate a sigle chain protein
    test_A = "test_A.pdb"
    test_A_stru = PDBParser.get_structure(test_A)
    test_mutation_pattern_A = (
            "GA11A, {NA176W, PA51A},"
            " {L56A, r:2[resi 254 around 3:all not self]*5}"
            )
    mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
    print(mutants_A)

    ##mutate a two-chain protein
    test_A_B = "test_A_B.pdb"
    test_A_B_stru = PDBParser.get_structure(test_A_B)
    test_mutation_pattern_A_B = ("{GA11A, NB176W, PB51A}")
    mutation_pattern_A_B = mapi.assign_mutant(test_A_B_stru, test_mutation_pattern_A_B, chain_sync_list=[("A", "B")], chain_index_mapper{"A": 0, "B": 0})
    print(mutation_pattern_A_B)

    #mutate a four-chain protein
    test_A_B_C_D = "test_A_B_C_D.pdb"
    test_A_B_C_D_stru = PDBParser.get_structure(test_A_B_C_D)
    test_mutation_pattern_A_B_C_D = ("{TA391A, RC58A}")
    mutation_pattern_A_B_C_D = mapi.assign_mutant(test_A_B_C_D_stru, test_mutation_pattern_A_B_C_D, chain_sync_list=[("A", "B"), ("C","D")], chain_index_mapper={"A": 0, "B": 0, "C": 0, "D": 0})
    print(mutation_pattern_A_B_C_D)
