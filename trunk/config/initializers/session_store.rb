# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_eliza_session',
  :secret      => '93b5ef74d685cf6e70b56bfb6534c1d380f96375084ec1acedeb07f2c0d1d3e8002334dae1d10b27505f5b928ecaf6a1bc8f326c87a845943ca6d532ba799767'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
