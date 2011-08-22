From: Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] btrfs:make close_ctree() return void
Date: Mon, 22 Aug 2011 23:18:11 +0800
Message-ID: <1314026291-8873-1-git-send-email-wanlong.gao@gmail.com>
Cc: chris.mason@oracle.com, Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Make close_ctree() return void since it always return 0, and fix
the return value of btrfs_put_super() to consistent with VFS.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c |    4 +---
 fs/btrfs/disk-io.h |    2 +-
 fs/btrfs/super.c   |    5 +----
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 07b3ac6..b2c15d4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2528,7 +2528,7 @@ int btrfs_commit_super(struct btrfs_root *root)
 	return ret;
 }
 
-int close_ctree(struct btrfs_root *root)
+void close_ctree(struct btrfs_root *root)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	int ret;
@@ -2630,8 +2630,6 @@ int close_ctree(struct btrfs_root *root)
 	kfree(fs_info->dev_root);
 	kfree(fs_info->csum_root);
 	kfree(fs_info);
-
-	return 0;
 }
 
 int btrfs_buffer_uptodate(struct extent_buffer *buf, u64 parent_transid)
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index bec3ea4..4a191b2 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -47,7 +47,7 @@ int clean_tree_block(struct btrfs_trans_handle *trans,
 struct btrfs_root *open_ctree(struct super_block *sb,
 			      struct btrfs_fs_devices *fs_devices,
 			      char *options);
-int close_ctree(struct btrfs_root *root);
+void close_ctree(struct btrfs_root *root);
 int write_ctree_super(struct btrfs_trans_handle *trans,
 		      struct btrfs_root *root, int max_mirrors);
 struct buffer_head *btrfs_read_dev_super(struct block_device *bdev);
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 31e9654..e1d8d32 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -146,12 +146,9 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
 static void btrfs_put_super(struct super_block *sb)
 {
 	struct btrfs_root *root = btrfs_sb(sb);
-	int ret;
 
-	ret = close_ctree(root);
+	close_ctree(root);
 	sb->s_fs_info = NULL;
-
-	(void)ret; /* FIXME: need to fix VFS to return error? */
 }
 
 enum {
-- 
1.7.4.1
