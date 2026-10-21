============================================
Adding Missing Residues
============================================



Briefs
============================================

Proteins are often missing residues from flexible loop regions. This is a problem for various types
of calculations including molecular dynamics (MD) and quantum mechanics (QM) simulations. This function
aids in HTP workflow design by adding missing ``Residue()`` objects into a ``Structure()``. Missing residues
can be defined by the user or by pulling from the Protein DataBank (PDB) when possible.

.. note:: 
    
    **Using this functionality requires Rosetta to be installed.**
    See :doc:`/install` for details

.. note::

    Science API is a special concept in EnzyHTP. They stands for those top-layer APIs
    the are supposed to be used in assembling the `workflow <https://enzyhtp-doc.readthedocs.io/en/latest/sci_api_tutorial/how_to_assemble.html#find-the-science-api-that-directly-gives-what-you-need>`_.

.. warning::
    
    Some loop refinement methods are known to slightly move sidechain positions. It may be necessary to minimize a ``Structure`` after filling in missing loops.
    Rosetta will attempt to optimize the inserted residues, but this optimization may not be optimal for your use case.

**You will find a detailed tutorial of how to use this Science API.**

Input/Output
=========================================================================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/add_missing_residues.svg
        :width: 100%
        :alt: dipole_bond

Input
-----------------------------------------------------------------------------------------


The ``stru``, ``missing_residues``, ``method`` arguments and required inputs

    - ``stru``:
        A ``Structure()`` object that is missing residues. 

        .. admonition:: Getting a ``Structure``

            | A ``Structure()`` object can be obtained using these `APIs <obtaining_stru.html>`_


    - ``missing_residues``:
        A ``List[SeqRes]`` objects which describe the chain/index location and identity of each missing residue.

        .. admonition:: Getting the missing residues

            | A ``List[SeqRes]`` objects can be created by giving the four letter PDB code of a structure using the ``identify_missing_residues()`` function from the ``preparation`` module. (See tutorial `here <identify_missing_residue.html>`_)

    - ``method``:
        A ``str`` specifying the method to use for filling missing residues.

        .. admonition:: Current method options

            | At present, only ``rosetta`` is supported.

    - ``work_dir``:
        Working directory containing all the files in the calculation process. Optional argument.

    - ``inplace``:
        Should the missing residues be added to the supplied ``Structure`` or to a new, copied one. Optional argument, ``True`` by default.



Output
-----------------------------------------------------------------------------------------

A ``Union[None, Structure]`` that is either nothing or a copied ``Structure`` with the added missing residues.



Examples
================================================================================



Example Code
-----------------------------------------------------------------------------------------


    .. code:: python

        from enzy_htp import PDBParser
        from enzy_htp.preparation import (
                identify_missing_residues,
                add_missing_residues)

        sp = PDBParser()

        stru = sp.get_structure("./3r3v_.pdb")
        
        print(stru)

        missing = identify_missing_residues("3R3V")

        
        fill_missing_residues(stru, missing, method="rosetta")

        print(stru)

    The output from the above code is listed below:

    .. code::


        <Structure object at 0x7f8576baa370>
        Structure(
        chains: (sorted, original ['A', 'B'])
            A(polypeptide): residue: 4-254,256-300 atom_count: 2339
            B(polypeptide): residue: 4-252,259-300 atom_count: 2310
        )
        
        <Structure object at 0x7f8576baa370>
        Structure(
        chains: (sorted, original ['A', 'B'])
            A(polypeptide): residue: -1-304 atom_count: 2408
            B(polypeptide): residue: -1-304 atom_count: 2408
        )


    Instead of using ``identify_missing_residues()``, the missing residue list can also be built manually:

    .. code:: python

        from enzy_htp.chemical import SeqRes
        
        missing = [
                SeqRes(model=1, chain='A', idx=-1, name='GLY', missing=True, seq_idx=None),
                SeqRes(model=1, chain='A', idx=0, name='HIS', missing=True, seq_idx=None),
                SeqRes(model=1, chain='A', idx=1, name='MET', missing=True, seq_idx=None),
                SeqRes(model=1, chain='A', idx=2, name='PRO', missing=True, seq_idx=None),
                SeqRes(model=1, chain='A', idx=3, name='ASP', missing=True, seq_idx=None),
                SeqRes(model=1, chain='A', idx=255, name='GLN', missing=True, seq_idx=None),
                SeqRes(model=1, chain='A', idx=301, name='ALA', missing=True, seq_idx=None),
                SeqRes(model=1, chain='A', idx=302, name='PRO', missing=True, seq_idx=None),
                SeqRes(model=1, chain='A', idx=303, name='GLY', missing=True, seq_idx=None),
                SeqRes(model=1, chain='A', idx=304, name='SER', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=-1, name='GLY', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=0, name='HIS', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=1, name='MET', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=2, name='PRO', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=3, name='ASP', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=253, name='ILE', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=254, name='ALA', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=255, name='GLN', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=256, name='SER', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=257, name='ALA', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=258, name='ALA', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=301, name='ALA', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=302, name='PRO', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=303, name='GLY', missing=True, seq_idx=None),
                SeqRes(model=1, chain='B', idx=304, name='SER', missing=True, seq_idx=None),
        ]


Author: Chris Jurich <chris.jurich@vanderbilt.edu>
