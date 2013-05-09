Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44541 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3EIOJ7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 May 2013 10:09:59 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9F2877C04E9
	for <linux-btrfs@vger.kernel.org>; Thu,  9 May 2013 08:09:58 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id T2r3COLmPLxL4TMq (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 09 May 2013 08:09:57 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add the ability to find mismmatching backrefs
Date: Thu, 9 May 2013 10:09:55 -0400
Message-ID: <1368108595-2836-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An unfortunate side effect to my fsync bug means that anybody who didn't hit the
BUG_ON() during tree log replay would have ended up with a corrupted file
system.  Currently our fsck does not catch this because it just looks for
bytenrs for backrefs, it doesn't look at the num_bytes at all.  So this patch
makes us keep track of how big the backrefs are, since their disk_num_bytes
_have_ to match the number of bytes for the actual extent item.  With this patch
fsck now finds problems with a file system it previously thought was ok.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 53 insertions(+), 12 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 71f5959..1e5e005 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -66,6 +66,7 @@ struct data_backref {
 	};
 	u64 owner;
 	u64 offset;
+	u64 bytes;
 	u32 num_refs;
 	u32 found_ref;
 };
@@ -1922,6 +1923,17 @@ static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 					(unsigned long long)dback->offset,
 					dback->found_ref, dback->num_refs, back);
 			}
+			if (dback->bytes != rec->nr) {
+				err = 1;
+				if (!print_errs)
+					goto out;
+				fprintf(stderr, "Backref bytes do not match "
+					"extent backref, bytenr=%llu, ref "
+					"bytes=%llu, backref bytes=%llu\n",
+					(unsigned long long)rec->start,
+					(unsigned long long)rec->nr,
+					(unsigned long long)dback->bytes);
+			}
 		}
 		if (!back->is_data) {
 			found += 1;
@@ -2167,7 +2179,8 @@ static struct tree_backref *alloc_tree_backref(struct extent_record *rec,
 
 static struct data_backref *find_data_backref(struct extent_record *rec,
 						u64 parent, u64 root,
-						u64 owner, u64 offset)
+						u64 owner, u64 offset,
+						int found_ref, u64 bytes)
 {
 	struct list_head *cur = rec->backrefs.next;
 	struct extent_backref *node;
@@ -2188,8 +2201,12 @@ static struct data_backref *find_data_backref(struct extent_record *rec,
 			if (node->full_backref)
 				continue;
 			if (back->root == root && back->owner == owner &&
-			    back->offset == offset)
+			    back->offset == offset) {
+				if (found_ref && node->found_ref &&
+				    back->bytes != bytes)
+					continue;
 				return back;
+			}
 		}
 	}
 	return NULL;
@@ -2215,6 +2232,7 @@ static struct data_backref *alloc_data_backref(struct extent_record *rec,
 		ref->offset = offset;
 		ref->node.full_backref = 0;
 	}
+	ref->bytes = max_size;
 	ref->found_ref = 0;
 	ref->num_refs = 0;
 	list_add_tail(&ref->node.list, &rec->backrefs);
@@ -2227,7 +2245,7 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 			  struct btrfs_key *parent_key,
 			  u64 start, u64 nr, u64 extent_item_refs,
 			  int is_root, int inc_ref, int set_checked,
