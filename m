Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34092 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbbDHFef (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 01:34:35 -0400
Received: by pacyx8 with SMTP id yx8so102967998pac.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Apr 2015 22:34:34 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH 1/3] Btrfs: lock superblock before remounting for rw subvol
Date: Tue,  7 Apr 2015 22:34:00 -0700
Message-Id: <aacec1feade820dc860174024ecc02079dd98814.1428471096.git.osandov@osandov.com>
In-Reply-To: <cover.1428471096.git.osandov@osandov.com>
References: <cover.1428471096.git.osandov@osandov.com>
In-Reply-To: <cover.1428471096.git.osandov@osandov.com>
References: <cover.1428471096.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since commit 0723a0473fb4 ("btrfs: allow mounting btrfs subvolumes with
different ro/rw options"), when mounting a subvolume read/write when
another subvolume has previously been mounted read-only, we first do a
remount. However, this should be done with the superblock locked, as per
sync_filesystem():

	/*
	 * We need to be protected against the filesystem going from
	 * r/o to r/w or vice versa.
	 */
	WARN_ON(!rwsem_is_locked(&sb->s_umount));

This WARN_ON can easily be hit with:

mkfs.btrfs -f /dev/vdb
mount /dev/vdb /mnt
btrfs subvol create /mnt/vol1
btrfs subvol create /mnt/vol2
umount /mnt
mount -oro,subvol=/vol1 /dev/vdb /mnt
mount -orw,subvol=/vol2 /dev/vdb /mnt2

Fixes: 0723a0473fb4
Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 05fef19..d38be09 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1205,7 +1205,9 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 				return ERR_CAST(mnt);
 			}
 
+			down_write(&mnt->mnt_sb->s_umount);
 			r = btrfs_remount(mnt->mnt_sb, &flags, NULL);
+			up_write(&mnt->mnt_sb->s_umount);
 			if (r < 0) {
 				/* FIXME: release vfsmount mnt ??*/
 				kfree(newargs);
-- 
2.3.5

