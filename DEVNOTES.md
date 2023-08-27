# Developer Notes

## Permissions
Had to modify permissions of the script initially as I got a "Permission denied" error when trying to run:
```bash
./raspberry-pi-sd-creator.sh
```

To remedy this I altered permissions like this:
```bash
chmod 777 raspberry-pi-sd-creator.sh
```

Also made it executable:
```bash
chmod -x raspberry-pi-sd-creator.sh
```