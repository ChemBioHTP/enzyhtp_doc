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

    .. admonition:: How to obtain

        | The ``pattern`` can be written with the syntax `Pattern Syntax <#mutant-pattern>`_.

``chain_sync_list``
    a list that identifies homologous chains in the multimer protein, need to be clarified.

    .. admonition:: How to obtain

        | The ``chain_sync_list`` can be written as a list like ``[(A,C),(B,D)]`` to indicate homo-chains in enzyme ploymer (like dimer). Mutations will be **copied** to the correpondinhomo-chains as it is maybe experimentally impossible to only do mutations on one chain of a homo-dimer enzyme.

``chain_index_mapper``
    a dictionary mapping the residue indices for each chain in the multimer protein, need to be clarified.

    .. admonition:: How to obtain

        | The ``chain_index_mapper`` need to be clarified in cases that residue index in each chain is not aligned.
            | e.g.: for a pair of homo-dimer below:
            | "A": ABCDEFG (start from 7)
            | "B": BCDEFGH (start from 14)
            | the chain_sync_mapper should be ``{"A":0, "B":6}`` and index conversion is done by A_res_idx - 0 + 6 = B_res_idx

Output
------------------------------------------------

``mutation``
    a list of mutants defined each by a list of ``Mutation`` objects.
            
    *NOTE*: this function generates WT as ``[]`` or ``[Mutation(None, "WT", None, None)]`` unless directly indication. Act accordingly.

Mutant Pattern
==============================================

Basic usage example
----------------------------------------------
    
* Generate a mutant with a single-point mutation: R378E
    
    .. code:: python
        
        test_A = "test_A.pdb"
        test_A_stru = PDBParser.get_structure(test_A)
        test_mutation_pattern_A = "R378E"
        mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
        print(mutants_A)
        #[[('ARG','GLU','A',378)]]

Chemistry-inspired example
----------------------------------------------

* Mutate residues using the protein with the LIG substrate near the binding pocket, defined as residues within 5 Å of LIG, to increase pocket volume. Not all residues need to be force mutated.

    .. code:: python

        test_A = "test_A.pdb"
        test_A_stru = PDBParser.get_structure(test_A)
        test_mutation_pattern_A = "a:[byres resn LIG around 5:smaller]"
        mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
        print(mutants_A)

