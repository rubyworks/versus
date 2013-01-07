# RELEASE HISTORY

## 0.2.0 / 2013-01-07

This release fixes a bug in the Resolver that can lead to inifinite recursion
if one entry requires another that in turn requires the former. Also, resolution
failures are now tracked so that a nice list of the culprits can be had, helpful
for trouble-shooting unsuccessful resolutions.

Changes:

* Prevent possible infinite recustion in Resolver#resolve.
* Keep record of resolution failures.


## 0.1.0 / 2013-01-05

While the code is beening sitting around on my hard drive for nearly
a year, finally, yes finally, we have settled on a gem name to release
it under.

Changes:

* Finally a first release.
