package main

import (
	"crypto/tls"
	"crypto/x509"
	"log"
	"net/http"
	"os"
)

func main() {
	caCert, err := os.ReadFile("dod_ca.pem")
	if err != nil {
		log.Fatalf("Reading CA certificate: %v", err)
	}

	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	server := &http.Server{
		Addr: ":9443",
		TLSConfig: &tls.Config{
			ClientCAs:  caCertPool,
			ClientAuth: tls.RequireAndVerifyClientCert,
		},
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// Return "Hello World!" to the visitor
		w.Header().Set("Content-Type", "text/plain")
		w.WriteHeader(http.StatusOK) // HTTP 200
		w.Write([]byte("Hello World!"))
	})

	log.Printf("Starting server on https://localhost:9443")
	err = server.ListenAndServeTLS("cert.pem", "key.pem")
	if err != nil {
		log.Fatalf("Starting server: %v", err)
	}
}
