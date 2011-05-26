From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 11/11 v2] Btrfs: use the right generation number to read log_root_tree
Date: Thu, 26 May 2011 16:19:26 +0800
Message-ID: <1306397966-7834-12-git-send-email-liubo2009@cn.fujitsu.com>
References: <1306397966-7834-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>, <josef@redhat.com>,
	Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306397966-7834-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Currently we use the generation number of the super to read in the log
tree root after a crash.  This doesn't always match the sub trans id and
so it doesn't always match the transid stored in the btree blocks.

We can use log_root_transid to record the log_root_tree's generation
so that when we recover from crash, we can match log_root_tree's btree blocks.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c  |    3 ++-
 fs/btrfs/tree-log.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5271365..517655f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2103,6 +2103,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 	if (btrfs_super_log_root(disk_super) != 0 &&
 	    !(fs_info->fs_state & BTRFS_SUPER_FLAG_ERROR)) {
 		u64 bytenr = btrfs_super_log_root(disk_super);
+		u64 log_root_transid = btrfs_super_log_root_transid(disk_super);
 
 		if (fs_devices->rw_devices == 0) {
 			printk(KERN_WARNING "Btrfs log replay required "
@@ -2125,7 +2126,7 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 
 		log_tree_root->node = read_tree_block(tree_root, bytenr,
 						      blocksize,
-						      generation + 1);
+						      log_root_transid);
 		ret = btrfs_recover_log_trees(log_tree_root);
 		BUG_ON(ret);
 
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index fea4f39..b033ba3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2089,6 +2089,8 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 				log_root_tree->node->start);
 	btrfs_set_super_log_root_level(&root->fs_info->super_for_commit,
 				btrfs_header_level(log_root_tree->node));
+	btrfs_set_super_log_root_transid(&root->fs_info->super_for_commit,
+					 trans->transid);
 
 	log_root_tree->log_batch = 0;
 	log_root_tree->log_transid++;
-- 
1.6.5.2

