require 'spec_helper'

describe NDebug do

  it 'has a version number' do
    expect( NDebug::VERSION ).to eq "0.2.0"
  end

  it 'does nothing when DEBUG is not set' do

    ENV['DEBUG'] = ''

    class NegTest
      include NDebug

      def something
        debug 'negtest'
      end
    end

    expect( NegTest.new.something ).to eq false
  end


  it 'does nothing when DEBUG is blank' do
    ENV['DEBUG'] = ''
    class BlankTest
      include NDebug

      def something
        debug 'blanktest'
      end
    end
    expect( BlankTest.new.something ).to eq false
  end


  it 'logs debug when DEBUG is "*"' do
    ENV['DEBUG'] = '*'
    allow(Time).to receive(:now).and_return Time.mktime(1970,1,1), Time.mktime(1970,1,1,0,0,1)

    class PosTest
      include NDebug

      def something
        debug 'postest'
      end
    end
    expect( PosTest.new.something ).to eq Time.mktime(1970,1,1,0,0,1)
  end


  it 'logs debug for multiple classes' do

    ENV['DEBUG'] = 'OneTest,TwoTest'

    allow(Time).to receive(:now) { Time.mktime(1970,1,1) }

    class OneTest
      include NDebug
      def something
        debug 'onetest'
      end
    end
    class TwoTest
      include NDebug
      def something
        debug 'twotest'
      end
    end
    class ThrTest
      def something
      end
    end

    allow(Time).to receive(:now).and_return Time.mktime(1970,1,1,0,0,1), Time.mktime(1970,1,1,0,0,2)

    expect( OneTest.new.something ).to eq Time.mktime(1970,1,1,0,0,1)
    expect( TwoTest.new.something ).to eq Time.mktime(1970,1,1,0,0,2)
    expect( ThrTest.new.something ).to eq nil
  end


  it 'runs debug on child class via ::*' do
    
    ENV['DEBUG'] = 'One::*'
    
    allow(Time).to receive(:now).and_return Time.mktime(1970,1,1), Time.mktime(1970,1,1,0,0,1)

    class One
      class Two
        include NDebug
        def something
          debug 'one::two'
        end
      end
    end

    expect( One::Two.new.something ).to eq Time.mktime(1970,1,1,0,0,1)
  end


  it 'runs debug on a child class without a star' do
    
    ENV['DEBUG'] = 'One::Two'
    
    allow(Time).to receive(:now).and_return Time.mktime(1970,1,1), Time.mktime(1970,1,1,0,0,1)

    class One
      class Two
        include NDebug
        def something
          debug 'one::two'
        end
      end
    end

    expect( One::Two.new.something ).to eq Time.mktime(1970,1,1,0,0,1)
  end


  it 'runs debug on a module without a star' do
    
    ENV['DEBUG'] = 'Oone::Two'
    
    allow(Time).to receive(:now).and_return Time.mktime(1970,1,1), Time.mktime(1970,1,1,0,0,1)

    module Oone
      class Two
        include NDebug
        def something
          debug 'oone::two'
        end
      end
    end

    expect( Oone::Two.new.something ).to eq Time.mktime(1970,1,1,0,0,1)
  end


  it 'doesn\'t debug the upper class when using ::star' do
    
    ENV['DEBUG'] = 'Sub::Star::*'

    allow(Time).to receive(:now).and_return Time.mktime(1970,1,1), Time.mktime(1970,1,2)
    
    class Sub
      class Star
        #binding.pry
        include NDebug
        def something
          debug 'this is the sub star *'
        end
      end
    end

    expect( Sub::Star.new.something ).to eq false
  end

  it 'debugs the upper class when using star' do

    ENV['DEBUG'] = 'Sub::Star*'

    allow(Time).to receive(:now).and_return Time.mktime(1970,1,1), Time.mktime(1970,1,2)

    class Sub
      class Star
        #binding.pry
        include NDebug
        def something
          debug 'this is the sub star *'
        end
      end
    end
    expect( Sub::Star.new.something ).to eq Time.mktime(1970,1,2)
  end

  it 'prints a large ms' do

    ENV['DEBUG'] = 'OneTest'

    allow(Time).to receive(:now).and_return Time.mktime(1970,1,1),
      Time.mktime(1970,1,1,1), Time.mktime(1970,1,1,2)

    class OneTest
      include NDebug
      def something
        debug 'onetest'
      end
    end

    expect( OneTest.new.something ).to eq Time.mktime(1970,1,1,1)
    expect( OneTest.new.something ).to eq Time.mktime(1970,1,1,2)
  end


  it 'prints a some positive value with real time' do

    ENV['DEBUG'] = 'OneTest'

    class OneTest
      include NDebug
      def something
        debug 'onetest'
      end
    end

    first_debug = OneTest.new.something
    sleep 0.1
    second_debug = OneTest.new.something
    expect( second_debug - first_debug ).to be > 0.1
  end

end
