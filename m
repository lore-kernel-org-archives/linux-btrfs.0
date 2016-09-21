Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:48883 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752463AbcIUDQ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 23:16:28 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH v2 10/14] btrfs-progs: check: introduce function to check root ref
Date: Wed, 21 Sep 2016 11:16:00 +0800
Message-Id: <20160921031604.23334-11-quwenruo@cn.fujitsu.com>
In-Reply-To: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
References: <20160921031604.23334-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Introduce a new function check_root_ref() to check
root_ref/root_backref.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 6d3c6a8..7593013 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3864,6 +3864,8 @@ out:
 #define ORPHAN_ITEM		(1<<13) /* INODE_ITEM no reference */
 #define NO_INODE_ITEM		(1<<14) /* no inode_item */
 #define LAST_ITEM		(1<<15)	/* Complete this tree traversal */
+#define ROOT_REF_MISSING	(1<<16)	/* ROOT_REF not found */
+#define ROOT_REF_MISMATCH	(1<<17)	/* ROOT_REF found but not match */
 
 /*
  * Find DIR_ITEM/DIR_INDEX for the given key and check it with the specified
@@ -4757,6 +4759,97 @@ out:
 	return ret;
 }
 
+/*
+ * Find the relative ref for root_ref and root_backref.
+ *
+ * @root:	the root of the root tree.
+ * @ref_key:	the key of the root ref.
+ *
+ * Return 0 if no error occurred.
+ */
+static int check_root_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
+			  struct extent_buffer *node, int slot)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_root_ref *ref;
+	struct btrfs_root_ref *backref;
+	char ref_name[BTRFS_NAME_LEN];
+	char backref_name[BTRFS_NAME_LEN];
+	u64 ref_dirid;
+	u64 ref_seq;
+	u32 ref_namelen;
+	u64 backref_dirid;
+	u64 backref_seq;
+	u32 backref_namelen;
+	u32 len;
+	int ret;
+	int err = 0;
+
+	ref = btrfs_item_ptr(node, slot, struct btrfs_root_ref);
+	ref_dirid = btrfs_root_ref_dirid(node, ref);
+	ref_seq = btrfs_root_ref_sequence(node, ref);
+	ref_namelen = btrfs_root_ref_name_len(node, ref);
+
+	if (ref_namelen <= BTRFS_NAME_LEN) {
+		len = ref_namelen;
+	} else {
+		len = BTRFS_NAME_LEN;
+		warning("%s[%llu %llu] ref_name too long",
+			ref_key->type == BTRFS_ROOT_REF_KEY ?
+			"ROOT_REF" : "ROOT_BACKREF", ref_key->objectid,
+			ref_key->offset);
+	}
+	read_extent_buffer(node, ref_name, (unsigned long)(ref + 1), len);
+
+	/* Find relative root_ref */
+	key.objectid = ref_key->offset;
+	key.type = BTRFS_ROOT_BACKREF_KEY + BTRFS_ROOT_REF_KEY - ref_key->type;
+	key.offset = ref_key->objectid;
+
+	path = btrfs_alloc_path();
+	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	if (ret) {
+		err |= ROOT_REF_MISSING;
+		error("%s[%llu %llu] couldn't find relative ref",
+		      ref_key->type == BTRFS_ROOT_REF_KEY ?
+		      "ROOT_REF" : "ROOT_BACKREF",
+		      ref_key->objectid, ref_key->offset);
+		goto out;
+	}
+
+	backref = btrfs_item_ptr(path->nodes[0], path->slots[0],
+				 struct btrfs_root_ref);
+	backref_dirid = btrfs_root_ref_dirid(path->nodes[0], backref);
+	backref_seq = btrfs_root_ref_sequence(path->nodes[0], backref);
+	backref_namelen = btrfs_root_ref_name_len(path->nodes[0], backref);
+
+	if (backref_namelen <= BTRFS_NAME_LEN) {
+		len = backref_namelen;
+	} else {
+		len = BTRFS_NAME_LEN;
+		warning("%s[%llu %llu] ref_name too long",
+			key.type == BTRFS_ROOT_REF_KEY ?
+			"ROOT_REF" : "ROOT_BACKREF",
+			key.objectid, key.offset);
+	}
+	read_extent_buffer(path->nodes[0], backref_name,
+			   (unsigned long)(backref + 1), len);
+
+	if (ref_dirid != backref_dirid || ref_seq != backref_seq ||
+	    ref_namelen != backref_namelen ||
+	    strncmp(ref_name, backref_name, len)) {
+		err |= ROOT_REF_MISMATCH;
+		error("%s[%llu %llu] mismatch relative ref",
+		      ref_key->type == BTRFS_ROOT_REF_KEY ?
+		      "ROOT_REF" : "ROOT_BACKREF",
+		      ref_key->objectid, ref_key->offset);
+	}
+out:
+	btrfs_free_path(path);
+	return err;
+}
+
 static int all_backpointers_checked(struct extent_record *rec, int print_errs)
 {
 	struct list_head *cur = rec->backrefs.next;
-- 
2.10.0



