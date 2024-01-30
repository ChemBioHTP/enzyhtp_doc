# Configuration file for the Sphinx documentation builder.

# -- Project information

project = 'EnzyHTP'
copyright = '2021-2024, the Yang Lab@Vanderbilt University'
author = 'Qianzhen Shao'

release = '2.0'
version = '2.0.0'

# -- General configuration

extensions = [
    'sphinx.ext.duration',
    'sphinx.ext.doctest',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.intersphinx',
    "ablog",
    "sphinx_panels",
    "sphinx_copybutton",
    "sphinx_togglebutton",
]

intersphinx_mapping = {
    'python': ('https://docs.python.org/3/', None),
    'sphinx': ('https://www.sphinx-doc.org/en/master/', None),
}
intersphinx_disabled_domains = ['std']

templates_path = ['_templates']

# -- Options for HTML output

html_theme = 'sphinx_rtd_theme'

# -- Options for EPUB output
epub_show_urls = 'footnote'

# other default
master_doc = 'index'
