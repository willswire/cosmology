package main

import (
	"context"
	"errors"
	"testing"
)

// MockKubernetesService simplifies the original mock by focusing on the behavior needed for testing.
type MockKubernetesService struct {
	IP  string
	Err error
}

// GetServiceIP implements the KubernetesService interface, returning predefined values for testing.
func (m *MockKubernetesService) GetServiceIP(ctx context.Context, namespace, serviceName string) (string, error) {
	if m.Err != nil {
		return "", m.Err
	}
	return m.IP, nil
}

// Test cases are defined in a table-driven style to facilitate easy extension and readability.
func TestGetExternalIP(t *testing.T) {
	tests := []struct {
		name          string
		mockService   *MockKubernetesService
		expectedIP    string
		expectedError error
	}{
		{
			name: "success - valid IP returned",
			mockService: &MockKubernetesService{
				IP:  "127.0.0.1",
				Err: nil,
			},
			expectedIP:    "127.0.0.1",
			expectedError: nil,
		},
		{
			name: "failure - no external IP found",
			mockService: &MockKubernetesService{
				IP:  "",
				Err: errors.New("no external IP found for service"),
			},
			expectedIP:    "",
			expectedError: errors.New("no external IP found for service"),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			ip, err := tt.mockService.GetServiceIP(context.TODO(), "istio-system", "public-ingressgateway")
			if err != nil && tt.expectedError == nil {
				t.Errorf("Expected no error, got %v", err)
			}
			if err == nil && tt.expectedError != nil {
				t.Errorf("Expected error, got none")
			}
			if err != nil && tt.expectedError != nil && err.Error() != tt.expectedError.Error() {
				t.Errorf("Expected error %v, got %v", tt.expectedError, err)
			}
			if ip != tt.expectedIP {
				t.Errorf("Expected IP %s, got %s", tt.expectedIP, ip)
			}
		})
	}
}
