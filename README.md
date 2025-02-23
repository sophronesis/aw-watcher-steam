# aw-watcher-steam
<a href ="https://activitywatch.net/">ActivityWatch</a> watcher to watch your currently playing Steam game. Steam allows you to see your total hour spent per game, but not the exact timeline, this watcher attempt to log the timeline of Steam game activity. 


This watcher will log your play time accross devices so long it has internet connection 


In order for this to watcher work you need to either set your game details settings to public or register Steam WebAPI with the same account 

## Usage 
### Step 0: Get Steam API key
<a href = "https://steamcommunity.com/dev/apikey">Register Steam API key.</a> 


Enter localhost as domain name 

### Step 1: Find Steam ID
Find your 17 digits steam ID <a href = "https://help.steampowered.com/en/faqs/view/2816-BE67-5B69-0FEC">here</a>. 

### Step 2: Install package (without poetry, using only pip)

Install the requirements:

```sh
pip install .
```

### Step 3: Restart ActivityWatch and click on aw-watcher-steam 

![image](https://github.com/Edwardsoen/aw-watcher-steam/assets/70268484/34ce2803-d564-46e2-bc08-399bcc0ed828)

### Step 4: Fill config file
Find the config file in <a href = "https://docs.activitywatch.net/en/latest/directories.html#config"> config directory</a> and fill accordingly. 


## Patches:

* Changed "currently-playing-game" data to "title" so it can be viewed inside of Timeline tab of ActivityWatch
* Added flake.nix, flake.lock, poetry2nix and updated pyproject.toml to build effortlessly with nix

## Usage on NixOS:

flake.nix:
```
inputs = {
  ...
  aw-watcher-steam.url = "github:sophronesis/aw-watcher-steam";
  ...
}
...
system = "x86_64-linux"
...
outputs = {self, ..., aw-watcher-steam, ...}@inputs
```

configuration.nix:
```
...
environment.systemPackages = with pkgs; [
  ...
  inputs.aw-watcher-steam.packages."${system}".default
  ...
];
```


