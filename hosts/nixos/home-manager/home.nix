{ config, pkgs, ... }:

{
	programs.home-manager.enable = true;

	home.username = "sid";
	home.homeDirectory = "/home/sid";
	home.stateVersion = "24.11";

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		historySubstringSearch.enable = true;

		"oh-my-zsh" = {
			enable = true;
			plugins = [
				"git"
				"fzf"
				"docker"
				"kubectl"
				"vi-mode"
				"history-substring-search"
			];
			custom = "${config.home.homeDirectory}/.oh-my-zsh/custom";
			theme = "powerlevel10k/powerlevel10k";
		};

		shellAliases = {
			ll = "ls -lh";
			la = "ls -lha";
			gs = "git status -sb";
			gl = "git log --oneline --graph --decorate";
			gp = "git pull --rebase --autostash && git push";
			k = "kubectl";
			v = "nvim";
			".." = "cd ..";
			"..." = "cd ../..";
		};

		envExtra = ''
  			export ZSH_DISABLE_COMPFIX=true
		'';

		initExtra = ''

			# Auto-launch tmux
   			if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
   				tmux attach -t default || tmux new -s default
   			fi

  			# User-overrides: put your custom Zsh config in ~/.zshrc.local
  			[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local

  			export EDITOR=nvim
  			[[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
		'';
	};

	home.file.".oh-my-zsh/custom/themes/powerlevel10k".source = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";

	programs.fzf = {
		enable = true;
		enableZshIntegration = true;
	};

	programs.zoxide = {
		enable = true;
		enableZshIntegration = true;
	};

	home.packages = with pkgs; [
		zsh-powerlevel10k
		fzf
		zoxide
		bat
		ripgrep
		fd
		git
		delta
		nerdfonts
		tmux
	];

	programs.direnv = {
		enable = true;
		nix-direnv.enable = true;
	};

	fonts.fontconfig.enable = true;

	services.udiskie = {
		enable = true;
		settings = {
			# workaround for
			# https://github.com/nix-community/home-manager/issues/632
			program_options = {
				# replace with your favorite file manager
				file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
			};
		};
	};

	# Ensure npm global installs are in a user-writable prefix and on PATH
	home.sessionVariables = {
		NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
		NPM_CONFIG_CACHE = "${config.home.homeDirectory}/.cache/npm";
	};

	home.sessionPath = [
		"${config.home.homeDirectory}/.npm-global/bin"
	];
}

