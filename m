Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51249 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab2FOHt0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jun 2012 03:49:26 -0400
Received: by bkcji2 with SMTP id ji2so2151212bkc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jun 2012 00:49:25 -0700 (PDT)
From: Alexander Block <ablock84@googlemail.com>
To: linux-btrfs@vger.kernel.org
Cc: Alexander Block <ablock84@googlemail.com>
Subject: [PATCH v2] Btrfs: don't update atime on RO subvolumes
Date: Fri, 15 Jun 2012 09:49:33 +0200
Message-Id: <1339746573-3573-1-git-send-email-ablock84@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before the update_time inode operation was indroduced, it was
not possible to prevent updates of atime on RO subvolumes. VFS
was only able to check for RO on the mount, but did not know
anything about btrfs subvolumes.

btrfs_update_time does now check if the root is RO and skip
updating of times.

Signed-off-by: Alexander Block <ablock84@googlemail.com>
---
 fs/btrfs/inode.c |    5 +++++
 fs/inode.c       |    2 ++
 2 files changed, 7 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f6ab6f5..4d0ceed 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4478,6 +4478,11 @@ int btrfs_dirty_inode(struct inode *inode)
 static int btrfs_update_time(struct inode *inode, struct timespec *now,
 			     int flags)
 {
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+
+	if (btrfs_root_readonly(root))
+		return -EROFS;
+
 	if (flags & S_VERSION)
 		inode_inc_iversion(inode);
 	if (flags & S_CTIME)
diff --git a/fs/inode.c b/fs/inode.c
index c99163b..033529e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1551,6 +1551,8 @@ void touch_atime(struct path *path)
 	 * Btrfs), but since we touch atime while walking down the path we
 	 * really don't care if we failed to update the atime of the file,
 	 * so just ignore the return value.
+	 * We may also fail on filesystems that have the ability to make parts
+	 * of the fs read only, e.g. subvolumes in Btrfs.
 	 */
 	update_time(inode, &now, S_ATIME);
 	mnt_drop_write(mnt);
-- 
1.7.10

