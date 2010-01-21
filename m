From: Brian Neu <proclivity76@yahoo.com>
Subject: removing a snapshot that is outside the subvolume directory fails, sorta
Date: Wed, 20 Jan 2010 17:11:15 -0800 (PST)
Message-ID: <593044.1345.qm@web51908.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Well, it fails the way that I'm trying to do it.
kernel:            2.6.31.9-174.fc12.x86_64
btrfs-progs:     btrfs-progs-0.19-9.fc12.x86_64

On a new filesystem:

$ cd /mnt/btrfs1
$ btrfsctl -S subvol1 .
operation complete
Btrfs Btrfs v0.19
$ btrfsctl -s snapofsubvol1 subvol1
operation complete
Btrfs Btrfs v0.19
$ btrfsctl -D snapofsubvol1 subvol1
ioctl:: No such file or directory



$ btrfsctl -S subvol2 .
operation complete
Btrfs Btrfs v0.19
--------> # cd subvol2    <------------
$ btrfsctl -s snapofsubvol2 subvol2
operation complete
Btrfs Btrfs v0.19
$ btrfsctl -D snapofsubvol2 subvol2
operation complete
Btrfs Btrfs v0.19


AHA, I figured it out!

$ btrfsctl -D snapofsubvol1 subvol1/..

I don't know if that's the intended syntax or if it's accidental, but I'll go ahead and send this as an FYI if anyone has the same issue.  Maybe it's obvious to some, but it wasn't to me.
