# ResKeyMod

This Kong plugin enables you to change the names of keys in JSON response body.

## Trying the plugin

Install the plugin according to the documentation of Kong.
https://docs.konghq.com/0.10.x/plugin-development/distribution/#installing-the-plugin

#### Create a service and route

```
curl -X POST --url http://localhost:8001/services/ --data 'name=example-service' --data 'url=https://jsonplaceholder.typicode.com/todos/1'
curl -i -X POST --url http://localhost:8001/services/example-service/routes --data 'paths[]=/test'
```

#### Enabling the plugin

```
curl -X POST --url http://localhost:8001/services/example-service/plugins/ --data 'name=reskeymod' --data "config.rename_body_key.json=userId:uID" --data "config.rename_body_key.json=com
pleted:done" 

```

#### Original response

```
curl -X GET --url http://localhost:8000/test | jq

{
  "userId": 1,
  "id": 1,
  "title": "delectus aut autem",
  "completed": false
}

```

#### Modified response

```
curl -X GET "http://localhost:8000/test" | jq

{
  "done": false,
  "title": "delectus aut autem",
  "uID": 1,
  "id": 1
}

```