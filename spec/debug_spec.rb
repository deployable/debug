require 'spec_helper'

describe Debug do

  it 'has a version number' do
    expect( Debug::VERSION ).to eq "0.0.1"
  end

  it 'does nothing useful' do
    class NegTest
      include Debug

      def something
        debug 'negtest'
      end
    end

    expect( NegTest.new.something ).to eq false
  end

  it 'does debug' do
    ENV['DEBUG'] = '*'
    class PosTest
      include Debug

      def something
        debug 'postest'
      end
    end
    expect( PosTest.new.something ).to eq true
  end

  it 'does many debug' do
    ENV['DEBUG'] = 'OneTest,TwoTest'
    class OneTest
      include Debug
      def something
        debug 'onetest'
      end
    end
    class TwoTest
      include Debug
      def something
        debug 'twotest'
      end
    end
    class ThrTest
      def something
      end
    end
    expect( OneTest.new.something ).to eq true
    expect( TwoTest.new.something ).to eq true
    expect( ThrTest.new.something ).to eq nil
  end


  it 'does debug on child with a star' do
    ENV['DEBUG'] = 'One::*'
    class One
      class Two
        include Debug
        def something
          debug 'one::two'
        end
      end
    end
    expect( One::Two.new.something ).to eq true
  end


  it 'debugs without a star' do
    ENV['DEBUG'] = 'One::Two'
    class One
      class Two
        include Debug
        def something
          debug 'one::two'
        end
      end
    end
    expect( One::Two.new.something ).to eq true
  end


  it 'debugs on a module without star' do
    ENV['DEBUG'] = 'Oone::Two'
    module Oone
      class Two
        include Debug
        def something
          debug 'oone::two'
        end
      end
    end
    expect( Oone::Two.new.something ).to eq true
  end


  it 'doesn\'t debug the upper class when using ::star' do
    ENV['DEBUG'] = 'Sub::Star::*'
    class Sub
      class Star
        #binding.pry
        include Debug
        def something
          debug 'this is the sub star *'
        end
      end
    end
    expect( Sub::Star.new.something ).to eq false
  end

  it 'debugs the upper class when using star' do
    ENV['DEBUG'] = 'Sub::Star*'
    class Sub
      class Star
        #binding.pry
        include Debug
        def something
          debug 'this is the sub star *'
        end
      end
    end
    expect( Sub::Star.new.something ).to eq true
  end

  it 'prints a large ms' do

    ENV['DEBUG'] = 'OneTest'
    class OneTest
      include Debug
      def something
        debug 'onetest'
      end
    end

    expect( OneTest.new.something ).to eq true
    sleep 0.1
    expect( OneTest.new.something ).to eq true
  end
end
