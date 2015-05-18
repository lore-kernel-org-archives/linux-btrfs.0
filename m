Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34576 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbbERJQo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 May 2015 05:16:44 -0400
Received: by pdbnk13 with SMTP id nk13so45892353pdb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 May 2015 02:16:43 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v3 1/6] Btrfs: lock superblock before remounting for rw subvol
Date: Mon, 18 May 2015 02:16:26 -0700
Message-Id: <89684580fa5b3dce63d7491789f835eb3ce6d4dd.1431939732.git.osandov@osandov.com>
In-Reply-To: <cover.1431939732.git.osandov@osandov.com>
References: <cover.1431939732.git.osandov@osandov.com>
In-Reply-To: <cover.1431939732.git.osandov@osandov.com>
References: <cover.1431939732.git.osandov@osandov.com>
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

Fixes: 0723a0473fb4 ("btrfs: allow mounting btrfs subvolumes with different ro/rw options")
Reviewed-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9e66f5e..0576750 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1214,7 +1214,9 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 				return ERR_CAST(mnt);
 			}
 
+			down_write(&mnt->mnt_sb->s_umount);
 			r = btrfs_remount(mnt->mnt_sb, &flags, NULL);
+			up_write(&mnt->mnt_sb->s_umount);
 			if (r < 0) {
 				/* FIXME: release vfsmount mnt ??*/
 				kfree(newargs);
-- 
2.4.1

