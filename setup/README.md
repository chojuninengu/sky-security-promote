# Victim Agent Setup

## 1. Run the container

```bash
docker run -d \
  --name wazuh-agent \
  --restart unless-stopped \
  -e WAZUH_MANAGER=10.165.230.16 \
  -v "$(pwd)/volumes/wazuh-agent/sslagent.key:/var/ossec/etc/sslagent.key" \
  -v "$(pwd)/volumes/wazuh-agent/sslagent.cert:/var/ossec/etc/sslagent.cert" \
  -v "$(pwd)/volumes/suricata/nmap-detection.rules:/opt/wazuh/suricata/var/lib/suricata/rules/nmap-detection.rules" \
  -p 2222:22 \
  -p 1514:1514 \
  -p 1515:1515 \
  --cap-add NET_ADMIN \
  --cap-add NET_RAW \
  --privileged \
  ghcr.io/t-desmond/wazuh-suricata-container:latest
```

## 2. Get the victim container's IP and user

```bash
# Get the container's IP address
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' wazuh-agent

# Get the container's default user
docker exec wazuh-agent whoami
```

These are used as `-t <IP>` and `-u <USER>` when running `run_attacks.sh`.

## 3. Install attack tools on the attacker endpoint

```bash
sudo bash setup/install-nmap-hydra.sh
```
