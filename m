Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35322 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755708Ab3F1RNB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Jun 2013 13:13:01 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3F4DE9A06C8
	for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 11:13:01 -0600 (MDT)
Received: from CAS2.int.fusionio.com (cas2.int.fusionio.com [10.101.1.41]) by mx2.fusionio.com with ESMTP id CXVeOVWA4nq1vOUp (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 28 Jun 2013 11:13:00 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: make backref walking code handle skinny metadata
Date: Fri, 28 Jun 2013 13:12:58 -0400
Message-ID: <1372439578-17151-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I missed fixing the backref stuff when I introduced the skinny metadata.  If you
try and do things like snapshot aware defrag with skinny metadata you are going
to see tons of warnings related to the backref count being less than 0.  This is
because the delayed refs will be found for stuff just fine, but it won't find
the skinny metadata extent refs.  With this patch I'm not seeing warnings
anymore.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/backref.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 431ea92..eaf1333 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -597,6 +597,7 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 	int slot;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
+	struct btrfs_key found_key;
 	unsigned long ptr;
 	unsigned long end;
 	struct btrfs_extent_item *ei;
@@ -614,17 +615,21 @@ static int __add_inline_refs(struct btrfs_fs_info *fs_info,
 
 	ei = btrfs_item_ptr(leaf, slot, struct btrfs_extent_item);
 	flags = btrfs_extent_flags(leaf, ei);
+	btrfs_item_key_to_cpu(leaf, &found_key, slot);
 
 	ptr = (unsigned long)(ei + 1);
 	end = (unsigned long)ei + item_size;
 
-	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
+	if (found_key.type == BTRFS_EXTENT_ITEM_KEY &&
+	    flags & BTRFS_EXTENT_FLAG_TREE_BLOCK) {
 		struct btrfs_tree_block_info *info;
 
 		info = (struct btrfs_tree_block_info *)ptr;
 		*info_level = btrfs_tree_block_level(leaf, info);
 		ptr += sizeof(struct btrfs_tree_block_info);
 		BUG_ON(ptr > end);
+	} else if (found_key.type == BTRFS_METADATA_ITEM_KEY) {
+		*info_level = found_key.offset;
 	} else {
 		BUG_ON(!(flags & BTRFS_EXTENT_FLAG_DATA));
 	}
@@ -796,8 +801,11 @@ static int find_parent_nodes(struct btrfs_trans_handle *trans,
 	INIT_LIST_HEAD(&prefs_delayed);
 
 	key.objectid = bytenr;
-	key.type = BTRFS_EXTENT_ITEM_KEY;
 	key.offset = (u64)-1;
+	if (btrfs_fs_incompat(fs_info, SKINNY_METADATA))
+		key.type = BTRFS_METADATA_ITEM_KEY;
+	else
+		key.type = BTRFS_EXTENT_ITEM_KEY;
 
 	path = btrfs_alloc_path();
 	if (!path)
@@ -862,7 +870,8 @@ again:
 		slot = path->slots[0];
 		btrfs_item_key_to_cpu(leaf, &key, slot);
 		if (key.objectid == bytenr &&
-		    key.type == BTRFS_EXTENT_ITEM_KEY) {
+		    (key.type == BTRFS_EXTENT_ITEM_KEY ||
+		     key.type == BTRFS_METADATA_ITEM_KEY)) {
 			ret = __add_inline_refs(fs_info, path, bytenr,
 						&info_level, &prefs);
 			if (ret)
@@ -1276,12 +1285,16 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 {
 	int ret;
 	u64 flags;
+	u64 size = 0;
 	u32 item_size;
 	struct extent_buffer *eb;
 	struct btrfs_extent_item *ei;
 	struct btrfs_key key;
 
-	key.type = BTRFS_EXTENT_ITEM_KEY;
+	if (btrfs_fs_incompat(fs_info, SKINNY_METADATA))
+		key.type = BTRFS_METADATA_ITEM_KEY;
+	else
+		key.type = BTRFS_EXTENT_ITEM_KEY;
 	key.objectid = logical;
 	key.offset = (u64)-1;
 
@@ -1294,9 +1307,15 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 		return ret;
 
 	btrfs_item_key_to_cpu(path->nodes[0], found_key, path->slots[0]);
-	if (found_key->type != BTRFS_EXTENT_ITEM_KEY ||
+	if (found_key->type == BTRFS_METADATA_ITEM_KEY)
+		size = fs_info->extent_root->leafsize;
+	else if (found_key->type == BTRFS_EXTENT_ITEM_KEY)
+		size = found_key->offset;
+
+	if ((found_key->type != BTRFS_EXTENT_ITEM_KEY &&
+	     found_key->type != BTRFS_METADATA_ITEM_KEY) ||
 	    found_key->objectid > logical ||
-	    found_key->objectid + found_key->offset <= logical) {
+	    found_key->objectid + size <= logical) {
 		pr_debug("logical %llu is not within any extent\n",
 			 (unsigned long long)logical);
 		return -ENOENT;
-- 
1.7.7.6

