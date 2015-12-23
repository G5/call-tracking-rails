module ParamsCleaner
  RAILS_PARAMS = [ "action", "controller", "route_info", "format" ]

  def clean_rails_parameters(dirty_params)
    dirty_params.reject { |k, v| RAILS_PARAMS.include?(k) }
  end
end
