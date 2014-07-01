Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51742 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757419AbaGAJ27 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 05:28:59 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s619Su73013464
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Jul 2014 17:28:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with different ro/rw options"
Date: Tue, 1 Jul 2014 17:30:01 +0800
Message-ID: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit 0723a0473fb48a1c93b113a28665b64ce5faf35a.
This commit has the following problem:
1) Break the ro mount rule.
When users mount the whole btrfs ro, it is still possible to mount
subvol rw and change the contents. Which make the whole fs ro mount
non-sense.

2) Cause whole btrfs ro/rw mount change fails.
When mount a subvol ro first, when you can't mount the whole fs mounted
rw. This is due to the check in btrfs_mount() which returns -EBUSY,
which is OK for single fs to prevent mount fs ro in one mount point and
mount the same fs rw in other mount point.
Step to reproduce:
mount -o subvol=subv,ro /dev/sda6 /mnt/btrfs
mount -o rw /dev/sda6 /mnt/btrfs	<-this will fail

3) Kernel warn in vfs.
When mount the whole fs ro, and mount a subvol ro, kernel warning will
show in fs/sync.c complaining s_umount rwsem is not locked.
Since this remount is not called by VFS, so s_mounts rwsem is not
correctly locked.

4) Lacks ro/rw conflicint check.
The commit uses a trick to 'cheat' vfs about ro/rw flags to allow
different ro/rw mount options, however this breaks the original ro/rw
conflicting rule: one fs(even subvolume) can't be mounted rw in one place
and mounted ro in someplace else.
This can be triggered quite easily:
mount -o subvol=subv,ro /dev/sda6 /mnt/btrfs
mount -o subvol=subv,rw /dev/sda6 /mnt/other

Also the check logical about checking the ro/rw needed to be investigated
further. e.g. When the subvolume is mounted ro, the whole btrfs fs is mounted
rw, so one can change the ro mounted subvolume from the mounted whole btrfs.

Due to the above reasons, the per-subvolume ro/rw mount options should be
investigated further to ensure the correctness and better reverting it
before correct implement
(It may takes a lone time to find the right logic about ro/rw option in
subvolume)

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Conflicts:
	fs/btrfs/super.c
---
 fs/btrfs/super.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 4662d92..4a088f8 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -66,8 +66,6 @@
 static const struct super_operations btrfs_super_ops;
 static struct file_system_type btrfs_fs_type;
 
-static int btrfs_remount(struct super_block *sb, int *flags, char *data);
-
 static const char *btrfs_decode_error(int errno)
 {
 	char *errstr = "unknown";
@@ -1179,31 +1177,7 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 		return ERR_PTR(-ENOMEM);
 	mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name,
 			     newargs);
-
-	if (PTR_RET(mnt) == -EBUSY) {
-		if (flags & MS_RDONLY) {
-			mnt = vfs_kern_mount(&btrfs_fs_type, flags & ~MS_RDONLY, device_name,
-					     newargs);
-		} else {
-			int r;
-			mnt = vfs_kern_mount(&btrfs_fs_type, flags | MS_RDONLY, device_name,
-					     newargs);
-			if (IS_ERR(mnt)) {
-				kfree(newargs);
-				return ERR_CAST(mnt);
-			}
-
-			r = btrfs_remount(mnt->mnt_sb, &flags, NULL);
-			if (r < 0) {
-				/* FIXME: release vfsmount mnt ??*/
-				kfree(newargs);
-				return ERR_PTR(r);
-			}
-		}
-	}
-
 	kfree(newargs);
-
 	if (IS_ERR(mnt))
 		return ERR_CAST(mnt);
 
-- 
2.0.1

