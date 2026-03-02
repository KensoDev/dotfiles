{ pkgs, ... }:

let isDarwin = pkgs.stdenv.hostPlatform.system == "x86_64-darwin";

in {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      set-option -a terminal-overrides ",*256col*:RGB"
      #
      # Setting the prefix from C-b to C-s
      set -g prefix C-a
      set-option -g default-command "reattach-to-user-namespace -l zsh"
      
      # Free the original Ctrl-b prefix keybinding
      unbind C-b
      #setting the delay between prefix and command
      set -sg escape-time 1
      # Ensure that we can send Ctrl-S to other apps
      bind C-s send-prefix
      # Set the base index for windows to 1 instead of 0
      set -g base-index 1
      # Set the base index for panes to 1 instead of 0
      setw -g pane-base-index 1
      # splitting panes
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # Reload the file with Prefix r
      bind R source-file ~/.tmux.conf \; display "Reloaded!"
      bind r command-prompt -I "#W" "rename-window '%%'"
      
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Moving between windows, gnome-terminal style
      bind -n C-PgUp select-window -t :-
      bind -n C-PgDn select-window -t :+

      bind Right select-window -t :-
      bind Left select-window -t :+

      # Direct window navigation - prompt for window number (supports 10, 11, etc.)
      bind g command-prompt -p "Go to window:" "select-window -t '%%'"
      
      # open new window gnome-terminal style
      bind -n C-T new-window -c "#{pane_current_path}"
      set-window-option -g xterm-keys on
      
      # move windows forward and backwards, gnome-terminal style
      bind-key -n C-S-Left swap-window -t -1
      bind-key -n C-S-Right swap-window -t +1

      # use the mouse (modern tmux syntax)
      set -g mouse on
      
      # use vim-bindings for copying and pasting text
      unbind [
      bind Escape copy-mode
      
      # use vim-bindings for copying and pasting text
      unbind [
      bind Escape copy-mode
      unbind p
      
      bind-key -Tcopy-mode-vi 'v' send -X begin-selection
      bind-key -Tcopy-mode-vi 'y' send -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"
      
      bind y run 'tmux save-buffer - | reattach-to-user-namespace pbcopy '
      bind C-y run 'tmux save-buffer - | reattach-to-user-namespace pbcopy '
      
      
      #unbind p
      #bind p run "xclip -o | tmux load-buffer - ; tmux paste-buffer"
      #bind-key -t vi-copy 'v' begin-selection
      ## see http://unix.stackexchange.com/questions/131011/use-system-clipboard-in-vi-copy-mode-in-tmux
      #bind-key -t vi-copy 'y' save-buffer
      #bind -t vi-copy y copy-pipe 'xclip -i'
      #bind -t vi-copy V rectangle-toggle
      
      # end corentin
      
      # Pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5
      # Set the default terminal mode to 256color mode
      set -g default-terminal "screen-256color"
      # enable activity alerts
      setw -g monitor-activity on
      set -g visual-activity on
      set -g bell-action any
      set -g visual-bell off

      # OSX notification support for window activity
      set-hook -g alert-activity 'run-shell "terminal-notifier -title \"tmux: #{session_name}\" -subtitle \"Activity in window #{window_index}\" -message \"#{window_name}\" -group tmux-activity -sound default"'
      set-hook -g alert-bell 'run-shell "terminal-notifier -title \"tmux: #{session_name}\" -subtitle \"Bell in window #{window_index}\" -message \"#{window_name}\" -group tmux-bell -sound default"'

      # Also trigger notifications on any output in non-active windows
      set-hook -g after-new-window 'setw -g monitor-activity on'
      set-hook -g after-split-window 'setw -g monitor-activity on'

      # Dracula theme will handle colors, but keep dim inactive panes setting
      set -g window-style 'fg=colour247,bg=colour236'
      set -g window-active-style 'fg=colour250,bg=black'
      # Status line left side
      set -g status-left-length 40
      set -g status-left "#[fg=green]Session: #S #[fg=yellow]#I #[fg=cyan]#P"
      # Status line right side
      # 15% | 28 Nov 18:15
      #set -g status-right "#(~/battery Discharging) | #[fg=cyan]%d %b %R"
      # Center the window list
      set -g status-justify centre
      # enable vi keys.
      setw -g mode-keys vi
      # Open panes in the same directory using the tmux-panes script
      #unbind v
      #unbind n
      #bind v send-keys " ~/tmux-panes -h" C-m
      #bind n send-keys " ~/tmux-panes -v" C-m
      # Maximize and restore a pane
      #unbind Up
      #bind Up new-window -d -n tmp \; swap-pane -s tmp.1 \; select-window -t tmp
      #unbind Down
      #bind Down last-window \; swap-pane -s tmp.1 \; kill-window -t tmp
      #
      # Log output to a text file on demand
      bind P pipe-pane -o "cat >>~/#W.log" \; display "Toggled logging to ~/#W.log"
      
      
      set-window-option -g automatic-rename off
      set -g allow-rename on
      set-option -g status-interval 1
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'
      
      set-option -g history-limit 3000
      
      set-option -g status-position top
      
      #new-window
      new-session
    '';

    plugins = with pkgs; [ customTmux.dracula ];
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = if isDarwin then "screen-256color" else "xterm-256color";
  };
}
