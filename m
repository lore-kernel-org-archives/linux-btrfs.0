From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] Btrfs: Fix crash on read failures at mount
Date: Fri, 17 Jul 2009 12:02:25 +0100
Message-ID: <1247828545.22313.55.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I spent a while this morning trying to work out how I'd screwed up
parity recovery on RAID5, before coming to my senses and realising that
I was still using my RAID6 test case -- and knocking two drives out of a
RAID5 array is _expected_ to fail.

My code was doing _exactly_ the right thing, and failing the bio with
-EIO. But then we were using the stale buffers anyway. This patch fixes
a couple of places where we do that, and gives me a much saner failure
mode. There are probably other places which need a similar fix.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 0d50d49..55d9d18 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1783,6 +1783,11 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 					   btrfs_super_chunk_root(disk_super),
 					   blocksize, generation);
 	BUG_ON(!chunk_root->node);
+	if (!test_bit(EXTENT_BUFFER_UPTODATE, &chunk_root->node->bflags)) {
+		printk(KERN_WARNING "btrfs: failed to read chunk root on %s\n",
+		       sb->s_id);
+		goto fail_chunk_root;
+	}
 	btrfs_set_root_node(&chunk_root->root_item, chunk_root->node);
 	chunk_root->commit_root = btrfs_root_node(chunk_root);
 
@@ -1810,6 +1815,11 @@ struct btrfs_root *open_ctree(struct super_block *sb,
 					  blocksize, generation);
 	if (!tree_root->node)
 		goto fail_chunk_root;
+	if (!test_bit(EXTENT_BUFFER_UPTODATE, &tree_root->node->bflags)) {
+		printk(KERN_WARNING "btrfs: failed to read tree root on %s\n",
+		       sb->s_id);
+		goto fail_tree_root;
+	}
 	btrfs_set_root_node(&tree_root->root_item, tree_root->node);
 	tree_root->commit_root = btrfs_root_node(tree_root);
 


-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

