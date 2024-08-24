---
title:      Syllabus
layout:     main
---

## Logistical information

CS 5220, {{ site.data.logistics.semester }}: Applications of Parallel Computers  
Lecture time: {{ site.data.logistics.time }}  
Lecture location: {{ site.data.logistics.location }}

Prof: [{{ site.data.logistics.prof.name }}]({{ site.data.logistics.prof.url }})  
E-mail: <{{ site.data.logistics.prof.email }}>  
OH: {{ site.data.logistics.prof.oh }}  
{% if site.data.logistics.prof.scheduler %}[Scheduler link]({{ site.data.logistics.prof.scheduler }}){% endif %}

{% for ta in site.data.logistics.prof.staff %}
TA: {% if ta.url %}[{{ ta.name }}]({{ ta.url }}){% else %}{{ ta.name }}{% endif %}  
Email: <{{ ta.email }}>
OH: {{ ta.oh }}

{% endfor %}
## Course description

CS 5220 is an introduction to performance tuning and parallelization,
particularly for scientific codes. Topics include:

- Single-processor architecture, caches, and serial performance tuning
- Basics of parallel machine organization
- Distributed memory programming with MPI
- Shared memory programming with OpenMP
- Parallel patterns: data partitioning, synchronization, and load balancing
- Examples of parallel numerical algorithms
- Applications from science and engineering

Students should be able to read and write serial programs written in
C, C++, or a related language.  Because our examples will be drawn primarily
from engineering and scientific computations, some prior exposure to
numerical methods is useful, though not necessary.  Prior exposure to
parallel programming is not required, and non-CS students from fields
involving simulation are particularly welcome!

### Course work

The course work consists of:

- *Lecture*: Participation is expected!  Notes and slides will be
  posted online in advance of the meeting, and students should come
  with questions.
- *Homework*: Homework assignments are done individually, and are
  meant to ensure students have the basic skills needed to work on
  parallel machines and to modify, build, and time parallel codes.
  Homework will be posted on Tuesday and due the following Tuesday
- *Projects*: There will be three projects that involve performance
  tuning of a scientific computing kernel or small code.  In each
  case, a reference code will be provided; students are
  responsible for parallelizing the code, tuning it, and running
  performance experiments and analyses.  These are more significant
  than the homeworks, and will run 2-3 weeks.
- *Final projects*: In addition to the assigned projects, students
  will complete a significant final project of their own choosing.  We
  will suggest final projects, or students may bring projects of their
  own.  Group projects are encouraged!  Final project proposals will
  be due immediately after fall break, and groups are expected to make
  steady progress on the project in November and early December.  The
  last two lectures are reserved for project presentations, with a
  final project report due during the finals period in lieu of a final
  exam.

### Texts

The class will be taught from lecture notes and slides, which will be
posted as the class proceeds.  Supplementary reading materials will
also be posted.

### Course technology

We will distribute code via Git repositories, and we recommend the use
of Git for code development and submissions (though this is not
strictly required).  Assignment submissions and grading will generally
be managed via [CMS][cms].  For discussion, we will use [Ed
Discussion][Ed] which you can also reach via the course Canvas site.

## Course policies

### Grading

Graded work will be weighted as follows:

- Class participation: 10%
- Individual homework: 15%
- Small group assignments: 45%
- Final project: 30%

Your participation makes the class more interesting and useful
for all of us.  There are several ways to participate:

- Answering questions in class
- Actively engaging and answering questions on [Piazza]
- Helping correct and clarify class notes and assignments

It is also critical for us to have your feedback about how the class
is going, both to improve the class for the current semester and to
make the class better for future semesters.  We will solicit
non-anonymous comments around the midterm, and at the end of the
semester will check with the college to see who has completed course
evaluation surveys (though we obviously cannot check to see whether
your feedback is useful!).  Participating in these feedback activities
counts toward your grade.

### Collaboration

An assignment is an academic document, like a journal article.
When you turn it in, you are claiming everything in it is your
original work, *unless you cite a source for it*.

You are welcome to discuss homework and projects among yourselves in
general terms.  However, you should not look at code or writeups from
other students, or allow other students to see your code or writeup,
even if the general solution was worked out together.  Unless we
explicitly allow it on an assignment, we will not credit code or
writeups that are shared between students (or teams, in the case of
projects).

If you get an idea from a classmate, the TA, a book or other published
source, or elsewhere, please provide an appropriate citation.  This is
not only critical to maintaining academic integrity, but it is also an
important way for you to give credit to those who have helped you out.
When in doubt, cite!  Code or writeups with appropriate citations will
never be considered a violation of academic integrity in this class
(though you will not receive credit for code or writeups that were
shared when you should have done them yourself).

### Use of Generative AI

You may use generative AI tools if you wish, but we ask that you
explicitly state where and how you have used these tools.  If you do
use generative AI, you should make sure that you understand the
generated code or text.  You are ultimately the responsible party for
your submissions, and incorrect or nonsensical results will be graded
the same whether they are produced by a human or an AI system.

### Academic Integrity

We expect academic integrity from everyone.  School is stressful,
and you may feel pressure from your coursework or other factors,
but that is no reason for dishonesty!  If you feel you can't complete
the work on the own, come talk to the professor, the TA, or your advisor,
and we can help you figure out what to do.

For more information, see Cornell's [Code of Academic Integrity][coai].

### Emergency procedures

In the event of a major campus emergency, course requirements, deadlines, and
grading percentages are subject to changes that may be necessitated by a
revised semester calendar or other circumstances.  Any such announcements will
be posted to [Ed Discussion] and [the course home page](index.html).

[Ed]: {{ site.data.logistics.discussion }}
[cms]: https://cmsx.cs.cornell.edu/
[coai]: https://deanoffaculty.cornell.edu/faculty-and-academic-affairs/academic-integrity/code-of-academic-integrity/
