import os
import json
import gnupg
import requests

API_FILE=".config/bitpass/key.gpg"

class BitWarden:
    def __init__(self):
        self.url_identity   = "https://identity.bitwarden.com"
        self.url_api        = "https://api.bitwarden.com"

        self.gpg = gnupg.GPG()
        self.gpg.encoding = 'utf-8'

        if os.path.isfile("/home/xenose/.config/bitpass/api-key.json.gpg"):
            self.key = {}
            self.key["api-key"]     = input("Enter the API key: ")
            self.key["email"]       = input("Enter the E-Mail Address: ")
        else:
            self.key = json.load(self.gpg.decrypt_file("/home/xenose/.config/bitpass/api-key.json.gpg"))

    def SyncData(self):
        r = requests.get(
            f"{self.url_identity}/connect/token",
            headers = {
                "access_token":     self.key["api-key"],
                "expires_in":       3600,
                "token_type":       "Bearer"
            }
        )

    def GeneratePassword(self):
        pass

    def CreateCredential(self):
        pass

    def GetPassword(self):
        pass

    def GetOTP(self):
        pass

    def GetUser(self):
        pass

    def GetEmail(self):
        pass

    def PrintFile(self):
        pass


def main():
    bit = BitWarden()

if "__main__" == __name__:
    main()
