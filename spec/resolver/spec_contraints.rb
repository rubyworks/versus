require_relative '../helper'

describe Version::Resolver do

  it "resolves greater than constraints" do
    resolver = Version::Resolver.new
    resolver.add('foo', '1.0.0', 'bar'=>'> 0.8')
    resolver.add('bar', '0.1.0')
    resolver.add('bar', '0.8.0')
    resolver.add('bar', '1.0.0')
    result = resolver.resolve('foo', '1.0.0')
    result.assert == {'foo'=>Version['1.0.0'], 'bar'=>Version['1.0.0']}
  end

  it "resolves greater than or equal constraints" do
    resolver = Version::Resolver.new
    resolver.add('foo', '1.0.0', 'bar'=>'>= 0.8')
    resolver.add('bar', '0.1.0')
    resolver.add('bar', '0.8.0')
    resolver.add('bar', '1.0.0')
    result = resolver.resolve('foo', '1.0.0')
    result.assert == {'foo'=>Version['1.0.0'], 'bar'=>Version['1.0.0']}

    resolver = Version::Resolver.new
    resolver.add('foo', '1.0.0', 'bar'=>'>= 0.8')
    resolver.add('bar', '0.1.0')
    resolver.add('bar', '0.8.0')
    result = resolver.resolve('foo', '1.0.0')
    result.assert == {'foo'=>Version['1.0.0'], 'bar'=>Version['0.8.0']}
  end

  it "resolves lesser than constraints" do
    resolver = Version::Resolver.new
    resolver.add('foo', '1.0.0', 'bar'=>'< 1.0.0')
    resolver.add('bar', '0.1.0')
    resolver.add('bar', '0.8.0')
    resolver.add('bar', '1.0.0')
    result = resolver.resolve('foo', '1.0.0')
    result.assert == {'foo'=>Version['1.0.0'], 'bar'=>Version['0.8.0']}
  end

  it "resolves lesser than or equal constraints" do
    resolver = Version::Resolver.new
    resolver.add('foo', '1.0.0', 'bar'=>'<= 1.0.0')
    resolver.add('bar', '0.1.0')
    resolver.add('bar', '0.8.0')
    resolver.add('bar', '1.0.0')
    result = resolver.resolve('foo', '1.0.0')
    result.assert == {'foo'=>Version['1.0.0'], 'bar'=>Version['1.0.0']}
  end

  it "resolves semantically equal constraints" do
    resolver = Version::Resolver.new
    resolver.add('foo', '1.0.0', 'bar'=>'~> 1.0.0')
    resolver.add('bar', '1.0.1')
    resolver.add('bar', '1.1.0')
    resolver.add('bar', '2.0.0')
    result = resolver.resolve('foo', '1.0.0')
    result.assert == {'foo'=>Version['1.0.0'], 'bar'=>Version['1.1.0']}
  end

end

