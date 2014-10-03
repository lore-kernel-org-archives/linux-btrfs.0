Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17425 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbaJCOpe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Oct 2014 10:45:34 -0400
Received: from pps.filterd (m0004060 [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s93EaIPP010287
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Oct 2014 07:45:33 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0b-00082601.pphosted.com with ESMTP id 1psjh5sja1-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Oct 2014 07:45:33 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: add the ability to fix shifted item offsets V3
Date: Fri, 3 Oct 2014 10:45:29 -0400
Message-ID: <1412347529-4175-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A user had a corrupted fs where the items had been shifted improperly.  This
patch adds the ability to fix this sort of problem within fsck.  We will simply
shift the item over to the proper offset and update the offsets to make sure
they are correct.  I tested this with a hand crafted fs that was broken in the
same way as the user, and I've included the file as a new test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V2->V3: the data shifting stuff was wrong, needed to be using btrfs_leaf_data()
in the math.  Fix that and updated the test image appropriately.

 cmds-check.c                           | 121 +++++++++++++++++++++++++++++----
 tests/fsck-tests/003-shift-offsets.img | Bin 0 -> 4096 bytes
 2 files changed, 108 insertions(+), 13 deletions(-)
 create mode 100644 tests/fsck-tests/003-shift-offsets.img

diff --git a/cmds-check.c b/cmds-check.c
index 02fbd4e..df85264 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2413,15 +2413,9 @@ static int swap_values(struct btrfs_root *root, struct btrfs_path *path,
 	return 0;
 }
 
-/*
- * Attempt to fix basic block failures.  Currently we only handle bad key
- * orders, we will cycle through the keys and swap them if necessary.
- */
-static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
-				struct btrfs_root *root,
-				struct extent_buffer *buf,
-				struct btrfs_disk_key *parent_key,
-				enum btrfs_tree_block_status status)
+static int fix_key_order(struct btrfs_trans_handle *trans,
+			 struct btrfs_root *root,
+			 struct extent_buffer *buf)
 {
 	struct btrfs_path *path;
 	struct btrfs_key k1, k2;
@@ -2429,9 +2423,6 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 	int level;
 	int ret;
 
-	if (status != BTRFS_TREE_BLOCK_BAD_KEY_ORDER)
-		return -EIO;
-
 	k1.objectid = btrfs_header_owner(buf);
 	k1.type = BTRFS_ROOT_ITEM_KEY;
 	k1.offset = (u64)-1;
@@ -2482,6 +2473,111 @@ static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int fix_item_offset(struct btrfs_trans_handle *trans,
+			   struct btrfs_root *root,
+			   struct extent_buffer *buf)
+{
+	struct btrfs_path *path;
+	struct btrfs_key k1;
+	int i;
+	int level;
+	int ret;
+
+	k1.objectid = btrfs_header_owner(buf);
+	k1.type = BTRFS_ROOT_ITEM_KEY;
+	k1.offset = (u64)-1;
+
+	root = btrfs_read_fs_root(root->fs_info, &k1);
+	if (IS_ERR(root))
+		return -EIO;
+
+	record_root_in_trans(trans, root);
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -EIO;
+
+	level = btrfs_header_level(buf);
+	path->lowest_level = level;
+	path->skip_check_block = 1;
+	if (level)
+		btrfs_node_key_to_cpu(buf, &k1, 0);
+	else
+		btrfs_item_key_to_cpu(buf, &k1, 0);
+
+	ret = btrfs_search_slot(trans, root, &k1, path, 0, 1);
+	if (ret) {
+		btrfs_free_path(path);
+		return -EIO;
+	}
+
+	buf = path->nodes[level];
+	for (i = 0; i < btrfs_header_nritems(buf); i++) {
+		unsigned int shift = 0, offset;
+
+		if (i == 0 && btrfs_item_end_nr(buf, i) !=
+		    BTRFS_LEAF_DATA_SIZE(root)) {
+			if (btrfs_item_end_nr(buf, i) >
+			    BTRFS_LEAF_DATA_SIZE(root)) {
+				fprintf(stderr, "item is off the end of the "
+					"leaf, can't fix\n");
+				ret = -EIO;
+				break;
+			}
+			shift = BTRFS_LEAF_DATA_SIZE(root) -
+				btrfs_item_end_nr(buf, i);
+		} else if (i > 0 && btrfs_item_end_nr(buf, i) !=
+			   btrfs_item_offset_nr(buf, i - 1)) {
+			if (btrfs_item_end_nr(buf, i) >
+			    btrfs_item_offset_nr(buf, i - 1)) {
+				fprintf(stderr, "items overlap, can't fix\n");
+				ret = -EIO;
+				break;
+			}
+			shift = btrfs_item_offset_nr(buf, i - 1) -
+				btrfs_item_end_nr(buf, i);
+		}
+		if (!shift)
+			continue;
+
+		printf("Shifting item nr %d by %u bytes in block %llu\n",
+		       i, shift, (unsigned long long)buf->start);
+		offset = btrfs_item_offset_nr(buf, i);
+		memmove_extent_buffer(buf,
+				      btrfs_leaf_data(buf) + offset + shift,
+				      btrfs_leaf_data(buf) + offset,
+				      btrfs_item_size_nr(buf, i));
+		btrfs_set_item_offset(buf, btrfs_item_nr(i),
+				      offset + shift);
+		btrfs_mark_buffer_dirty(buf);
+	}
+
+	/*
+	 * We may have moved things, in which case we want to exit so we don't
+	 * write those changes out.  Once we have proper abort functionality in
+	 * progs this can be changed to something nicer.
+	 */
+	BUG_ON(ret);
+	btrfs_free_path(path);
+	return ret;
+}
+
+/*
+ * Attempt to fix basic block failures.  If we can't fix it for whatever reason
+ * then just return -EIO.
+ */
+static int try_to_fix_bad_block(struct btrfs_trans_handle *trans,
+				struct btrfs_root *root,
+				struct extent_buffer *buf,
+				enum btrfs_tree_block_status status)
+{
+	if (status == BTRFS_TREE_BLOCK_BAD_KEY_ORDER)
+		return fix_key_order(trans, root, buf);
+	if (status == BTRFS_TREE_BLOCK_INVALID_OFFSETS)
+		return fix_item_offset(trans, root, buf);
+	return -EIO;
+}
+
 static int check_block(struct btrfs_trans_handle *trans,
 		       struct btrfs_root *root,
 		       struct cache_tree *extent_cache,
@@ -2520,7 +2616,6 @@ static int check_block(struct btrfs_trans_handle *trans,
 	if (status != BTRFS_TREE_BLOCK_CLEAN) {
 		if (repair)
 			status = try_to_fix_bad_block(trans, root, buf,
-						      &rec->parent_key,
 						      status);
 		if (status != BTRFS_TREE_BLOCK_CLEAN) {
 			ret = -EIO;
diff --git a/tests/fsck-tests/003-shift-offsets.img b/tests/fsck-tests/003-shift-offsets.img
new file mode 100644
index 0000000000000000000000000000000000000000..ce23f673e0c6c806027bc53b2786b057d1fe42dd
GIT binary patch
literal 4096
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
b2PYW$$S}$8^Zj3qBRdXw?<H9Opys~-e#k|w

literal 0
HcmV?d00001

-- 
1.8.3.1

