==============================================
 QM Single Point
==============================================

Briefs
==============================================
The QM single point energy calculation. This function calculates the molecular orbitals (MOs)
as well as their energy for a molecule **in a specific geometry**. (i.e.: a single point
on the potential energy surface) If an ensemble of geometry is give, the calculation is applied 
to each snapshot in this ensemble.

Input/Output
==============================================

.. panels::

    :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-left

    .. image:: ../../figures/single_point_api_io.svg
        :width: 100%
        :alt: single_point_api_io                  

    |

    .. note::
        
        Data representation format in the diagram -- (data_name : data_type)

Input
------------------------------------------------

``stru`` or ``stru_esm``
    the target molecule of the calculation as a Structure() object.

    .. admonition:: How to obtain

        | A Strutcure() object can be obtained by these `APIs <obtaining_stru.html>`_.

    OR

    the target molecules of the calculation as a StructureEnsemble() object.

    .. admonition:: How to obtain

        | A StructureEnsemble() object can be obtained by these `APIs <obtaining_stru_esm.html>`_.
        | Commonly by a sampling of conformations of the structure.

``engine``
    the name of the QM engine you want to use.
    
    .. admonition:: How to obtain

        | Choose from supported QM engine: ["gaussian", ]

``method``
    the level of theory of this calculation as a LevelOfTheory().
    This is used when there is only 1 region specified.
    
    .. admonition:: How to obtain

        | In EnzyHTP, you can use QMLevelOfTheory() to define a method. See `examples <#example-code>`_ for detail.
        | The level of theory defines the method used to solve the Schrodinger equation and
          basis function set that used for the description of the MOs. An inappropriate selection
          of level of theory may leads to completely wrong result. The selection of the level
          of theory for different tasks is widely discussed/benchmarked in papers and the internet. Search
          for benchmark papers or selections of systems close to your need. Here are several good
          summary (in Chinese): http://sobereva.com/336, http://sobereva.com/272.
        

``regions``
    This option allows you to define different region, apply different
    level of theory to each region, and perform multiscale modeling.
    e.g.: defining 2 regions and perform QM/MM.
    
    .. admonition:: How to obtain

        | the regions are defined by a list of `selection patterns <structure_selection.html>`_.
          the selection is applied to the 1st frame and the same region
          is used for every frames.
        | The selection of QM regions have its only field of research. A simple guideline is that
          your QM region should at least contain residues that involve significant charge transfer
          with the target bond/orbital/... you cares about. (e.g.: residues that form H-bonds with
          the electrophile carbonyl group containing the carbon of attack.)

``region_methods``
    If more than 1 region is specified. The associate methods need to be specified.
    
    .. admonition:: How to obtain

        | Same as methods.

If you use ARMer to run those QM on computing nodes:

``cluster_job_config`` 
    the config for cluster_job if it is used as the parallel method.
    (See `ARMer Config <armer.html#api-config-dict>`_ section)

Output
------------------------------------------------

``electronic_structure``

    A `ElectronicStructure() <todo>`_ object.

Arguments
==============================================

.. dropdown:: :fa:`eye,mr-1` Click to see full argument explanations

    ``stru``
        the target molecule of the calculation represented as Structure()
        It can also be an ensemble of structures as StructureEnsemble()
        and in this case, each geometry in this ensemble will be calculated.
        (See `Input/Output <#input-output>`_ section)

    ``engine``
        the QM or QM/MM engine as a keyword. (See `Input/Output <#input-output>`_ section)

    ``method``
        the level of theory of this calculation as a LevelOfTheory().
        This is used when there is only 1 region specified. (See `Input/Output <#input-output>`_ section)

    ``regions``
        This option allows you to define different region and apply different
        level of theory to each region.
        e.g.: defining 2 regions and perform QM/MM.
        the regions are defined by a list of `selection patterns <structure_selection.html>`_.
        the selection is applied to the 1st frame and the same region
        is used for every frames.
        (See `Input/Output <#input-output>`_ section)

    ``region_methods``
        The level of theory of each region.
        This is used when more than 1 region is specified.
        The region and the method is align based on the order.
        (See `Input/Output <#input-output>`_ section)

    ``capping_method``
        | the free valence capping method. (See `Capping Methods <capping.html>`_)
        | default: ``"res_ter_cap"``

    ``embedding_method``
        | The embedding method of multiscale simulation.
        This is used when more than 1 region is specified.
        Supported keywords: ["mechanical"]
        | default: ``"mechanical"``

    ``parallel_method``
        | the method to parallelize the multiple runs when more
        than 1 geometry is in the input StructureEnsemble
        The execution will serial and locally if None is given.
        | default: ``"cluster_job"``

    ``cluster_job_config`` 
        the config for cluster_job if it is used as the parallel method.
        (See `ARMer Config <armer.html#api-config-dict>`_ section)

    ``job_check_period``
        the time cycle for update job state change if cluster_job is used. (Unit: s)
        | default: ``210``

    ``job_array_size``
        how many jobs are allowed to submit simultaneously. (0 means all -> len(inp))
        (e.g. 5 for 100 jobs means run 20 groups. All groups will be submitted and
        in each group, submit the next job only after the previous one finishes.)
        | default: ``20``

    ``work_dir``
        the working dir that contains all the files in the SPE process
        | default: ``"./QM_SPE"``

    ``keep_in_file``
        whether keep the input file of the calculation
        | default: ``False``

