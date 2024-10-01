---
title: Compile OpenMP on Perlmutter
layout: main
---

Due 2024-10-08.

The goal of this homework is to make you learn to compile OpenMP code on Perlmutter.

## Spawn an interactive shell
In the previous homework, you have experimented with methods to queue jobs from a login node.
In this one, you will take a slightly different approach to run jobs on a Slurm system to observe your job outputs directly. Specifically, you can utilize [salloc][salloc] to allocate resources for an interactive session. After running this command, you will land on the compute nodes you just allocated where you can start a new shell with [srun][srun]. The use of `srun` here is only slightly different from how you used it in `sbatch` files. In addition to all the other arguments, you need to add `--pty /bin/bash -l` to the end of your `srun` command to explicitly inform the system that you would like to start an interactive shell. Then on this shell, you can run your compiled C++ programs and directly read their outputs. Below we demonstrate how to spawn an interactive shell from an allocation of 16 cpu cores: 
```
salloc --nodes 1 --qos interactive --time 01:00:00 --constraint cpu --cpus-per-task 16 --account m4776
srun -n 1 -N 1 -p development -t 00:05:00 --pty /bin/bash -l
```
[salloc]: https://docs.nersc.gov/jobs/interactive/
[srun]: https://docs.nersc.gov/jobs/#srun

## Your tasks

You have one task:

- Compile and run [`omp_hello.cpp`] and screenshot its output on Perlmutter.

[`omp_hello.cpp`]: https://github.com/cs5220-f24/hw2