.. dropdown:: :fa:`eye,mr-1` Click to see more **monomer protein** examples

    * Work with the wild-type

        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "WT" 
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #[[(None,'WT',None,None)]]


    * Generate a mutant with a single-point mutation: R378E

        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "R378E"
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #[[('ARG','GLU','A',378)]]

    * Generate a mutant with double-point mutation: L383H and N363E.

        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "LA383H,NB363E"
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #[[('LEU','HIS','A',383)], [('ASN','GLU','A',363)]]

    * Generate two mutants with triple-point mutation from the same wild-type. The first mutant: L383H/N363E/I161L. The second mutant: D158I/W365T/ V79L.

        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "{L383H,N363E,I161L},{D158I,W365T,V79L}"
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #[[('ILE','LEU','A',161), ('ASN','GLU','A',363), ('LEU','HIS','A',383)], 
            #[('ASP','ILE','A',158), ('TRP','THR','A',365), ('VAL','LEU','A',79)]]

    * Generate 20 mutants with single-point mutation of the target protein, resulting in 20 different single mutants.

        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "r:1[all:all not self]*20"
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #[[('MET','ASP','A',85)], [('THR','SER','A',388)], [('VAL','ASN','A',132)], [('GLY','ASN','A',214)], [('ASP','SER','A',364)], [('THR',  'TYR','A',295)], [('ILE','THR','A',245)], [('TRP','LYS','A',365)], [('GLY','TRP','A',321)], [('ALA','ASP','A',26)], [('ILE','PHE','A',    161)], [('ASP','PRO','A',158)], [('LYS','CYS','A',250)], [('SER','ASP','A',81)], [('LYS','TYR','A',25)], [('PHE','SER','A',180)],   [('LEU','GLY','A',175)], [('ASN','TRP','A',256)], [('VAL','ILE','A',79)], [('SER','PRO','A',224)]]

    *  Generate 10 mutants with triple-point mutation of the target protein, resulting in 10 different triple mutants.

        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "r:3[all:all not self]*10"
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #[[('ASP','THR','A',377), ('ASP','CYS','A',64), ('LEU','ASN','A',121)], [('PRO','TYR','A',43), ('ASN','SER','A',315), ('GLY','ASN','A', 148)], [('GLN','TRP','A',356), ('ASP','THR','A',328), ('GLN','MET','A',316)], [('PRO','PHE','A',139), ('ARG','PHE','A',244), ('LEU', 'ASN','A',225)], [('PHE','TYR','A',392), ('ASP','GLN','A',333), ('GLY','ASP','A',60)], [('ARG','SER','A',281), ('GLN','HIS','A',271),    ('LEU','TRP','A',341)], [('ARG','LEU','A',58), ('PRO','TRP','A',131), ('TRP','PRO','A',159)], [('GLU','VAL','A',260), ('PRO','GLY','A',    54), ('ARG','GLY','A',380)], [('VAL','TRP','A',291), ('GLY','ASN','A',280), ('ASN','PRO','A',167)], [('GLY','CYS','A',148), ('PHE', 'TYR','A',195), ('ALA','SER','A',120)]]

    *  Perform 20 random double-point mutations on amino acids within 5 Å of the LIG substrate binding pocket, resulting in 20 different double mutants.

        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "r:2[byres resn LIG around 5:all not self]*20"
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #[[('PHE','ASP','A',75), ('ARG','THR','A',72)], [('GLY','ASN','A',296), ('TYR','LEU','A',188)], [('GLY','ASN','A',296), ('SER','PRO',   'A',215)], [('ASN','THR','A',293), ('SER','TYR','A',215)], [('HIS','MET','A',49), ('ASN','LEU','A',293)], [('GLY','ASN','A',297),  ('VAL','CYS','A',228)], [('VAL','PHE','A',47), ('GLY','CYS','A',297)], [('PHE','TYR','A',75), ...

    * Mutate residues using the protein with the LIG substrate near the binding pocket, defined as residues within 3 Å of LIG, to introduce more positive charges to the pocket. Not all residues need to be force mutated.

        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "a:[byres resn LIG around 3:charge+]"
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #[[('PRO','ARG','A',294), ('VAL','ARG','A',216), ('THR','ARG','A',295), ('PHE','ARG','A',75), ('GLY','ARG','A',296), ('MET','ARG','A',  207), ('TYR','ARG','A',354), ('THR','ARG','A',229), ('TYR','ARG','A',188)]...

    * Mutate residues using the protein with the LIG substrate near the binding pocket, defined as residues within 5 Å of LIG, to increase pocket volume. Not all residues need to be force mutated.

        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "a:[byres resn LIG around 5:smaller]"
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #(too many mutants)...

    * Generate 5 random mutants with single-point mutation using the protein with the LIG substrate to introduce more negative charges to distal residues, defined as over 30 Å away from the substrate.
    
        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "r:1[byres all and not (byres resn LIG around 30 or resn LIG):charge-]*5"
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #[[('GLY','ASP','A',152), ('SER','ALA','A',141), ('SER','GLU','A',150)], [('GLN','ASP','A',5), ('ARG','TYR','A',6), ('SER','ALA','A',   141)], [('SER','ALA','A',141), ('PRO','GLU','A',139), ('VAL','ASP','A',317)]]

    * Using the protein with the LIG substrate, randomly generate 3 double mutants in the distal region to introduce more negative charges to   distal residues, which is defined as residues over 30 Å away from the substrate. Additionally, mutate S141 to alanine in each mutant.
    
        .. code:: python

            test_A = "test_A.pdb"
            test_A_stru = PDBParser.get_structure(test_A)
            test_mutation_pattern_A = "{S141A, r:2[byres all and not (byres resn LIG around 30 or resn LIG):charge-]*3}"
            mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
            print(mutants_A)
            #[[('GLY','ASP','A',152), ('SER','ALA','A',141), ('SER','GLU','A',150)], [('GLN','ASP','A',5), ('ARG','TYR','A',6), ('SER','ALA','A',   141)], [('SER','ALA','A',141), ('PRO','GLU','A',139), ('VAL','ASP','A',317)]]

