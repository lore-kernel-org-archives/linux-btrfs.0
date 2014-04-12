Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay03.ispgateway.de ([80.67.31.41]:44833 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043AbaDLLka (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Apr 2014 07:40:30 -0400
From: Christoph Jaeger <christophjaeger@linux.com>
To: clm@fb.com, jbacik@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <christophjaeger@linux.com>
Subject: [PATCH] btrfs: fix use-after-free in mount_subvol()
Date: Sat, 12 Apr 2014 13:33:13 +0200
Message-Id: <1397302393-22145-1-git-send-email-christophjaeger@linux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Pointer 'newargs' is used after the memory that it points to has already
been freed.

Picked up by Coverity - CID 1201425.

Fixes: 0723a0473f ("btrfs: allow mounting btrfs subvolumes with
different ro/rw options")
Signed-off-by: Christoph Jaeger <christophjaeger@linux.com>
---
 fs/btrfs/super.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 5011aad..62f70cc 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1186,7 +1186,6 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 		return ERR_PTR(-ENOMEM);
 	mnt = vfs_kern_mount(&btrfs_fs_type, flags, device_name,
 			     newargs);
-	kfree(newargs);
 
 	if (PTR_RET(mnt) == -EBUSY) {
 		if (flags & MS_RDONLY) {
@@ -1196,17 +1195,22 @@ static struct dentry *mount_subvol(const char *subvol_name, int flags,
 			int r;
 			mnt = vfs_kern_mount(&btrfs_fs_type, flags | MS_RDONLY, device_name,
 					     newargs);
-			if (IS_ERR(mnt))
+			if (IS_ERR(mnt)) {
+				kfree(newargs);
 				return ERR_CAST(mnt);
+			}
 
 			r = btrfs_remount(mnt->mnt_sb, &flags, NULL);
 			if (r < 0) {
 				/* FIXME: release vfsmount mnt ??*/
+				kfree(newargs);
 				return ERR_PTR(r);
 			}
 		}
 	}
 
+	kfree(newargs);
+
 	if (IS_ERR(mnt))
 		return ERR_CAST(mnt);
 
-- 
1.9.0

