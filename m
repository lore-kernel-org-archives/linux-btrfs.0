Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:25367 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2H0Qxz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Aug 2012 12:53:55 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: jbacik@fusionio.com
Subject: [PATCH 2/2] Btrfs: improve fsync by filtering extents that we want
Date: Tue, 28 Aug 2012 00:52:20 +0800
Message-Id: <1346086340-14776-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1346086340-14776-1-git-send-email-bo.li.liu@oracle.com>
References: <1346086340-14776-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is based on Josef's "Btrfs: turbo charge fsync".

The above Josef's patch performs very good in random sync write test,
because we won't have too much extents to merge.

However, it does not performs good on the test:
dd if=/dev/zero of=foobar bs=4k count=12500 oflag=sync

The reason is when we do sequencial sync write, we need to merge the
current extent just with the previous one, so that we can get accumulated
extents to log:

A(4k) --> AA(8k) --> AAA(12k) --> AAAA(16k) ...

So we'll have to flush more and more checksum into log tree, which is the
bottleneck according to my tests.

But we can avoid this by telling fsync the real extents that are needed
to be logged.

With this, I did the above dd sync write test (size=50m),

         w/o (orig)   w/ (josef's)   w/ (this)
SATA      104KB/s       109KB/s       121KB/s
ramdisk   1.5MB/s       1.5MB/s       10.7MB/s (613%)

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_map.c |   20 ++++++++++++++++++++
 fs/btrfs/extent_map.h |    2 ++
 fs/btrfs/inode.c      |    1 +
 fs/btrfs/tree-log.c   |    6 +++---
 4 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 1fe82cf..ac606f0 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -203,6 +203,8 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 			em->block_start = merge->block_start;
 			merge->in_tree = 0;
 			if (merge->generation > em->generation) {
+				em->mod_start = em->start;
+				em->mod_len = em->len;
 				em->generation = merge->generation;
 				list_move(&em->list, &tree->modified_extents);
 			}
@@ -222,6 +224,7 @@ static void try_merge_map(struct extent_map_tree *tree, struct extent_map *em)
 		rb_erase(&merge->rb_node, &tree->map);
 		merge->in_tree = 0;
 		if (merge->generation > em->generation) {
+			em->mod_len = em->len;
 			em->generation = merge->generation;
 			list_move(&em->list, &tree->modified_extents);
 		}
@@ -247,6 +250,7 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 {
 	int ret = 0;
 	struct extent_map *em;
+	bool prealloc = false;
 
 	write_lock(&tree->lock);
 	em = lookup_extent_mapping(tree, start, len);
@@ -259,8 +263,21 @@ int unpin_extent_cache(struct extent_map_tree *tree, u64 start, u64 len,
 	list_move(&em->list, &tree->modified_extents);
 	em->generation = gen;
 	clear_bit(EXTENT_FLAG_PINNED, &em->flags);
+	em->mod_start = em->start;
+	em->mod_len = em->len;
+
+	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {
+		prealloc = true;
+		clear_bit(EXTENT_FLAG_PREALLOC, &em->flags);
+	}
 
 	try_merge_map(tree, em);
+
+	if (prealloc) {
+		em->mod_start = em->start;
+		em->mod_len = em->len;
+	}
+
 	free_extent_map(em);
 out:
 	write_unlock(&tree->lock);
@@ -298,6 +315,9 @@ int add_extent_mapping(struct extent_map_tree *tree,
 	}
 	atomic_inc(&em->refs);
 
+	em->mod_start = em->start;
+	em->mod_len = em->len;
+
 	try_merge_map(tree, em);
 out:
 	return ret;
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 2388a60..8e6294b 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -20,6 +20,8 @@ struct extent_map {
 	/* all of these are in bytes */
 	u64 start;
 	u64 len;
+	u64 mod_start;
+	u64 mod_len;
 	u64 orig_start;
 	u64 block_start;
 	u64 block_len;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e887d10..8879e46e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1308,6 +1308,7 @@ out_check:
 			em->block_start = disk_bytenr;
 			em->bdev = root->fs_info->fs_devices->latest_bdev;
 			set_bit(EXTENT_FLAG_PINNED, &em->flags);
+			set_bit(EXTENT_FLAG_PREALLOC, &em->flags);
 			while (1) {
 				write_lock(&em_tree->lock);
 				ret = add_extent_mapping(em_tree, em);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e7365d7..e70cdad 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2833,8 +2833,8 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 	struct btrfs_root *log = root->log_root;
 	struct btrfs_file_extent_item *fi;
 	struct btrfs_key key;
-	u64 start = em->start;
-	u64 len = em->len;
+	u64 start = em->mod_start;
+	u64 len = em->mod_len;
 	u64 num_bytes;
 	int nritems;
 	int ret;
@@ -2970,7 +2970,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		 * sequential then we need to copy the items we have and redo
 		 * our search
 		 */
-		if (args.nr && em->start != args.next_offset) {
+		if (args.nr && em->mod_start != args.next_offset) {
 			ret = copy_items(trans, log, dst_path, args.src,
 					 args.start_slot, args.nr,
 					 LOG_INODE_ALL);
-- 
1.7.7.6

