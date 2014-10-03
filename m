Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:62959 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752152AbaJCOya (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Oct 2014 10:54:30 -0400
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id s93EoDIE020192
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Oct 2014 07:54:29 -0700
Received: from mail.thefacebook.com (mailwest.thefacebook.com [173.252.71.148])
	by mx0a-00082601.pphosted.com with ESMTP id 1prrx0bae5-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Oct 2014 07:54:29 -0700
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: make fsck deal with bogus items
Date: Fri, 3 Oct 2014 10:54:26 -0400
Message-ID: <1412348066-6284-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We can deal with corrupt items by deleting them in a few cases.  Fsck can easily
recover from a missing extent item or a dir index item.  So if we notice a item
is completely bogus and it is of a key that we know we can repair then just
delete it and carry on.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 cmds-check.c                             |  45 +++++++++++++++++++++++++++++++
 tests/fsck-tests/005-bad-item-offset.img | Bin 0 -> 398336 bytes
 2 files changed, 45 insertions(+)
 create mode 100644 tests/fsck-tests/005-bad-item-offset.img

diff --git a/cmds-check.c b/cmds-check.c
index cd3713b..cc7a619 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2621,6 +2621,42 @@ static int fix_key_order(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int delete_bogus_item(struct btrfs_trans_handle *trans,
+			     struct btrfs_root *root,
+			     struct btrfs_path *path,
+			     struct extent_buffer *buf, int slot)
+{
+	struct btrfs_key key;
+	int nritems = btrfs_header_nritems(buf);
+
+	btrfs_item_key_to_cpu(buf, &key, slot);
+
+	/* These are all the keys we can deal with missing. */
+	if (key.type != BTRFS_DIR_INDEX_KEY &&
+	    key.type != BTRFS_EXTENT_ITEM_KEY &&
+	    key.type != BTRFS_METADATA_ITEM_KEY &&
+	    key.type != BTRFS_TREE_BLOCK_REF_KEY &&
+	    key.type != BTRFS_EXTENT_DATA_REF_KEY)
+		return -1;
+
+	printf("Deleting bogus item [%llu,%u,%llu] at slot %d on block %llu\n",
+	       (unsigned long long)key.objectid, key.type,
+	       (unsigned long long)key.offset, slot, buf->start);
+	memmove_extent_buffer(buf, btrfs_item_nr_offset(slot),
+			      btrfs_item_nr_offset(slot + 1),
+			      sizeof(struct btrfs_item) *
+			      (nritems - slot - 1));
+	btrfs_set_header_nritems(buf, nritems - 1);
+	if (slot == 0) {
+		struct btrfs_disk_key disk_key;
+
+		btrfs_item_key(buf, &disk_key, 0);
+		btrfs_fixup_low_keys(root, path, &disk_key, 1);
+	}
+	btrfs_mark_buffer_dirty(buf);
+	return 0;
+}
+
 static int fix_item_offset(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root,
 			   struct extent_buffer *buf)
@@ -2660,6 +2696,7 @@ static int fix_item_offset(struct btrfs_trans_handle *trans,
 	}
 
 	buf = path->nodes[level];
+again:
 	for (i = 0; i < btrfs_header_nritems(buf); i++) {
 		unsigned int shift = 0, offset;
 
@@ -2667,6 +2704,10 @@ static int fix_item_offset(struct btrfs_trans_handle *trans,
 		    BTRFS_LEAF_DATA_SIZE(root)) {
 			if (btrfs_item_end_nr(buf, i) >
 			    BTRFS_LEAF_DATA_SIZE(root)) {
+				ret = delete_bogus_item(trans, root, path,
+							buf, i);
+				if (!ret)
+					goto again;
 				fprintf(stderr, "item is off the end of the "
 					"leaf, can't fix\n");
 				ret = -EIO;
@@ -2678,6 +2719,10 @@ static int fix_item_offset(struct btrfs_trans_handle *trans,
 			   btrfs_item_offset_nr(buf, i - 1)) {
 			if (btrfs_item_end_nr(buf, i) >
 			    btrfs_item_offset_nr(buf, i - 1)) {
+				ret = delete_bogus_item(trans, root, path,
+							buf, i);
+				if (!ret)
+					goto again;
 				fprintf(stderr, "items overlap, can't fix\n");
 				ret = -EIO;
 				break;
diff --git a/tests/fsck-tests/005-bad-item-offset.img b/tests/fsck-tests/005-bad-item-offset.img
new file mode 100644
index 0000000000000000000000000000000000000000..e11e1e32686112f12418ca8dbba6e03c2517f598
GIT binary patch
literal 398336
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
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
z1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs
z0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZ
zfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&U
zAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C7
z2oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N
z0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+
z009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly
zK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF
z5FkK+009C72oNAZfB*pk1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk
w1PBlyK!5-N0t5&UAV7cs0RjXF5FkK+009C72oNAZfB*pk1PBly@X`|aKM|?Lv;Y7A

literal 0
HcmV?d00001

-- 
1.8.3.1

