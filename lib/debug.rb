require "nebug/version"

module NDebug

  METHOD_NAME = :debug

  # Setup when we are included
  # Scope vars under `d_ndebug` so we (hopefully) don't interfere with 
  # other modules/classes.

  def self.included klass
    #STDERR.puts "debugmodule: included in #{klass} #{self.class}"

    # Pull the `DEBUG` env variable into components and store it
    debugs = "#{ENV['DEBUG']}".split( /[,\s]+/ )
    # Replace any `*` with `.*` as long as they aren't `.*` already
    debugs.map!{|a| a.gsub( /(?<!\.)\*/ , '.*' ) }
    klass.instance_variable_set :@d_ndebug_these_classes, debugs
    
    # Create the regexp for all the named classes from `DEBUG`
    re_ndebugs_string = debugs.join('|')
    re = Regexp.new( /
      \A                     # Beginning of string
      (#{re_ndebugs_string})  # Any of the classes from DEBUG
      \Z                     # End of string
    /x )
    klass.instance_variable_set :@d_ndebug_this_re, re
    
    # Compare the regex against the current class name and switch
    # debug on if needed.
    match = re.match klass.to_s
    klass.instance_variable_set :@d_ndebug_class_match_data, match
    klass.instance_variable_set :@d_ndebug_is_on, !!match

    # Set an initial time for the next ms calculation.
    klass.instance_variable_set :@d_ndebug_time_last, Time.now.utc

    if klass.instance_variable_get :@d_ndebug_is_on
      alias_method NDebug::METHOD_NAME, :d_ndebug_on
    else
      alias_method NDebug::METHOD_NAME, :d_ndebug_off
    end

    #STDERR.puts "debugmodule: re #{re}"
  end


  # Noop when off
  def d_ndebug_off msg, *args, &block
    false
  end


  # The main `.debug` method
  def d_ndebug_on msg, *args, &block
    cls = self.class

    # Exit early if we are not needed
    # return false unless cls.instance_variable_get :@d_ndebug_is_on
    
    # Setup the log array from a block, if given
    args = Array[yield] if block_given?
    
    # Calculate the ms since last log
    time_prev = cls.instance_variable_get( :@d_ndebug_time_last )
    time_now  = Time.now.utc

    ms_since = (time_now - time_prev)*1000.0
    ms_str = "%.0f" % ms_since
    ms_str = "%0.1f" % ms_since if ms_str == "0"
    
    # Log it
    STDERR.puts "debug #{cls} #{msg} #{args.join} +#{ms_str}ms"
    
    # Store the new time
    cls.instance_variable_set :@d_ndebug_time_last, time_now

  end

end

