==============================================
 User Guide of EnzyHTP
==============================================

`EnzyHTP <https://github.com/ChemBioHTP/EnzyHTP>`_ is a Python library that automates the complete life cycle of enzyme modeling.
EnzyHTP automates modular steps in traditional enzyme modeling workflows, which rely on manual curations. Such automation enable
high-throughput (HTP) enzyme modeling for enzyme engineering, understanding, and machine learning. 

This user guide contains:

- Install
   | How to install EnzyHTP and configure it for you local HPC (if you are using one).

- Quick Starts
   | Tutorials for users that are **new to protein modeling**.
   | With these quick starts, people can quickly perform some HTP modeling modifying from template
      workflows.

- Tutorials 
   | Tutorials for users that are **experienced in protein modeling** (knows what steps should be in the workflows)
   | There will be a master tutorial that guide your through the methodology of assembly a EnzyHTP main 
      script for your workflow.(e.g.: what to think about, which API to look for.)
   | There will also a collections of Science API tutorials. Each will provide a details about
     what does this API do, the dataflow, commonly used arguments and how to determine the value of them, etc.

.. note::

   | This document is under active development.
   | Currently only part of the tutorials of EnzyHTP are provided.

.. note::

   | We refactored EnzyHTP (1.0 -> 2.0) on 2024/1/29. Tutorials before this time is deprocated. (they only works on 1.0)

.. toctree::
   :maxdepth: 3
   :caption: Install

   install

.. toctree::
   :maxdepth: 3
   :caption: Quick Start
 
   qkst_general
   qkst_cluster
   qkst_shrapnel
   modified_aa

.. toctree::
   :maxdepth: 3
   :caption: Tutorials

   sci_api_tutorial/how_to_assemble
   sci_api_tutorial/single_point
   sci_api_tutorial/assign_mutant
   sci_api_tutorial/mutate_stru
   sci_api_tutorial/dipole
   sci_api_tutorial/obtaining_stru
   sci_api_tutorial/obtaining_stru_esm
   sci_api_tutorial/structure_selection
   sci_api_tutorial/capping
   sci_api_tutorial/armer
   sci_api_tutorial/PDBParser
   usage

.. toctree::
   :maxdepth: 3
   :caption: Documents

   api

-------------
 Links
-------------

.. panels::

   :column: :column: col-lg-12 col-md-12 col-sm-12 col-xs-12 p-2 text-center

   .. image:: ../figures/enzyhtp_concept_art.png
      :width: 100%
      :alt: enzyhtp_github

   +++

   .. link-button:: https://github.com/ChemBioHTP/EnzyHTP
      :text: EnzyHTP GitHub repo
      :classes: btn-block stretched-link

   ---
   :column: + text-center


   .. image:: ../figures/enzygpt_logo.svg
      :width: 100%
      :alt: enzyhtp_gpt_website

   +++

   .. link-button:: https://huggingface.co/spaces/zjyang-group/enzyhtp-mutant-gen
      :text: EnzyHTP-GPT demo
      :classes: btn-block stretched-link

   ---
   :column: + text-center


   .. image:: ../figures/enzyhtp_paper_concept_art.svg
      :width: 100%
      :alt: enzyhtp_paper

   +++

   .. link-button:: https://github.com/ChemBioHTP/EnzyHTP
      :text: EnzyHTP JCIM paper
      :classes: btn-block stretched-link
