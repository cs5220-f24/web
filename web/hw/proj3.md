# P3 Overview - (Linearized) Shallow Water Simulation

Welcome to P3 everyone! We hope that you enjoyed simulating particle hydrodynamics, which was a problem that introduced you to less than uniform computation. What we mean by this is that particles were not evenly divided in space, so simply looping through all cells would often lead to wasted work (as most cells were empty). In this assignment, you will work with a structured grid computation, where every cell will be (roughly) the same, so you can't be too clever in how you divide the work.

# What are the Linearized Shallow Water Equations (SWE)?

The original shallow water equations, in non-conservative form, are given by

$$
\begin{align*}
\frac{\partial h}{\partial t} + \frac{\partial}{\partial x} \left((H + u) u\right) + \frac{\partial}{\partial y} \left((H + u) v\right) = 0, \\
\frac{\partial u}{\partial t} + u \frac{\partial u}{\partial x} + v \frac{\partial u}{\partial y} = -g \frac{\partial h}{\partial x} - ku + \nu \left(\frac{\partial^2 u}{\partial x^2} + \frac{\partial^2 u}{\partial y^2}\right), \\
\frac{\partial v}{\partial t} + u \frac{\partial v}{\partial x} + v \frac{\partial v}{\partial y} = -g \frac{\partial h}{\partial y} - kv + \nu \left(\frac{\partial^2 v}{\partial x^2} + \frac{\partial^2 v}{\partial y^2}\right)
\end{align*}
$$

where $(u, v)$ describes the velocity field of a body of water, $H$ is the mean depth of the water (i.e. the average) at a particular point, $h$ is how much the height deviates from the mean at a given time, $k$ describes the viscous drag (basically a friction force), and $\nu$ is the viscosity (how much a liquid wants to flow away from itself). In some other sources you might also see a term dealing with $f$, the Coriolis parameter, which takes into account the rotation of the Earth. However, since we assume we are on a scale much smaller than this, we ignore this term. As you can see, these equations are quite the doozy, though if you'd like to know more please see the [Wikipedia](https://en.wikipedia.org/wiki/Shallow_water_equations) or ask Professor Bindel (he knows way more than us TAs!).

Since this is so complicated, and I have no background in PDEs, I decided to use the simpler, linearized shallow water equations. Essentially, if we assume that our height deviation is small relative to the average height (i.e. $h \ll H$) and that the higher order terms of velocity are quite small, through some derivations we can reach

$$
\begin{align*}
\frac{\partial h}{\partial t} + H \left(\frac{\partial u}{\partial x} + \frac{\partial v}{\partial y}\right) = 0, \\
\frac{\partial u}{\partial t} = -g \frac{\partial h}{\partial x} - ku, \\
\frac{\partial v}{\partial t} = -g \frac{\partial h}{\partial y} - kv
\end{align*}
$$

Since we want our equations to be energy conserving (as a check of our correctness), we assume that $k = 0$, so we don't want to dissipate energy due to friction. Now that we have a much simpler looking set of equations, how do we actualy solve them? If you already know about solving PDEs numerically you can skip this next section, but if not (like me), then please read on!

# Discretizing the Problem in Space

In order to actually solve this problem numerically, we need to be able to compute derivatives with respect to space as well as time. Looking at the definition of a derivative

$$
\begin{align*}
f'(x) = \lim_{h \rightarrow 0} \frac{f(x + h) - f(x)}{h}
\end{align*}
$$

we see that it is the limit of a difference quotient. Given that, we could imagine that for a fixed (but small) $h$, the corresponding finite difference quotient should be a good approximation. Therefore, given a rectangular domain $R \subseteq \mathbb{R}^2$, we can discretize it into evenly spaced partitions $(x_1, \dots, x_{n_x})$ and $(y_1, \dots, y_{n_y})$, and then take the difference quotient of adjacent points to approximate spatial derivatives. In other words, we would say that the spatial derivative in the $x$ direction of a function $f$ at $(x_i, y_j)$ is approximately given by

$$
\begin{align*}
\hat{\frac{\partial f}{\partial x}}(x_i, y_j) = \frac{f(x_{i + 1}, y_j) - f(x_i, y_j)}{x_{i + 1} - x_i} = \frac{f(x_{i + 1}, y_j) - f(x_i, y_j)}{\Delta x}
\end{align*}
$$

