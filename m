From: Dan Rosenberg <drosenberg@vsecurity.com>
Subject: btrfs: issues with SUBVOL_SETFLAGS
Date: Wed, 09 Feb 2011 14:14:41 -0500
Message-ID: <1297278881.11434.36.camel@Dan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: lizf@cn.fujitsu.com, chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Commit 0caa102da82799efaba88e234484786a9591c797 introduced the
SUBVOL_SETFLAGS ioctl, which contains the following check:

	if (flags & ~BTRFS_SUBVOL_CREATE_ASYNC)
		return -EINVAL;

	if (flags & ~BTRFS_SUBVOL_RDONLY)
		return -EOPNOTSUPP;

Is it intentional that 0 is the only acceptable flags value?  In
addition, there should probably be an inode ownership check before
allowing setting subvolume flags.

Regards,
Dan

