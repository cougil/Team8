package com.schibsted.hackathons.example.topquotes.ribbon;

import com.netflix.hystrix.HystrixInvokableInfo;
import com.netflix.ribbon.hystrix.FallbackHandler;
import io.netty.buffer.ByteBuf;
import io.netty.buffer.Unpooled;
import rx.Observable;

import java.util.Map;

/**
 * Class to implement the action to be performed in Fallbacks.
 * In this case, return a standard "GOT_QUOTES service failed. No quote to return" in the "error" field.
 */
public class GotQuotesFallbackHandler implements FallbackHandler<ByteBuf> {

    private final static String DEFAULT_RESPONSE = "{\"error\":\"GOT_QUOTES service failed. No quote to return.\"}";

    @Override
    public Observable<ByteBuf> getFallback(HystrixInvokableInfo<?> hystrixInfo, Map<String, Object> requestProperties) {
        return Observable.just(Unpooled.wrappedBuffer(DEFAULT_RESPONSE.getBytes()));
    }
}
