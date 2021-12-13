# Iterate through each of the zsh rc files and source each of them
for config_file in ${ZSH_RC_FILES}; do
	source "${config_file}"
done

unset config_file
