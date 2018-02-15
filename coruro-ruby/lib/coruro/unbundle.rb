module Unbundle
  def self.all(env)
    env.keys.grep(/BUNDLER_ORIG/).reduce({}) do |new_env, env_var|
      orig_val = ENV[env_var]
      val = orig_val == "BUNDLER_ENVIRONMENT_PRESERVER_INTENTIONALLY_NIL" ? nil : orig_val
      new_env[env_var.gsub("BUNDLER_ORIG_", "")] = val
      new_env
    end
  end
end
