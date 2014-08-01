Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39946 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbaHAXMu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:50 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/12] btrfs: factor btrfs_replay_log() out of open_ctree()
Date: Fri,  1 Aug 2014 18:12:46 -0500
Message-Id: <1406934766-16974-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |  100 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 56 insertions(+), 44 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a50beca..ffb2f21 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2445,6 +2445,60 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
+static int btrfs_replay_log(struct btrfs_fs_info *fs_info,
+			    struct btrfs_fs_devices *fs_devices)
+{
+	int ret;
+	u32 blocksize;
+	struct btrfs_root *tree_root = fs_info->tree_root;
+	struct btrfs_root *log_tree_root;
+	struct btrfs_super_block *disk_super = fs_info->super_copy;
+	u64 bytenr = btrfs_super_log_root(disk_super);
+
+	if (fs_devices->rw_devices == 0) {
+		printk(KERN_WARNING "BTRFS: log replay required "
+		       "on RO media\n");
+		return -EIO;
+	}
+	blocksize = btrfs_level_size(tree_root,
+			      btrfs_super_log_root_level(disk_super));
+
+	log_tree_root = btrfs_alloc_root(fs_info);
+	if (!log_tree_root)
+		return -ENOMEM;
+
+	__setup_root(tree_root->nodesize, tree_root->leafsize,
+		     tree_root->sectorsize, tree_root->stripesize,
+		     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
+
+	log_tree_root->node = read_tree_block(tree_root, bytenr,
+					      blocksize,
+					      fs_info->generation + 1);
+	if (!log_tree_root->node ||
+	    !extent_buffer_uptodate(log_tree_root->node)) {
+		printk(KERN_ERR "BTRFS: failed to read log tree\n");
+		free_extent_buffer(log_tree_root->node);
+		kfree(log_tree_root);
+		return -EIO;
+	}
+	/* returns with log_tree_root freed on success */
+	ret = btrfs_recover_log_trees(log_tree_root);
+	if (ret) {
+		btrfs_error(tree_root->fs_info, ret,
+			    "Failed to recover log tree");
+		free_extent_buffer(log_tree_root->node);
+		kfree(log_tree_root);
+		return ret;
+	}
+
+	if (fs_info->sb->s_flags & MS_RDONLY) {
+		ret = btrfs_commit_super(tree_root);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2461,7 +2515,6 @@ int open_ctree(struct super_block *sb,
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	struct btrfs_root *tree_root;
 	struct btrfs_root *chunk_root;
-	struct btrfs_root *log_tree_root;
 	int ret;
 	int err = -EINVAL;
 	int num_backups_tried = 0;
@@ -2905,52 +2958,11 @@ retry_root_backup:
 
 	/* do not make disk changes in broken FS */
 	if (btrfs_super_log_root(disk_super) != 0) {
-		u64 bytenr = btrfs_super_log_root(disk_super);
-
-		if (fs_devices->rw_devices == 0) {
-			printk(KERN_WARNING "BTRFS: log replay required "
-			       "on RO media\n");
-			err = -EIO;
-			goto fail_qgroup;
-		}
-		blocksize =
-		     btrfs_level_size(tree_root,
-				      btrfs_super_log_root_level(disk_super));
-
-		log_tree_root = btrfs_alloc_root(fs_info);
-		if (!log_tree_root) {
-			err = -ENOMEM;
-			goto fail_qgroup;
-		}
-
-		__setup_root(nodesize, leafsize, sectorsize, stripesize,
-			     log_tree_root, fs_info, BTRFS_TREE_LOG_OBJECTID);
-
-		log_tree_root->node = read_tree_block(tree_root, bytenr,
-						      blocksize,
-						      generation + 1);
-		if (!log_tree_root->node ||
-		    !extent_buffer_uptodate(log_tree_root->node)) {
-			printk(KERN_ERR "BTRFS: failed to read log tree\n");
-			free_extent_buffer(log_tree_root->node);
-			kfree(log_tree_root);
-			goto fail_qgroup;
-		}
-		/* returns with log_tree_root freed on success */
-		ret = btrfs_recover_log_trees(log_tree_root);
+		ret = btrfs_replay_log(fs_info, fs_devices);
 		if (ret) {
-			btrfs_error(tree_root->fs_info, ret,
-				    "Failed to recover log tree");
-			free_extent_buffer(log_tree_root->node);
-			kfree(log_tree_root);
+			err = ret;
 			goto fail_qgroup;
 		}
-
-		if (sb->s_flags & MS_RDONLY) {
-			ret = btrfs_commit_super(tree_root);
-			if (ret)
-				goto fail_qgroup;
-		}
 	}
 
 	ret = btrfs_find_orphan_roots(tree_root);
-- 
1.7.1

