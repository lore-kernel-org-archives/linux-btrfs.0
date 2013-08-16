Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:40717 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3HPOXr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 10:23:47 -0400
Received: by mail-we0-f173.google.com with SMTP id x54so508062wes.4
        for <linux-btrfs@vger.kernel.org>; Fri, 16 Aug 2013 07:23:46 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH] Btrfs: reset force_compress on btrfs_file_defrag failure
Date: Fri, 16 Aug 2013 15:23:33 +0100
Message-Id: <1376663013-20672-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After we set force_compress with a new value (which was not being done
while holding the inode mutex), if an error happens and we jump to
the label out_ra, the force_compress property of the inode is not set
to BTRFS_COMPRESS_NONE (unlike in the case where no errors happen).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/ioctl.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 107c5f4..411dc0a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1272,9 +1272,6 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			cluster = max_cluster;
 		}
 
-		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
-			BTRFS_I(inode)->force_compress = compress_type;
-
 		if (i + cluster > ra_index) {
 			ra_index = max(i, ra_index);
 			btrfs_force_ra(inode->i_mapping, ra, file, ra_index,
@@ -1283,6 +1280,8 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 		}
 
 		mutex_lock(&inode->i_mutex);
+		if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS)
+			BTRFS_I(inode)->force_compress = compress_type;
 		ret = cluster_pages_for_defrag(inode, pages, i, cluster);
 		if (ret < 0) {
 			mutex_unlock(&inode->i_mutex);
@@ -1339,10 +1338,6 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 			    atomic_read(&root->fs_info->async_delalloc_pages) == 0));
 		}
 		atomic_dec(&root->fs_info->async_submit_draining);
-
-		mutex_lock(&inode->i_mutex);
-		BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_NONE;
-		mutex_unlock(&inode->i_mutex);
 	}
 
 	if (range->compress_type == BTRFS_COMPRESS_LZO) {
@@ -1352,6 +1347,11 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
 	ret = defrag_count;
 
 out_ra:
+	if (range->flags & BTRFS_DEFRAG_RANGE_COMPRESS) {
+		mutex_lock(&inode->i_mutex);
+		BTRFS_I(inode)->force_compress = BTRFS_COMPRESS_NONE;
+		mutex_unlock(&inode->i_mutex);
+	}
 	if (!file)
 		kfree(ra);
 	kfree(pages);
-- 
1.7.9.5

