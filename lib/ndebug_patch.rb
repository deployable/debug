# A Debugging monkeypatch

module NDebug

  debug_ori = method :debug

  def debug *args, &block
    puts "env: #{ENV['DEBUG']}"
    puts "debugcl: #{cls}"
    puts "debug_re: #{cls.instance_variable_get :@d_debug_this_re }"
    puts "debug_on: #{cls.instance_variable_get :@d_debug_is_on }"
    puts "debug_ma: #{cls.instance_variable_get :@d_debug_class_match_data }"
    puts "debug_cl: #{cls.instance_variable_get :@d_debug_these_classes }"
    debug_ori args, &block
  end

end
