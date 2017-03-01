Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23240 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751373AbdCADSB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:01 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 8569147C4EB1
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:13 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 06/20] btrfs-progs: cmds-check.c: change find_dir_index/item
Date: Wed, 1 Mar 2017 11:13:49 +0800
Message-ID: <20170301031403.23902-7-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For further lowmem_repair, introduce 'find_dir_index' to
get the index by other inode item information.
Remove 'check_dir_item' error msg print.

Adjust 'find_dir_item' args and remove err msg print.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 231 +++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 155 insertions(+), 76 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 892a22ba..c45dfae4 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -130,6 +130,8 @@ struct data_backref {
 #define LAST_ITEM		(1<<15)	/* Complete this tree traversal */
 #define ROOT_REF_MISSING	(1<<16)	/* ROOT_REF not found */
 #define ROOT_REF_MISMATCH	(1<<17)	/* ROOT_REF found but not match */
+#define DIR_INDEX_MISSING       (1<<18) /* INODE_INDEX not found */
+#define DIR_INDEX_MISMATCH      (1<<19) /* INODE_INDEX found but not match */
 
 static inline struct data_backref* to_data_backref(struct extent_backref *back)
 {
@@ -4133,29 +4135,30 @@ out:
 	return err;
 }
 
+static int find_dir_index(struct btrfs_root *root, u64 dirid, u64 location_id,
+			  u64 *index_ret, char *namebuf, u32 name_len,
+			  u8 file_type);
 /*
  * Find DIR_ITEM/DIR_INDEX for the given key and check it with the specified
  * INODE_REF/INODE_EXTREF match.
  *
  * @root:	the root of the fs/file tree
- * @ref_key:	the key of the INODE_REF/INODE_EXTREF
- * @key:	the key of the DIR_ITEM/DIR_INDEX
- * @index:	the index in the INODE_REF/INODE_EXTREF, be used to
- *		distinguish root_dir between normal dir/file
- * @name:	the name in the INODE_REF/INODE_EXTREF
- * @namelen:	the length of name in the INODE_REF/INODE_EXTREF
- * @mode:	the st_mode of INODE_ITEM
+ * @key:	the key of the DIR_ITEM/DIR_INDEX, key->offset will be right
+ *              value while find index
+ * @location_key: location key of the struct btrfs_dir_item to match
+ * @name:	the name to match
+ * @namelen:	the length of name
+ * @file_type:	the type of file to math
  *
  * Return 0 if no error occurred.
- * Return ROOT_DIR_ERROR if found DIR_ITEM/DIR_INDEX for root_dir.
- * Return DIR_ITEM_MISSING if couldn't find DIR_ITEM/DIR_INDEX for normal
- * dir/file.
- * Return DIR_ITEM_MISMATCH if INODE_REF/INODE_EXTREF and DIR_ITEM/DIR_INDEX
- * not match for normal dir/file.
+ * Return DIR_ITEM_MISSING/DIR_INDEX_MISSING if couldn't find
+ * DIR_ITEM/DIR_INDEX
+ * Return DIR_ITEM_MISMATCH/DIR_INDEX_MISMATCH if INODE_REF/INODE_EXTREF
+ * and DIR_ITEM/DIR_INDEX mismatch
  */
-static int find_dir_item(struct btrfs_root *root, struct btrfs_key *ref_key,
-			 struct btrfs_key *key, u64 index, char *name,
-			 u32 namelen, u32 mode)
+static int find_dir_item(struct btrfs_root *root, struct btrfs_key *key,
+			 struct btrfs_key *location_key, char *name,
+			 u32 namelen, u8 file_type)
 {
 	struct btrfs_path path;
 	struct extent_buffer *node;
@@ -4165,104 +4168,166 @@ static int find_dir_item(struct btrfs_root *root, struct btrfs_key *ref_key,
 	u32 total;
 	u32 cur = 0;
 	u32 len;
-	u32 name_len;
 	u32 data_len;
 	u8 filetype;
 	int slot;
 	int ret;
 
+	/* get the index by traversing all index */
+	if (key->type == BTRFS_DIR_INDEX_KEY && key->offset == (u64)-1) {
+		ret = find_dir_index(root, key->objectid,
+				     location_key->objectid, &key->offset,
+				     name, namelen, file_type);
+		if (ret)
+			ret = DIR_INDEX_MISSING;
+		return ret;
+	}
+
 	btrfs_init_path(&path);
 	ret = btrfs_search_slot(NULL, root, key, &path, 0, 0);
-	if (ret < 0) {
-		ret = DIR_ITEM_MISSING;
+	if (ret) {
+		ret = key->type == BTRFS_DIR_ITEM_KEY ? DIR_ITEM_MISSING :
+			DIR_INDEX_MISSING;
 		goto out;
 	}
 
-	/* Process root dir and goto out*/
-	if (index == 0) {
-		if (ret == 0) {
-			ret = ROOT_DIR_ERROR;
-			error(
-			"root %llu INODE %s[%llu %llu] ROOT_DIR shouldn't have %s",
-				root->objectid,
-				ref_key->type == BTRFS_INODE_REF_KEY ?
-					"REF" : "EXTREF",
-				ref_key->objectid, ref_key->offset,
-				key->type == BTRFS_DIR_ITEM_KEY ?
-					"DIR_ITEM" : "DIR_INDEX");
-		} else {
-			ret = 0;
-		}
+	/* Check whether inode_id/filetype/name match */
+	node = path.nodes[0];
+	slot = path.slots[0];
+	di = btrfs_item_ptr(node, slot, struct btrfs_dir_item);
+	total = btrfs_item_size_nr(node, slot);
+	while (cur < total) {
+		ret = key->type == BTRFS_DIR_ITEM_KEY ?
+			DIR_ITEM_MISMATCH : DIR_INDEX_MISMATCH;
 
-		goto out;
-	}
+		len = btrfs_dir_name_len(node, di);
+		data_len = btrfs_dir_data_len(node, di);
 
-	/* Process normal file/dir */
-	if (ret > 0) {
-		ret = DIR_ITEM_MISSING;
-		error(
-		"root %llu INODE %s[%llu %llu] doesn't have related %s[%llu %llu] namelen %u filename %s filetype %d",
+		btrfs_dir_item_key_to_cpu(node, di, &location);
+		if (location.objectid != location_key->objectid ||
+		    location.type != location_key->type ||
+		    location.offset != location_key->offset)
+			goto next;
+
+		filetype = btrfs_dir_type(node, di);
+		if (file_type != filetype)
+			goto next;
+
+		if (len > BTRFS_NAME_LEN) {
+			len = BTRFS_NAME_LEN;
+			warning("root %llu %s[%llu %llu] name too long %u, trimmed",
 			root->objectid,
-			ref_key->type == BTRFS_INODE_REF_KEY ? "REF" : "EXTREF",
-			ref_key->objectid, ref_key->offset,
 			key->type == BTRFS_DIR_ITEM_KEY ?
-				"DIR_ITEM" : "DIR_INDEX",
-			key->objectid, key->offset, namelen, name,
-			imode_to_type(mode));
+			"DIR_ITEM" : "DIR_INDEX",
+			key->objectid, key->offset, len);
+		}
+		read_extent_buffer(node, namebuf, (unsigned long)(di + 1),
+				   len);
+		if (len != namelen || strncmp(namebuf, name, len))
+			goto next;
+
+		ret = 0;
 		goto out;
+next:
+		len += sizeof(*di) + data_len;
+		di = (struct btrfs_dir_item *)((char *)di + len);
+		cur += len;
 	}
 
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
+/*
+ * Find the @index according @ino.
+ * Notice:the time efficiency is O(n)
+ *
+ * @root:	the root of the fs/file tree
+ * @index_ret:	the index as return value
+ * @namebuf:	the name to match
+ * @name_len:	the length of name to match
+ * @file_type:	the file_type of INODE_ITEM to match
+ *
+ * Returns 0 if found and *index will be modified with right value
+ * Returns< 0 not found and *index will be (u64)-1
+ */
+static int find_dir_index(struct btrfs_root *root, u64 dirid, u64 location_id,
+			  u64 *index_ret, char *namebuf, u32 name_len,
+			  u8 file_type)
+{
+	struct btrfs_path path;
+	struct extent_buffer *node;
+	struct btrfs_dir_item *di;
+	struct btrfs_key key;
+	struct btrfs_key location;
+	char name[BTRFS_NAME_LEN] = {0};
+
+	u32 total;
+	u32 cur = 0;
+	u32 len;
+	u32 data_len;
+	u8 filetype;
+	int slot;
+	int ret;
+
+	ASSERT(index_ret);
+
+	/* search from the last index */
+	key.objectid = dirid;
+	key.offset = (u64)-1;
+	key.type = BTRFS_DIR_INDEX_KEY;
+	btrfs_init_path(&path);
+
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0 || !ret)
+		return -EIO;
+
+loop:
+	ret = btrfs_previous_item(root, &path, dirid, BTRFS_DIR_INDEX_KEY);
+	if (ret) {
+		ret = -ENOENT;
+		*index_ret = (64)-1;
+		goto out;
+	}
 	/* Check whether inode_id/filetype/name match */
 	node = path.nodes[0];
 	slot = path.slots[0];
 	di = btrfs_item_ptr(node, slot, struct btrfs_dir_item);
 	total = btrfs_item_size_nr(node, slot);
 	while (cur < total) {
-		ret = DIR_ITEM_MISMATCH;
-		name_len = btrfs_dir_name_len(node, di);
+		ret = -ENOENT;
+		len = btrfs_dir_name_len(node, di);
 		data_len = btrfs_dir_data_len(node, di);
 
 		btrfs_dir_item_key_to_cpu(node, di, &location);
-		if (location.objectid != ref_key->objectid ||
-		    location.type !=  BTRFS_INODE_ITEM_KEY ||
+		if (location.objectid != location_id ||
+		    location.type != BTRFS_INODE_ITEM_KEY ||
 		    location.offset != 0)
 			goto next;
 
 		filetype = btrfs_dir_type(node, di);
-		if (imode_to_type(mode) != filetype)
+		if (file_type != filetype)
 			goto next;
 
-		if (name_len <= BTRFS_NAME_LEN) {
-			len = name_len;
-		} else {
+		if (len > BTRFS_NAME_LEN)
 			len = BTRFS_NAME_LEN;
-			warning("root %llu %s[%llu %llu] name too long %u, trimmed",
-			root->objectid,
-			key->type == BTRFS_DIR_ITEM_KEY ?
-			"DIR_ITEM" : "DIR_INDEX",
-			key->objectid, key->offset, name_len);
-		}
-		read_extent_buffer(node, namebuf, (unsigned long)(di + 1), len);
-		if (len != namelen || strncmp(namebuf, name, len))
+
+		read_extent_buffer(node, name, (unsigned long)(di + 1), len);
+		if (len != name_len || strncmp(namebuf, name, len))
 			goto next;
 
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		*index_ret = key.offset;
 		ret = 0;
 		goto out;
 next:
-		len = sizeof(*di) + name_len + data_len;
+		len += sizeof(*di) + data_len;
 		di = (struct btrfs_dir_item *)((char *)di + len);
 		cur += len;
 	}
-	if (ret == DIR_ITEM_MISMATCH)
-		error(
-		"root %llu INODE %s[%llu %llu] and %s[%llu %llu] mismatch namelen %u filename %s filetype %d",
-			root->objectid,
-			ref_key->type == BTRFS_INODE_REF_KEY ? "REF" : "EXTREF",
-			ref_key->objectid, ref_key->offset,
-			key->type == BTRFS_DIR_ITEM_KEY ?
-				"DIR_ITEM" : "DIR_INDEX",
-			key->objectid, key->offset, namelen, name,
-			imode_to_type(mode));
+	goto loop;
+
 out:
 	btrfs_release_path(&path);
 	return ret;
@@ -4284,6 +4349,7 @@ static int check_inode_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 			   int mode)
 {
 	struct btrfs_key key;
+	struct btrfs_key location;
 	struct btrfs_inode_ref *ref;
 	char namebuf[BTRFS_NAME_LEN] = {0};
 	u32 total;
@@ -4293,6 +4359,10 @@ static int check_inode_ref(struct btrfs_root *root, struct btrfs_key *ref_key,
 	u64 index;
 	int ret, err = 0;
 
+	location.objectid = ref_key->objectid;
+	location.type = BTRFS_INODE_ITEM_KEY;
+	location.offset = 0;
+
 	ref = btrfs_item_ptr(node, slot, struct btrfs_inode_ref);
 	total = btrfs_item_size_nr(node, slot);
 
@@ -4324,14 +4394,16 @@ next:
 	key.objectid = ref_key->offset;
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = index;
-	ret = find_dir_item(root, ref_key, &key, index, namebuf, len, mode);
+	ret = find_dir_item(root, &key, &location, namebuf, len,
+			    imode_to_type(mode));
 	err |= ret;
 
 	/* Find related dir_item */
 	key.objectid = ref_key->offset;
 	key.type = BTRFS_DIR_ITEM_KEY;
 	key.offset = btrfs_name_hash(namebuf, len);
-	ret = find_dir_item(root, ref_key, &key, index, namebuf, len, mode);
+	ret = find_dir_item(root, &key, &location, namebuf, len,
+			    imode_to_type(mode));
 	err |= ret;
 
 	len = sizeof(*ref) + name_len;
@@ -4360,6 +4432,7 @@ static int check_inode_extref(struct btrfs_root *root,
 			      int mode)
 {
 	struct btrfs_key key;
+	struct btrfs_key location;
 	struct btrfs_inode_extref *extref;
 	char namebuf[BTRFS_NAME_LEN] = {0};
 	u32 total;
@@ -4371,6 +4444,10 @@ static int check_inode_extref(struct btrfs_root *root,
 	int ret;
 	int err = 0;
 
+	location.objectid = ref_key->objectid;
+	location.type = BTRFS_INODE_ITEM_KEY;
+	location.offset = 0;
+
 	extref = btrfs_item_ptr(node, slot, struct btrfs_inode_extref);
 	total = btrfs_item_size_nr(node, slot);
 
@@ -4401,14 +4478,16 @@ next:
 	key.objectid = parent;
 	key.type = BTRFS_DIR_INDEX_KEY;
 	key.offset = index;
-	ret = find_dir_item(root, ref_key, &key, index, namebuf, len, mode);
+	ret = find_dir_item(root, &key, &location, namebuf, len,
+			    imode_to_type(mode));
 	err |= ret;
 
 	/* find related dir_item */
 	key.objectid = parent;
 	key.type = BTRFS_DIR_ITEM_KEY;
 	key.offset = btrfs_name_hash(namebuf, len);
-	ret = find_dir_item(root, ref_key, &key, index, namebuf, len, mode);
+	ret = find_dir_item(root, &key, &location, namebuf, len,
+			    imode_to_type(mode));
 	err |= ret;
 
 	len = sizeof(*extref) + name_len;
-- 
2.11.1



