# Usage

## Manual way

Create the `/etc/portage/repos.conf/my-ebuilds.conf` file as follows:

```
[my-ebuilds]
priority = 50
location = /var/db/repos/my-ebuilds
sync-type = git
sync-uri = https://github.com/DriedSnow/ebuilds.git
auto-sync = Yes
```

Then run `emaint sync -r my-ebuilds`, Portage should now find and update the repository.

## Eselect way

On terminal:

```bash
sudo eselect repository add my-ebuilds git https://github.com/DriedSnow/ebuilds.git
```

And then run `emaint sync -r my-ebuilds`, Portage should now find and update the repository.

# Packages
emerge --ask --verbose =wezterm-9999
