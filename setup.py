"""A setuptools based setup module."""

from setuptools import setup, find_packages

with open("README.md", encoding="utf8") as f:
    long_description = f.read()

raise NotImplementedError

setup(
    name='swbatch',
    version='v0.3.0',
    description='SWbatch: a DesignSafe-CI application for performing batch-style surface-wave inversions.',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/jpvantassel/swbatch',
    author='Joseph P. Vantassel',
    author_email='jvantassel@utexas.edu',
    classifiers=[
        'Development Status :: 5 - Production/Stable',

        'Intended Audience :: Education',
        'Intended Audience :: Science/Research',

        'Topic :: Education',
        'Topic :: Scientific/Engineering',
        'Topic :: Scientific/Engineering :: Physics',

        'License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)',

        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
    ],
    keywords='swbatch',
    packages=find_packages(),
    python_requires = '>=3.6, <3.9',
    install_requires=['click'],
    extras_require={
    },
    package_data={
    },
    data_files=[
        ],
    entry_points="""
        [console_scripts]
        swbatch=swbatch:swbatch
    """,
    project_urls={
        'Bug Reports': 'https://github.com/jpvantassel/swbatch/issues',
        'Source': 'https://github.com/jpvantassel/swbatch',
        'Docs': 'https://swbatch.readthedocs.io/en/latest/?badge=latest',
    },
)