From: Mark Fasheh <mfasheh@suse.com>
Subject: [RFC][PATCH 0/2] btrfs/vfs: Return same device in stat(2) and /proc/pid/maps
Date: Fri, 13 May 2011 16:18:47 -0700
Message-ID: <1305328729-9995-1-git-send-email-mfasheh@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I originally posted about this issue some weeks ago but unfortunately didn't
get a response:

http://comments.gmane.org/gmane.comp.file-systems.btrfs/9682


To recap:

btrfs_getattr() is filling stat->dev with an anonymous device
(for per-snapshot root?):

stat->dev = BTRFS_I(inode)->root->anon_super.s_dev;

but /proc/pid/maps uses the "real" block device:

dev = inode->i_sb->s_dev;


This results in some unfortunate behavior for lsof as it reports some
duplicate paths (except on different block devices). The easiest way to see
this (if your root partition is btrfs):

$ lsof | grep lsof
<snip>
lsof       9238            root  txt       REG               0,19   139736 14478 /usr/bin/lsof
lsof       9238            root  mem       REG               0,17   14478 /usr/bin/lsof (path dev=0,19)


As was noted in my original mail, this winds up breaking userspace software
(zypper in my case).

The following patch series fixes this issue by allowing a file
system to supply a custom method for the device reported in /proc/pid/maps.
It fixes the issue for me, but I'm not 100% sold on the approach taken -
it's an admittedly brute-force solution hence the RFC tag. Any comments are
appreciated and welcome.

Thanks,
	--Mark

