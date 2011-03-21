From: Mark Fasheh <mfasheh@suse.com>
Subject: btrfs device returned from stat vs /proc/pid/maps
Date: Mon, 21 Mar 2011 14:55:08 -0700
Message-ID: <20110321215508.GN1703@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I noticed that btrfs_getattr() is filling stat->dev with an anonymous device
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
lsof       9238            root  mem       REG               0,17          14478 /usr/bin/lsof (path dev=0,19)


Ultimately, this breaks existing software. In my case, "zypper ps" gets
really unhappy (which may partially also be due to a zypper bug, hooray!)


I'm not really quite sure how this should be handled though. Do we have
/proc/pid/maps report the subvolumes device (via some callback I suppose)?
Another alternative of course is to return the true block device in
btrfs_getattr() but that has some obvious downsides too.


Thanks and best regards,
	--Mark

--
Mark Fasheh
