bring cloud;
bring http;
bring dynamodb;

let table = new dynamodb.Table(
  attributes: [
    {
      name: "id",
      type: "S"

    }
  ],
  hashKey: "id"
);

table.setStreamConsumer(inflight (record) => {
  log("record processed = " + Json.stringify(record));
});

let api = new cloud.Api();

api.get("/", inflight (req) => {
  return {
    status: 200,
    headers: { "Content-Type": "text/html" },
    body: "<html><body><h1>Hello, world!</h1></body></html>"
  };
});

api.post("/greet/:name", inflight (req) => {
  let name = req.vars.get("name");
  let var message = "Hello, {name}!";  // using var to allow reassignment

  if let _ = req.query.tryGet("all-caps") {
    message = message.uppercase();
  }

  table.put(
    Item: {
      id: name,
      message: message
    }
  );

  return {
    status: 200,
    body: message,
  };
});

test "POST /greet/:name" {
  let res = http.post("{api.url}/greet/world", body: "Hello, world!");
  assert(res.status == 200);
  assert(res.body == "Hello, world!");
}

test "POST /greet/:name?all-caps" {
  let res = http.post("{api.url}/greet/world?all-caps", body: "Hello, world!");
  assert(res.status == 200);
  assert(res.body == "HELLO, WORLD!");
}

test "DynamoDB put and query" {
  table.put(
    Item: {
      id: "test-id",
      body: "hello"
    }
  );
  let response = table.query(
    KeyConditionExpression: "id = :id",
    ExpressionAttributeValues: {":id": "test-id"}
  );
  assert(response.Count == 1);
  assert(response.Items[0]["id"].asStr() == "test-id");
  assert(response.Items[0]["body"].asStr() == "hello");
}