package main

import (
//	"crypto/tls"
	"fmt"
	"net/http"
	"io/ioutil"
        "os"
)

func main() {
        if len(os.Args) < 2 {
		fmt.Println("Usage: ", os.Args[0] , "<url>")
		return
	}

	// Extract URL from command line argument
	url := os.Args[1]



	// Custom Transport to handle insecure SSL certificates (for demo purposes)
	tr := &http.Transport{
		//TLSClientConfig: &tls.Config{InsecureSkipVerify: false},
	}

	// Make the GET request with the custom Transport
	client := &http.Client{Transport: tr}
	response, err := client.Get(url)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}
	defer response.Body.Close()

	// Check if the certificate is trusted
	if response.TLS != nil && len(response.TLS.PeerCertificates) > 0 {
		fmt.Println("Certificate is trusted.")
	} else {
		fmt.Println("Certificate is not trusted (self-signed or invalid).")
	}

	// Read the response body
	body, err := ioutil.ReadAll(response.Body)
	if err != nil {
		fmt.Println("Error reading response body:", err)
		return
	}

	// Print the response status code and body
	fmt.Println("Response Status Code:", response.Status)
	fmt.Println("Response Body:", string(body))
}

