package com.schibsted.hackathons.example.topquotes;

import com.google.inject.Singleton;
import com.netflix.governator.annotations.Modules;
import com.schibsted.hackathons.example.topquotes.common.LoggingInterceptor;
import com.schibsted.hackathons.example.topquotes.common.auth.AuthenticationService;
import com.schibsted.hackathons.example.topquotes.common.health.HealthCheck;
import com.schibsted.hackathons.example.topquotes.endpoints.TopQuotesController;
import com.schibsted.hackathons.example.topquotes.ribbon.GotQuotesRibbonClient;
import com.schibsted.hackathons.example.topquotes.common.auth.AuthenticationServiceImpl;
import com.schibsted.hackathons.example.topquotes.ribbon.GotQuotesRibbonClientImpl;
import netflix.adminresources.resources.KaryonWebAdminModule;
import netflix.karyon.KaryonBootstrap;
import netflix.karyon.ShutdownModule;
import netflix.karyon.archaius.ArchaiusBootstrap;
import netflix.karyon.eureka.KaryonEurekaModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import scmspain.karyon.restrouter.KaryonRestRouterModule;


@ArchaiusBootstrap
@KaryonBootstrap(name = "AppServer", healthcheck = HealthCheck.class)
@Singleton
@Modules(include = {
        ShutdownModule.class,
        KaryonWebAdminModule.class,
        KaryonEurekaModule.class,
        AppServer.KaryonRestRouterModuleImpl.class,
})
public interface AppServer {
    class KaryonRestRouterModuleImpl extends KaryonRestRouterModule {

        static final int DEFAULT_PORT = 8080;
        static final int DEFAULT_THREADS = 50;

        private static final Logger LOGGER = LoggerFactory.getLogger(KaryonRestRouterModuleImpl.class);

        public KaryonRestRouterModuleImpl() {
            super();
        }

        @Override
        protected void configureServer() {
            server().port(DEFAULT_PORT).threadPoolSize(DEFAULT_THREADS);
        }

        @Override
        public void configure() {
            bind(GotQuotesRibbonClient.class).to(GotQuotesRibbonClientImpl.class);
            bind(AuthenticationService.class).to(AuthenticationServiceImpl.class);
            interceptorSupport().forUri("/*").intercept(LoggingInterceptor.class);
            bind(TopQuotesController.class).asEagerSingleton();
            super.configure();
        }
    }
}