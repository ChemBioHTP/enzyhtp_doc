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
        A Structure() object which represents the structure of the target enzyme. MUST have charges assigned for ligands. (See examples).
        
        .. admonition:: How to obtain
            
            | A protein strutcuture object can be obtained by this `APIs <structure_class.html>`_.
            | Normally, the EF is calculated based on structures sampled from MD or other sampling methods.

    - ``p1``, ``p2`` and ``d1``:
        | Specify where is the field strength is calculated.
        | (p1,p2) - by 2 points (default: the center of them) and calculate along p1 -> p2
        | (p1,d1) - by 1 point and along direction d1
        | 
        | p1 and p2 can be Atom() objects or Cartesian coordinates. 
        | For example, a cartesian coordinates can be the center of an aromatic ring.

        .. admonition:: How to obtain
            
            | `Atom()` objects can be obtained by these `APIs <structure_class.html>`_.
            | Cartesian coordinate can be defined as a tuple (e.g.: (1.0, 2.0, 3.0) )

    ``region_pattern``:
        The specified region within the structure serves as the origin of field charges.

        .. admonition:: How to obtain
            
            | The region_pattern uses the StructureSelection syntax defined `here <structure_selection.html>`_. 
            | Normally people exclude the solvent and substrate, which the target bond is in, from the selection region.


Output
-----------------------------------------------------------------------------------------
**Output**: A specified field strength in default unit kcal/(mol*e*Ang). The direction is from ``p1`` to ``p2`` or along the ``d1`` direction

Arguments
=========================================================================================

``stru``:
    The target enzyme's structure must be initialized with charges. (See Input/Output)

``p1``, ``p2`` and ``d1``:
    To calculate the electric field within an enzyme, input a location and either a direction (d1) or two points (p1, p2), ensuring enzyme charges are included; d1 defines the field strength projection direction.
    (See Input/Output)

``location``:
    | The location of the measurement when 2 points are specified.
    | Supported keywords: [center, p1, p2] (default: center)

    .. admonition:: Reference

        REF: EnzyHTP: A High-Throughput Computational Platform for Enzyme Modeling (https://pubs.acs.org/doi/full/10.1021/acs.jcim.1c01424)

``region_pattern``:
    The specified region within the structure serves as the origin of field charges, utilizing PyMOL selection syntax. Users should exclude the solvent or substrate from the selection region if they intend to measure a bond within the same molecule. The instruction can be founded as `APIs <structure_selection.html>`_.

``unit``:
    | The unit of the result.
    | Supported keywords: [kcal/(mol*e*Ang), MV/cm] (default: kcal/(mol*e*Ang))

Example code
=========================================================================================

In this example, we will use the script to calculate the electric field
between the breaking C-H of the substrate in a KE07 variant.

.. admonition:: How input is prepared

    ``stru``
        obtained by reading from a :download:`PDB file <../downloadable/KE.pdb>` using ``PDBParser().get_structure()``
        Note that we also assigned the charge and spin using ``.assign_ncaa_chargespin()`` method.
        (See `Details <#input-output>`_)
    
    ``p1, p2``
        They are obtained by the ``.get()`` method from Structure

    ``region_pattern``
        we excluded the reacting residue (A.101) and the substrate (B.254)
        
.. code:: python
    
    import os
    import numpy as np
    from enzy_htp.analysis import ele_field_strength_at_along
    from enzy_htp import PDBParser

    # Initialize PDB parser
    sp = PDBParser()

    # Load structure from PDB file
    stru_obj = sp.get_structure("KE.pdb")

    # Assign charges to the structure
    stru_obj.assign_ncaa_chargespin({"H5J" : (0,1)})

    # Define the target bond as p1, p2
    p1 = test_stru.get("B.254.CAE")
    p2 = test_stru.get("B.254.H2")

    # Calculate electric field strength along the bond
    result = ele_field_strength_at_along(stru_obj, p1, p2, region_pattern="chain A and (not resi 101)",)

    print("Electric field strength:", result)

=========================================================================================

Author: Xinchun Ran <xinchun.ran@vanderbilt.edu>

