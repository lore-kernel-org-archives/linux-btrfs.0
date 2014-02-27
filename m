Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16434 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbaB0PSp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Feb 2014 10:18:45 -0500
Received: from pps.filterd (m0044012 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s1RFIFqA002723
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 07:18:44 -0800
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1j9pm4ufcq-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Feb 2014 07:18:44 -0800
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: record generation for tree blocks in fsck
Date: Thu, 27 Feb 2014 10:18:41 -0500
Message-ID: <1393514321-28406-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When working with a user who had a broken file system I noticed that we were
reading a bad copy of a block when the other copy was perfectly fine.  This is
because we don't keep track of the parent generation for tree blocks, so we just
read whichever copy we damned well please with no regards for which is best.
This fixes this problem by recording the parent generation of the tree block so
we can be sure to read the most correct copy before we check it, which will give
us a better chance of fixing really broken filesystems.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 2911af0..2fc5253 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -98,6 +98,7 @@ struct extent_record {
 	u64 refs;
 	u64 extent_item_refs;
 	u64 generation;
+	u64 parent_generation;
 	u64 info_objectid;
 	u64 num_duplicates;
 	u8 info_level;
@@ -2643,7 +2644,7 @@ static struct data_backref *alloc_data_backref(struct extent_record *rec,
 }
 
 static int add_extent_rec(struct cache_tree *extent_cache,
-			  struct btrfs_key *parent_key,
+			  struct btrfs_key *parent_key, u64 parent_gen,
 			  u64 start, u64 nr, u64 extent_item_refs,
 			  int is_root, int inc_ref, int set_checked,
 			  int metadata, int extent_rec, u64 max_size)
@@ -2719,6 +2720,8 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 
 		if (parent_key)
 			btrfs_cpu_key_to_disk(&rec->parent_key, parent_key);
+		if (parent_gen)
+			rec->parent_generation = parent_gen;
 
 		if (rec->max_size < max_size)
 			rec->max_size = max_size;
@@ -2759,6 +2762,11 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 	else
 		memset(&rec->parent_key, 0, sizeof(*parent_key));
 
+	if (parent_gen)
+		rec->parent_generation = parent_gen;
+	else
+		rec->parent_generation = 0;
+
 	rec->cache.start = start;
 	rec->cache.size = nr;
 	ret = insert_cache_extent(extent_cache, &rec->cache);
@@ -2780,7 +2788,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 
 	cache = lookup_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
-		add_extent_rec(extent_cache, NULL, bytenr,
+		add_extent_rec(extent_cache, NULL, 0, bytenr,
 			       1, 0, 0, 0, 0, 1, 0, 0);
 		cache = lookup_cache_extent(extent_cache, bytenr, 1);
 		if (!cache)
@@ -2828,7 +2836,7 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 
 	cache = lookup_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
-		add_extent_rec(extent_cache, NULL, bytenr, 1, 0, 0, 0, 0,
+		add_extent_rec(extent_cache, NULL, 0, bytenr, 1, 0, 0, 0, 0,
 			       0, 0, max_size);
 		cache = lookup_cache_extent(extent_cache, bytenr, 1);
 		if (!cache)
@@ -3315,7 +3323,7 @@ static int process_extent_item(struct btrfs_root *root,
 #else
 		BUG();
 #endif
-		return add_extent_rec(extent_cache, NULL, key.objectid,
+		return add_extent_rec(extent_cache, NULL, 0, key.objectid,
 				      num_bytes, refs, 0, 0, 0, metadata, 1,
 				      num_bytes);
 	}
@@ -3323,7 +3331,7 @@ static int process_extent_item(struct btrfs_root *root,
 	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
 	refs = btrfs_extent_refs(eb, ei);
 
-	add_extent_rec(extent_cache, NULL, key.objectid, num_bytes,
+	add_extent_rec(extent_cache, NULL, 0, key.objectid, num_bytes,
 		       refs, 0, 0, 0, metadata, 1, num_bytes);
 
 	ptr = (unsigned long)(ei + 1);
@@ -3836,6 +3844,7 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 	u64 owner;
 	u64 flags;
 	u64 ptr;
+	u64 gen = 0;
 	int ret = 0;
 	int i;
 	int nritems;
@@ -3885,8 +3894,16 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 		free(cache);
 	}
 
+	cache = lookup_cache_extent(extent_cache, bytenr, size);
+	if (cache) {
+		struct extent_record *rec;
+
+		rec = container_of(cache, struct extent_record, cache);
+		gen = rec->parent_generation;
+	}
+
 	/* fixme, get the real parent transid */
-	buf = read_tree_block(root, bytenr, size, 0);
+	buf = read_tree_block(root, bytenr, size, gen);
 	if (!extent_buffer_uptodate(buf)) {
 		record_bad_block_io(root->fs_info,
 				    extent_cache, bytenr, size);
@@ -4059,6 +4076,7 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 				}
 			}
 			ret = add_extent_rec(extent_cache, &key,
+					     btrfs_node_ptr_generation(buf, i),
 					     ptr, size, 0, 0, 1, 0, 1, 0,
 					     size);
 			BUG_ON(ret);
@@ -4100,7 +4118,7 @@ static int add_root_to_pending(struct extent_buffer *buf,
 		add_pending(nodes, seen, buf->start, buf->len);
 	else
 		add_pending(pending, seen, buf->start, buf->len);
-	add_extent_rec(extent_cache, NULL, buf->start, buf->len,
+	add_extent_rec(extent_cache, NULL, 0, buf->start, buf->len,
 		       0, 1, 1, 0, 1, 0, buf->len);
 
 	if (root_key->objectid == BTRFS_TREE_RELOC_OBJECTID ||
-- 
1.8.3.1