.. dropdown:: :fa:`eye,mr-1` Click to see more **homodimeric protein** examples

    * Generate two mutants for a homologous dimeric protein: L383H and N363E.


        .. code:: python

            test_A_B = "test_A_B.pdb"
            test_A_B_stru = PDBParser.get_structure(test_A_B)
            test_mutation_pattern_A_B = "LA383H,NB363E"
            mutation_pattern_A_B = mapi.assign_mutant(test_A_B_stru, 
                                                      test_mutation_pattern_A_B, 
                                                      chain_sync_list=[("A", "B")], 
                                                      chain_index_mapper={"A": 0, "B": 0})
            print(mutation_pattern_A_B)
            #[[('LEU','HIS','B',383), ('LEU','HIS','A',383)], [('ASN','GLU','B',363), ('ASN','GLU','A',363)]]

    * Randomly generate 3 double mutants by mutating residues at the dimer interface to smaller amino acids for a homologous dimericprotein.
        
        .. code:: python
            
            test_A_B = "test_A_B.pdb"
            test_A_B_stru = PDBParser.get_structure(test_A_B)
            test_mutation_pattern_A_B = "r:2[byres chain A around 5.0 and chain B:smaller]*3"
            mutation_pattern_A_B = mapi.assign_mutant(test_A_B_stru, 
                                                      test_mutation_pattern_A_B, 
                                                      chain_sync_list=[("A", "B")], 
                                                      chain_index_mapper={"A": 0, "B": 0})
            print(mutation_pattern_A_B)
            #[[('PHE','GLY','B',179), ('ALA','GLY','A',332), ('PHE','GLY','A',179), ('ALA','GLY','B',332)], [('ARG','THR','A',272), ('ASP''ALA',       'B',275), ('ARG','THR','B',272), ('ASP','ALA','A',275)], [('ASN','CYS','A',178), ('GLU','ASP','B',340), ('GLU''ASP','A',340), ('ASN',  'CYS','B',178)]]
    
    * Randomly generate 4 triple mutants by mutating residues at the dimer interface to neutral amino acids for a homologous dimeric protein.

        .. code:: python

            test_A_B = "test_A_B.pdb"
            test_A_B_stru = PDBParser.get_structure(test_A_B)
            test_mutation_pattern_A_B = "r:3[byres chain A around 5.0 and chain B:neutral]*4"
            mutation_pattern_A_B = mapi.assign_mutant(test_A_B_stru, 
                                                      test_mutation_pattern_A_B, 
                                                      chain_sync_list=[("A", "B")], 
                                                      chain_index_mapper={"A": 0, "B": 0})
            print(mutation_pattern_A_B)
            #[[('PRO','MET','A',344), ('GLY','PHE','B',181), ('ASP','ALA','A',211), ('PRO','MET','B',344), ('ASP','ALA','B',211), ('GLY''PHE','A',     181)], [('ARG','CYS','A',276), ('ARG','VAL','B',351), ('ASP','CYS','A',364), ('ARG','VAL','A',351), ('ASP','CYS''B',364), ('ARG','CYS',    'B',276)], [('ARG','CYS','B',336), ('ARG','CYS','A',336), ('LYS','GLY','A',357), ('PRO','ALA','A'358), ('LYS','GLY','B',357), ('PRO',     'ALA','B',358)], [('ILE','TYR','A',182), ('ASP','THR','A',211), ('ALA','TRP','B',332),('ASP','THR','B',211), ('ILE','TYR','B',182),      ('ALA','TRP','A',332)]]

.. dropdown:: :fa:`eye,mr-1` Click to see more **heterodimeric protein** examples

    * Generate the following mutations on a heterodimeric protein with chains A and D: P151F on chain A and T76D on chain D. 

        .. code:: python

            test_A_D = "4nb9_A_D.pdb"
            test_A_D_stru = PDBParser.get_structure(test_A_B)
            test_mutation_pattern_A_D = "{PA151F,TD76D}"
            mutation_pattern_A_D = mapi.assign_mutant(test_A_B_stru, 
                                                      test_mutation_pattern_A_B, 
                                                      chain_sync_list=[("A"), ("D")], 
                                                      chain_index_mapper={"A": 0, "D": 0})
            print(mutation_pattern_A_D)
            #[[('THR','ASP','D',76), ('PRO','PHE','A',151)]]

    * Generate two separate mutants with a heterodimeric protein containing chains A and D: P151F on chain A, and T76D on chain D

        .. code:: python

            test_A_D = "4nb9_A_D.pdb"
            test_A_D_stru = PDBParser.get_structure(test_A_B)
            test_mutation_pattern_A_D = "{PA151F,TD76D}"
            mutation_pattern_A_D = mapi.assign_mutant(test_A_B_stru, 
                                                      test_mutation_pattern_A_B, 
                                                      chain_sync_list=[("A"), ("D")], 
                                                      chain_index_mapper={"A": 0, "D": 0})
            print(mutation_pattern_A_D)
            #[[('PRO','PHE','A',151)], [('THR','ASP','D',76)]]

    * Use a heterodimeric protein comprised of A and D chains, where chain A contains the cofactor FE2 and chain D contains the cofactor FES.   Generate 3 single mutants to add a negative charge within 3 Å of the FE2 cofactor in chain A. Simultaneously, mutate residues within 4 Å of the   FES cofactor in chain D to smaller residues to create 2 double mutations, for each mutation in chain A. The result should be 6 mutants, each  with a single point mutation in chain A and a double point mutation in chain D. 

        .. code:: python

            test_A_D = "4nb9_A_D.pdb"
            test_A_D_stru = PDBParser.get_structure(test_A_B)
            test_mutation_pattern_A_D = "{r:1[byres resn FE2 around 3 and chain A:charge+1]*3, r:2[byres resn FES around 4 and chain D:smaller]*2}"
            mutation_pattern_A_D = mapi.assign_mutant(test_A_B_stru, 
                                                      test_mutation_pattern_A_B, 
                                                      chain_sync_list=[("A"), ("D")], 
                                                      chain_index_mapper={"A": 0, "D": 0})
            print(mutation_pattern_A_D)
            #[[('HIS','ASP','D',48), ('ASP','PHE','A',333), ('CYS','GLY','D',84)], 
            #[('ASP','PHE','A',333), ('PHE','THR','D',67), ('CYS','GLY','D',84)], 
            #[('ASP','SER','A',333), ('HIS','ASP','D',48), ('CYS','GLY','D',84)], 
            #[('ASP','SER','A',333), ('PHE','THR','D',67), ('CYS','GLY','D',84)], 
            #[('HIS','ASP','D',48), ('HIS','ARG','A',183), ('CYS','GLY','D',84)], 
            #[('PHE','THR','D',67), ('HIS','ARG','A',183), ('CYS','GLY','D',84)]]

