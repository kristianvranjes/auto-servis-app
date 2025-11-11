package com.havana.backend;

import io.github.cdimascio.dotenv.Dotenv;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class BackendApplication {

    public static void main(String[] args) {

        // Check if we're running in Docker or on Render (which sets environment variables directly)
        // Only load .env file for local development
        boolean isDocker = "true".equals(System.getenv("DOCKER_ENV"));
        boolean isRender = System.getenv("RENDER") != null || System.getenv("RENDER_SERVICE_NAME") != null;
        
        if (!isDocker && !isRender) {
            // Local development - try to load .env file
            try {
                Dotenv dotenv = Dotenv.load();
                dotenv.entries().forEach(entry ->
                        System.setProperty(entry.getKey(), entry.getValue())
                );
                System.out.println("Loaded .env file for local environment");
            } catch (Exception e) {
                System.out.println("No .env file found - using environment variables and defaults");
            }
        } else if (isRender) {
            System.out.println("Running on Render - using environment variables from dashboard");
        } else {
            System.out.println("Running inside Docker - using environment variables");
        }

        // Construct JDBC URL from individual database properties if needed
        String datasourceUrl = System.getProperty("spring.datasource.url");
        if (datasourceUrl == null || datasourceUrl.isEmpty() || !datasourceUrl.startsWith("jdbc:")) {
            String host = System.getenv("SPRING_DATASOURCE_HOST");
            String port = System.getenv("SPRING_DATASOURCE_PORT");
            String database = System.getenv("SPRING_DATASOURCE_DATABASE");
            String urlEnv = System.getenv("SPRING_DATASOURCE_URL");
            
            // If SPRING_DATASOURCE_URL is set and valid, use it
            if (urlEnv != null && !urlEnv.isEmpty() && urlEnv.startsWith("jdbc:")) {
                System.setProperty("spring.datasource.url", urlEnv);
            } 
            // Otherwise, construct from individual properties
            else if (host != null && !host.isEmpty() && database != null && !database.isEmpty()) {
                if (port == null || port.isEmpty()) {
                    port = "5432";
                }
                String jdbcUrl = String.format("jdbc:postgresql://%s:%s/%s", host, port, database);
                System.setProperty("spring.datasource.url", jdbcUrl);
                System.out.println("Constructed JDBC URL from individual properties: " + jdbcUrl.replaceAll(":[^:@]+@", ":****@"));
            }
        }

        SpringApplication.run(BackendApplication.class, args);

    }
}
