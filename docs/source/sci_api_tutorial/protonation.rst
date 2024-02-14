==============================================
 Preparation: Protonate Structure
==============================================

Briefs
==============================================

This science API, named ``enzy_htp.preparation.protonate.protonate_stru``,
solves the protein protonation problem that add missing H atoms to the
``enzy_htp.structure.Structure`` class instance (here in after called ``Structure`` instance).
Protonation states are determined for residues with multiple ones.

Input/Output
==============================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    ``input``: A ``Structure`` instance (no matter it's a protein, polypeptite, or ligand).

    ``output``: A ``Structure`` instance of protonated structure (in-place modification, not as return value).

Arguments
==============================================
.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    ``stru``: the input structure

    ``ph``: the pH value for determining the protonation state
    
    ``protonate_ligand``: if also protonate ligand
    
    ``engine``: engine for determining the pKa and adding hydrogens to the protein peptide part (current available values: ``pdb2pqr``)
    
    ``ligand_engine``: engine for adding hydrogens to ligands (current available values: ``pybel``)
    
    ``**kwarg``: setting/option related to specific engine.

Examples
==============================================

Load Structure
----------------------------------------------

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    In order to make use of the ``protonation`` module, we should have structure loaded.

    .. code:: python    

        import enzy_htp.structure as struct
        from enzy_htp.preparation import protonate
                                    
        sp = struct.PDBParser()

        pdb_filepath = "/path/to/your/structure.pdb"
        stru = sp.get_structure(pdb_filepath)

Execute API
----------------------------------------------

To use ``preparation.protonate.protonate_stru`` to protonate (i.e. add hydrogen atoms to) your structure.

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    The simpliest use of ``protonation`` is as follows.
        Where the ``ph`` is set to ``7.0``, and ``protonate_ligand`` is set to ``True`` by default.

    .. code:: python
        
        protonate.protonate_stru(stru=stru)

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    We can also customize the arguments passed to this function.
      How much is your pH value? Customize ``ph``.  
      
      Do you want to protonate your ligands? Customize ``protonate_ligand``.

    .. code:: python
        
        protonate.protonate_stru(stru=stru, ph=6.5, protonate_ligand=False)

.. note::

    This API modifies the ``Structure`` instance (what we passed as argument ``stru``) itself and does not return any value, i.e. return ``None``.
    
    Thus, if you write ``stru = protonate.protonate_stru(stru=stru)``, your ``stru`` will very unfortunately be assigned the value ``None``.

Check Output
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
