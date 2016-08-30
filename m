Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47711 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751606AbcH3HW3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 03:22:29 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id D257C4334C87
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Aug 2016 15:22:21 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] btrfs-progs: fsck: Avoid abort and BUG_ON in add_tree_backref
Date: Tue, 30 Aug 2016 15:22:16 +0800
Message-ID: <20160830072217.8599-5-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
References: <20160830072217.8599-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Add_tree_backref() can cause BUG_ON() and abort() in quite a lot of
cases, from the ENOMEM to existing tree backref records.

Change all these BUG_ON() and abort() to return proper values.
And modify all callers to handle such problems.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 75 ++++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 22 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c56b176..ef3e3a1 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4864,20 +4864,25 @@ static int add_tree_backref(struct cache_tree *extent_cache, u64 bytenr,
 
 		add_extent_rec_nolookup(extent_cache, &tmpl);
 
+		/* really a bug in cache_extent implement now */
 		cache = lookup_cache_extent(extent_cache, bytenr, 1);
 		if (!cache)
-			abort();
+			return -ENOENT;
 	}
 
 	rec = container_of(cache, struct extent_record, cache);
 	if (rec->start != bytenr) {
-		abort();
+		/*
+		 * Several cause, from unaligned bytenr to over lapping extents
+		 */
+		return -EEXIST;
 	}
 
 	back = find_tree_backref(rec, parent, root);
 	if (!back) {
 		back = alloc_tree_backref(rec, parent, root);
-		BUG_ON(!back);
+		if (!back)
+			return -ENOMEM;
 	}
 
 	if (found_ref) {
@@ -5154,16 +5159,18 @@ static int process_extent_ref_v0(struct cache_tree *extent_cache,
 {
 	struct btrfs_extent_ref_v0 *ref0;
 	struct btrfs_key key;
+	int ret;
 
 	btrfs_item_key_to_cpu(leaf, &key, slot);
 	ref0 = btrfs_item_ptr(leaf, slot, struct btrfs_extent_ref_v0);
 	if (btrfs_ref_objectid_v0(leaf, ref0) < BTRFS_FIRST_FREE_OBJECTID) {
-		add_tree_backref(extent_cache, key.objectid, key.offset, 0, 0);
+		ret = add_tree_backref(extent_cache, key.objectid, key.offset,
+				0, 0);
 	} else {
-		add_data_backref(extent_cache, key.objectid, key.offset, 0,
-				 0, 0, btrfs_ref_count_v0(leaf, ref0), 0, 0);
+		ret = add_data_backref(extent_cache, key.objectid, key.offset,
+				0, 0, 0, btrfs_ref_count_v0(leaf, ref0), 0, 0);
 	}
-	return 0;
+	return ret;
 }
 #endif
 
@@ -5406,6 +5413,7 @@ static int process_extent_item(struct btrfs_root *root,
 	struct extent_record tmpl;
 	unsigned long end;
 	unsigned long ptr;
+	int ret;
 	int type;
 	u32 item_size = btrfs_item_size_nr(eb, slot);
 	u64 refs = 0;
@@ -5485,12 +5493,18 @@ static int process_extent_item(struct btrfs_root *root,
 		offset = btrfs_extent_inline_ref_offset(eb, iref);
 		switch (type) {
 		case BTRFS_TREE_BLOCK_REF_KEY:
-			add_tree_backref(extent_cache, key.objectid,
-					 0, offset, 0);
+			ret = add_tree_backref(extent_cache, key.objectid,
+					0, offset, 0);
+			if (ret < 0)
+				error("add_tree_backref failed: %s",
+				      strerror(-ret));
 			break;
 		case BTRFS_SHARED_BLOCK_REF_KEY:
-			add_tree_backref(extent_cache, key.objectid,
-					 offset, 0, 0);
+			ret = add_tree_backref(extent_cache, key.objectid,
+					offset, 0, 0);
+			if (ret < 0)
+				error("add_tree_backref failed: %s",
+				      strerror(-ret));
 			break;
 		case BTRFS_EXTENT_DATA_REF_KEY:
 			dref = (struct btrfs_extent_data_ref *)(&iref->offset);
@@ -6413,13 +6427,19 @@ static int run_next_block(struct btrfs_root *root,
 			}
 
 			if (key.type == BTRFS_TREE_BLOCK_REF_KEY) {
-				add_tree_backref(extent_cache, key.objectid, 0,
-						 key.offset, 0);
+				ret = add_tree_backref(extent_cache,
+						key.objectid, 0, key.offset, 0);
+				if (ret < 0)
+					error("add_tree_backref failed: %s",
+					      strerror(-ret));
 				continue;
 			}
 			if (key.type == BTRFS_SHARED_BLOCK_REF_KEY) {
-				add_tree_backref(extent_cache, key.objectid,
-						 key.offset, 0, 0);
+				ret = add_tree_backref(extent_cache,
+						key.objectid, key.offset, 0, 0);
+				if (ret < 0)
+					error("add_tree_backref failed: %s",
+					      strerror(-ret));
 				continue;
 			}
 			if (key.type == BTRFS_EXTENT_DATA_REF_KEY) {
@@ -6517,9 +6537,16 @@ static int run_next_block(struct btrfs_root *root,
 			tmpl.metadata = 1;
 			tmpl.max_size = size;
 			ret = add_extent_rec(extent_cache, &tmpl);
-			BUG_ON(ret);
+			if (ret < 0)
+				goto out;
 
-			add_tree_backref(extent_cache, ptr, parent, owner, 1);
+			ret = add_tree_backref(extent_cache, ptr, parent,
+					owner, 1);
+			if (ret < 0) {
+				error("add_tree_backref failed: %s",
+				      strerror(-ret));
+				continue;
+			}
 
 			if (level > 1) {
 				add_pending(nodes, seen, ptr, size);
@@ -6553,6 +6580,7 @@ static int add_root_to_pending(struct extent_buffer *buf,
 			       u64 objectid)
 {
 	struct extent_record tmpl;
+	int ret;
 
 	if (btrfs_header_level(buf) > 0)
 		add_pending(nodes, seen, buf->start, buf->len);
@@ -6570,11 +6598,12 @@ static int add_root_to_pending(struct extent_buffer *buf,
 
 	if (objectid == BTRFS_TREE_RELOC_OBJECTID ||
 	    btrfs_header_backref_rev(buf) < BTRFS_MIXED_BACKREF_REV)
-		add_tree_backref(extent_cache, buf->start, buf->start,
-				 0, 1);
+		ret = add_tree_backref(extent_cache, buf->start, buf->start,
+				0, 1);
 	else
-		add_tree_backref(extent_cache, buf->start, 0, objectid, 1);
-	return 0;
+		ret = add_tree_backref(extent_cache, buf->start, 0, objectid,
+				1);
+	return ret;
 }
 
 /* as we fix the tree, we might be deleting blocks that
@@ -8425,8 +8454,10 @@ static int deal_root_from_list(struct list_head *list,
 			ret = -EIO;
 			break;
 		}
-		add_root_to_pending(buf, extent_cache, pending,
+		ret = add_root_to_pending(buf, extent_cache, pending,
 				    seen, nodes, rec->objectid);
+		if (ret < 0)
+			break;
 		/*
 		 * To rebuild extent tree, we need deal with snapshot
 		 * one by one, otherwise we deal with node firstly which
-- 
2.9.3



