Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbaCRMFE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 08:05:04 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2IC4uW7001921
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 20:04:57 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] Btrfs-progs: fsck: add ability to rebuild extent tree with snapshots
Date: Tue, 18 Mar 2014 20:02:45 +0800
Message-Id: <1395144167-775-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1395144167-775-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch makes us to rebuild a really corrupt extent tree with snapshots.
To implement this, we have to verify whether a block is FULL BACKREF.

This idea come from Josef Bacik:

1) We walk down the original tree, every eb we encounter has
btrfs_header_owner(eb) == root->objectid.  We add normal references
for this root (BTRFS_TREE_BLOCK_REF_KEY) for this root.  World peace
is achieved.

2) We walk down the snapshotted tree.  Say we didn't change anything
at all, it was just a clean snapshot and then boom.  So the
btrfs_header_owner(root->node) == root->objectid, so normal backref.
We walk down to the next level, where btrfs_header_owner(eb) !=
root->objectid, but the level above did, so we add normal refs for all
of these blocks.  We go down the next level, now our
btrfs_header_owner(parent) != root->objectid and
btrfs_header_owner(eb) != root->objectid.  This is where we need to
now go back and see if btrfs_header_owner(eb) currently has a ref on
eb.  If it does we are done, move on to the next block in this same
level, we don't have to go further down.

