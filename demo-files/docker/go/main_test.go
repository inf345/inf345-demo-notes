package main

import (
	"io"
	"net/http"
	"net/http/httptest"
	"testing"
)

func get(t *testing.T, path string) (int, string) {
	srv := httptest.NewServer(Handler())
	defer srv.Close()
	res, err := http.Get(srv.URL + path)
	if err != nil {
		t.Fatal(err)
	}
	defer res.Body.Close()
	b, _ := io.ReadAll(res.Body)
	return res.StatusCode, string(b)
}

func TestRootAnswers(t *testing.T) {
	if code, _ := get(t, "/"); code != 200 {
		t.Fatalf("got %d", code)
	}
}

func TestHealthzIsOk(t *testing.T) {
	code, body := get(t, "/healthz")
	if code != 200 || body == "" {
		t.Fatalf("got %d %q", code, body)
	}
}

func TestNotesCountsThree(t *testing.T) {
	if _, body := get(t, "/notes"); body != "3" {
		t.Fatalf("got %q", body)
	}
}
