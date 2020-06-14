require "http"
require "cache"
require "json"

class HttpCacheHandler
  include HTTP::Handler
  getter methods : Array(String)
  getter store : Cache::MemoryStore(String, String) | Cache::FileStore(String, String) | Cache::RedisStore(String, String) | Cache::MemcachedStore(String, String) | Cache::NullStore(String, String)

  # Init with a cache store
  def initialize(*, @methods : Array(String) = ["GET"], @store)
  end

  # Init with null or memory store
  def initialize(*, @methods : Array(String) = ["GET"], expires_in, null = false)
    @store = if null
               Cache::NullStore(String, String).new(expires_in: expires_in)
             else
               Cache::MemoryStore(String, String).new(expires_in: expires_in)
             end
  end

  # Init with redis store
  def initialize(*, @methods : Array(String) = ["GET"], expires_in, redis)
    @store =
      Cache::RedisStore(String, String).new(
        expires_in: expires_in,
        cache: redis
      )
  end

  # Init with memcache store
  def initialize(*, @methods : Array(String) = ["GET"], expires_in, memcached)
    @store =
      Cache::MemcachedStore(String, String).new(
        expires_in: expires_in,
        cache: memcached
      )
  end

  # Init with file store
  def initialize(*, @methods : Array(String) = ["GET"], expires_in, path)
    @store = Cache::Cache::FileStore(String, String).new(
      expires_in: expires_in,
      cache_path: path
    )
  end

  def call(context)
    call_next(context) unless context.request.method === "GET"
    key = "http-cache-handler:#{context.request.resource}"
    if (cached_response = store.read(key))
      io = IO::Memory.new(cached_response)
      IO.copy(io, context.response.output)
    else
      io = IO::Memory.new
      context.response.output = IO::MultiWriter.new(context.response.output, io)
      call_next(context)
      store.write(key, io.tap(&.rewind).gets_to_end)
    end
  end
end