-			  int metadata, u64 max_size)
+			  int metadata, int extent_rec, u64 max_size)
 {
 	struct extent_record *rec;
 	struct cache_extent *cache;
@@ -2241,6 +2259,14 @@ static int add_extent_rec(struct cache_tree *extent_cache,
 		if (rec->nr == 1)
 			rec->nr = max(nr, max_size);
 
+		/*
+		 * We need to make sure to reset nr to whatever the extent
+		 * record says was the real size, this way we can compare it to
+		 * the backrefs.
+		 */
+		if (extent_rec)
+			rec->nr = nr;
+
 		if (start != rec->start) {
 			fprintf(stderr, "warning, start mismatch %llu %llu\n",
 				(unsigned long long)rec->start,
@@ -2325,7 +2351,7 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 	cache = find_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
 		add_extent_rec(extent_cache, NULL, bytenr,
-			       1, 0, 0, 0, 0, 1, 0);
+			       1, 0, 0, 0, 0, 1, 0, 0);
 		cache = find_cache_extent(extent_cache, bytenr, 1);
 		if (!cache)
 			abort();
@@ -2373,7 +2399,7 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 	cache = find_cache_extent(extent_cache, bytenr, 1);
 	if (!cache) {
 		add_extent_rec(extent_cache, NULL, bytenr, 1, 0, 0, 0, 0,
-			       0, max_size);
+			       0, 0, max_size);
 		cache = find_cache_extent(extent_cache, bytenr, 1);
 		if (!cache)
 			abort();
@@ -2386,15 +2412,29 @@ static int add_data_backref(struct cache_tree *extent_cache, u64 bytenr,
 	if (rec->max_size < max_size)
 		rec->max_size = max_size;
 
-	back = find_data_backref(rec, parent, root, owner, offset);
+	/*
+	 * If found_ref is set then max_size is the real size and must match the
+	 * existing refs.  So if we have already found a ref then we need to
+	 * make sure that this ref matches the existing one, otherwise we need
+	 * to add a new backref so we can notice that the backrefs don't match
+	 * and we need to figure out who is telling the truth.  This is to
+	 * account for that awful fsync bug I introduced where we'd end up with
+	 * a btrfs_file_extent_item that would have its length include multiple
+	 * prealloc extents or point inside of a prealloc extent.
+	 */
+	back = find_data_backref(rec, parent, root, owner, offset, found_ref,
+				 max_size);
 	if (!back)
 		back = alloc_data_backref(rec, parent, root, owner, offset,
 					  max_size);
 
 	if (found_ref) {
 		BUG_ON(num_refs != 1);
+		if (back->node.found_ref)
+			BUG_ON(back->bytes != max_size);
 		back->node.found_ref = 1;
 		back->found_ref += 1;
+		back->bytes = max_size;
 	} else {
 		if (back->node.found_extent_tree) {
 			fprintf(stderr, "Extent back ref already exists "
@@ -2548,7 +2588,7 @@ static int process_extent_item(struct btrfs_root *root,
 		BUG();
 #endif
 		return add_extent_rec(extent_cache, NULL, key.objectid,
-				      num_bytes, refs, 0, 0, 0, metadata,
+				      num_bytes, refs, 0, 0, 0, metadata, 1,
 				      num_bytes);
 	}
 
@@ -2556,7 +2596,7 @@ static int process_extent_item(struct btrfs_root *root,
 	refs = btrfs_extent_refs(eb, ei);
 
 	add_extent_rec(extent_cache, NULL, key.objectid, num_bytes,
-		       refs, 0, 0, 0, metadata, num_bytes);
+		       refs, 0, 0, 0, metadata, 1, num_bytes);
 
 	ptr = (unsigned long)(ei + 1);
 	if (btrfs_extent_flags(eb, ei) & BTRFS_EXTENT_FLAG_TREE_BLOCK &&
@@ -3203,7 +3243,7 @@ static int run_next_block(struct btrfs_root *root,
 			ret = add_extent_rec(extent_cache, NULL,
 				   btrfs_file_extent_disk_bytenr(buf, fi),
 				   btrfs_file_extent_disk_num_bytes(buf, fi),
-				   0, 0, 1, 1, 0,
+				   0, 0, 1, 1, 0, 0,
 				   btrfs_file_extent_disk_num_bytes(buf, fi));
 			add_data_backref(extent_cache,
 				btrfs_file_extent_disk_bytenr(buf, fi),
@@ -3226,7 +3266,8 @@ static int run_next_block(struct btrfs_root *root,
 			u32 size = btrfs_level_size(root, level - 1);
 			btrfs_node_key_to_cpu(buf, &key, i);
 			ret = add_extent_rec(extent_cache, &key,
-					     ptr, size, 0, 0, 1, 0, 1, size);
+					     ptr, size, 0, 0, 1, 0, 1, 0,
+					     size);
 			BUG_ON(ret);
 
 			add_tree_backref(extent_cache, ptr, parent, owner, 1);
@@ -3267,7 +3308,7 @@ static int add_root_to_pending(struct extent_buffer *buf,
 	else
 		add_pending(pending, seen, buf->start, buf->len);
 	add_extent_rec(extent_cache, NULL, buf->start, buf->len,
-		       0, 1, 1, 0, 1, buf->len);
+		       0, 1, 1, 0, 1, 0, buf->len);
 
 	if (root_key->objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
@@ -3303,7 +3344,7 @@ static int free_extent_hook(struct btrfs_trans_handle *trans,
 	if (is_data) {
 		struct data_backref *back;
 		back = find_data_backref(rec, parent, root_objectid, owner,
-					 offset);
+					 offset, 1, num_bytes);
 		if (!back)
 			goto out;
 		if (back->node.found_ref) {
-- 
1.7.7.6

