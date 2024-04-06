==============================================
 Preparation: Protonate Structure
==============================================

Briefs
==============================================

This science API, named ``enzy_htp.preparation.protonate_stru``,
solves the protein protonation problem that add missing H atoms to the supplied
``enzy_htp.structure.Structure`` class instance (hereafter referred to as ``Structure`` instance).
Protonation states are determined for residues with multiple ones.

.. dropdown:: :fa:`eye,mr-1` Click to learn more about protein protonation

    Approximately 88% of the structures in the protein data bank (PDB) are determined 
    by X-ray crystallography, which can not, in general, resolve positions of most hydrogen
    atoms. The same problem appear in structures obtained from structure prediction tools
    too, AlphaFold2 also cannot give accurate position for hydrogens. (https://github.com/deepmind/alphafold/issues/598)

    Thus accuately determine protonation state is a vital part of structural preparation 
    in EnzyHTP to ensure the accuracy of the modeling result.

    In short, the challenge is to predicting the protonation states of titratable groups such
    as the side chains of ASP, GLU, ARG, LYS, TYR, HIS, CYS, and ligands.

Input/Output
==============================================

**input**: A ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

.. admonition:: How to obtain

    A ``Structure`` instance can be obtained by these `APIs <obtaining_stru.html>`_.

    Note: Structure(s) with missing loops are not acceptable.

**output**: A ``Structure`` instance of protonated structure (in-place modification, not as return value).

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/preparation_protonate_stru_dfd.svg
        :width: 100%
        :alt: preparation_remove_solvent

Arguments
==============================================

``stru``
    The input ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

    (See `Input/Output <#input-output>`_ section)


``ph``
    The pH value for determining the protonation state.
    (Float, optional, default ``7.0``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``ph``

        The choice of pH value depends on the physiological environment of the protein you are simulating.

        For example, if you are simulating a protein in human blood, then the pH value is best set in the range [7.35, 7.45].

``protonate_ligand``
    If also protonate ligand, i.e., add hydrogen atoms to ligand compounds.

    Set this parameter to ``False`` if you only want to add hydrogen atoms to the polypeptide and not to the ligand (small molecules).
    
    (Boolean, optional, default ``True``)

``engine``
    Engine for determining the pKa and adding hydrogens to the protein peptide part.

    (String, optional, default ``pdb2pqr``) 
    
    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``engine``

        The ``engine`` option determines which third-party tool you use to add hydrogen atoms to your protein (polypeptide).

        Currently only ``pdb2pqr`` is available. More ``engine`` options will be available in future versions.

``ligand_engine``
    Engine for adding hydrogens to ligands (current available values: ``pybel``)

    (String, optional, default ``pybel``)
    
    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``ligand_engine``

        The ``ligand_engine`` option determines which third-party tool you use to add hydrogen atoms to your ligand.

        Currently only ``pybel`` is available. More ``ligand_engine`` options will be available in future versions.

.. ``**kwarg``
..     Setting(s)/Option(s) related to specific engine.

..     (optional, default ``None``)

..     .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``**kwarg``

..         Valid ``kwarg`` argument key-value pairs depend on your choice of ``engine`` and ``ligand_engine``, 
..         and these ``kwarg`` parameters are passed inside the methods that call ``engine`` and ``ligand_engine``, 
..         and what the specific role ``kwarg`` arguments play also depends on the internal behavior of the methods.

``int_pdb_path`` (Works when ``engine="pdb2pqr"``.)
    
    Path for intermediate pdb file.

    (String, optional, default ``None``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``int_pdb_path``

        You can set it to a file path or leave it blank. 

        If you leave it blank or ``None``, a temporary folder will be employed to store intermediate files.

``int_pqr_path`` (Works when ``engine="pdb2pqr"``.)
    
    Path for intermediate pqr file (not this will be changed to pdb extension)

    (String, optional, default ``None``)

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``int_pqr_path``

        You can set it to a file path or leave it blank. 

        If you leave it blank or ``None``, a temporary folder will be employed to store intermediate files.

``metal_fix_method`` (Works when ``engine="pdb2pqr"``.)
    
    Method for determining the protonation state of donor residues

    (String, optional, default ``deprotonate_all``)

    Current available keywords:

    - ``deprotonate_all``: Deprotonate all donor residues of the metal center on the donor atom

    .. dropdown:: :fa:`eye,mr-1` Click to learn more about ``metal_fix_method``

        Currently there is only one available value for this parameter, 
        so you don't need to set it in the current version. (2024-03-31)

Examples
==============================================

Prepare the Input: Load Structure
----------------------------------------------

In order to make use of the API, we should have structure loaded.

.. code:: python    

    import enzy_htp.structure as struct
                                
    sp = struct.PDBParser()

    pdb_filepath = "/path/to/your/structure.pdb"
    stru = sp.get_structure(pdb_filepath)

Execute API
----------------------------------------------

Use ``preparation.protonate_stru`` to protonate (i.e. add hydrogen atoms to) your structure.

The simpliest use of ``protonate_stru`` is as follows.
    Where the ``ph`` is set to ``7.0``, and ``protonate_ligand`` is set to ``True`` by default.

.. code:: python
    
    from enzy_htp.preparation import protonate_stru

    protonate_stru(stru=stru)

We can also customize the arguments passed to this function.
    How much is your pH value? Customize ``ph``.  

    Do you want to protonate your ligands? Customize ``protonate_ligand``.

.. code:: python
    
    protonate.protonate_stru(stru=stru, ph=6.5, protonate_ligand=False)

.. note::

    This API modifies the ``Structure`` instance (what we passed as argument ``stru``) itself and does not return any value, i.e. return ``None``.
    
    Thus, if you write ``stru = protonate.protonate_stru(stru=stru)``, your ``stru`` will very unfortunately be assigned the value ``None``, so Please Don't Do This!

Check the Output
----------------------------------------------

Let's try executing the API here and check if there's any changes taking place.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    We choose the structure of a complex containing SARS-Cov-2 Main Protease 
    and Nirmatrelvir for example, whose solvent has been removed manually.

    Set ``ph=7.4`` (which is the pH value of human blood) and ``protonate_ligand=True`` (to protonate Nirmatrelvir).

    Now, we can go through the procedure.

    .. code:: python
        
        import enzy_htp.structure as struct
        from enzy_htp.preparation import protonate
                                    
        sp = struct.PDBParser()

        pdb_filepath = "7si9_rm_water.pdb"  # The structure of a complex containing SARS-Cov-2 Main Protease and Nirmatrelvir.
        stru = sp.get_structure(pdb_filepath)

        print(stru.num_atoms)   # 2402.
        protonate.protonate_stru(stru=stru, ph=7.4, protonate_ligand=True)
        print(stru.num_atoms)   # 4751.
    
We may notice that, after executing the API, the number of atoms (``num_atoms``) in the structure increased,
representing that the hydrogen atoms have been added to the structure.

Author: Zhong, Yinjie <yinjie.zhong@vanderbilt.edu>