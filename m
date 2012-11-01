Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45740 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2KAHdi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 03:33:38 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id qA17XaPH031212
	for <linux-btrfs@vger.kernel.org>; Thu, 1 Nov 2012 15:33:36 +0800
Message-ID: <509225E7.20205@cn.fujitsu.com>
Date: Thu, 01 Nov 2012 15:33:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/5] Btrfs: fix wrong file extent length
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There are two types of the file extent - inline extent and regular extent,
When we log file extents, we didn't take inline extent into account, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/ctree.h     |    1 +
 fs/btrfs/file-item.c |   21 ++++++++++++++++++++-
 fs/btrfs/tree-log.c  |   10 ++--------
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2ce1135..f019fd2 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -3256,6 +3256,7 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path, u64 objectid,
 			     u64 bytenr, int mod);
+u64 btrfs_file_extent_length(struct btrfs_path *path);
 int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct btrfs_ordered_sum *sums);
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 1ad08e4e4..bd38cef 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -133,7 +133,6 @@ fail:
 	return ERR_PTR(ret);
 }
 
-
 int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 			     struct btrfs_root *root,
 			     struct btrfs_path *path, u64 objectid,
@@ -151,6 +150,26 @@ int btrfs_lookup_file_extent(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+u64 btrfs_file_extent_length(struct btrfs_path *path)
+{
+	int extent_type;
+	struct btrfs_file_extent_item *fi;
+	u64 len;
+
+	fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_file_extent_item);
+	extent_type = btrfs_file_extent_type(path->nodes[0], fi);
+
+	if (extent_type == BTRFS_FILE_EXTENT_REG ||
+	    extent_type == BTRFS_FILE_EXTENT_PREALLOC)
+		len = btrfs_file_extent_num_bytes(path->nodes[0], fi);
+	else if (extent_type == BTRFS_FILE_EXTENT_INLINE)
+		len = btrfs_file_extent_inline_len(path->nodes[0], fi);
+	else
+		BUG();
+
+	return len;
+}
 
 static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
 				   struct inode *inode, struct bio *bio,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e9ebb47..cbb544e 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3143,7 +3143,6 @@ static int log_one_extent(struct btrfs_trans_handle *trans,
 			  struct btrfs_path *dst_path, struct log_args *args)
 {
 	struct btrfs_root *log = root->log_root;
-	struct btrfs_file_extent_item *fi;
 	struct btrfs_key key;
 	u64 start = em->mod_start;
 	u64 search_start = start;
@@ -3199,10 +3198,7 @@ again:
 				}
 			} while (key.offset > start);
 
-			fi = btrfs_item_ptr(path->nodes[0], path->slots[0],
-					    struct btrfs_file_extent_item);
-			num_bytes = btrfs_file_extent_num_bytes(path->nodes[0],
-								fi);
+			num_bytes = btrfs_file_extent_length(path);
 			if (key.offset + num_bytes <= start) {
 				btrfs_release_path(path);
 				return -ENOENT;
@@ -3211,8 +3207,7 @@ again:
 		args->src = path->nodes[0];
 next_slot:
 		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
-		fi = btrfs_item_ptr(args->src, path->slots[0],
-				    struct btrfs_file_extent_item);
+		num_bytes = btrfs_file_extent_length(path);
 		if (args->nr &&
 		    args->start_slot + args->nr == path->slots[0]) {
 			args->nr++;
@@ -3230,7 +3225,6 @@ next_slot:
 		}
 		nritems = btrfs_header_nritems(path->nodes[0]);
 		path->slots[0]++;
-		num_bytes = btrfs_file_extent_num_bytes(args->src, fi);
 		if (len < num_bytes) {
 			/* I _think_ this is ok, envision we write to a
 			 * preallocated space that is adjacent to a previously
-- 
1.7.6.5
