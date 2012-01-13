## Version::Constraint#to_proc

A version constraint object can be converter into a Proc object
for making version comparisions.

    cv = DotRuby::Version::Constraint['>', '1.0.0']
    cp = cv.to_proc

    cp.call('1.1.1')  #=> true


