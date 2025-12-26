# Trouble shooting

## Running the container

### Permission denied

```
root@212b8893acc5:/workspace# ls -lh .
ls: cannot open directory '.': Permission denied
```

There could be a few possible causes of this, but here are what has been struck so far:

#### Running inside your home directory

By default, docker doesn't have access to your home folder. You can work around this by moving the home directory somewhere else. Eg

```bash
sudo mkdir /usr/safePlace
sudo mv ai-docker /usr/safePlace
ln -s /usr/safePlace/ai-docker .
```

#### Permissions of a parent directory

You can use `./shared/tools/listParentPerms` to debug where the problem might be.

#### SELinux

This is hopefully fixed now. But this is a place you may want to check.
