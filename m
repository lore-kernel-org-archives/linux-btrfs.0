Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39938 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756282AbaHAXMt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 19:12:49 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 06/12] btrfs: factor btrfs_btree_inode_init() out of open_ctree()
Date: Fri,  1 Aug 2014 18:12:40 -0500
Message-Id: <1406934766-16974-7-git-send-email-sandeen@redhat.com>
In-Reply-To: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/btrfs/disk-io.c |   56 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8c7113b..6636386 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2156,6 +2156,36 @@ static void btrfs_balance_init(struct btrfs_fs_info *fs_info)
 	init_waitqueue_head(&fs_info->balance_wait_q);
 }
 
+static void btrfs_btree_inode_init(struct btrfs_fs_info *fs_info,
+				   struct btrfs_root *tree_root)
+{
+	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
+	set_nlink(fs_info->btree_inode, 1);
+	/*
+	 * we set the i_size on the btree inode to the max possible int.
+	 * the real end of the address space is determined by all of
+	 * the devices in the system
+	 */
+	fs_info->btree_inode->i_size = OFFSET_MAX;
+	fs_info->btree_inode->i_mapping->a_ops = &btree_aops;
+	fs_info->btree_inode->i_mapping->backing_dev_info = &fs_info->bdi;
+
+	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
+	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
+			     fs_info->btree_inode->i_mapping);
+	BTRFS_I(fs_info->btree_inode)->io_tree.track_uptodate = 0;
+	extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree);
+
+	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
+
+	BTRFS_I(fs_info->btree_inode)->root = tree_root;
+	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
+	       sizeof(struct btrfs_key));
+	set_bit(BTRFS_INODE_DUMMY,
+		&BTRFS_I(fs_info->btree_inode)->runtime_flags);
+	btrfs_insert_inode_hash(fs_info->btree_inode);
+}
+
 int open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options)
@@ -2315,31 +2345,7 @@ int open_ctree(struct super_block *sb,
 	sb->s_blocksize_bits = blksize_bits(4096);
 	sb->s_bdi = &fs_info->bdi;
 
-	fs_info->btree_inode->i_ino = BTRFS_BTREE_INODE_OBJECTID;
-	set_nlink(fs_info->btree_inode, 1);
-	/*
-	 * we set the i_size on the btree inode to the max possible int.
-	 * the real end of the address space is determined by all of
-	 * the devices in the system
-	 */
-	fs_info->btree_inode->i_size = OFFSET_MAX;
-	fs_info->btree_inode->i_mapping->a_ops = &btree_aops;
-	fs_info->btree_inode->i_mapping->backing_dev_info = &fs_info->bdi;
-
-	RB_CLEAR_NODE(&BTRFS_I(fs_info->btree_inode)->rb_node);
-	extent_io_tree_init(&BTRFS_I(fs_info->btree_inode)->io_tree,
-			     fs_info->btree_inode->i_mapping);
-	BTRFS_I(fs_info->btree_inode)->io_tree.track_uptodate = 0;
-	extent_map_tree_init(&BTRFS_I(fs_info->btree_inode)->extent_tree);
-
-	BTRFS_I(fs_info->btree_inode)->io_tree.ops = &btree_extent_io_ops;
-
-	BTRFS_I(fs_info->btree_inode)->root = tree_root;
-	memset(&BTRFS_I(fs_info->btree_inode)->location, 0,
-	       sizeof(struct btrfs_key));
-	set_bit(BTRFS_INODE_DUMMY,
-		&BTRFS_I(fs_info->btree_inode)->runtime_flags);
-	btrfs_insert_inode_hash(fs_info->btree_inode);
+	btrfs_btree_inode_init(fs_info, tree_root);
 
 	spin_lock_init(&fs_info->block_group_cache_lock);
 	fs_info->block_group_cache_tree = RB_ROOT;
-- 
1.7.1

