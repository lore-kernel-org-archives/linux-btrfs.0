From: Prasad Joshi <prasadjoshi124@gmail.com>
Subject: List of devices added to a btrfs file system
Date: Sat, 7 Nov 2009 18:34:44 +0530
Message-ID: <fe291c8c0911070504v12957f85je800890fd4a89942@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I want to know the list of devices added to a mounted btrfs file
system. I could not figure out how to find the list.

I created file system on 2 devices. Now I could mount the file system
using any device.
$ mkfs.btrfs /dev/sdb /dev/sdc

$ mount -t btrfs /dev/sdb /mnt

$ umount /mnt

$ mount -t btrfs /dev/sdc /mnt

$ mount -t btrfs /dev/sdb /mnt
mount -t btrfs /dev/sdb /mnt
mount: /dev/sdb already mounted or /mnt busy
mount: according to mtab, /dev/sdc is already mounted on /mnt

This works really fine, but there should be a way to list the number
of device and device names added to the file system. Is there any way
to get that list?

Thanks and Regards,
Prasad
