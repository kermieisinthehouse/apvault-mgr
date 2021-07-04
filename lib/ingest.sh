#!/bin/bash

function ingest.rsyncImages () {
	fromPath=$(echo "$1" | sed 's:/*$::')
	toPath="$2"
	rsync -ahmP --remove-source-files --include='**/' --include='**/*.jpg' --include='**/*.JPG' \
		--include='**/*.png' --include='**/*.PNG' --include='**/*.jpeg' --include='**/*.JPEG' \
		--include='**/*.gif' --include='**/*.GIF' --exclude='*' "$fromPath" "$toPath";
	return $?
}

function ingest.ingestByPathInteractive () {
	targetPath="$1"
	vaultVideosPath="$2"
	vaultImagesPath="$3"

	# Check if vault paths exist, if not create
	if [[ -z "$vaultVideosPath" ]] || [[ -z "$vaultVideosPath" ]]; then
		echo "ERROR: APVault: Vault paths required."
		return 1;
	fi
	if [[ ! -d "$vaultVideosPath" ]]; then
		echo "WARNING: Video path ""$vaultVideosPath"" not found, creating"
		if mkdir -p "$vaultVideosPath"; then
			echo "ERROR: APVault: Could not create directory."
			return 1;
		fi
	fi
	if [[ ! -d "$vaultImagesPath" ]]; then
		echo "WARNING: Image path ""$vaultImagesPath"" not found, creating"
		if mkdir -p "$vaultImagesPath"; then
			echo "ERROR: APVault: Could not create directory."
			return 1;
		fi
	fi
	if [[ -z "$targetPath" ]] || [[ ! -d "$targetPath" ]]; then
		echo "ERROR: APVault: Path ""$targetPath"" not found."
		return 1;
	fi

	# prompt for vault-relative path, create if missing
	callDir="$(pwd)"
	cd "$vaultVideosPath" || return 1 # allow tab completion from vault path
	echo
	read -r -e -p "APVault: Where should we ingest this? (vault-relative, hit TAB): " VAULT_PATH
	VAULT_PATH="$VAULT_PATH"/
	mkdir -p "$vaultVideosPath"/"$VAULT_PATH" "$vaultImagesPath"/"$VAULT_PATH"

	echo "APVault: Ingesting files..."
	cd "$callDir" || return 1

	if [[ ! "$vaultVideosPath" = "$vaultImagesPath" ]]; then # if not using split directories, skip images step
		ingest.rsyncImages "$targetPath" "$vaultImagesPath"/"$VAULT_PATH"
		# delete now-empty folders
		find "$targetPath" -depth -type d -empty -delete
	fi
	# move everything else, use mv where possible
	mv -v --no-clobber "$targetPath" "$vaultVideosPath"/"$VAULT_PATH"

	if [[ -d "$targetPath" ]]; then
		#there are directory name conflicts, use rsync to copy what we can, leaving what we can't
		targetPathNoTrailingSlash=$(echo $targetPath | sed 's:/*$::')
		rsync -ahmP --remove-source-files "$targetPathNoTrailingSlash" "$vaultVideosPath"/"$VAULT_PATH";
		# delete now-empty folders
		find "$targetPath" -depth -type d -empty -delete
	fi
	echo
	echo "APVault: Finished ingesting."
}
