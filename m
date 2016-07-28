Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42349 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1163330AbcG1HJB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Jul 2016 03:09:01 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
	by cn.fujitsu.com (Postfix) with ESMTP id 8ED0742BA383
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Jul 2016 15:08:47 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH 05/13] btrfs-progs: check: introduce function to find inode_ref
Date: Thu, 28 Jul 2016 15:08:17 +0800
Message-ID: <1469689705-26836-6-git-send-email-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
References: <1469689705-26836-1-git-send-email-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function find_inode_ref() to find
INODE_REF/INODE_EXTREF for the given key, and check it with the
specified DIR_ITEM/DIR_INDEX match.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 152 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 152 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index f9d5c8c..501c5e0 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3882,6 +3882,7 @@ out:
 #define ROOT_DIR_ERROR		(1<<1)	/* bad root_dir */
 #define DIR_ITEM_MISSING	(1<<2)	/* DIR_ITEM not found */
 #define DIR_ITEM_MISMATCH	(1<<3)	/* DIR_ITEM found but not match */
+#define INODE_REF_MISSING	(1<<4)	/* INODE_REF/INODE_EXTREF not found */
 
 /*
  * Find DIR_ITEM/DIR_INDEX for the given key and check it with the specified
@@ -4172,6 +4173,157 @@ next:
 	return err;
 }
 
+/*
+ * Find INODE_REF/INODE_EXTREF for the given key and check it with the specified
+ * DIR_ITEM/DIR_INDEX match.
+ *
+ * @root:	the root of the fs/file tree
+ * @key:	the key of the INODE_REF/INODE_EXTREF
+ * @name:	the name in the INODE_REF/INODE_EXTREF
+ * @namelen:	the length of name in the INODE_REF/INODE_EXTREF
+ * @index:	the index in the INODE_REF/INODE_EXTREF, for DIR_ITEM set index
+ * to (u64)-1
+ * @ext_ref:	the EXTENDED_IREF feature
+ *
+ * Return 0 if no error occurred.
+ * Return INODE_REF_MISSING if couldn't find related INODE_REF/INODE_EXTREF for
+ * specified DIR_ITEM/DIR_INDEX.
+ */
+static int find_inode_ref(struct btrfs_root *root, struct btrfs_key *key,
+			  char *name, int namelen, u64 index,
+			  unsigned int ext_ref)
+{
+	struct btrfs_path path;
+	struct btrfs_inode_ref *ref;
+	struct btrfs_inode_extref *extref;
+	struct extent_buffer *node;
+	char ref_namebuf[BTRFS_NAME_LEN] = {0};
+	u32 total;
+	u32 cur = 0;
+	u32 len;
+	u32 ref_namelen;
+	u64 ref_index;
+	u64 parent;
+	u64 dir_id;
+	int slot;
+	int ret;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, root, key, &path, 0, 0);
+	if (ret) {
+		ret = INODE_REF_MISSING;
+		goto extref;
+	}
+
+	node = path.nodes[0];
+	slot = path.slots[0];
+
+	ref = btrfs_item_ptr(node, slot, struct btrfs_inode_ref);
+	total = btrfs_item_size_nr(node, slot);
+
+	/* Iterate all entry of INODE_REF */
+	while (cur < total) {
+		ret = INODE_REF_MISSING;
+
+		ref_namelen = btrfs_inode_ref_name_len(node, ref);
+		ref_index = btrfs_inode_ref_index(node, ref);
+		if (index != (u64)-1 && index != ref_index)
+			goto next_ref;
+
+		if (ref_namelen <= BTRFS_NAME_LEN) {
+			len = ref_namelen;
+		} else {
+			len = BTRFS_NAME_LEN;
+			fprintf(stderr,
+				"Warning: root %llu INODE %s[%llu %llu] name too long\n",
+				root->objectid,
+				key->type == BTRFS_INODE_REF_KEY ?
+					"REF" : "EXTREF",
+				key->objectid, key->offset);
+		}
+		read_extent_buffer(node, ref_namebuf, (unsigned long)(ref + 1),
+				   len);
+
+		if (len != namelen || strncmp(ref_namebuf, name, len))
+			goto next_ref;
+
+		ret = 0;
+		goto out;
+next_ref:
+		len = sizeof(*ref) + ref_namelen;
+		ref = (struct btrfs_inode_ref *)((char *)ref + len);
+		cur += len;
+	}
+
+extref:
+	/* Skip if not support EXTENDED_IREF feature */
+	if (!ext_ref)
+		goto out;
+
+	btrfs_release_path(&path);
+	btrfs_init_path(&path);
+
+	dir_id = key->offset;
+	key->type = BTRFS_INODE_EXTREF_KEY;
+	key->offset = btrfs_extref_hash(dir_id, name, namelen);
+
+	ret = btrfs_search_slot(NULL, root, key, &path, 0, 0);
+	if (ret) {
+		ret = INODE_REF_MISSING;
+		goto out;
+	}
+
+	node = path.nodes[0];
+	slot = path.slots[0];
+
+	extref = btrfs_item_ptr(node, slot, struct btrfs_inode_extref);
+	cur = 0;
+	total = btrfs_item_size_nr(node, slot);
+
+	/* Iterate all entry of INODE_EXTREF */
+	while (cur < total) {
+		ret = INODE_REF_MISSING;
+
+		ref_namelen = btrfs_inode_extref_name_len(node, extref);
+		ref_index = btrfs_inode_extref_index(node, extref);
+		parent = btrfs_inode_extref_parent(node, extref);
+		if (index != (u64)-1 && index != ref_index)
+			goto next_extref;
+
+		if (parent != dir_id)
+			goto next_extref;
+
+		if (ref_namelen <= BTRFS_NAME_LEN) {
+			len = ref_namelen;
+		} else {
+			len = BTRFS_NAME_LEN;
+			fprintf(stderr,
+				"Warning: root %llu INODE %s[%llu %llu] name too long\n",
+				root->objectid,
+				key->type == BTRFS_INODE_REF_KEY ?
+					"REF" : "EXTREF",
+				key->objectid, key->offset);
+		}
+		read_extent_buffer(node, ref_namebuf,
+				   (unsigned long)(extref + 1), len);
+
+		if (len != namelen || strncmp(ref_namebuf, name, len))
+			goto next_extref;
+
+		ret = 0;
+		goto out;
+
+next_extref:
+		len = sizeof(*extref) + ref_namelen;
+		extref = (struct btrfs_inode_extref *)((char *)extref + len);
+		cur += len;
+
+	}
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
 	struct rb_node *n;
-- 
2.7.4



