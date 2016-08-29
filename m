Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7029 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932681AbcH2IJL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 04:09:11 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 050DA4334C85
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 16:09:08 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4] btrfs-progs: Ignore invalid key in invalid root
Date: Mon, 29 Aug 2016 16:09:01 +0800
Message-ID: <20160829080902.2952-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
References: <20160829080902.2952-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs tree implies a lot of restriction on which key types are allowed
in specific roots.

Like CHUNK_ITEM keys are only valid in chunk root.

This patch will add such check at run_next_block() for original mode.

Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 0ddfd24..617b867 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6122,6 +6122,58 @@ full_backref:
 	return 0;
 }
 
+static void report_mismatch_key_root(u8 key_type, u64 rootid)
+{
+	fprintf(stderr, "Invalid key type(");
+	print_key_type(stderr, 0, key_type);
+	fprintf(stderr, ") found in root(");
+	print_objectid(stderr, rootid, 0);
+	fprintf(stderr, ")\n");
+}
+
+/*
+ * Check if the key is valid with its extent buffer.
+ *
+ * This is a early check in case invalid key exists in a extent buffer
+ * This is not comprehensive yet, but should prevent wrong key/item passed
+ * further
+ */
+static int check_type_with_root(u64 rootid, u8 key_type)
+{
+	switch (key_type) {
+	/* Only valid in chunk tree */
+	case BTRFS_DEV_ITEM_KEY:
+	case BTRFS_CHUNK_ITEM_KEY:
+		if (rootid != BTRFS_CHUNK_TREE_OBJECTID)
+			goto err;
+		break;
+	/* valid in csum and log tree */
+	case BTRFS_CSUM_TREE_OBJECTID:
+		if (!(rootid == BTRFS_TREE_LOG_OBJECTID ||
+		      is_fstree(rootid)))
+			goto err;
+		break;
+	case BTRFS_EXTENT_ITEM_KEY:
+	case BTRFS_METADATA_ITEM_KEY:
+	case BTRFS_BLOCK_GROUP_ITEM_KEY:
+		if (rootid != BTRFS_EXTENT_TREE_OBJECTID)
+			goto err;
+		break;
+	case BTRFS_ROOT_ITEM_KEY:
+		if (rootid != BTRFS_ROOT_TREE_OBJECTID)
+			goto err;
+		break;
+	case BTRFS_DEV_EXTENT_KEY:
+		if (rootid != BTRFS_DEV_TREE_OBJECTID)
+			goto err;
+		break;
+	}
+	return 0;
+err:
+	report_mismatch_key_root(key_type, rootid);
+	return -EINVAL;
+}
+
 static int run_next_block(struct btrfs_root *root,
 			  struct block_info *bits,
 			  int bits_nr,
@@ -6271,6 +6323,16 @@ static int run_next_block(struct btrfs_root *root,
 		for (i = 0; i < nritems; i++) {
 			struct btrfs_file_extent_item *fi;
 			btrfs_item_key_to_cpu(buf, &key, i);
+			/*
+			 * Check key type against the leaf owner.
+			 * Could filter quite a lot of early error if
+			 * owner is correct
+			 */
+			if (check_type_with_root(btrfs_header_owner(buf),
+						 key.type)) {
+				fprintf(stderr, "ignoring invalid key\n");
+				continue;
+			}
 			if (key.type == BTRFS_EXTENT_ITEM_KEY) {
 				process_extent_item(root, extent_cache, buf,
 						    i);
-- 
2.9.3



