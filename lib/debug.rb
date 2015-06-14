require "debug/version"


module Debug

  def self.included klass
    #puts "Debug included in #{klass} #{self.class}"
    #binding.pry
    # scope things so we don't interfere with modules 

    # Split the DEBUG string and turn the * into regex .*
    debugs = "#{ENV['DEBUG']}".split( /[,\s]+/ )
    debugs.map!{|a| a.gsub( /(?<!\.)\*/ , '.*' ) }

    klass.instance_variable_set :@d_debug_these_classes, debugs
    
    # Create a regex for the DEBUG env variable
    re_debugs_string = debugs.join('|')
    re = Regexp.new( /
      \A
      (#{re_debugs_string})
      \Z
    /x )
    klass.instance_variable_set :@d_debug_this_re, re
    
    match = re.match klass.to_s
    klass.instance_variable_set :@d_debug_class_match_data, match
    klass.instance_variable_set :@d_debug_is_on, !!match

    # Initialise a "last" time for ms reporting. 
    klass.instance_variable_set :@d_debug_time_last, Time.now #.utc

    if klass.instance_variable_get :@d_debug_is_on
      alias_method :debug, :debug_on
    else
      alias_method :debug, :debug_off
    end

  end


  def debug_off msg, *args, &block
  end


  def debug_on msg, *args, &block

    # Check if we have a block, ensure it's returns an array. 
    args = Array[yield] if block_given?
    
    time_prev = self.class.instance_variable_get :@d_debug_time_last
    time_now  = Time.now #.utc

    ms_since = ( time_now - time_prev ) * 1000.0
    ms_str = "%.0f" % ms_since
    ms_str = "%0.1f" % ms_since if ms_str == "0"
    
    STDERR.puts "debug #{self.class} #{msg} #{args.join} +#{ms_str}ms"
    
    self.class.instance_variable_set :@d_debug_time_last, time_now

  end

end

