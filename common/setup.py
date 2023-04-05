from setuptools import find_packages, setup

setup(
    name="common",
    version="1.0.0",
    description="This is a simple common package",
    packages=find_packages(),
    install_requires=[
        "boto3==1.26.104",
    ],
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
)
