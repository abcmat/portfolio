# Function to install gpg4win using chocolatey
function installGPG {
    # Check if chocolatey is installed
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Chocolatey package manager is required but not found. Please install chocolatey first."
        exit 1
    }
    
    # Install gpg4win using chocolatey
    choco install gpg4win -y
}

# Function to setup gpg and generate a key
function setupGPG {
    # Generate a gpg key
    & 'C:\Program Files (x86)\GnuPG\bin\gpg.exe' --generate-key

    # Prompt for user information
    $name = Read-Host "Enter your name (e.g. John Doe)"
    $email = Read-Host "Enter your email address"

    # Set user details
    & 'C:\Program Files (x86)\GnuPG\bin\gpg.exe' --batch --gen-key -<<EOF
    %echo Generating a standard key
    Key-Type: RSA
    Key-Length: 2048
    Subkey-Type: RSA
    Subkey-Length: 2048
    Name-Real: $name
    Name-Email: $email
    Expire-Date: 0
    %commit
    %echo done
EOF
}

# Function to backup files
function backup {
    # Iterate through all files in the source folder
    Get-ChildItem -Path ".\source" | ForEach-Object {
        $sourceFile = $_.FullName
        $backupFile = ".\backup\$($_.Name).gpg"
        
        # Encrypt the file using gpg
        & 'C:\...\bin\gpg.exe' --output $backupFile --encrypt --recipient $email $sourceFile
    }
}

# Function to restore files
function restore {
    # Iterate through all files in the backup folder
    Get-ChildItem -Path ".\backup" | ForEach-Object {
        $backupFile = $_.FullName
        $restoredFile = ".\restored\$($_.Name -replace '\.gpg$','')"
        
        # Decrypt and save the file to the restored folder
        & 'C:\...\bin\gpg.exe' --output $restoredFile --decrypt $backupFile
    }
}

# Main script logic
if ($args[0] -eq "installGPG") {
    installGPG
} elseif ($args[0] -eq "setupGPG") {
    setupGPG
} elseif ($args[0] -eq "backup") {
    backup
} elseif ($args[0] -eq "restore") {
    restore
} else {
    Write-Host "Invalid command line argument. Please use 'installGPG', 'setupGPG', 'backup', or 'restore'."
}