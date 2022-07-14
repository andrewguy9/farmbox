Puppet module to configure farmfs on a Raspberry Pi running Raspbian.

To setup run: `curl https://raw.githubusercontent.com/andrewguy9/farmbox/master/bootstrap.sh | sudo bash`

# Recovery Instructions:

If there is a problem with your mounts on Raspberry Pi, you may need to edit `fstab` to recover the device.

To recover, we need to get the SD card to boot us into a root shell, then edit `/etc/fstab`.

## Steps

First turn off the Raspberry Pi, and plug the SD card into a computer.
Append `init=/bin/sh` to the `cmdline.txt` file.

Plug the SD card back in and reboot the machine, with HDMI and keyboard plugged in.

The machine should now boot into a root shell, but the volume might be read only.

If it is, you can restore access by unmounting and remounting.
`/usr/bin/umount /` then `/usr/bin/mount -o remount,rw /dev/mmcblk0p2 /`.

Now you can edit `fstab`, and reboot. If things are looking good, undo the edits to `cmdline.txt`.