Example Code
==============================================

1. Calculate single point energy for a small molecule
---------------------------------------------------------

In this example, we perform single point energy calculation on 
the whole Structure which represents a small molecule. (PDB code: `H5J <https://www.rcsb.org/ligand/H5J>`_)

.. admonition:: How input is prepared

    ``stru``
        obtained by reading from a PDB file using ``PDBParser().get_structure()``
        Note that we also assigned the charge and spin using ``.assign_ncaa_chargespin()`` method.
        (See `Details <#input-output>`_)
    
    ``engine``
        we choose "gaussian"

    ``method``
        defined using ``QMLevelOfTheory()``

    ``cluster_job_config``
        defined based on our local HPC and account.

.. code:: python
    
    from enzy_htp.quantum import single_point
    from enzy_htp import PDBParser
    from enzy_htp.chemical.level_of_theory import QMLevelOfTheory
    from enzy_htp.core.clusters.accre import Accre

    test_stru = PDBParser().get_structure(f"{DATA_DIR}H5J.pdb")
    test_stru.assign_ncaa_chargespin({"H5J" : (0,1)})
    test_method = QMLevelOfTheory(
        basis_set="3-21G",
        method="HF",
        solvent="water",
        solv_method="SMD",
    )
    cluster_job_config = {
        "cluster" : Accre(),
        "res_keywords" : {
            "account" : "yang_lab_csb",
            "partition" : "production",
            'walltime' : '30:00',
        }
    }

    qm_result = single_point(
        stru=test_stru,
        engine="gaussian",
        method=test_method,
        cluster_job_config=cluster_job_config,
        job_check_period=10,
        work_dir=f"./QM_SPE/"
    )
    qm_result = qm_result[0]

    # >>> qm_result.energy_0
    # >>> -597.293275805

2. Calculate single point energy for a QM region
---------------------------------------------------------

In this example, we perform single point energy calculation on 
a QM region that is 2 Ang from the substrate in Kemp Eliminase.

.. admonition:: How input is prepared

    ``stru``
        obtained by reading from a PDB file using ``PDBParser().get_structure()``
        (See `Details <#input-output>`_)
    
    ``engine``
        we choose "gaussian"

    ``method``
        defined using ``QMLevelOfTheory()``

    ``regions``
        defined using a PyMol selection syntax.
        (See `Details <structure_selection.html>`_)

    ``cluster_job_config``
        defined based on our local HPC and account.

.. code:: python

    from enzy_htp.quantum import single_point
    from enzy_htp import PDBParser
    from enzy_htp.chemical.level_of_theory import QMLevelOfTheory
    from enzy_htp.core.clusters.accre import Accre
    
    test_stru = PDBParser().get_structure(f"{STRU_DATA_DIR}KE_07_R7_2_S.pdb")
    test_stru.assign_ncaa_chargespin({"H5J" : (0,1)})
    test_method = QMLevelOfTheory(
        basis_set="3-21G",
        method="HF",
    )
    cluster_job_config = {
        "cluster" : Accre(),
        "res_keywords" : {
            "account" : "yang_lab_csb",
            "partition" : "production",
            'walltime' : '30:00',
        }
    }

    qm_result = single_point(
        stru=test_stru,
        engine="gaussian",
        method=test_method,
        regions=["br. (resi 254 around 2)"],
        cluster_job_config=cluster_job_config,
        job_check_period=10,
        work_dir=f"./QM_SPE/",
        )[0]

    # >>> qm_result.energy_0
    # >>> -2169.29406633

3. Calculate single point energy for a QM cluster
---------------------------------------------------------

In this example, we perform single point energy calculation for 
a QM region and for each snapshot from an ensemble of substrates
of Kemp Eliminase.

(note that this is a snippt of a workflow instead of a full script)

.. admonition:: How input is prepared

    ``stru``
        The ``stru`` is a ``StructureEnsemble()`` obtained from a MD trajectory from ``equi_md_sampling()``
        (See `Details <#input-output>`_)
    
    ``engine``
        we choose "gaussian"

    ``method``
        defined using ``QMLevelOfTheory()``

    ``regions``
        defined using a PyMol selection syntax.
        (See `Details <structure_selection.html>`_)

    ``cluster_job_config``
        defined based on our local HPC and account.

.. code:: python

    ...
    qm_level_of_theory = QMLevelOfTheory(
        basis_set="3-21G",
        method="hf",        
    )

    md_result = equi_md_sampling(
        stru = mutant_stru,
        param_method = param_method,
        parallel_runs = 1,
        cluster_job_config = md_cluster_job_config,
        job_check_period=10,
        prod_constrain=mut_constraints,
        prod_time=md_length,
        record_period=md_length*0.1,
        work_dir=f"{mutant_dir}/MD/"
    )[0]

    qm_cluster_job_config = {
        "cluster" : Accre(),
        "res_keywords" : {
            "account" : "yang_lab_csb",
            "partition" : "production",
            'walltime' : '1-00:00:00',
        }}
    qm_results = single_point(
        stru=md_result,
        engine="gaussian",
        method=qm_level_of_theory,
        regions=["resi 101+254"],
        cluster_job_config=qm_cluster_job_config,
        job_check_period=60,
        job_array_size=20,
        work_dir=f"{mutant_dir}/QM_SPE/",
    )
    ...
