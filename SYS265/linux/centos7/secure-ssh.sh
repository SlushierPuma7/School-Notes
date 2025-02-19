#Secure-ssh.sh
#author SlushierPuma7
#creates a new ssh user using $1 parameter
#adds a public key from the local repo or curled from the remote repo
#removes roots ability to ssh in

if [ -z "$1" ]; then
	echo "usage: $0 <username>"
	exit 1
fi

USERNAME="$1"
USER_HOME="/home/$USERNAME"
SSH_DIR="$USER_HOME/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
PUBLIC_KEY_PATH="/home/School-Notes/SYS265/linux/public-keys/id_rsa.pub"

sudo useradd -m -d "$USER_HOME" -s /bin/bash "$USERNAME"

sudo mkdir -p "$SSH_DIR"
sudo chmod 700 "$SSH_DIR"

if [ -f "$PUBLIC_KEY_PATH" ]; then
	sudo cp "$PUBLIC_KEY_PATH" "$AUTHORIZED_KEYS"
elif command -v curl &>/dev/null; then
	sudo curl -o "$AUTHORIZED_KEYS" "https://raw.githubusercontent.com/SlushierPuma7/School-Notes/refs/heads/main/SYS265/linux/public-keys/id_rsa.pub"
else
	echo "Error: Public key not found locally and curl is not installed."
	exit 1
fi

sudo sed -i 's/^PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config

sudo systemctl restart sshd

echo "User $USERNAME created successfully with SSH key authentication only"
