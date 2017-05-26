Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45841 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946511AbdEZB1P (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 21:27:15 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4Q1RE70003063
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v4Q1REBG031362
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:14 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v4Q1RCAB024813
        for <linux-btrfs@vger.kernel.org>; Fri, 26 May 2017 01:27:13 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] Btrfs: convert to use btrfs_get_extent_inline_ref_type
Date: Thu, 25 May 2017 18:26:27 -0600
Message-Id: <20170526002631.8546-3-bo.li.liu@oracle.com>
In-Reply-To: <20170526002631.8546-1-bo.li.liu@oracle.com>
References: <20170526002631.8546-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have a helper which can do sanity check, this converts all
btrfs_extent_inline_ref_type to it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/backref.c     |  9 +++++++--
 fs/btrfs/extent-tree.c | 33 ++++++++++++++++++++++++++-------
 fs/btrfs/relocation.c  | 15 +++++++++++++--
 3 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 7699e16..6ffc6bb 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1009,7 +1009,10 @@ static int __add_inline_refs(struct btrfs_path *path, u64 bytenr,
 		int type;
 
 		iref = (struct btrfs_extent_inline_ref *)ptr;
-		type = btrfs_extent_inline_ref_type(leaf, iref);
+		type = btrfs_get_extent_inline_ref_type(leaf, iref, 2);
+		if (type == -EINVAL)
+			return -EINVAL;
+
 		offset = btrfs_extent_inline_ref_offset(leaf, iref);
 
 		switch (type) {
@@ -1905,7 +1908,9 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
 
 	end = (unsigned long)ei + item_size;
 	*out_eiref = (struct btrfs_extent_inline_ref *)(*ptr);
-	*out_type = btrfs_extent_inline_ref_type(eb, *out_eiref);
+	*out_type = btrfs_get_extent_inline_ref_type(eb, *out_eiref, 2);
+	if (*out_type == -EINVAL)
+		return -EINVAL;
 
 	*ptr += btrfs_extent_inline_ref_size(*out_type);
 	WARN_ON(*ptr > end);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index fba8ca0..ecbed56 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1421,12 +1421,18 @@ static noinline u32 extent_data_ref_count(struct btrfs_path *path,
 	struct btrfs_extent_data_ref *ref1;
 	struct btrfs_shared_data_ref *ref2;
 	u32 num_refs = 0;
+	int type;
 
 	leaf = path->nodes[0];
 	btrfs_item_key_to_cpu(leaf, &key, path->slots[0]);
 	if (iref) {
-		if (btrfs_extent_inline_ref_type(leaf, iref) ==
-		    BTRFS_EXTENT_DATA_REF_KEY) {
+		/*
+		 * If type is invalid, we should have bailed out earlier than
+		 * this call.
+		 */
+		type = btrfs_get_extent_inline_ref_type(leaf, iref, 1);
+		ASSERT(type > 0);
+		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 			ref1 = (struct btrfs_extent_data_ref *)(&iref->offset);
 			num_refs = btrfs_extent_data_ref_count(leaf, ref1);
 		} else {
@@ -1587,6 +1593,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	int ret;
 	int err = 0;
 	bool skinny_metadata = btrfs_fs_incompat(fs_info, SKINNY_METADATA);
+	int is_data = !!(owner >= BTRFS_FIRST_FREE_OBJECTID);
 
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -1603,7 +1610,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	 * Owner is our parent level, so we can just add one to get the level
 	 * for the block we are interested in.
 	 */
-	if (skinny_metadata && owner < BTRFS_FIRST_FREE_OBJECTID) {
+	if (skinny_metadata && !is_data) {
 		key.type = BTRFS_METADATA_ITEM_KEY;
 		key.offset = owner;
 	}
@@ -1685,7 +1692,12 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 			break;
 		}
 		iref = (struct btrfs_extent_inline_ref *)ptr;
-		type = btrfs_extent_inline_ref_type(leaf, iref);
+		type = btrfs_get_extent_inline_ref_type(leaf, iref, is_data);
+		if (type == -EINVAL) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		if (want < type)
 			break;
 		if (want > type) {
@@ -1877,7 +1889,12 @@ void update_inline_extent_backref(struct btrfs_fs_info *fs_info,
 	if (extent_op)
 		__run_delayed_extent_op(extent_op, leaf, ei);
 
-	type = btrfs_extent_inline_ref_type(leaf, iref);
+	/*
+	 * If type is invalid, we should have bailed out after
+	 * lookup_inline_extent_backref().
+	 */
+	type = btrfs_get_extent_inline_ref_type(leaf, iref, 2);
+	ASSERT(type > 0);
 
 	if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
@@ -3146,6 +3163,7 @@ static noinline int check_committed_ref(struct btrfs_root *root,
 	struct btrfs_extent_item *ei;
 	struct btrfs_key key;
 	u32 item_size;
+	int type;
 	int ret;
 
 	key.objectid = bytenr;
@@ -3187,8 +3205,9 @@ static noinline int check_committed_ref(struct btrfs_root *root,
 		goto out;
 
 	iref = (struct btrfs_extent_inline_ref *)(ei + 1);
-	if (btrfs_extent_inline_ref_type(leaf, iref) !=
-	    BTRFS_EXTENT_DATA_REF_KEY)
+
+	type = btrfs_get_extent_inline_ref_type(leaf, iref, 1);
+	if (type != BTRFS_EXTENT_DATA_REF_KEY)
 		goto out;
 
 	ref = (struct btrfs_extent_data_ref *)(&iref->offset);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index d60df51..b043e200 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -799,9 +799,16 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 		if (ptr < end) {
 			/* update key for inline back ref */
 			struct btrfs_extent_inline_ref *iref;
+			int type;
 			iref = (struct btrfs_extent_inline_ref *)ptr;
-			key.type = btrfs_extent_inline_ref_type(eb, iref);
+			type = btrfs_get_extent_inline_ref_type(eb, iref, 0);
+			if (type < 0) {
+				ret = type;
+				goto out;
+			}
+			key.type = type;
 			key.offset = btrfs_extent_inline_ref_offset(eb, iref);
+
 			WARN_ON(key.type != BTRFS_TREE_BLOCK_REF_KEY &&
 				key.type != BTRFS_SHARED_BLOCK_REF_KEY);
 		}
@@ -3740,6 +3747,7 @@ int add_data_references(struct reloc_control *rc,
 	u32 blocksize = rc->extent_root->fs_info->nodesize;
 	int ret = 0;
 	int err = 0;
+	int type = 0;
 
 	eb = path->nodes[0];
 	ptr = btrfs_item_ptr_offset(eb, path->slots[0]);
@@ -3753,7 +3761,10 @@ int add_data_references(struct reloc_control *rc,
 
 	while (ptr < end) {
 		iref = (struct btrfs_extent_inline_ref *)ptr;
-		key.type = btrfs_extent_inline_ref_type(eb, iref);
+		type = btrfs_get_extent_inline_ref_type(eb, iref, 1);
+		if (type < 0)
+			key.type = 0;
+
 		if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
 			key.offset = btrfs_extent_inline_ref_offset(eb, iref);
 			ret = __add_tree_block(rc, key.offset, blocksize,
-- 
2.9.4