.. dropdown:: :fa:`eye,mr-1` Click to see more **heterotetrameric protein** examples

    * Use a tetrameric protein where chains A and B, as well and chains D and E, are homologous subunits. Mutate W321 in chains A and B was mutated     to A321, and Y101 in chains D and E to R101.

        .. code:: python

            test_A_B_C_D = "4nb9_AB_DE.pdb"
            test_A_B_C_D_stru = PDBParser.get_structure(test_A_B_C_D)
            test_mutation_pattern_A_B_C_D = "{WA321A, YD101R}"
            mutation_pattern = mapi.assign_mutant(test_A_B_C_D_stru, 
                                                      pattern, 
                                                      chain_sync_list=[("A", "B"), ("D","E")],
                                                      chain_index_mapper={"A": 0, "B": 0, "C": 0, "D": 0})
            print(mutation_pattern_A_B_C_D)
            #[[('TYR','ARG','E',101), ('TRP','ALA','B',321), ('TYR','ARG','D',101), ('TRP','ALA','A',321)]]

    * Use a tetrameric protein where chains A and B, as well as chains D and E, are homologous subunits. Mutate W321 to A321 in chains A and B to   generate one mutant. Mutate Y101 to R101 in chains D and E to generate another mutant.
        .. code:: python

            test_A_B_C_D = "4nb9_AB_DE.pdb"
            test_A_B_C_D_stru = PDBParser.get_structure(test_A_B_C_D)
            test_mutation_pattern_A_B_C_D = "WA321A, YD101R"
            mutation_pattern = mapi.assign_mutant(test_A_B_C_D_stru, 
                                                      pattern, 
                                                      chain_sync_list=[("A", "B"), ("D","E")],
                                                      chain_index_mapper={"A": 0, "B": 0, "C": 0, "D": 0})
            print(mutation_pattern_A_B_C_D)
            #[[('TRP','ALA','B',321), ('TRP','ALA','A',321)], [('TYR','ARG','D',101), ('TYR','ARG','E',101)]]

.. dropdown:: :fa:`eye,mr-1` Click to see overall *pattern* layers diagram

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
                            * Note: "charge+", "charge-", "charge+1", "charge-1", these keywords do not set HIS as target residue. For HIS, pH=7 is the condition we determine the formal charge
        
                The two pattern are seperated by ``:`` and a mutation_esm_patterns looks like: ``position_pattern_0:target_aa_pattern_0, ...``

                * In 2&3 the pattern may indicate a mutant collection, if more than one mutant collection are indicated in the same ``{}``, all combination of them is considered.

        Overall an example of pattern will be: ``"{RA154W, DA11G}, r:2[resi 289 around 4 and not resi 36:larger, proj(id 1000, id 2023, positive, 10) :more_negative_charge]*100"``

        * Here ``proj()`` is a hypothetical selection function

    - *Details:*

        | Which mutations should we study is a non-trivial question. Mutations could be assigned from a database or a site-saturation requirement. It reflexs the scientific question defined Assigning the mutation requires converting chemical/structural language to strict mutation definitions. Some fast calculations can also be done during the selection of mutations. (e.g.: calculating residues aligned with the projection line of the reacting bond) 
        | There are no existing software besides EnzyHTP addressing this challenge. 
        | A language that helps user to assign mutations is defined above.


