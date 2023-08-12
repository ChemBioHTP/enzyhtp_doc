==============================================
 User Guide of EnzyHTP
==============================================

`EnzyHTP <https://github.com/ChemBioHTP/EnzyHTP>`_ is a Python library that automates the complete life cycle of enzyme modeling.
EnzyHTP automates modular steps in traditional enzyme modeling workflows, which reply on manual curations. Such automation enable
high-throughput enzyme modeling for enzyme engineering, understanding, and machine learning. 

This user guide contains tutorials of using EnzyHTP (mainly science APIs), example workflows built by EnzyHTP, and inner-layer Python API reference for
advanced usage of EnzyHTP. 

.. note::

   | This document is under active development.
   | Currently only tutorials of EnzyHTP are provided.

.. note::

   | We are refactoring EnzyHTP these days under the `refactoring_branch <https://github.com/ChemBioHTP/EnzyHTP/tree/develop_refactor>`_ to make
     it more extensible and easier to use. (built around the Structure class)
   | Current tutorials only works on the beta version. 
     The beta version uses an old architecture (built around the PDB class) before the refactoring.


.. toctree::
   :maxdepth: 3
   :caption: Tutorials

   install
   qkst_general
   qkst_shrapnel
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
