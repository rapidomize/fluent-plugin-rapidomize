# fluent-plugin-rapidomize
[Fluentd](https://fluentd.org/) output plugin to send data to Rapidomize cloud.

## Installation
### RubyGems
```
$ gem install fluent-plugin-rapidomize
```

## Data Model

In current version of out_rapidomize, a JSON object with following schema is sent over HTTP.

```json
[
  {
    "time": 1627647461, // unix epoch timestamp,
    "tag": "test.default", // the tag associated with the record
    "record": { // schema of this object will vary on the fluentd source type
      "text": "Hello World" 
    }
  }
]
```

> *__TIP__* To transform the record object, you can use the `record_transformer` filter.
> ```xml
> <filter test.**>
>  @type record_transformer
>  <record>
>    timestamp ${time}
>  </record>
> </filter>
> ```

## Configuration
| parameter | Description | Default |
|:----------|:------------|:--------|
| `appid`| Id of the Rapidomize application | |
| `icappid` | Id of the ICApp under `appid` | |
| `apptoken` | Authorization token for `appid` | |

### Example Fluentd Config file
```bash
## $ echo <json> | fluent-cat <tag>
<source>
  @type forward
  @id forward_input
</source>

<match fluent.**>
  @type stdout
</match>

## match tag=test.** and send to rpz plugin(dev)
<match test.**>
  @type rpz
  # RPZ output plugin will send all the received records to this endpoint
  endpoint http://127.0.0.1:21847/flb
  # RPZ output plugin only supports buffered output for now. This section is
  # necessary
  <buffer>
    flush_interval 5s
  </buffer>
</match>
```

### To test this plugin an action...

1. Create an appropriate Application and ICApp on rapidomize cloud. 

2. Install `fluentd` gem
```sh
$ gem install fluentd
```

3. Start Fluentd with above sample configuration file in `fluent.conf` and `out_rapidomize.rb` in current directory
```sh
$ ls
fluent.conf 
out_rapidomize.rb

$ fluentd --config ./fluent.conf --plugin .
```

4. In another shell send messages to fluentd 
```sh
$ echo '{ "text": "Hello World 1" }' | fluent-cat test.default
$ echo '{ "text": "Hello World 2" }' | fluent-cat test.default
```