Arguments
==============================================

``stru``
    the target protein structure for mutation represented as Structure()

``pattern``: 
    the pattern that defines the mutation.
    (See `Mutant Pattern <#mutant-pattern>`_ section)

``chain_sync_list``: 
    A list to indicate homo-chains in enzyme ploymer (like dimer). 
    (See `Input/Output <#input-output>`_ section)

``random_state``: 
    The ``int()`` seed for the random number generator. Default value is 100.

``chain_index_mapper``: 
    A dictionary that need to be clarified in cases that residue index in each chain is not aligned.
    (See `Input/Output <#input-output>`_ section)

``if_check``
    if or not checking if each mutation is valid. (This could be pretty slow if the mutant is >10^7 level)

Example Code
==============================================

1. Assign mutants for a monomer protein
---------------------------------------------------------

In this example, we perform assign mutations on a monomer protein structure. 

.. admonition:: How input is prepared

    ``stru``
        obtained by reading from a PDB file using ``PDBParser().get_structure()``
        (See `Details <#input-output>`_)

    ``pattern``
        defined as pattern syntax
        (See `Details <#mutant-pattern>`_)

.. code:: python

    from enzy_htp.structure import PDBParser
    import enzy_htp.mutation.api as mapi
    test_A = "test_A.pdb"
    test_A_stru = PDBParser.get_structure(test_A)
    test_mutation_pattern_A = (
            "GA11A, {NA176W, PA51A},"
            " {L56A, r:2[resi 254 around 3:all not self]*5}"
            )
    mutants_A = mapi.assign_mutant(test_A_stru, test_mutation_pattern_A)
    print(mutants_A)

2. Assign mutants for a two-chain protein
---------------------------------------------------------

In this example, we perform assign mutations on a two-chainr protein structure, in which A and B are homologous chains.

.. admonition:: How input is prepared

    ``stru``
        obtained by reading from a PDB file using ``PDBParser().get_structure()``
        (See `Details <#input-output>`_)

    ``pattern``
        defined as pattern syntax
        (See `Details <#mutant-pattern>`_)

    ``chain_sync_list``
        defined according to the structure, there are two chains (A and B)
        (See `Details <#input-output>`_)

    ``chain_index_mapper``
        defined according to the structure, there are two chains (A and B) both start from the same residue index
        (See `Details <#input-output>`_)

.. code:: python

    from enzy_htp.structure import PDBParser
    import enzy_htp.mutation.api as mapi
    test_A_B = "test_A_B.pdb"
    test_A_B_stru = PDBParser.get_structure(test_A_B)
    test_mutation_pattern_A_B = "{GA11A, NB176W, PB51A}"
    mutation_pattern_A_B = mapi.assign_mutant(test_A_B_stru, 
                                              test_mutation_pattern_A_B, 
                                              chain_sync_list=[("A", "B")], 
                                              chain_index_mapper{"A": 0, "B": 0})
    print(mutation_pattern_A_B)

3. Assign mutants for a four-chain protein
---------------------------------------------------------

In this example, we perform assign mutations on a four-chainr protein structure, in which A and B are homologous chains, and C and D are homologous chains distinct from A and B.

.. admonition:: How input is prepared

    ``stru``
        obtained by reading from a PDB file using ``PDBParser().get_structure()``
        (See `Details <#input-output>`_)

    ``pattern``
        defined as pattern syntax
        (See `Details <#mutant-pattern>`_)

    ``chain_sync_list``
        defined according to the structure, there are four chains (A, B, C, and D), A and B are same subunits, C and D are same subunits
        (See `Details <#input-output>`_)

    ``chain_index_mapper``
        defined according to the structure, A & B and C & D start from the same residue index
        (See `Details <#input-output>`_)
        
.. code:: python

    from enzy_htp.structure import PDBParser
    import enzy_htp.mutation.api as mapi
    test_A_B_C_D = "test_A_B_C_D.pdb"
    test_A_B_C_D_stru = PDBParser.get_structure(test_A_B_C_D)
    test_mutation_pattern_A_B_C_D = "{TA391A, RC58A}"
    mutation_pattern_A_B_C_D = mapi.assign_mutant(test_A_B_C_D_stru, 
                                                  test_mutation_pattern_A_B_C_D,
                                                  chain_sync_list=[("A", "B"), ("C","D")], 
                                                  chain_index_mapper={"A": 0, "B": 0, "C": 0, "D": 0})
    print(mutation_pattern_A_B_C_D)


=========================================================================================

Author: Xingyu Ouyang <ouyangxingyu913@gmail.com>