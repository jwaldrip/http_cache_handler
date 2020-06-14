# http_cache_handler

A Handler to handle caching within Crystal's HTTP layer. Built with the [Cache Shard](https://crystalshards.org/shards/github/mamantoha/cache)

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     http_cache_handler:
       github: jwaldrip/http_cache_handler
   ```

2. Run `shards install`

## Usage
You can use HTTP::CacheHandler with any framework that accepts Crystal's 
`HTTP::Handler`. See the guides for this on popular frameworks such as [Kemal](https://kemalcr.com/guide/#middleware), [Amber](https://docs.amberframework.org/amber/guides/routing/pipelines), [Lucky](https://luckyframework.org/guides/http-and-routing/http-handlers), [Orion](https://github.com/obsidian/orion#instrumenting-handlers-a-k-a-middleware),  and [Grip](https://github.com/grip-framework/grip/blob/master/DOCUMENTATION.md#middleware). See the options below for how to configure with the various strategies.

```crystal
require "http_cache_handler"

# In Memory
HTTPCacheHandler.new expires_in: 30.minutes

# With a file
HTTPCacheHandler.new expires_in: 30.minutes, path: "tmp/cache"

# With Redis
redis_client = Redis::Client.new
HTTPCacheHandler.new expires_in: 30.minutes, redis: redis_client

# With MemCached
memcached_client = Memcached::Client.new
HTTPCacheHandler.new expires_in: 30.minutes, memcached: memcached_client

# Null Store (for devlopment)
HTTPCacheHandler.new expires_in: 30.minutes, null: true
```

## Contributing

1. Fork it (<https://github.com/your-github-user/http_cache_handler/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [jwaldrip](https://github.com/your-github-user) - creator and maintainer
