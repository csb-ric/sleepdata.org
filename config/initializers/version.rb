# frozen_string_literal: true

module SleepData
  module VERSION #:nodoc:
    MAJOR = 33
    MINOR = 0
    TINY = 0
    BUILD = "rc" # "pre", "beta1", "beta2", "rc", "rc2", nil

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join(".").freeze
  end
end
