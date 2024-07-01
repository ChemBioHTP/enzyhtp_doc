==============================================
Structure
==============================================

Briefs
==============================================
This class define the core data structure of EnzyHTP: Structure. Structure stands for the single enzyme structure.
As the core data class, Structure will be solely designed for **storing, accessing and editing** structural data.

Input/Output
==============================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/Structure_io.svg
        :width: 100%
        :alt: assign_mutant_io 

.. dropdown:: :fa:`eye,mr-1` Click to see *conceptual discussions* 

    - Composition
    
    For the data point of view, the enzyme structure is composed by two parts of data:
    
    - topology (composition of atoms and their connectivity)
    
      there are 2 common ways to store connectivity:
    
        + the chain, residue division of atoms (inter-residue connectivity)
    
          & the canonical residue name and atom names in it (intra-residue connectivity)
    
          & the connectivity table for non-canonical parts
    
        + the connectivity table for the whole enzyme
    
    - coordinate (atomic coordinate upon topology)
    
    Base on this concept, Structure object holds a list of composing Chain objects which also contain Residue objects and so that Atom objects. In each Atom     object, atom name and coordinate is stored. Every level (chain, residue, atom/coordinate/connectivity) of information can all be pulled out from the Structure     object with getter methods and can be set with setter methods. Also Structure() supports common editing methods such as add/remove children objects.
    
    
    - Application
    
    Application of Structure objects - Binding modules:
    
    Generation:
    
        Note that Structure() objects SHOULD NOT be created by the user directly and instead created through different generation methods from the binding     StructureIO classes (e.g.: ``enzy_htp.structure_io.PDBParser().get_structure()``) from different file types and different external data structures.
    
    Selection:
    
        Selection of Structural regions are handled by the Selection module.
    
    Operation:
    
        Changes of the Structure data are handled by functions in the operation module. These commonly used operations of Structure will than be used in     scientific APIs: Preparation, Mutation, Geom Variation. And structure based descriptors are derived by functions in the Energy Engine module.
    
    - Details
    
        Sturcture() is designed for direct interfacing by users.
    
        Composed of child Chain() objects and their subsequent child Residue() objects and so on Atom() objects.
    
        Note: This class SHOULD NOT be created directly by users. It should be created with methods from the StructureIO module.
    
        Note: regardless of index assigned to residues and atoms, there is an intrinsic indexing system based on the order of _children lists. This intrinsicc index can be compared with pymol's index (not id)

Highlighted Methods 
==============================================

``get`` Method
---------------------------------------------------------
The ``get`` method is designed to retrieve specific components—either a Chain, a Residue, or an Atom—from a biological structure based on a given key. The key must follow a specific format, and the method performs differently based on the level of detail in the key.

Input
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``key``
    A string that specifies the chain, residue, and atom in a biological structure using the format ``<chain_name>.<residue_index>.<atom_name>``. The levels of detail can vary:


    .. admonition:: How to obtain

        - Chain Only: Input just the chain name (e.g., ``A``).
        
        - Residue: Input the chain name and residue index (e.g., ``A.1``).
        
        - Atom: Input the chain name, residue index, and atom name (e.g., ``A.1.CA``).

Output
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The function returns an object of type Chain, Residue, or Atom depending on the input key's specificity. If the input key does not conform to the expected format or if the specified item does not exist within the structure, the function raises a ValueError.

Example Usage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Here's how you might use the get method in your Python code:

.. code:: python

    chain = structure.get("A")
    residue = structure.get("A.1")
    atom = structure.get("A.1.CA")

Example Code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In this example, we load a protein from PDB file and perform ``Structrure()`` on this protein. 

.. admonition:: How input is prepared

    ``8k68.pdb``
        Download example protein from `Protein Data Bank <https://www.rcsb.org/>`_, and load it via `PDBParser <../sci_api_tutorial/PDBParser.html>`_

