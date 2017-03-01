Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21599 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751782AbdCADZg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:25:36 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 1C40747C4EB6
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:14 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 07/20] btrfs-progs: cmds-check.c: introduce print_inode_ref
Date: Wed, 1 Mar 2017 11:13:50 +0800
Message-ID: <20170301031403.23902-8-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce 'print_inode_ref' to print error msg while checking inode ref.

Add args 'name_ret' and 'namelen_ret' to 'check_inode_ref' because
they are essential while doing nlinks repair.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 19 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c45dfae4..24a39e54 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4334,34 +4334,76 @@ out:
 }
 
 /*
+ * Print inode ref error message
+ */
+static void print_inode_ref_err(struct btrfs_root *root, struct btrfs_key *key,
+				u64 index, const char *namebuf, int name_len,
+				u8 filetype, int err)
+{
+	if (!err)
+		return;
+
+	/*root dir error */
+	if (key->objectid == BTRFS_FIRST_FREE_OBJECTID) {
+		error("root %llu root dir shouldn't have INODE REF[%llu %llu] name %s",
+		      root->objectid, key->objectid, key->offset, namebuf);
+		return;
+	}
+
+	/* normal error */
+	if (err & (DIR_ITEM_MISMATCH | DIR_ITEM_MISSING))
+		error("root %llu DIR ITEM[%llu %llu] %s name %s filetype %u",
+		       root->objectid, key->offset,
+			   btrfs_name_hash(namebuf, name_len),
+		       err & DIR_ITEM_MISMATCH ? "mismath" : "missing",
+		       namebuf, filetype);
+	if (err & (DIR_INDEX_MISMATCH | DIR_INDEX_MISSING))
+		error("root %llu DIR INDEX[%llu %llu] %s name %s filetype %u",
+		       root->objectid, key->offset,
+		       index,
+		       err & DIR_ITEM_MISMATCH ? "mismath" : "missing",
+		       namebuf, filetype);
+}
+
+/*
  * Traverse the given INODE_REF and call find_dir_item() to find related
- * DIR_ITEM/DIR_INDEX.
+ * DIR_ITEM/DIR_INDEX.If repair is enable, research @ref_key and
+ * @path may change.
  *
  * @root:	the root of the fs/file tree
  * @ref_key:	the key of the INODE_REF
+ * @path        the path provides node and slot
  * @refs:	the count of INODE_REF
  * @mode:	the st_mode of INODE_ITEM
+ * @name_ret:   returns with the first ref's name
+ * @name_len_ret:    len of the name_ret
  *
+ * Return <0 on error.
  * Return 0 if no error occurred.
  */
 static int check_inode_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
-			   struct extent_buffer *node, int slot, u64 *refs,
-			   int mode)
+			   struct btrfs_path *path, char *name_ret,
+			   u32 *namelen_ret, u64 *refs, int mode)
 {
 	struct btrfs_key key;
 	struct btrfs_key location;
 	struct btrfs_inode_ref *ref;
+	struct extent_buffer *node;
 	char namebuf[BTRFS_NAME_LEN] = {0};
+	int name_len;
 	u32 total;
 	u32 cur = 0;
-	u32 len;
-	u32 name_len;
+	long len;
 	u64 index;
-	int ret, err = 0;
+	int err = 0;
+	int tmp_err;
+	int slot;
 
 	location.objectid = ref_key->objectid;
 	location.type = BTRFS_INODE_ITEM_KEY;
 	location.offset = 0;
+	node = path->nodes[0];
+	slot = path->slots[0];
 
 	ref = btrfs_item_ptr(node, slot, struct btrfs_inode_ref);
 	total = btrfs_item_size_nr(node, slot);
@@ -4370,6 +4412,7 @@ next:
 	/* Update inode ref count */
 	(*refs)++;
 
+	tmp_err = 0;
 	index = btrfs_inode_ref_index(node, ref);
 	name_len = btrfs_inode_ref_name_len(node, ref);
 	if (name_len <= BTRFS_NAME_LEN) {
@@ -4382,30 +4425,40 @@ next:
 
 	read_extent_buffer(node, namebuf, (unsigned long)(ref + 1), len);
 
-	/* Check root dir ref name */
-	if (index == 0 && strncmp(namebuf, "..", name_len)) {
-		error("root %llu INODE_REF[%llu %llu] ROOT_DIR name shouldn't be %s",
-		      root->objectid, ref_key->objectid, ref_key->offset,
-		      namebuf);
-		err |= ROOT_DIR_ERROR;
+	/* copy the firt name found to name_ret */
+	if (*refs == 1 && name_ret) {
+		memcpy(name_ret, namebuf, len);
+		*namelen_ret = len;
+	}
+	/* Check root dir ref */
+	if (ref_key->objectid == BTRFS_FIRST_FREE_OBJECTID) {
+		if (index != 0 || len != strlen("..") ||
+		    strncmp("..", namebuf, len) ||
+		    ref_key->offset != BTRFS_FIRST_FREE_OBJECTID) {
+			/* set fake err bit so repair will delete the ref */
+			err |= DIR_INDEX_MISSING;
+			err |= DIR_ITEM_MISSING;
+		}
+		goto end;
 	}
 
 	/* Find related DIR_INDEX */
 	key.objectid = ref_key->offset;
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = index;
-	ret = find_dir_item(root, &key, &location, namebuf, len,
+	tmp_err |= find_dir_item(root, &key, &location, namebuf, len,
 			    imode_to_type(mode));
-	err |= ret;
 
 	/* Find related dir_item */
 	key.objectid = ref_key->offset;
 	key.type = BTRFS_DIR_ITEM_KEY;
 	key.offset = btrfs_name_hash(namebuf, len);
-	ret = find_dir_item(root, &key, &location, namebuf, len,
+	tmp_err |= find_dir_item(root, &key, &location, namebuf, len,
 			    imode_to_type(mode));
-	err |= ret;
-
+end:
+	print_inode_ref_err(root, ref_key, index, namebuf, name_len,
+			    imode_to_type(mode), tmp_err);
+	err |= tmp_err;
 	len = sizeof(*ref) + name_len;
 	ref = (struct btrfs_inode_ref *)((char *)ref + len);
 	cur += len;
@@ -5093,6 +5146,8 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 	int slot;
 	int ret;
 	int err = 0;
+	char namebuf[BTRFS_NAME_LEN] = {0};
+	u32 name_len = 0;
 
 	node = path->nodes[0];
 	slot = path->slots[0];
@@ -5133,8 +5188,8 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 
 		switch (key.type) {
 		case BTRFS_INODE_REF_KEY:
-			ret = check_inode_ref(root, &key, node, slot, &refs,
-					      mode);
+			ret = check_inode_ref(root, &key, path, namebuf,
+					      &name_len, &refs, mode);
 			err |= ret;
 			break;
 		case BTRFS_INODE_EXTREF_KEY:
-- 
2.11.1



