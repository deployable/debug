require "debug/version"
require 'pry'
module Debug

  def self.included klass
    #puts "Debug included in #{klass} #{self.class}"
    #binding.pry
    # scope things so we don't interfere with modules 

    debugs = "#{ENV['DEBUG']}".gsub( /(?<!\.)\*/ , '.*' ).split(',')
    klass.instance_variable_set :@d_debug_these_classes, debugs
    
    re = Regexp.new( /\A(#{debugs.join('|')})\Z/ )
    klass.instance_variable_set :@d_debug_this_re, re
    
    match = re.match klass.to_s
    klass.instance_variable_set :@d_debug_class_match_data, match
    klass.instance_variable_set :@d_debug_is_on, !!match

    klass.instance_variable_set :@d_debug_time_last, Time.now.utc
  end

  def debug msg, *args, &block
    cls = self.class

    if cls.instance_variable_get :@d_debug_is_on

      args = Array[yield] if block_given?
      
      time_prev = cls.instance_variable_get( :@d_debug_time_last )
      time_now  = Time.now.utc

      ms_since = (time_now - time_prev)*1000.0
      ms_str = "%.0f" % ms_since
      ms_str = "%0.1f" % ms_since if ms_str == "0"
      
      puts "debug #{cls} #{msg} #{args.join} +#{ms_str}ms"
      
      cls.instance_variable_set :@d_debug_time_last, time_now
      true
    end
  end

end

