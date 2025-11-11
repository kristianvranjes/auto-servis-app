package com.havana.backend.configuration;

import com.havana.backend.service.CustomOAuth2UserService;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
public class SecurityConfig {

    @Value("${FRONTEND_URL}")
    private String frontendUrl;

    private final CustomOAuth2UserService customOAuth2UserService;

    public SecurityConfig(CustomOAuth2UserService customOAuth2UserService) {
        this.customOAuth2UserService = customOAuth2UserService;
    }

    private String getNormalizedFrontendUrl() {
        // Ensure frontendUrl has protocol (Render may provide host without protocol)
        if (!frontendUrl.startsWith("http://") && !frontendUrl.startsWith("https://")) {
            return "https://" + frontendUrl;
        }
        return frontendUrl;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

        http
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .csrf(AbstractHttpConfigurer::disable)
        .authorizeHttpRequests(auth -> auth
            // Require authentication only for creating a new Nalog (reservation).
            // Allow anonymous access to other API endpoints (GET /api/...) so
            // unauthenticated users can view services, marks, models, etc.
            .requestMatchers(HttpMethod.POST, "/api/nalog").authenticated()
            .requestMatchers("/", "/health", "/api/**").permitAll()
            .anyRequest().authenticated()
        )
                .oauth2Login(oauth2 -> oauth2
                        .userInfoEndpoint(userInfo -> userInfo.userService(customOAuth2UserService))
                        .defaultSuccessUrl(getNormalizedFrontendUrl(), true)
                )
                .logout(logout -> logout
                        .logoutSuccessUrl(getNormalizedFrontendUrl())
                        .deleteCookies("JSESSIONID")
                );

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowCredentials(true);
        // Ensure frontendUrl has protocol (Render may provide host without protocol)
        String normalizedFrontendUrl = frontendUrl;
        if (!normalizedFrontendUrl.startsWith("http://") && !normalizedFrontendUrl.startsWith("https://")) {
            normalizedFrontendUrl = "https://" + normalizedFrontendUrl;
        }
        configuration.setAllowedOrigins(List.of(normalizedFrontendUrl));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setExposedHeaders(List.of("Authorization", "Content-Type"));

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
