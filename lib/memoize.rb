module Memoize
  def present_in_cache?(key)
    Rails.cache.exist?(key)
  end

  def read_from_cache(key)
    Rails.cache.read(key)
  end

  def write_in_cache(key, value)
    Rails.cache.write(key, value, expires_in: 2.minutes)
  end
end