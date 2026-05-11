import subprocess
import base64
import os
import sys

# Usage: python3 fdr_signer.py <input_xml> <fdr_key>
def sign_and_generate_plist(xml_path, key_path):
    if not os.path.exists(xml_path) or not os.path.exists(key_path):
        print("[-] Error: Input file or key not found.")
        return

    sig_out = "payloads/temp.sig"
    
    print(f"[*] Signing {xml_path}...")
    try:
        # Generate detached SHA256 signature
        subprocess.run([
            "openssl", "dgst", "-sha256", "-sign", key_path,
            "-out", sig_out, xml_path
        ], check=True)

        with open(sig_out, "rb") as f:
            sig_data = base64.b64encode(f.read()).decode()

        print("[+] Signature generated (Base64):")
        print(f"\n{sig_data}\n")
        print("[*] Inject this into your <data> field in the final activation plist.")

    except Exception as e:
        print(f"[-] Error: {e}")
    finally:
        if os.path.exists(sig_out):
            os.remove(sig_out)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 fdr_signer.py <input_xml> <fdr_key>")
    else:
        sign_and_generate_plist(sys.argv[1], sys.argv[2])
