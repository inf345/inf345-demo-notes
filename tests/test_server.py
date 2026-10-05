import sys, os, threading, unittest, urllib.request, urllib.error
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "src"))
from server import make_server


class TestService(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.srv = make_server(0)
        cls.port = cls.srv.server_address[1]
        threading.Thread(target=cls.srv.serve_forever, daemon=True).start()

    @classmethod
    def tearDownClass(cls):
        cls.srv.shutdown()

    def get(self, path):
        try:
            with urllib.request.urlopen(f"http://127.0.0.1:{self.port}{path}") as r:
                return r.status, r.read().decode()
        except urllib.error.HTTPError as e:
            return e.code, ""

    def test_root_answers(self):
        self.assertEqual(self.get("/")[0], 200)

    def test_healthz_is_ok(self):
        status, body = self.get("/healthz")
        self.assertEqual(status, 200)
        self.assertTrue(body.strip())

    def test_notes_counts_three(self):
        self.assertEqual(self.get("/notes")[1], "3")
