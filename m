From: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: do not do filemap_write_and_wait_range in fsync
Date: Mon, 23 Apr 2012 15:06:41 -0400
Message-ID: <1335208001-8833-1-git-send-email-josef@redhat.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We already do the btrfs_wait_ordered_range which will do this for us, so
just remove this call so we don't call it twice.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/btrfs/file.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f0da02b..0c8ed6a 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1492,14 +1492,15 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	trace_btrfs_sync_file(file, datasync);
 
-	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (ret)
-		return ret;
 	mutex_lock(&inode->i_mutex);
 
-	/* we wait first, since the writeback may change the inode */
+	/*
+	 * we wait first, since the writeback may change the inode, also wait
+	 * ordered range does a filemape_write_and_wait_range which is why we
+	 * don't do it above like other file systems.
+	 */
 	root->log_batch++;
-	btrfs_wait_ordered_range(inode, 0, (u64)-1);
+	btrfs_wait_ordered_range(inode, start, end);
 	root->log_batch++;
 
 	/*
-- 
1.7.7.6

