From: cwillu <cwillu@cwillu.com>
Subject: Can't mount removable device if device name changes.
Date: Sat, 10 Apr 2010 19:49:37 -0600
Message-ID: <l2k4853c6511004101849r8c34baebq39774a47bf3c8f19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've got a btrfs on an sd card, which I'm using as the root fs on a
beagle.  That's not the problem :)

The machine I generate my images on has an internal sd reader, and I
also have a usb card reader.  After creating the fs on the internal
reader, I ended up plugging it in on the external reader.

internal: sdd
external: sdh

mount /dev/sdh2 /mnt -t btrfs
> mount: /dev/sdh2: can't read superblock
[15035.538462] device fsid 48fadf7ed76537-bb9c7266ecb8b2 devid transid
8986 /dev/sdh2
[15035.538462] open /dev/sdd2 failed

If I plug it back into the internal reader, it mounts fine on /dev/sdd2.

An strace of btrfsctl -a shows it reading /dev/sdh2, and there's no
mention of /dev/sdd:
> open("/dev/sdh2", O_RDONLY)             = 4
> pread(4, "\2067kF\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2859, 65536) = 2859

The fs mounts fine on the external reader on a different machine.
