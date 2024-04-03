==============================================
PDBParser
==============================================

Briefs
==============================================
``PDBParser`` facilitates the conversion between PDB files and ``Structure`` objects. It primarily offers two functions: ``get_structure()`` for converting a PDB file into a ``Structure`` object, and ``save_structure()`` for performing the inverse operation.

Input/Output
==============================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/PDBParser_io.svg
        :width: 100%
        :alt: PDBParser_io

PDBParser.get_structure()
==============================================

Input
------------------------------------------------

``path``
    Specifies the file path of the PDB file.

    .. admonition:: How to obtain

        PDB files can be downloaded from the `Protein Data Bank <https://www.rcsb.org/>`_ or acquired from experimental results.

Output
------------------------------------------------

``Structure()``
    Returns the constructed ``Structure`` object.

Arguments
------------------------------------------------

``path``
    Path to the PDB file.
    (See `PDBParser.get_structure() <#pdbparser-get-structure>`_ section)

``model``
    | Index of the model to select if the file contains multiple models.
    | Determine if there are multiple models by looking for "MODEL {number}" and "ENDMDL" tags in the PDB file, or by using protein visualization tools such as `PyMOL <https://pymol.org>`_ or `UCSF Chimera <https://www.cgl.ucsf.edu/chimera/>`_.

``add_solvent_list``
    | List of additional solvent names. If solvents other than water are present, include them here.
    | For example, ``add_solvent_list=["DMS", "ACT"]``
    | Solvents are recognized by names in these lists within non-polypeptide chains:
    | ``chem.RD_SOLVENT_LIST + add_solvent_list``
    | ``RD_SOLVENT_LIST`` includes common water aliases such as HOH and WAT. (``RD_SOLVENT_LIST: List[str] = ["HOH", "WAT"]``)

``add_ligand_list``
    | List of additional ligand names, used to retain specific ligands within the protein structure.
    | For example, ``add_ligand_list=["FAD", "NAD"]``
    | Ligands are identified by their absence from these lists within non-polypeptide chains:

        | 1. ``chem.RD_SOLVENT_LIST + add_solvent_list``
        | - ``RD_SOLVENT_LIST`` includes common water aliases such as HOH and WAT. (``RD_SOLVENT_LIST: List[str] = ["HOH", "WAT"]``)
        | 2. ``chem.RD_NON_LIGAND_LIST - add_ligand_list``
        | - ``RD_NON_LIGAND_LIST`` includes common co-crystallized ligands found in solvents, including CL (CHLORIDE ION), EDO (1,2-ETHANEDIOL), GOL (GLYCEROL), and EOH (ETHANOL). (``"RD_NON_LIGAND_LIST: List[str] = ["CL", "EDO", "GOL", "EOH"]"``)
        | *Solvent list have higher pirority*

``remove_trash``
    | Option to remove unwanted ligands, defined by ``RD_NON_LIGAND_LIST``, can be set to either ``remove_trash=True`` or  ``remove_trash=False``, default value is ``True``.

``give_idx_map``
    | Option to return a tuple of ``(Structure, idx_change_mapper)``, can be set to either ``give_idx_map=True`` or  ``give_idx_map=False``, default value is ``Flase``.
    | The mapping is a dictionary: ``{(old_chain_id, old_residue_id): (new_chain_id, new_residue_id), ... }``
    
``allow_multichain_in_atom`` 
    | Used for resolving chain id,  can be set to either ``allow_multichain_in_atom=True`` or  ``allow_multichain_in_atom=False``, default value is ``Flase``.
    | When set to ``True``, it allows multiple chain IDs to appear within the same chain that consists of ATOM records. Although this conflicts with the standard PDB file format definition, it is useful for resolving chain IDs of multi-chain PDB files exported by PyMOL2.
    

PDBParser.save_structure()
==============================================


Input
------------------------------------------------

``outfile``
    Path for saving the ``Structure()`` object as a string.

    .. admonition:: How to obtain

        Define the save path as a string, e.g., ``outfile='./save_pro.pdb'``.

``stru``
    The ``Structure()`` object to be saved.

    .. admonition:: How to obtain

        (See `PDBParser.get_structure() <#pdbparser-get-structure>`_ section)


Output
------------------------------------------------

``str()``
    Path where the ``Structure()`` was saved, returned as a string.

Arguments
------------------------------------------------

``outfile``
    Path for saving the ``Structure()`` object as a string.
    (See `PDBParser.save_structure() <#pdbparser-save-structure>`_ section)

``stru``
    The ``Structure()`` object to be saved.
    (See `PDBParser.save_structure() <#pdbparser-save-structure>`_ section)

``if_renumber``
    Determines whether to renumber atoms starting from 1, can be set to either ``if_renumber=True`` or ``if_renumber=False``, default value is ``True``.

``if_fix_atomname``
    Determines whether atom names should be adjusted to conform to PDB conventions, can be set to either ``if_fix_atomname=True`` or ``if_fix_atomname=False``. The default value is True, which ensures that atom names are automatically converted to the standard PDB format.

    
Example Code
==============================================

Generation a ``Structure`` objects from a simple PDB file
---------------------------------------------------------

In this example, we use ``PDBParser`` to process a single-chain, single-model PDB file containing a protein with ligands (a substrate named C4C and a cofactor named HEM) and solvent molecules. We aim to import the PDB file as a ``Structure`` object and export it as a new PDB file.

.. admonition:: How input is prepared
    
    For ``PDBParser.get_structure()``, need to prepare: 

    ``path``
        The file path of the PDB file. In this example, the PDB file was downloaded from the Protein Data Bank with the ID "2V7M" and is named ``"./2v7m.pdb"``. 
        (See `PDBParser.get_structure() <#pdbparser-get-structure>`_ section)

    ``add_solvent_list``
        According to the PDB file, the phosphate ion (named "PO4" in the PDB file) needs to be regarded as a solvent.

    ``add_ligand_list``
        According to the PDB file, there are substrate and cofactor molecules (named "HEM" and "C4C" in the PDB file) that need to be defined as ligands.

    For ``PDBParser.save_structure()``, need to prepare:
        
    ``outfile``
        The path to save the ``Structure`` object as a string. In this example, we save the structure as ``"./2v7m_new.pdb"``

    ``stru``
        The ``Structure()`` object obtained from ``PDBParser.get_structure()``
        (See `PDBParser.get_structure() <#pdbparser-get-structure>`_ section)
		

.. code:: python

    from enzy_htp.structure import PDBParser
    
    test_A="./2v7m.pdb"
    test_A_struc = PDBParser.get_structure(path=test_A, 
                                           add_solvent_list=["PO4"], 
                                           add_ligand_list=["HEM","C4C"])
    test_A_saved_path = PDBParser.save_structure(outfile="./2v7m_new.pdb",
                                                 stru=test_A_struc)
    print(test_A_saved_path)
    #./2v7m_new.pdb


=========================================================================================

Author: Xingyu Ouyang <ouyangxingyu913@gmail.com>
