Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44634 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2EYM4z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 08:56:55 -0400
Received: by bkcji2 with SMTP id ji2so708706bkc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 25 May 2012 05:56:54 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH] Btrfs: don't update atime on RO subvolumes
Date: Fri, 25 May 2012 14:50:43 +0200
Message-Id: <1337950243-5992-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before the update_time inode operation was indroduced, it was
not possible to prevent updates of atime on RO subvolumes.
btrfs_update_time does now check if the root is RO and skip
updating of atime.

This patch requires the update_time patches from Josef
Bacik.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/inode.c |   26 +++++++++++++++++++++-----
 fs/inode.c       |    3 +++
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 54ae3df..b48db5a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4470,14 +4470,30 @@ int btrfs_dirty_inode(struct inode *inode)
 static int btrfs_update_time(struct inode *inode, struct timespec *now,
 			     int flags)
 {
-	if (flags & S_VERSION)
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	int did_update = 0;
+
+	if (flags & S_VERSION) {
 		inode_inc_iversion(inode);
-	if (flags & S_CTIME)
+		did_update = 1;
+	}
+	if (flags & S_CTIME) {
 		inode->i_ctime = *now;
-	if (flags & S_MTIME)
+		did_update = 1;
+	}
+	if (flags & S_MTIME) {
 		inode->i_mtime = *now;
-	if (flags & S_ATIME)
-		inode->i_atime = *now;
+		did_update = 1;
+	}
+	if (flags & S_ATIME) {
+		/* don't do atime updates on RO subvolumes */
+		if (!btrfs_root_readonly(root)) {
+			inode->i_atime = *now;
+			did_update = 1;
+		}
+	}
+	if (!did_update)
+		return 0;
 	return btrfs_dirty_inode(inode);
 }
 
diff --git a/fs/inode.c b/fs/inode.c
index 06d8bd4..949d06f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1545,6 +1545,9 @@ void touch_atime(struct path *path)
 	 * Btrfs), but since we touch atime while walking down the path we
 	 * really don't care if we failed to update the atime of the file,
 	 * so just ignore the return value.
+	 * Also, the checks done above to see if updating atime is allowed
+	 * are not enough for some filesystems. Btrfs for example may have
+	 * RO subvolumes on a RW filesystems, which vfs is not aware of.
 	 */
 	update_time(inode, &now, S_ATIME);
 	mnt_drop_write(mnt);
-- 
1.7.10