3) Harder case, we snapshotted and then changed things in the original
root.  Do the same thing as in step 2, but now we get down to
btrfs_header_owner(eb) != root->objectid && btrfs_header_owner(parent)
!= root->objectid.  We lookup the references we have for eb and notice
that btrfs_header_owner(eb) no longer refers to eb.  So now we must
set FULL_BACKREF on this extent reference and add a
SHARED_BLOCK_REF_KEY for this eb using the parent->start as the
offset.  And we need to keep walking down and doing the same thing
until we either hit level 0 or btrfs_header_owner(eb) has a ref on the
block.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 132 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 129 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index e40b806..e1238d7 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -107,6 +107,7 @@ struct extent_record {
 	unsigned int owner_ref_checked:1;
 	unsigned int is_root:1;
 	unsigned int metadata:1;
+	unsigned int flag_block_full_backref:1;
 };
 
 struct inode_backref {
@@ -3829,6 +3830,127 @@ static int is_dropped_key(struct btrfs_key *key,
 	return 0;
 }
 
+static int calc_extent_flag(struct btrfs_root *root,
+			   struct cache_tree *extent_cache,
+			   struct extent_buffer *buf,
+			   struct root_item_record *ri,
+			   u64 *flags)
+{
+	int i;
+	int nritems = btrfs_header_nritems(buf);
+	struct btrfs_key key;
+	struct extent_record *rec;
+	struct cache_extent *cache;
+	struct data_backref *dback;
+	struct tree_backref *tback;
+	struct extent_buffer *new_buf;
+	u64 owner = 0;
+	u64 bytenr;
+	u64 offset;
+	u64 ptr;
+	int size;
+	int ret;
+	u8 level;
+
+	/*
+	 * Except file/reloc tree, we can not have
+	 * FULL BACKREF MODE
+	 */
+	if (ri->objectid < BTRFS_FIRST_FREE_OBJECTID)
+		goto normal;
+	/*
+	 * root node
+	 */
+	if (buf->start == ri->bytenr)
+		goto normal;
+	if (btrfs_is_leaf(buf)) {
+		/*
+		 * we are searching from original root, world
+		 * peace is achieved, we use normal backref.
+		 */
+		owner = btrfs_header_owner(buf);
+		if (owner == ri->objectid)
+			goto normal;
+		/*
+		 * we check every eb here, and if any of
+		 * eb dosen't have original root refers
+		 * to this eb, we set full backref flag for
+		 * this extent, otherwise normal backref.
+		 */
+		for (i = 0; i < nritems; i++) {
+			struct btrfs_file_extent_item *fi;
+			btrfs_item_key_to_cpu(buf, &key, i);
+
+			if (key.type != BTRFS_EXTENT_DATA_KEY)
+				continue;
+			fi = btrfs_item_ptr(buf, i,
+					    struct btrfs_file_extent_item);
+			if (btrfs_file_extent_type(buf, fi) ==
+			    BTRFS_FILE_EXTENT_INLINE)
+				continue;
+			if (btrfs_file_extent_disk_bytenr(buf, fi) == 0)
+				continue;
+			bytenr = btrfs_file_extent_disk_bytenr(buf, fi);
+			cache = lookup_cache_extent(extent_cache, bytenr, 1);
+			if (!cache)
+				goto full_backref;
+			offset = btrfs_file_extent_offset(buf, fi);
+			rec = container_of(cache, struct extent_record, cache);
+			dback = find_data_backref(rec, 0, ri->objectid, owner,
+					key.offset - offset, 1, bytenr, bytenr);
+			if (!dback)
+				goto full_backref;
+		}
+		goto full_backref;
+	} else {
+		level = btrfs_header_level(buf);
+		for (i = 0; i < nritems; i++) {
+			ptr = btrfs_node_blockptr(buf, i);
+			size = btrfs_level_size(root, level);
+			if (i == 0) {
+				new_buf = read_tree_block(root, ptr, size, 0);
+				if (!extent_buffer_uptodate(new_buf)) {
+					free_extent_buffer(new_buf);
+					ret = -EIO;
+					return ret;
+				}
+				/*
+				 * we are searching from origin root, world
+				 * peace is achieved, we use normal backref.
+				 */
+				owner = btrfs_header_owner(new_buf);
+				free_extent_buffer(new_buf);
+				if (owner == ri->objectid)
+					goto normal;
+			}
+			cache = lookup_cache_extent(extent_cache, ptr, size);
+			if (!cache)
+				goto full_backref;
+			rec = container_of(cache, struct extent_record, cache);
+			tback = find_tree_backref(rec, 0, owner);
+			if (!tback)
+				goto full_backref;
+		}
+
+	}
+normal:
+	*flags = 0;
+	cache = lookup_cache_extent(extent_cache, buf->start, 1);
+	/* we have added this extent before */
+	BUG_ON(!cache);
+	rec = container_of(cache, struct extent_record, cache);
+	rec->flag_block_full_backref = 0;
+	return 0;
+full_backref:
+	*flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
+	cache = lookup_cache_extent(extent_cache, buf->start, 1);
+	/* we have added this extent before */
+	BUG_ON(!cache);
+	rec = container_of(cache, struct extent_record, cache);
+	rec->flag_block_full_backref = 1;
+	return 0;
+}
+
 static int run_next_block(struct btrfs_trans_handle *trans,
 			  struct btrfs_root *root,
 			  struct block_info *bits,
@@ -3923,9 +4045,12 @@ static int run_next_block(struct btrfs_trans_handle *trans,
 				       btrfs_header_level(buf), 1, NULL,
 				       &flags);
 		if (ret < 0)
-			flags = 0;
+			goto out;
 	} else {
 		flags = 0;
+		ret = calc_extent_flag(root, extent_cache, buf, ri, &flags);
+		if (ret < 0)
+			goto out;
 	}
 
 	if (flags & BTRFS_BLOCK_FLAG_FULL_BACKREF) {
@@ -5115,9 +5240,10 @@ static int fixup_extent_refs(struct btrfs_trans_handle *trans,
 					rec->start, rec->max_size,
 					rec->metadata, NULL, &flags);
 		if (ret < 0)
-			flags = 0;
+			return ret;
 	} else {
-		flags = 0;
+		if (rec->flag_block_full_backref)
+			flags |= BTRFS_BLOCK_FLAG_FULL_BACKREF;
 	}
 
 	path = btrfs_alloc_path();
-- 
1.9.0

