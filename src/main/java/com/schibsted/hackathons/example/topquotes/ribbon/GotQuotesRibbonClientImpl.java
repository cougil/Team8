package com.schibsted.hackathons.example.topquotes.ribbon;

import com.netflix.ribbon.Ribbon;
import com.netflix.ribbon.RibbonRequest;
import com.netflix.ribbon.http.HttpRequestTemplate;
import com.netflix.ribbon.http.HttpResourceGroup;
import io.netty.buffer.ByteBuf;

/**
 * Ribbon client which creates the client balancer,
 * specify the endpoint from the remote service to be accessed and wraps the calls to that service.
 */
public class GotQuotesRibbonClientImpl implements GotQuotesRibbonClient {

    private final HttpResourceGroup httpResourceGroup;
    private final HttpRequestTemplate<ByteBuf> gotQuotesTemplate;

    public GotQuotesRibbonClientImpl() {

        // Creation of the client balancer
        // ClientOptions properties are set using the ones defined in AppServer.properties
        httpResourceGroup = Ribbon.createHttpResourceGroup("got-quotes-service-client");

        // Client endpoint definition
        gotQuotesTemplate = httpResourceGroup.newTemplateBuilder("gotQuotesTemplate", ByteBuf.class)
                .withMethod("GET")
                .withUriTemplate("/api/quote/{action}")
                .withFallbackProvider(new GotQuotesFallbackHandler()).build();
    }

    public RibbonRequest<ByteBuf> triggerGetQuote(String quoteId) {
        return gotQuotesTemplate.requestBuilder()
                        .withRequestProperty("action", quoteId)
                        .build();
    }

    public RibbonRequest<ByteBuf> triggerGetRandomQuote() {
        return gotQuotesTemplate.requestBuilder()
                        .withRequestProperty("action", "random")
                        .build();
    }

    public RibbonRequest<ByteBuf>  triggerGetTopQuote() {
        return gotQuotesTemplate.requestBuilder()
                        .withRequestProperty("action", "top")
                        .build();
    }
}


