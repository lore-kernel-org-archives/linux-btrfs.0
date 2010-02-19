From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: df shows wrong device while waiting for umount
Date: Fri, 19 Feb 2010 00:03:49 -0800
Message-ID: <93cdabd21002190003o21a06912gd3ab50635aceb411@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Kernel 2.6.33-0.46.rc8.git1.fc13.x86_64

I think I ran into the issue that triggers when you write the a btrfs
filesystem and then umount it and it takes a long time while writing
out the data.  It ends up writing at about 1MiB/second according to
dstat.  My understanding this issue is already fixed in the latest
code.

But that is not the issue I am reporting.  While waiting for the
umount to complete, df shows the wrong device.

# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             9.8G  7.5G  2.3G  77% /
tmpfs                 1.9G  536K  1.9G   1% /dev/shm
/dev/sda6             485M   62M  398M  14% /boot
/dev/sda7             111G  464M  111G   1% /mnt/t

# umount /mnt/t

# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda2             9.8G  7.5G  2.3G  77% /
tmpfs                 1.9G  536K  1.9G   1% /dev/shm
/dev/sda6             485M   62M  398M  14% /boot
/dev/sda7             9.8G  7.5G  2.3G  77% /mnt/t

The second df was run while waiting for the 111GB partition to unmount.
