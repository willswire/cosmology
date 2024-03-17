package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"

	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/rest"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

type CloudflareResponse struct {
	Result []struct {
		ID string `json:"id"`
	} `json:"result"`
}

type DNSRecord struct {
	Type    string `json:"type"`
	Name    string `json:"name"`
	Content string `json:"content"`
	Proxied bool   `json:"proxied"`
	Comment string `json:"comment"`
}

func main() {
	zoneID := os.Getenv("ZONE_ID")
	authKey := os.Getenv("AUTH_KEY")

	if zoneID == "" || authKey == "" {
		fmt.Println("Error: ZONE_ID and AUTH_KEY must be set.")
		os.Exit(1)
	}

	config, err := rest.InClusterConfig()
	if err != nil {
		panic(err.Error())
	}
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}

	for {
		ip, err := getExternalIP(clientset)
		if err != nil || ip == "" {
			fmt.Println("Failed to retrieve IP. Retrying after 60 seconds...", err)
			time.Sleep(60 * time.Second)
			continue
		}

		updateOrCreateDNSRecord(ip, "tatooine.dev", zoneID, authKey)
		updateOrCreateDNSRecord(ip, "*.tatooine.dev", zoneID, authKey)

		fmt.Println("Cosmology Update:", time.Now().Format("2006-01-02 15:04:05"))
		time.Sleep(600 * time.Second)
	}
}

func getExternalIP(clientset *kubernetes.Clientset) (string, error) {
	service, err := clientset.CoreV1().Services("istio-system").Get(context.TODO(), "public-ingressgateway", metav1.GetOptions{})
	if err != nil {
		return "", err
	}

	if len(service.Status.LoadBalancer.Ingress) > 0 {
		return service.Status.LoadBalancer.Ingress[0].IP, nil
	}
	return "", fmt.Errorf("no external IP found for service")
}

func updateOrCreateDNSRecord(ip, name, zoneID, authKey string) {
	recordID := getDNSRecordID(name, zoneID, authKey)
	data := DNSRecord{
		Type:    "A",
		Name:    name,
		Content: ip,
		Proxied: true,
		Comment: "Cosmology Update: " + time.Now().Format("2006-01-02 15:04:05"),
	}

	jsonData, err := json.Marshal(data)
	if err != nil {
		fmt.Println("Error marshaling JSON:", err)
		return
	}

	var url string
	var method string

	if recordID != "" {
		url = fmt.Sprintf("https://api.cloudflare.com/client/v4/zones/%s/dns_records/%s", zoneID, recordID)
		method = "PUT"
	} else {
		url = fmt.Sprintf("https://api.cloudflare.com/client/v4/zones/%s/dns_records", zoneID)
		method = "POST"
	}

	req, err := http.NewRequest(method, url, bytes.NewBuffer(jsonData))
	if err != nil {
		fmt.Println("Error creating request:", err)
		return
	}

	req.Header.Set("Authorization", "Bearer "+authKey)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error sending request:", err)
		return
	}
	defer resp.Body.Close()

	if resp.StatusCode >= 200 && resp.StatusCode <= 299 {
		fmt.Printf("DNS record %s for IP %s updated/created successfully\n", name, ip)
	} else {
		fmt.Printf("Failed to update/create DNS record: %s\n", resp.Status)
	}
}

func getDNSRecordID(name, zoneID, authKey string) string {
	url := fmt.Sprintf("https://api.cloudflare.com/client/v4/zones/%s/dns_records?type=A&name=%s", zoneID, name)
	req, _ := http.NewRequest("GET", url, nil)
	req.Header.Set("Authorization", "Bearer "+authKey)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error sending request:", err)
		return ""
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return ""
	}

	var response CloudflareResponse
	err = json.Unmarshal(body, &response)
	if err != nil {
		fmt.Println("Error unmarshaling JSON:", err)
		return ""
	}

	if len(response.Result) > 0 {
		return response.Result[0].ID
	}

	return ""
}
