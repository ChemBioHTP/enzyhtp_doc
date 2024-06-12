============================================
Identifying Missing Residues
============================================



Briefs
============================================

This is a companion to the `API for adding missing residues, <add_missing_residues.html>`_ and here
we discuss how one specifies the identities and locations of missing ``Residue()``'s. The general goal here is to
create a ``List[SeqRes]`` corresponding to the missing ``Residue()``'s. The ``SeqRes`` is a special, non-physical 
representation of a residue. It details the amino acid identity, chain, model, and index of an arbitrary ``Residue()``, 
as well as whether it is missing or not. Consider the description of the ``SeqRes`` class from ``enzy_htp.chemical.seq_res.py``:
    
    .. code:: python
    
        @dataclass
        class SeqRes:
            """Simple dataclass representing a Sequence Residue or SeqRes. In this description,
            each residue has a chain id, index, name, and may or may not be missing. Since it can
            be missing, it is used to represent the total sequence of a protein, including which
            residues are missing. Note that for sorting, the (chain id, idx) key is used.
            """
            model:int
            chain:str
            idx:int
            name:str
            missing:bool
            seq_idx:int

Generating a ``List[SeqRes]`` for missing ``Residue()'s`` is the name of the game in loop modelling in EnzyHTP.
Along these lines, there are two general cases, consisting of
when the ``Structure()`` is:

    1. derived from a PDB entry.
    2. **NOT** derived from a PDB entry.

The path you take to model missing loops will depend on the origin of your enzyme.

Case 1: PDB-Derived ``Structure()``
=====================================
This is the easy case. A *majority* of PDB entries will contain special ``REMARK`` lines in their text 
which specify which ``Residue()``'s are missing from the structure. EnzyHTP is designed to leverage this 
information, which is accomplished through the ``identify_missing_residues()`` function.

Input/Output
=========================================================================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/identify_missing_residues.svg
        :width: 100%

Input
-----------------------------------------------------------------------------------------


The ``stru``, ``missing_residues``, ``method`` arguments and required inputs

    - ``code``:
        A 4-character ``str`` of the PDB code in question.



Output
-----------------------------------------------------------------------------------------

A ``List[SeqRes]`` corresponding to the missing residues in the ``Structure()``.



Examples
================================================================================



Example Code
-----------------------------------------------------------------------------------------


    .. code:: python

        from enzy_htp.preparation import (
                identify_missing_residues,
        )

        
        missing_residues =  identify_missing_residues("3R3V")

        print(missing_residues)


    The output from the above code is listed below:

    .. code::


        [SeqRes(model=1, chain='A', idx=-1, name='GLY', missing=True, seq_idx=None),
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
        SeqRes(model=1, chain='B', idx=304, name='SER', missing=True, seq_idx=None)]


Case 2: non PDB-Derived ``Structure()``
=========================================
This is the more complicated case. Here, there are missing ``Residue()``'s that do not have a PDB entry
detailing their information. In reality, a PDB entry is not always guaranteed to have ``REMARK`` lines
with missing ``Residue()`` information. For all of these situations, one has to make their own ``SeqRes`` 
objects. A few notes on this:
    
    - Some parameters will not change very much between ``SeqRes`` options. Common settings will be ``model=1``, ``missing=True``, and ``seq_idx=None``.
    - The three-letter amino acid code must always be used for ``name``.
    - enzy_htp will **NOT** check if the ``chain`` and ``idx`` are unique and/or if they make sense for the system.
    - ``SeqRes`` is a dataclass and must have all parameters specified for each run.
    

Example Code
-----------------------------------------------------------------------------------------


    .. code:: python

        from enzy_htp.chemical import (
                SeqRes,
        )

        
        missing_residues = [
            SeqRes(model=1, chain='A', idx=0, name='HIS', missing=True, seq_idx=None),
            SeqRes(model=1, chain='A', idx=1, name='MET', missing=True, seq_idx=None),
            SeqRes(model=1, chain='A', idx=2, name='PRO', missing=True, seq_idx=None)

        ]



Author: Chris Jurich <chris.jurich@vanderbilt.edu>
