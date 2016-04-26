Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39542 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbcDZDtn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 23:49:43 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH RFC 08/16] btrfs-progs: fsck: Introduce function to check an extent
Date: Tue, 26 Apr 2016 11:48:55 +0800
Message-Id: <1461642543-4621-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce function check_extent_item() using previous introduced
functions.

With previous function to check referencer and backref, this function
can be quite easy.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 113 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 5588898..7f9f848 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -325,6 +325,9 @@ struct root_item_info {
 #define UNALIGNED_BYTES	(1 << 2) /* Some bytes are not aligned */
 #define MISSING_REFERENCER (1 << 3) /* Referencer not found */
 #define BAD_REFERENCER	(1 << 4) /* Referencer found, but not mismatch */
+#define CROSSING_STRIPE_BOUNDARY (1 << 4) /* For kernel scrub workaround */
+#define BAD_ITEM_SIZE	(1 << 5) /* Bad item size */
+#define UNKNOWN_TYPE	(1 << 6) /* Unknown type */
 
 static void *print_status_check(void *p)
 {
@@ -9013,6 +9016,116 @@ out:
 	return 0;
 }
 
+/*
+ * This function will check a given extent item, including its backref and
+ * itself (like crossing stripe boundary and type)
+ *
+ * Since we don't use extent_record anymore, introduce new error bit
+ */
+static int check_extent_item(struct btrfs_fs_info *fs_info,
+			     struct extent_buffer *eb, int slot, int metadata)
+{
+	struct btrfs_extent_item *ei;
+	struct btrfs_extent_inline_ref *iref;
+	struct btrfs_extent_data_ref *dref;
+	unsigned long end;
+	unsigned long ptr;
+	int type;
+	u32 nodesize = btrfs_super_nodesize(fs_info->super_copy);
+	u32 item_size = btrfs_item_size_nr(eb, slot);
+	u64 flags;
+	u64 offset;
+	int level;
+	struct btrfs_key key;
+	int ret;
+	int err = 0;
+
+	btrfs_item_key_to_cpu(eb, &key, slot);
+
+	/*
+	 * XXX: Do we really need to handle such historic
+	 * extent structure?
+	 */
+	if (item_size < sizeof(*ei)) {
+#ifdef BTRFS_COMPAT_EXTENT_TREE_V0
+		struct btrfs_extent_item_v0 *ei0;
+
+		BUG_ON(item_size != sizeof(*ei0));
+		return 1;
+#else
+		BUG();
+#endif
+	}
+
+	if (metadata && check_crossing_stripes(key.objectid, eb->len)) {
+		error("bad metadata [%llu, %llu) crossing stripe boundary",
+		      key.objectid, key.objectid + nodesize);
+		err |= CROSSING_STRIPE_BOUNDARY;
+	}
+
+	ei = btrfs_item_ptr(eb, slot, struct btrfs_extent_item);
+	flags = btrfs_extent_flags(eb, ei);
+
+	ptr = (unsigned long)(ei + 1);
+	if (flags & BTRFS_EXTENT_FLAG_TREE_BLOCK && !metadata) {
+		struct btrfs_tree_block_info *info;
+
+		info = (struct btrfs_tree_block_info *)ptr;
+		level = btrfs_tree_block_level(eb, info);
+		ptr += sizeof(struct btrfs_tree_block_info);
+	} else
+		level = key.offset;
+	end = (unsigned long)ei + item_size;
+
+	if (ptr >= end) {
+		err |= BAD_ITEM_SIZE;
+		goto out;
+	}
+
+	/* Now check every backref in this extent item */
+next:
+	iref = (struct btrfs_extent_inline_ref *)ptr;
+	type = btrfs_extent_inline_ref_type(eb, iref);
+	offset = btrfs_extent_inline_ref_offset(eb, iref);
+	switch (type) {
+	case BTRFS_TREE_BLOCK_REF_KEY:
+		ret = check_tree_block_backref(fs_info, offset, key.objectid,
+					       level);
+		err |= -ret;
+		break;
+	case BTRFS_SHARED_BLOCK_REF_KEY:
+		ret = check_shared_block_backref(fs_info, offset, key.objectid,
+						 level);
+		err |= -ret;
+		break;
+	case BTRFS_EXTENT_DATA_REF_KEY:
+		dref = (struct btrfs_extent_data_ref *)(&iref->offset);
+		ret = check_extent_data_backref(fs_info,
+				btrfs_extent_data_ref_root(eb, dref),
+				btrfs_extent_data_ref_objectid(eb, dref),
+				btrfs_extent_data_ref_offset(eb, dref),
+				key.objectid, key.offset);
+		err |= -ret;
+		break;
+	case BTRFS_SHARED_DATA_REF_KEY:
+		ret = check_shared_data_backref(fs_info, offset, key.objectid);
+		err |= -ret;
+		break;
+	default:
+		error("Extent[%llu %d %llu] has unknown ref type: %d",
+		      key.objectid, key.type, key.offset, type);
+		err |= UNKNOWN_TYPE;
+		goto out;
+	}
+
+	ptr += btrfs_extent_inline_ref_size(type);
+	if (ptr < end)
+		goto next;
+
+out:
+	return -err;
+}
+
 static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 			   struct btrfs_root *root, int overwrite)
 {
-- 
2.8.0



