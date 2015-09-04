# Top Quotes microservice in Java

## Description
    
A very simple microservice that uses GoT Quotes microservices to get the most returned quote.

### Get trending quote 


```
GET /api/quote/trending
```

Response:

```
{
	"trend_quote": STRING,
	"counter": INTEGER
}
```

