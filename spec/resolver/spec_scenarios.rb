require_relative '../helper'

describe Version::Resolver do

  it "resolves complex requirements - example 1" do
    resolver = Version::Resolver.new
    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0.0', 'baz'=>'> 2.0.0')
    resolver.add('bar', '1.0.0', 'baz'=>'= 3.1.0')
    resolver.add('bar', '2.0.0', 'baz'=>'= 3.1.0')
    resolver.add('baz', '2.9.0')
    resolver.add('baz', '3.1.0')
    resolver.add('baz', '3.2.0')
    result = resolver.resolve('foo', '1.0.0')
    result.assert == { 'foo'=>Version['1.0.0'], 'bar'=>Version['2.0.0'], 'baz'=>Version['3.1.0'] }
  end

  it "resolves complex requirements - example 2" do
    resolver = Version::Resolver.new
    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0', 'baz'=>'> 2.0')
    resolver.add('bar', '1.0.0', 'baz'=>'= 3.1')
    resolver.add('bar', '2.0.0', 'baz'=>'= 3.1')
    resolver.add('baz', '2.9.0')
    resolver.add('baz', '3.1.0')
    resolver.add('baz', '3.2.0')
    result = resolver.resolve('foo', '1.0.0')
    result.assert == { 'foo'=>Version['1.0.0'], 'bar'=>Version['2.0.0'], 'baz'=>Version['3.1.0'] }
  end

  it "resolves complex requirements - example 3" do
    resolver = Version::Resolver.new
    resolver.add('foo', '1.0.0', 'bar'=>'> 1.0.0', 'baz'=>'> 2.0.0')
    resolver.add('bar', '1.0.0', 'baz'=>'= 3.1.0')
    resolver.add('bar', '2.0.0', 'baz'=>'> 3.1.0')
    resolver.add('baz', '3.1.0')
    resolver.add('baz', '3.2.0')
    result = resolver.resolve('foo', '1.0.0')
    result.assert == { 'foo'=>Version['1.0.0'], 'bar'=>Version['2.0.0'], 'baz'=>Version['3.2.0'] }
  end

  #it "does not infinitely recurse" do
  #  resolver = Version::Resolver.new
  #  resolver.add('foo', '1.0.0', 'bar'=>'>= 1.0.0')
  #  resolver.add('bar', '1.0.0', 'foo'=>'>= 1.0.0')
  #  result = resolver.resolve('foo', '1.0.0')
  #  result.assert == {'foo'=>Version['1.0.0'], 'bar'=>Version['1.0.0']}
  #end

end

