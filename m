Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29819 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752572AbdFMJTw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:52 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 10/19] btrfs-progs: Refactor btrfs_readahead_tree_block to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:26 +0800
Message-ID: <20170613091935.23277-11-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 8 +++++---
 ctree.c      | 2 +-
 disk-io.c    | 8 ++++----
 disk-io.h    | 4 ++--
 image/main.c | 2 +-
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index b9c21553..bd6c4e75 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1967,6 +1967,7 @@ out:
 static void reada_walk_down(struct btrfs_root *root,
 			    struct extent_buffer *node, int slot)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	u64 bytenr;
 	u64 ptr_gen;
 	u32 nritems;
@@ -1979,11 +1980,11 @@ static void reada_walk_down(struct btrfs_root *root,
 		return;
 
 	nritems = btrfs_header_nritems(node);
-	blocksize = root->fs_info->nodesize;
+	blocksize = fs_info->nodesize;
 	for (i = slot; i < nritems; i++) {
 		bytenr = btrfs_node_blockptr(node, i);
 		ptr_gen = btrfs_node_ptr_generation(node, i);
-		readahead_tree_block(root, bytenr, blocksize, ptr_gen);
+		readahead_tree_block(fs_info, bytenr, blocksize, ptr_gen);
 	}
 }
 
@@ -7613,6 +7614,7 @@ static int run_next_block(struct btrfs_root *root,
 			  struct device_extent_tree *dev_extent_cache,
 			  struct root_item_record *ri)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *buf;
 	struct extent_record *rec = NULL;
 	u64 bytenr;
@@ -7642,7 +7644,7 @@ static int run_next_block(struct btrfs_root *root,
 				continue;
 
 			/* fixme, get the parent transid */
-			readahead_tree_block(root, bits[i].start,
+			readahead_tree_block(fs_info, bits[i].start,
 					     bits[i].size, 0);
 		}
 	}
diff --git a/ctree.c b/ctree.c
index a6916b30..f3c13e1c 100644
--- a/ctree.c
+++ b/ctree.c
@@ -1021,7 +1021,7 @@ void reada_for_search(struct btrfs_root *root, struct btrfs_path *path,
 		if ((search >= lowest_read && search <= highest_read) ||
 		    (search < lowest_read && lowest_read - search <= 32768) ||
 		    (search > highest_read && search - highest_read <= 32768)) {
-			readahead_tree_block(root, search, blocksize,
+			readahead_tree_block(fs_info, search, blocksize,
 				     btrfs_node_ptr_generation(node, nr));
 			nread += blocksize;
 		}
diff --git a/disk-io.c b/disk-io.c
index 7addaf61..686c55e7 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -187,17 +187,17 @@ struct extent_buffer* btrfs_find_create_tree_block(
 	return alloc_extent_buffer(&fs_info->extent_cache, bytenr, blocksize);
 }
 
-void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
-			  u64 parent_transid)
+void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
+			  u32 blocksize, u64 parent_transid)
 {
 	struct extent_buffer *eb;
 	u64 length;
 	struct btrfs_multi_bio *multi = NULL;
 	struct btrfs_device *device;
 
-	eb = btrfs_find_tree_block(root->fs_info, bytenr, blocksize);
+	eb = btrfs_find_tree_block(fs_info, bytenr, blocksize);
 	if (!(eb && btrfs_buffer_uptodate(eb, parent_transid)) &&
-	    !btrfs_map_block(root->fs_info, READ, bytenr, &length, &multi, 0,
+	    !btrfs_map_block(fs_info, READ, bytenr, &length, &multi, 0,
 			     NULL)) {
 		device = multi->stripes[0].dev;
 		device->total_ios++;
diff --git a/disk-io.h b/disk-io.h
index 20520e59..b834fea4 100644
--- a/disk-io.h
+++ b/disk-io.h
@@ -121,8 +121,8 @@ struct extent_buffer* read_tree_block(
 
 int read_extent_data(struct btrfs_fs_info *fs_info, char *data, u64 logical,
 		     u64 *len, int mirror);
-void readahead_tree_block(struct btrfs_root *root, u64 bytenr, u32 blocksize,
-			  u64 parent_transid);
+void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
+			  u32 blocksize, u64 parent_transid);
 struct extent_buffer* btrfs_find_create_tree_block(
 		struct btrfs_fs_info *fs_info, u64 bytenr, u32 blocksize);
 
diff --git a/image/main.c b/image/main.c
index e49430db..fac9b760 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1029,7 +1029,7 @@ static int add_extent(u64 start, u64 size, struct metadump_struct *md,
 			return ret;
 		md->pending_start = start;
 	}
-	readahead_tree_block(md->root, start, size, 0);
+	readahead_tree_block(md->root->fs_info, start, size, 0);
 	md->pending_size += size;
 	md->data = data;
 	return 0;
-- 
2.13.1