.. code:: python
    
    import enzy_htp
    #Loading a structure from PDB
    structure : enzy_htp.Structure = enzy_htp.PDBParser().get_structure("./8k68.pdb")

    #Highlighted Methods '.get'
    structure.get()
    #TypeError: get() missing 1 required positional argument: 'key'
    structure.get('A')
    #<enzy_htp.structure.chain.Chain object at 0x2ad5c219a9d0>
    structure.get('A.1')
    #Residue(1, SER, atom:6, Chain(A, residue: 1-45,51-301))
    structure.get('A.1.CA')
    #<Atom(CA, 2, (32.589, -23.487, -14.414), Residue(1, SER, atom:6, Chain(A, residue: 1-45,51-301)), 25.32, C, None ) at 0x2ad5c2171b80>
    structure.get('B.401')
    #Solvent(401, HOH, atom:1, Chain(B, residue: 401-658))

    #Surveying basic information
    structure.num_chains
    #2
    structure.sequence
    #{'A': 'SGFRKMAFPSGKVEGCMVQVTCGTTTLNGLWLDDVVYCPRHVICTNPNYEDLLIRKSNHNFLVQAGNVQLRVIGHSMQNCVLKLKVDTANPKTPKYKFVRIQPGQTFSVLACYNGSPSGVYQCAMRPNFTIKGSFLNGSCGSVGFNIDYDCVSFCYMHHMELPTGVHAGTDLEGNFYGPFVDRQTAQAAGTDTTITVNVLAWLYAAVINGDRWFLNRFTTTLNDFNLVAMKYNYEPLTQDHVDILGPLSAQTGIAVLDMCASLKELLQNGMNGRTILGSALLEDEFTPFDVVRQCS', 'B': 'HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH  HOH'}
    structure.num_residues
    #554
    
    #Interfacing with Chain()
    structure.chains
    #[<enzy_htp.structure.chain.Chain object at 0x2b82b42e2880>, <enzy_htp.structure.chain.Chain object at 0x2b82b42e2970>]
    structure.chain_names
    #['A', 'B']
    chain_cpy : enzy_htp.Chain = structure.get_chain( "B" )
    
    #Interfacing with Residue()
    structure.num_residues
    #554


``assign_ncaa_chargespin`` Method
---------------------------------------------------------
The ``assign_ncaa_chargespin`` method is designed to assign net charges and spin states to non-canonical amino acids (NCAAs) in    ``Structure()``. It specifically targets residues identified as NCAAs, ligands, or modified amino acids, based on their three-letter codes or general categories.

Input
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``net_charge_mapper``
    A dictionary where keys are the three-letter codes of NCAAs (or categories like "LIGAND" or "MODAA" for all of that kind), and values are tuples containing the net charge and multiplicity (spin state, the 2S+1 number for multiplicity) for these residues. The format is ``{"RES" : (charge, spin), ...}``.

    .. admonition:: How to construct
    
        - Specific NCAA: Use the three-letter code (e.g., `HEM`) with its charge and spin.
        
        - General Category: Use identifiers like `LIGAND` or `MODAA` to apply properties uniformly to all residues within these categories.

Output
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The function does not return a value but modifies the properties of the residues within the structure directly. If a specified NCAA does not exist or if the residue type is not appropriate for the charge and spin assignment, an error is raised.

Example Usage
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Here's how you might use the assign_ncaa_chargespin method in your Python code:

.. code:: python

    net_charge_mapper = {
        'MOL': (0, 1),  # Substrate molecule with a charge of 0 and a singlet spin state
        'LIGAND': (1, 1),  # All ligands with a charge of +1 and a singlet spin state
        'MODAA': (-1, 2)  # All modified amino acids with a charge of -1 and a doublet spin state
    }
    structure.assign_ncaa_chargespin(net_charge_mapper)

Example Code
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In this example, we load a protein from PDB file and perform ``Structrure()`` and ``assign_ncaa_chargespin`` on this protein. 

.. admonition:: How input is prepared

    ``4bf4.pdb``
        Download example protein from `Protein Data Bank <https://www.rcsb.org/>`_, and load it via `PDBParser <../sci_api_tutorial/PDBParser.html>`_

.. code:: python

    import enzy_htp
    #Loading a structure from PDB
    structure : enzy_htp.Structure = enzy_htp.PDBParser().get_structure("./4bf4.pdb")
    
    net_charge_mapper = {
        'HEM': (0, 1),  # Assuming HEM is neutral overall with iron in +2 state, spin state as singlet
        '17Q': (0, 1),  # Neutral organic compound
        'SO4': (-2, 1)  # Sulfate ion with a charge of -2 and a singlet state
    }
    
    structure.assign_ncaa_chargespin(net_charge_mapper)

========================================================================================

Author: Xingyu Ouyang <ouyangxingyu913@gmail.com>