with a similar formula for $y_i$. Using this idea, we can approximate all of the spatial derivatives for our functions $h$, $u$, and $v$. To be particularly clever, since our $u$ and $v$ functions govern the horizontal and vertical velocities of our field, we can imagine that they exist on the boundaries of our cells (since fluid flows into and out of our cells). This is called an Arakawa C grid, and an image is shown below ([source](https://amps-backup.ucar.edu/information/configuration/wrf_grid_structure.html)):

![Arakawa C Grid](https://amps-backup.ucar.edu/information/configuration/gridstructure.png)

As you can see, we take the $u$ values on the horizontal edges of our cells, and the $v$ values on the vertical edges of our cells. The $h$ values, on the other hand, are in the center of our cells. I did this because it was popular for other SWE solvers, though I don't know if there's a particular numerical reason why it is used. This becomes a little difficult because if we have $n_x$ points in our horizontal partition for the $h$ function, we will have $n_x + 1$ points in our partition for the $u$ function (since we have the last edge as well) and $n_y + 1$ points in our partition for the $v$ function (where $n_y$ is the number of points in our vertical partition). Therefore, we need to rely on boundary conditions to tell us what happens there.

# Discretizing the Problem in Time

Now that we're able to compute our spatial derivatives, how do we step our equations forward in time? Re-arranging our linear SWE equations, we see that the derivatives of each of our variables with respect to time are given by

$$
\begin{align*}
\frac{\partial h}{\partial t} &= -H \left(\frac{\partial u}{\partial x} + \frac{\partial v}{\partial y}\right), \\
\frac{\partial u}{\partial t} &= -g \frac{\partial h}{\partial x}, \\
\frac{\partial v}{\partial t} &= -g \frac{\partial h}{\partial y}
\end{align*}
$$

Since these give us the rate of change of each of our variables with respect to time, if we take a small discrete time step $\Delta t$ then we could imagine that we could use them to approximate the function value at our next time step. Using a difference quotient, we can reason that

$$
\begin{align*}
\frac{f(t + \Delta t) - f(t)}{\Delta t} \approx f'(t) \implies f(t + \Delta t) \approx f(t) + f'(t) \cdot \Delta t.
\end{align*}
$$

This is called Euler's method, and is first order, as we are essentially using our derivative as a linearization about the point $t$ to predict what the next value of our function will be. However, we could imagine that if our function is quite non-linear this approximation won't hold well, so we could imagine using higher order (i.e. with regards to a Taylor expansion) schemes. I based my implementation off of this [guide](https://empslocal.ex.ac.uk/people/staff/gv219/codes/shallowwater.pdf), which uses a 3rd order linear multistep method (i.e. it uses previous evaluations to make its next prediction) called the [Adams-Bashford method](https://en.wikipedia.org/wiki/Linear_multistep_method#Adams%E2%80%93Bashforth_methods), which is given by

$$
\begin{align*}
AB(f(t_4)) = f(t_3) + \Delta t \left(\frac{23}{12} f'(t_3) - \frac{16}{12} f'(t_2) + \frac{5}{12} f'(t_1)\right)
\end{align*}
$$

Here, $t_4, t_3, t_2, t_1$ are adjacent times (i.e. they are $\Delta t$ apart). You could imagine this serves to smooth out our approximations a little, since we balance out our current derivative with that of previous iterations. Empirically, I've found that in situations where's Euler's method blows up (i.e. solutions diverge to infinity), this method does not, so I feel comfortable using it (at least when things aren't too crazy).

# Putting it Together

Using these two ideas, if we let $h_{x,y}^t$ represent the value of our height function at timestep $t$ and position $(x, y)$ in our grid (and do the same for $u$ and $v$), then we approximate their derivatives with respect to time as

$$
\begin{align*}
\partial_t h_{x_i, y_i}^t &= -H \left(\frac{u_{x_{i + 1}, y_i}^t - u_{x_i, y_i}^t}{\Delta x} + \frac{v_{x_i, y_{i + 1}}^t - v_{x_i, y_i}^t}{\Delta y}\right), \\
\partial_t u_{x_{i + 1}, y_i}^t &= -g \left(\frac{h_{x_{i + 1}, y_i}^t - h_{x_i, y_i}^t}{\Delta x}\right), \\
\partial_t v_{x_i, y_{i + 1}}^t &= -g \left(\frac{h_{x_i, y_{i + 1}}^t - h_{x_i, y_i}^t}{\Delta y}\right)
\end{align*}
$$

and then step them forward using the Adams-Bashforth method. For the $u$ and $v$ equations we use $(x_{i + 1}, y_i)$ and $(x_i, y_{i + 1})$ because we have one more $u$ and $v$ value in the vertical and horizontal directions than for $h$, so we need to offset ourselves by one. If you look at the Arakawa grid, you'll see that this is indeed the best way to approximate the corresponding value of $u$ and $v$, as it resides in between the two values of $h$ that we take the difference over.

# Boundary Conditions

So far, we have beeen discussing the problem in a very general sense (i.e. not considering specific cells in our grid), so as to make general conclusions about how to simulate our system. However, one aspect of this problem we have neglected to mention is what to do at the boundaries. We can observe that we can't compute our derivatives there, as there is no next cell to take the difference with, so we need to set this value ourselves.

In the spirit of previous iterations of this project, we use periodic boundary conditions, which means going both vertically and horizontally we wrap back around. Visually, this looks like

![Periodic Boundary Conditions](https://upload.wikimedia.org/wikipedia/commons/thumb/2/2e/Limiteperiodicite.svg/1024px-Limiteperiodicite.svg.png)

In other words, when simulating our grid, the last row / column should behave as if it were adjacent to the first row / column. Symbolically, we represent these conditions as

$$
\begin{align*}
u_{0, y_i} = u_{x_{n_x + 1}, y_i}^t \quad \text { and } \quad y_{x_i, 0}^t = y_{x_i, y_{n_y + 1}}^t
\end{align*}
$$

# Ghost Cells

As stated previously, we also need to worry about how to compute our derivatives on our boundary values. Looking back at how we compute our time derivatives, we can see that we don't need to worry about computing $\partial_{t} h_{x_{n_x}, y_{n_y}}^t$, because our $u$ and $v$ grids have one more point in the $x$ and $y$ directions. In other words, because both $u_{x_{n_x + 1}, y_{n_y}}$ and $v_{x_{n_x}, y_{n_y + 1}}$ exist, we can compute the time derivativeof $h$ at its outermost points.

However, the same does not hold for the outermost points of $u$ and $v$. In our boundary conditions, we explicitly set $u_{0, y}$ and $v_{x, 0}$ to $u_{x_{n_x}, y}$ and $v_{x, y_{n_y}}$ respectively, but how do we actually compute those values? To compute the time derivatve of $u$, we need to take a step in the $x$ direction of $h$, however at the outermost points of our grid no such step can be taken. The same holds for $y$. So how do we get around this?

At the end of the day, we need to define what $h$ value we should be using when we take a step off of our grid. Looking back at our boundary conditions, we assume that the last row and column are adjacent to the first row / column. Therefore, when we step off our grid at these last points, intuitively we should arrive at the beggining of our grid in the corresponding direciton. Visually, a ghost cell would look like ([source](https://scicomp.stackexchange.com/questions/7650/how-should-boundary-conditions-be-applied-when-using-finite-volume-method))

![Ghost cell diagram](https://i.sstatic.net/tPF6Y.png)

In our case, we add a ''ghost'' row and column to our $h$ grid, which exists solely to allow us to compute these derivates and is not simulated. Instead, we do the same wrap around we did with our boundary conditions, and set these ghost cells as

$$
\begin{align*}
h_{x_{n_x + 1}, y_i} = h_{0, y_i} \quad \text{ and } \quad h_{x_i, y_{n_y + 1}} = h_{x_i, 0}
\end{align*}
$$

This differs slightly from the picture, where the ghost cells are the first row and column. We choose this format because we think it makes more intuitive sense. In other words, we do the flip of what the picture shows, so our ghost cells are at an added last row and column.

# Getting Started

To start this project, please take a look at `serial/basic_serial.cpp` and see how we have actually implemented all of these concepts. Pay particular attention to indices! This took quite a while to get right, so make sure you fully understand how and why we are iterating through things in the order that we are to get the results that we want.

Once you understand the code, try making it better! We have included a skeleton `serial/serial.cpp` file so that you can create your own optimized serial version. Don't spend too much time optimizing this code (an hour or so is enough), but it will give you some experience playing around with the framework. You may notice a lot of odd looking macros and functions such as `u(i, j)` and `dh_dx(i, j)`. These are all defined in `common/common.hpp`, and were created solely to make your (and our) lives easier. Definitely take a look at them! Indexing your grids will become MUCH easier.

You should also understand how our runner program works, which is located in `common/main.cpp`. This is what actually executes your script. Some command line options it accepts are:
- `--scenario`: which scenario to choose for your initial conditions. Can be `water_drop` (default), `dam_break`, or `wave` (for more info, see `common/scenarios.hpp`)
- `--nx`: the number of grid points in the $x$ direction
- `--ny`: the number of grid points in the $y$ direction
- `--num_iter`: the number of iterations to run your program
- `--output`: the file to save your $h$ grid to (defaults to not saving)
- `--save_iter`: the number of iterations between saving your file

Finally, look at `Makefile`! It will take care of compiling everything correctly for you. If you don't already have a `build/` directory, create one, because that is where it will put your files. The targets it uses are:
- `basic_serial`
- `serial`
- `mpi`
- `gpu`
- `all` (builds all of the above)
- `clean` (deletes all `*.o`, `*.out`, and `*.gif` files in `build/`)

# CUDA

The first parallelization task you have is to use CUDA to perform all this computation on the GPU. The skeleton file is located in `gpu/gpu.cpp`. One thing very much worth noting is that we don't transfer our initial $h$, $u$ and $v$ matrices to the GPU when we pass them in to the init function of your code. Therefore, it's up to you to put the data on the GPU for your kernels (hint, the `cudaMalloc` and `cudaMemcpy` will be very useful for this). You also need to implement the `transfer` function, copies the data from the GPU back on to the CPU. Another good note is that everything run on the GPU needs to have a `__global__` attribute to let the compiler know (1) that it will be transferred to GPU, and (2) that you will be calling it from your CPU code.

To actually run your code, you will need to allocate a GPU node on pearlmutter. To see how to do this, you can go to [this](https://docs.nersc.gov/jobs/interactive/) link on NERSC to learn more, or just use `salloc --nodes 1 --qos interactive --time 01:00:00 --constraint gpu --gpus 1 --account mxxxx`, where you fill in `mxxxx` with the account Professor Bindel has. If you want to use `sbatch`, see [this](https://www.nersc.gov/assets/Uploads/Building-and-running-GPU-applications-on-Perlmutter.pdf) presentation for the options you need. I've also included an example file in `gpu/job-gpu`.

# MPI

The next parallelization task you have is to use MPI to perform this computation on multiple separate computers (and potentially multiple local threads on each computer). The skeleton file for this task is located in `mpi/mpi.cpp`. Similar to the CUDA task, we don't allocate memory on all nodes for our initial $h$, $u$ and $v$ grids, and only do this for the node with rank 0. Therefore, in your init function you need to transfer the corresponding sections of your grids to each processor (hint, the `MPI_Scatterv` function might be very helpful for this). You will also need to gather all of the different pieces of the grid in the `transfer` and put them back on the node with rank 0 (hint, `MPI_Gatherv` is useful for this).

To run your MPI application, you can see [this](https://docs.nersc.gov/development/programming-models/mpi/cray-mpich/) article on NERSC, or TLDR use `salloc --nodes N --qos interactive --time 01:00:00 --constraint gpu --gpus 1 --account mxxxx`, where you fill in `N` with the number of nodes you want to use. Then, to run your application, you can follow the guide, or again TLDR use `srun -N N -n n ./mpi`, where `N` is the number of nodes you want to use and `n` is the number of threads you want per node.

# Utilities

In order to visualize and check the correctness of your implementations, we have created some helper scripts. The first, `utils/visualizer.py`, takes in the name of a file produced by your script, and creates an animated GIF file from it (you can choose the name of this file as your other argument). The other utility script, `utils/correctness.py`, takes in the names of two output files, prints out the maximum error between them over the $h$ grid at all timesteps, and also outputs a GIF file showing (1) the maximum error plotted over time, and (2) a plot of where the error is accumulating over your grid over time.

# Submission

Again, please work on this project in groups of 2-5, as otherwise grading is a real hassle (there are 2 TAs for the whole class). You should try to have one non-CS person per group if you can, so that you have a wide range of perspectives. This will be particularly helpful trying to understand the math or any domain specific knowledge. You do not need to have the same groups as last time.

Once you are done, you will submit your code to CMS, along with a report. This report should include:
- Proof that your serial implementation works as intended (i.e. that it does not deviate from the output of `basic_serial` by more than around $10^{-14}$)
- A plot of $n$ versus the time taken for your serial code (where $n$ is the number of cells in the $x$ and $y$ direction) for 10,000 iterations and up to $n = 1,000$
- A description of the optimizations you tried for your serial code, as well as a timing breakdown of where your program spends the most cycles
- Proof that your CUDA implementation works as intended
- A plot of $n$ versus the time taken for your CUDA code (where $n$ is the number of cells in the $x$ and $y$ direction) for 10,000 iterations and up to $n = 100,000$
- A description of the optimizations you tried for your CUDA code, as well as a timing breakdown of where your program spends the most cycles
- Proof that your MPI implementation works as intended (the error can be much looser here)
- Two parallel speed-up plots, one where you fix $n = 10,000$ for 10,000 iterations on 2 nodes and scale up the number of nodes / threads from there, and another where you start with $n = 1,000$ on a single node, then double the number of particles and nodes up to $n = 16, 000$
- A description of the optimizations you tried for your MPI code, as well as a timing breakdown of where your program spends the most cycles

# Resources

Feel free to stop by office hours, and make sure to go through the lecture notes, the Perlmutter NERSC resources provided here (especially with regards to MPI), and the [NVIDIA CUDA programming guide](https://docs.nvidia.com/cuda/cuda-c-programming-guide/).

Good luck! Make sure to periodically run the visualization script, as what you're doing looks really cool! To see your hard work pay off, set the number of iterations to be 10,000 and don't let $n$ be more than around 250. It will take a while to output, but when it does it looks really nice!
