import json
import sys

import requests


def getPackageName(packages_info, map):
    if map == "exact":
        return packages_info["results"]["exact"]["name"]
    return packages_info["results"][map][0]["name"]


if len(sys.argv) < 2:
    print("Usage: python3 searchDebianPackageDownloader.py <package_name>")
    sys.exit(1)

original_package_name = sys.argv[1]
search_url = f"https://sources.debian.org/api/search/{original_package_name}/"

response = requests.get(search_url)
packages_info = json.loads(response.text)

if packages_info["results"]["exact"]:
    package_name = getPackageName(packages_info, "exact")
else:
    package_name = getPackageName(packages_info, "other")

version_url = f"https://sources.debian.org/api/src/{package_name}/latest/"
version_response = requests.get(version_url)
version_info = json.loads(version_response.text)
latest_version = version_info["version"]

download_url = f"https://ftp.us.debian.org/debian/pool/main/{package_name[0]}/{package_name}/{original_package_name}_{latest_version}_amd64.deb"
print(download_url)
