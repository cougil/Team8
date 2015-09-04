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
public interface GotQuotesRibbonClient {

    public RibbonRequest<ByteBuf> triggerGetQuote(String quoteId);

    public RibbonRequest<ByteBuf> triggerGetRandomQuote();

    public RibbonRequest<ByteBuf>  triggerGetTopQuote();
}


