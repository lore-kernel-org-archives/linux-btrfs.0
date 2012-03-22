From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [RFC PATCH 2/2] Btrfs: fix deadlock on umount by umount_prepare interface
Date: Thu, 22 Mar 2012 11:13:17 +0800
Message-ID: <4F6A98CD.5090701@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Fsdevel <linux-fsdevel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>,
	viro <viro@zeniv.linux.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

The reason the deadlock is that:
  Task					Btrfs-cleaner
  umount()
    down_write(&s->s_umount)
    close_ctree()
      wait for the end of
      btrfs-cleaner
					start_transaction
					  reserve space
					    shrink_delalloc()
					      writeback_inodes_sb_nr_if_idle()
						down_read(&sb->s_umount)
So, the deadlock has happened.

The safest way to fix this problem is to close the btrfs-cleaner before
the umount is ready to continue. Since we have introduced umount_prepare
interface into vfs before, we can fix this problem by it.

Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |   15 ---------------
 fs/btrfs/super.c   |   22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 534266f..34ebd6e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3017,21 +3017,6 @@ int close_ctree(struct btrfs_root *root)
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
 
-	fs_info->closing = 1;
-	smp_mb();
-
-	/* pause restriper - we want to resume on mount */
-	btrfs_pause_balance(root->fs_info);
-
-	btrfs_scrub_cancel(root);
-
-	/* wait for any defraggers to finish */
-	wait_event(fs_info->transaction_wait,
-		   (atomic_read(&fs_info->defrag_running) == 0));
-
-	/* clear out the rbtree of defraggable inodes */
-	btrfs_run_defrag_inodes(fs_info);
-
 	/*
 	 * Here come 2 situations when btrfs is broken to flip readonly:
 	 *
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3ce97b2..24ed903 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -145,6 +145,27 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 	btrfs_handle_error(fs_info);
 }
 
+static void btrfs_umount_prepare(struct super_block *sb)
+{
+	struct btrfs_root *root = btrfs_sb(sb)->tree_root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+
+	fs_info->closing = 1;
+	smp_mb();
+
+	/* pause restriper - we want to resume on mount */
+	btrfs_pause_balance(root->fs_info);
+
+	btrfs_scrub_cancel(root);
+
+	/* wait for any defraggers to finish */
+	wait_event(fs_info->transaction_wait,
+		   (atomic_read(&fs_info->defrag_running) == 0));
+
+	/* clear out the rbtree of defraggable inodes */
+	btrfs_run_defrag_inodes(fs_info);
+}
+
 static void btrfs_put_super(struct super_block *sb)
 {
 	(void)close_ctree(btrfs_sb(sb)->tree_root);
@@ -1312,6 +1333,7 @@ static void btrfs_fs_dirty_inode(struct inode *inode, int flags)
 static const struct super_operations btrfs_super_ops = {
 	.drop_inode	= btrfs_drop_inode,
 	.evict_inode	= btrfs_evict_inode,
+	.umount_prepare	= btrfs_umount_prepare,
 	.put_super	= btrfs_put_super,
 	.sync_fs	= btrfs_sync_fs,
 	.show_options	= btrfs_show_options,
-- 
1.7.6.5
