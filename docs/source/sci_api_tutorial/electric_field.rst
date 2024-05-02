==============================================
Electric Field
==============================================


Briefs
=========================================================================================

The `electric_field_strength_at_along` function calculates the electric field strength at a specified point between two atoms based on their coordinates and charge, optionally considering a specified direction, and supports different units for the result.


Input/Output
=========================================================================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/ele_field_api.svg
        :width: 100%
        :alt: Electric Field

Input
-----------------------------------------------------------------------------------------

**Params**: The ``stru``, ``p1``, ``p2``, ``d1``, and ``region_pattern``  are required input

    - ``stru``:
        Structure which represent the structure of the target enzyme need to obtain from . MUST have charges initialized.
        
        .. admonition:: How to obtain
            
            | A protein strutcuture object can be obtained by this `APIs <structure_class.html>`_.

    - ``p1``, ``p2`` and ``d1``:
        Specify either the reference point or the direction for measuring the electric field, using combinations like (p1, p2) or (p1, d1), where p1 and p2 denote Atom() or Cartesian points. The direction goes from p1 to p2. Either p1 with d1 or p2 with d1 must be provided. Both p1 and p2 are Cartesian coordinates. For example, select a carbon coordinate from an aromatic ring and set p2 as the ring's center of mass. d1 defines the direction of the field strength projection.

        .. admonition:: How to obtain
            
            | A p1 and p2 might be `Atom()` object which can be obtained by these `APIs <structure_class.html>`_. The p1 and p2 can be specified either through Atom() objects or keyword str of Structure().get() combining with a Structure() (e.g.: A.100.CA)

Output
-----------------------------------------------------------------------------------------
**Output**: A specified field strength in default unit kcal/(mol*e*Ang). The direction is from ``p1`` to ``p2`` or along the ``d1`` direction

Argument code
=========================================================================================

``stru``:
    The target enzyme's structure must be initialized with charges.

``p1``, ``p2`` and ``d1``:
    To calculate the electric field within an enzyme, input a location and either a direction (d1) or two points (p1, p2), ensuring enzyme charges are included; d1 defines the field strength projection direction.

``location``:
     the location of the measurement when 2 points are specified. When it is (p1, d1), the p1 will be the position supported keywords: [center, p1, p2]

    .. admonition:: Where to look

        REF: EnzyHTP: A High-Throughput Computational Platform for Enzyme Modeling (https://pubs.acs.org/doi/full/10.1021/acs.jcim.1c01424)

``region_pattern``:
    The specified region within the structure serves as the origin of field charges, utilizing PyMOL selection syntax. Users should exclude the solvent or substrate from the selection region if they intend to measure a bond within the same molecule. The instruction can be founded as `APIs <structure_selection.html>`_.

``unit``:
    The unit of the result (default: kcal/(mol*e*Ang))


Example code
=========================================================================================

We will use the script to calculate the electric field between the atoms ``CAE``, ``H2`` with KE 07 mutant(101, 254)
        


**Let's put them together as a python script.**
        
    .. code:: python
        
        import os
        import numpy as np
        from enzy_htp.analysis import ele_field_strength_at_along
        from enzy_htp import PDBParser

        # Initialize PDB parser
        sp = PDBParser()

        # Load structure from PDB file
        stru_obj = sp.get_structure(f"{DATA_DIR}KE_mutant_101_254_frame_0.pdb")

        # Assign charges to the structure
        stru_obj.assign_ncaa_chargespin({"H5J" : (0,1)})

        # Define EF calcuation region as p1, p2
        target_bond = (test_stru.ligands[0].find_atom_name("CAE"),test_stru.ligands[0].find_atom_name("H2"))

        # Calculate electric field strength at the specified location along the bond
        result = ele_field_strength_at_along(stru_obj, *target_bond, region_pattern="chain A and (not resi 101)",)

        print("Electric field strength:", result)

Done!
=========================================================================================

Author: Xinchun Ran <xinchun.ran@vanderbilt.edu>

