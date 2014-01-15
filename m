Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53633 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502AbaAORPy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 12:15:54 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com, David Sterba <dsterba@suse.cz>, stable@vger.kernel.org
Subject: [PATCH] btrfs: restrict snapshotting to own subvolumes
Date: Wed, 15 Jan 2014 18:15:52 +0100
Message-Id: <1389806152-14297-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently, any user can snapshot any subvolume if the path is accessible and
thus indirectly create and keep files he does not own under his direcotries.
This is not possible with traditional directories.

In security context, a user can snapshot root filesystem and pin any
potentially buggy binaries, even if the updates are applied.

All the snapshots are visible to the administrator, so it's possible to
verify if there are suspicious snapshots.

Another more practical problem is that any user can pin the space used
by eg. root and cause ENOSPC.

Original report:
https://bugs.launchpad.net/ubuntu/+source/apparmor/+bug/484786

CC: stable@vger.kernel.org
Signed-off-by: David Sterba <dsterba@suse.cz>
---
 fs/btrfs/ioctl.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 21da5762b0b1..9f831bb3dbee 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1545,6 +1545,12 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 			printk(KERN_INFO "btrfs: Snapshot src from "
 			       "another FS\n");
 			ret = -EINVAL;
+		} else if (!inode_owner_or_capable(src_inode)) {
+			/*
+			 * Subvolume creation is not restricted, but snapshots
+			 * are limited to own subvolumes only
+			 */
+			ret = -EPERM;
 		} else {
 			ret = btrfs_mksubvol(&file->f_path, name, namelen,
 					     BTRFS_I(src_inode)->root,
-- 
1.7.9

