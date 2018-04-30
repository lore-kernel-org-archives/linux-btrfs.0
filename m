Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:47085 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751274AbeD3DQD (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Sun, 29 Apr 2018 23:16:03 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] btrfs-progs: Allow tree to be printed without an fs_info
Date: Mon, 30 Apr 2018 11:15:44 +0800
Message-Id: <20180430031545.29891-2-wqu@suse.com>
In-Reply-To: <20180430031545.29891-1-wqu@suse.com>
References: <20180430031545.29891-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For btrfs_print_tree() and btrfs_print_leaf(), the usage of fs_info is
mainly for nodesize and sectorsize.

However for nodesize, we can get it from @eb->len without the need for
fs_info at all.

For nodesize, introduce new helper BTRFS_NODEPTR_PER_EXTENT_BUFFER() to
get nodesize from @eb directly.
And with the help of previous modified btrfs_leaf_free_space(),
btrfs_print_tree() can live without fs_info at all.

For btrfs_print_leaf(), we modify print_extent_csum() to accept NULL
fs_info by skipping csum length calculation.

With all these modification, btrfs_print_tree/leaf() can be called
without accessing @fs_info at all, and make it more flex to handle
binary tree block dump, or inside gdb.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 ctree.h      |  7 +++++++
 print-tree.c | 15 +++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/ctree.h b/ctree.h
index e291a7d48d14..80fd19612434 100644
--- a/ctree.h
+++ b/ctree.h
@@ -1202,6 +1202,13 @@ static inline u32 BTRFS_NODEPTRS_PER_BLOCK(const struct btrfs_fs_info *info)
 	return BTRFS_LEAF_DATA_SIZE(info) / sizeof(struct btrfs_key_ptr);
 }
 
+static inline u32
+BTRFS_NODEPTRS_PER_EXTENT_BUFFER(const struct extent_buffer *eb)
+{
+	BUG_ON(eb->fs_info && eb->fs_info->nodesize != eb->len);
+	return __BTRFS_LEAF_DATA_SIZE(eb->len) / sizeof(struct btrfs_key_ptr);
+}
+
 #define BTRFS_FILE_EXTENT_INLINE_DATA_START		\
 	(offsetof(struct btrfs_file_extent_item, disk_bytenr))
 static inline u32 BTRFS_MAX_INLINE_DATA_SIZE(const struct btrfs_fs_info *info)
diff --git a/print-tree.c b/print-tree.c
index 34a724d5f7ef..31a851ef4413 100644
--- a/print-tree.c
+++ b/print-tree.c
@@ -1150,6 +1150,14 @@ static void print_extent_csum(struct extent_buffer *eb,
 {
 	u32 size;
 
+	/*
+	 * If we don't have fs_info, only output its start position as we
+	 * don't have sectorsize for the calculation
+	 */
+	if (!fs_info) {
+		printf("\t\trange start %llu\n", (unsigned long long)start);
+		return;
+	}
 	size = (item_size / btrfs_super_csum_size(fs_info->super_copy)) *
 			fs_info->sectorsize;
 	printf("\t\trange start %llu end %llu length %u\n",
@@ -1371,7 +1379,7 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 	printf("node %llu level %d items %d free %u generation %llu owner ",
 	       (unsigned long long)eb->start,
 	        btrfs_header_level(eb), nr,
-		(u32)BTRFS_NODEPTRS_PER_BLOCK(fs_info) - nr,
+		(u32)BTRFS_NODEPTRS_PER_EXTENT_BUFFER(eb) - nr,
 		(unsigned long long)btrfs_header_generation(eb));
 	print_objectid(stdout, btrfs_header_owner(eb), 0);
 	printf("\n");
@@ -1385,13 +1393,16 @@ void btrfs_print_tree(struct extent_buffer *eb, int follow)
 		btrfs_print_key(&disk_key);
 		printf(" block %llu (%llu) gen %llu\n",
 		       (unsigned long long)blocknr,
-		       (unsigned long long)blocknr / fs_info->nodesize,
+		       (unsigned long long)blocknr / eb->len,
 		       (unsigned long long)btrfs_node_ptr_generation(eb, i));
 		fflush(stdout);
 	}
 	if (!follow)
 		return;
 
+	if (follow && !fs_info)
+		return;
+
 	for (i = 0; i < nr; i++) {
 		next = read_tree_block(fs_info,
 				btrfs_node_blockptr(eb, i),
-- 
2.17.0

