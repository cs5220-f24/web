---
title: Hello Perlmutter
layout: main
---

Due 2024-10-01.

The goal of this homework is to get you up and running on Perlmutter.

## Logging in

The NERSC documentation has information about [how to
connect][connect] to Perlmutter.  The short version is "use ssh",
but I strongly recommend using ssh with the [sshproxy][sshproxy]
setup to avoid typing your password (and one-time password)
repeatedly.  With the proxy set up, you should only need to enter
your password (including one-time password) once every 24 hours.

[connect]: https://docs.nersc.gov/connect/
[sshproxy]: https://docs.nersc.gov/connect/mfa/#sshproxy

## Loading modules

When you log into Perlmutter, you start off with a fairly minimal set
of tools available in the standard path.  A variety of compilers and
other tools are all available, but you will need to learn a little
about [environment modules][lmod] to use them.

On Perlmutter there are standard [compiler wrappers][wrappers] for
building parallel codes.  These compiler wrappers include all the
requisite compiler and linker directives to make sure that things are
set up.  Make sure that you use the compiler wrappers (typically
called `cc`, `CC`, and `ftn` for C, C++, and Fortran) when you compile
in order to get this convenience.  The compilers are also set up so
that they target the appropriate behavior for the compute nodes.

[lmod]: https://docs.nersc.gov/environment/lmod/
[wrappers]: https://docs.nersc.gov/development/compilers/wrappers/

## Programming models

We will be learning to use MPI and OpenMP, which is the [recommended
programming model on Perlmutter][mpi-openmp].  We will be starting
with MPI.  The [default MPI][default-mpi] on Perlmutter is the Cray
MPI implementation.

[mpi-openmp]: https://docs.nersc.gov/development/programming-models/
[default-mpi]: https://docs.nersc.gov/development/programming-models/mpi/

## Running jobs

NERSC uses a [job queue system based on Slurm][jobs].  Users submit
jobs to a queue (using `sbatch`) with some set of parameters
describing resources that will be used.  The script that is submitted
includes additional parameters, shell commands to set up the
appropriate environment, and shell commands to run whatever is to be
run.  There is an [example submission script][hello-submit] in the
class [demos][demos] repository.

It sometimes takes a bit for things to run, and it is not so easy to
tell whether a code is taking a while because it has not been
scheduled or because something has gone wrong.  You can use the `sqs`
and `squeue` [monitoring tools][monitor] to check on the status of a
running job.

It is considered bad form to run anything computationally intensive on
the login nodes.

[jobs]: https://docs.nersc.gov/jobs/
[monitor]: https://docs.nersc.gov/jobs/monitoring/
[hello-submit]: https://github.com/cs5220-f24/demos/blob/main/hello-submit.sh
[demos]: https://github.com/cs5220-f24/demos

## Your tasks

You have two tasks:

- Run the MPI ping-pong example from the demos subdirectory and submit
  your timings from on Perlmutter.  
- Complete the [`telephone` code](https://github.com/cs5220-f24/hw1).
