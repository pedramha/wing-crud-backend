bring cloud;
bring util;
bring http;
bring expect;
bring dynamodb;

let messagesTable = new dynamodb.Table(
  attributes: [
    {
      name: "id",
      type: "S"
    }
  ],
  hashKey: "id"
);

let api = new cloud.Api();

let messageCounter = new cloud.Counter();

api.post("/messages", inflight (request) => {
  let newMessage = Json{
    id: messageCounter.inc(),
    message: request.body
  };
  log("New message: {Json.stringify(newMessage)}");

  let recordId = messageCounter.inc();
  messagesTable.put(
    Item: {
      id: Json.stringify(recordId),
      message: newMessage
    }
  );
  return {
    status: 200,
    headers: {
      "Content-Type" => "text/html",
      "Access-Control-Allow-Origin" => "*",
    },
    body: Json.stringify(newMessage),
  };
});

api.put("/messages", inflight (request) => {
  let messageId = request.vars.get("id");
  if let req = Json.tryParse(request.body) {
    let updatedMessage = Json{
      id: messageId,
      message: req.get("message").asStr()
    };
    messagesTable.update(
      Key: {
        id: messageId
      },
      UpdateExpression: "SET message = :message",
      ExpressionAttributeValues: {
        ":message": updatedMessage.get("message")
      }
    );
    log("Updated message: {Json.stringify(updatedMessage)}");
    return cloud.ApiResponse {
      status: 200,
      headers: {
        "Content-Type" => "application/json"
      },
      body: Json.stringify(updatedMessage)
    };
  }
});

api.get("/messages",
  inflight (request: cloud.ApiRequest): cloud.ApiResponse => {
    return cloud.ApiResponse{
      status: 200,
      headers: {
        "Content-Type" => "application/json"
      },
      body: Json.stringify(messagesTable.scan().Items)
    };
  }
);

api.delete("/messages",
  inflight (request: cloud.ApiRequest): cloud.ApiResponse => {
    let messageId = request.query.tryGet("id");
    log("Deleting message with id: {Json.stringify(messageId)}");
    if messageId == nil {
      return cloud.ApiResponse {
        status: 400,
        headers: {
          "Content-Type" => "text/plain"
        },
        body: "Missing id parameter"
      };
    }
    messagesTable.delete(Key: { id: messageId });
    return cloud.ApiResponse {
      status: 200,
      headers: {
        "Content-Type" => "text/plain"
      },
      body: "Deleted {Json.stringify(messageId)}"
    };
  }
);

let validateResponse = inflight(response: http.Response, expectedContent: str) => {
  log("Response status: {response.status}");
  expect.equal(response.status, 200);
  assert(response.body?.contains(expectedContent) == true);
};

test "messages API returns correct response" {
  let response = http.post("{api.url}/messages", {
    body: "xyz",
  });
  log("Response body: {response.body}");
  assert(response.body?.contains("xyz") == true);
}