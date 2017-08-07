Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29466 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbdHGW4t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 18:56:49 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v77Mum4t006232
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v77MumsK002216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v77MumZv017493
        for <linux-btrfs@vger.kernel.org>; Mon, 7 Aug 2017 22:56:48 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/7] Btrfs: convert to use btrfs_get_extent_inline_ref_type
Date: Mon,  7 Aug 2017 15:55:26 -0600
Message-Id: <20170807215531.12423-3-bo.li.liu@oracle.com>
In-Reply-To: <20170807215531.12423-1-bo.li.liu@oracle.com>
References: <20170807215531.12423-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have a helper which can do sanity check, this converts all
btrfs_extent_inline_ref_type to it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/backref.c     | 11 +++++++++--
 fs/btrfs/extent-tree.c | 36 ++++++++++++++++++++++++++++++------
 fs/btrfs/relocation.c  | 13 +++++++++++--
 3 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index f723c11..1b3d9df 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1012,7 +1012,11 @@ static int __add_inline_refs(struct btrfs_path *path, u64 bytenr,
 		int type;
 
 		iref = (struct btrfs_extent_inline_ref *)ptr;
-		type = btrfs_extent_inline_ref_type(leaf, iref);
+		type = btrfs_get_extent_inline_ref_type(leaf, iref,
+							BTRFS_REF_TYPE_ANY);
+		if (type == BTRFS_REF_TYPE_INVALID)
+			return -EINVAL;
+
 		offset = btrfs_extent_inline_ref_offset(leaf, iref);
 
 		switch (type) {
@@ -1908,7 +1912,10 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
 
 	end = (unsigned long)ei + item_size;
 	*out_eiref = (struct btrfs_extent_inline_ref *)(*ptr);
-	*out_type = btrfs_extent_inline_ref_type(eb, *out_eiref);
+	*out_type = btrfs_get_extent_inline_ref_type(eb, *out_eiref,
+						     BTRFS_REF_TYPE_ANY);
+	if (*out_type == BTRFS_REF_TYPE_INVALID)
+		return -EINVAL;
 
 	*ptr += btrfs_extent_inline_ref_size(*out_type);
 	WARN_ON(*ptr > end);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 83a3cdc..80b4db3c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1453,12 +1453,18 @@ static noinline u32 extent_data_ref_count(struct btrfs_path *path,
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
+		type = btrfs_get_extent_inline_ref_type(leaf, iref, BTRFS_REF_TYPE_DATA);
+		ASSERT(type != BTRFS_REF_TYPE_INVALID);
+		if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 			ref1 = (struct btrfs_extent_data_ref *)(&iref->offset);
 			num_refs = btrfs_extent_data_ref_count(leaf, ref1);
 		} else {
@@ -1619,6 +1625,7 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 	int ret;
 	int err = 0;
 	bool skinny_metadata = btrfs_fs_incompat(fs_info, SKINNY_METADATA);
+	int needed;
 
 	key.objectid = bytenr;
 	key.type = BTRFS_EXTENT_ITEM_KEY;
@@ -1710,6 +1717,11 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 		BUG_ON(ptr > end);
 	}
 
+	if (owner >= BTRFS_FIRST_FREE_OBJECTID)
+		needed = BTRFS_REF_TYPE_DATA;
+	else
+		needed = BTRFS_REF_TYPE_BLOCK;
+
 	err = -ENOENT;
 	while (1) {
 		if (ptr >= end) {
@@ -1717,7 +1729,12 @@ int lookup_inline_extent_backref(struct btrfs_trans_handle *trans,
 			break;
 		}
 		iref = (struct btrfs_extent_inline_ref *)ptr;
-		type = btrfs_extent_inline_ref_type(leaf, iref);
+		type = btrfs_get_extent_inline_ref_type(leaf, iref, needed);
+		if (type == BTRFS_REF_TYPE_INVALID) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		if (want < type)
 			break;
 		if (want > type) {
@@ -1909,7 +1926,12 @@ void update_inline_extent_backref(struct btrfs_fs_info *fs_info,
 	if (extent_op)
 		__run_delayed_extent_op(extent_op, leaf, ei);
 
-	type = btrfs_extent_inline_ref_type(leaf, iref);
+	/*
+	 * If type is invalid, we should have bailed out after
+	 * lookup_inline_extent_backref().
+	 */
+	type = btrfs_get_extent_inline_ref_type(leaf, iref, BTRFS_REF_TYPE_ANY);
+	ASSERT(type != BTRFS_REF_TYPE_INVALID);
 
 	if (type == BTRFS_EXTENT_DATA_REF_KEY) {
 		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
@@ -3194,6 +3216,7 @@ static noinline int check_committed_ref(struct btrfs_root *root,
 	struct btrfs_extent_item *ei;
 	struct btrfs_key key;
 	u32 item_size;
+	int type;
 	int ret;
 
 	key.objectid = bytenr;
@@ -3235,8 +3258,9 @@ static noinline int check_committed_ref(struct btrfs_root *root,
 		goto out;
 
 	iref = (struct btrfs_extent_inline_ref *)(ei + 1);
-	if (btrfs_extent_inline_ref_type(leaf, iref) !=
-	    BTRFS_EXTENT_DATA_REF_KEY)
+
+	type = btrfs_get_extent_inline_ref_type(leaf, iref, BTRFS_REF_TYPE_DATA);
+	if (type != BTRFS_EXTENT_DATA_REF_KEY)
 		goto out;
 
 	ref = (struct btrfs_extent_data_ref *)(&iref->offset);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 65661d1..f0bef3c 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -799,9 +799,17 @@ struct backref_node *build_backref_tree(struct reloc_control *rc,
 		if (ptr < end) {
 			/* update key for inline back ref */
 			struct btrfs_extent_inline_ref *iref;
+			int type;
 			iref = (struct btrfs_extent_inline_ref *)ptr;
-			key.type = btrfs_extent_inline_ref_type(eb, iref);
+			type = btrfs_get_extent_inline_ref_type(eb, iref,
+							BTRFS_REF_TYPE_BLOCK);
+			if (type == BTRFS_REF_TYPE_INVALID) {
+				err = -EINVAL;
+				goto out;
+			}
+			key.type = type;
 			key.offset = btrfs_extent_inline_ref_offset(eb, iref);
+
 			WARN_ON(key.type != BTRFS_TREE_BLOCK_REF_KEY &&
 				key.type != BTRFS_SHARED_BLOCK_REF_KEY);
 		}
@@ -3755,7 +3763,8 @@ int add_data_references(struct reloc_control *rc,
 
 	while (ptr < end) {
 		iref = (struct btrfs_extent_inline_ref *)ptr;
-		key.type = btrfs_extent_inline_ref_type(eb, iref);
+		key.type = btrfs_get_extent_inline_ref_type(eb, iref,
+							BTRFS_REF_TYPE_DATA);
 		if (key.type == BTRFS_SHARED_DATA_REF_KEY) {
 			key.offset = btrfs_extent_inline_ref_offset(eb, iref);
 			ret = __add_tree_block(rc, key.offset, blocksize,
-- 
2.9.4

