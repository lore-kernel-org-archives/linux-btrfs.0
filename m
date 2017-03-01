Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57673 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750957AbdCADSB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:01 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id AC37B47C4EBC
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:14 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 08/20] btrfs-progs: cmds-check.c: print_dir_item_err
Date: Wed, 1 Mar 2017 11:13:51 +0800
Message-ID: <20170301031403.23902-9-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce 'print_dir_item_err' to print error msg while
checking dir_item/dir_index.
'check_dir_item' now checks relative dir item and calls
'print_dir_itm_err" to print error msg.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 127 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 87 insertions(+), 40 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 24a39e54..44abb282 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4707,25 +4707,61 @@ out:
 	return ret;
 }
 
+static void print_dir_item_err(struct btrfs_root *root, struct btrfs_key *key,
+			       u64 ino, u64 index, const char *namebuf,
+			       int name_len, u8 filetype, int err)
+{
+	if (err & (DIR_ITEM_MISMATCH | DIR_ITEM_MISSING)) {
+		error("root %llu DIR ITEM[%llu %llu] name %s filetype %d %s",
+		      root->objectid, key->objectid, key->offset, namebuf,
+		      filetype,
+		      err & DIR_ITEM_MISMATCH ? "mismath" : "missing");
+	}
+
+	if (err & (DIR_INDEX_MISMATCH | DIR_INDEX_MISSING)) {
+		error("root %llu DIR INDEX[%llu %llu] name %s filetype %d %s",
+		      root->objectid, key->objectid, index, namebuf,
+		      filetype,
+		      err & DIR_ITEM_MISMATCH ? "mismath" : "missing");
+	}
+
+	if (err & (INODE_ITEM_MISSING | INODE_ITEM_MISMATCH)) {
+		error("root %llu INODE_ITEM[%llu] index %llu name %s filetype %d %s",
+		      root->objectid, ino, index, namebuf,
+		      filetype,
+		      err & INODE_ITEM_MISMATCH ? "mismath" : "missing");
+	}
+
+	if (err & INODE_REF_MISSING)
+		error("root %llu INODE REF[%llu, %llu] name %s filetype %u missing",
+		      root->objectid, ino, key->objectid, namebuf, filetype);
+
+}
+
 /*
  * Traverse the given DIR_ITEM/DIR_INDEX and check related INODE_ITEM and
- * call find_inode_ref() to check related INODE_REF/INODE_EXTREF.
+ * call find_inode_ref() to check related INODE_REF/INODE_EXTREF.If repair
+ * is enable, do repair and research by @path->nodes[0].
  *
  * @root:	the root of the fs/file tree
  * @key:	the key of the INODE_REF/INODE_EXTREF
+ * @path:       the path of key
  * @size:	the st_size of the INODE_ITEM
  * @ext_ref:	the EXTENDED_IREF feature
  *
  * Return 0 if no error occurred.
+ * Return >0 if on error
  */
 static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
-			  struct extent_buffer *node, int slot, u64 *size,
+			  struct btrfs_path *path, u64 *size,
 			  unsigned int ext_ref)
 {
 	struct btrfs_dir_item *di;
 	struct btrfs_inode_item *ii;
-	struct btrfs_path path;
+	struct btrfs_key key2;
 	struct btrfs_key location;
+	struct extent_buffer *node;
+	int slot;
 	char namebuf[BTRFS_NAME_LEN] = {0};
 	u32 total;
 	u32 cur = 0;
@@ -4737,6 +4773,7 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 	u64 index;
 	int ret;
 	int err = 0;
+	int tmp_err;
 
 	/*
 	 * For DIR_ITEM set index to (u64)-1, so that find_inode_ref
@@ -4744,11 +4781,14 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 	 */
 	index = (key->type == BTRFS_DIR_INDEX_KEY) ? key->offset : (u64)-1;
 
+	node = path->nodes[0];
+	slot = path->slots[0];
 	di = btrfs_item_ptr(node, slot, struct btrfs_dir_item);
 	total = btrfs_item_size_nr(node, slot);
 
 	while (cur < total) {
 		data_len = btrfs_dir_data_len(node, di);
+		tmp_err = 0;
 		if (data_len)
 			error("root %llu %s[%llu %llu] data_len shouldn't be %u",
 			      root->objectid, key->type == BTRFS_DIR_ITEM_KEY ?
@@ -4768,58 +4808,61 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 		}
 		(*size) += name_len;
 
-		read_extent_buffer(node, namebuf, (unsigned long)(di + 1), len);
+		read_extent_buffer(node, namebuf, (unsigned long)(di + 1),
+				   len);
 		filetype = btrfs_dir_type(node, di);
 
-		btrfs_init_path(&path);
 		btrfs_dir_item_key_to_cpu(node, di, &location);
-
 		/* Ignore related ROOT_ITEM check */
 		if (location.type == BTRFS_ROOT_ITEM_KEY)
 			goto next;
 
+		btrfs_release_path(path);
 		/* Check relative INODE_ITEM(existence/filetype) */
-		ret = btrfs_search_slot(NULL, root, &location, &path, 0, 0);
+		ret = btrfs_search_slot(NULL, root, &location, path, 0, 0);
 		if (ret) {
-			err |= INODE_ITEM_MISSING;
-			error("root %llu %s[%llu %llu] couldn't find relative INODE_ITEM[%llu] namelen %u filename %s filetype %x",
-			      root->objectid, key->type == BTRFS_DIR_ITEM_KEY ?
-			      "DIR_ITEM" : "DIR_INDEX", key->objectid,
-			      key->offset, location.objectid, name_len,
-			      namebuf, filetype);
-			goto next;
-		}
-
-		ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
-				    struct btrfs_inode_item);
-		mode = btrfs_inode_mode(path.nodes[0], ii);
-
-		if (imode_to_type(mode) != filetype) {
-			err |= INODE_ITEM_MISMATCH;
-			error("root %llu %s[%llu %llu] relative INODE_ITEM filetype mismatch namelen %u filename %s filetype %d",
-			      root->objectid, key->type == BTRFS_DIR_ITEM_KEY ?
-			      "DIR_ITEM" : "DIR_INDEX", key->objectid,
-			      key->offset, name_len, namebuf, filetype);
+			tmp_err |= INODE_ITEM_MISSING;
+		} else {
+			ii = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					    struct btrfs_inode_item);
+			mode = btrfs_inode_mode(path->nodes[0], ii);
+			if (imode_to_type(mode) != filetype)
+				tmp_err |= INODE_ITEM_MISMATCH;
 		}
 
 		/* Check relative INODE_REF/INODE_EXTREF */
-		location.type = BTRFS_INODE_REF_KEY;
-		location.offset = key->objectid;
-		ret = find_inode_ref(root, &location, namebuf, len,
-				       &index, ext_ref);
-		err |= ret;
-		if (ret & INODE_REF_MISSING)
-			error("root %llu %s[%llu %llu] relative INODE_REF missing namelen %u filename %s filetype %d",
-			      root->objectid, key->type == BTRFS_DIR_ITEM_KEY ?
-			      "DIR_ITEM" : "DIR_INDEX", key->objectid,
-			      key->offset, name_len, namebuf, filetype);
+		key2.objectid = location.objectid;
+		key2.type = BTRFS_INODE_REF_KEY;
+		key2.offset = key->objectid;
+		tmp_err |= find_inode_ref(root, &key2, namebuf, len,
+					  &index, ext_ref);
+
+		/* check relative INDEX/ITEM */
+		key2.objectid = key->objectid;
+		if (key->type == BTRFS_DIR_ITEM_KEY) {
+			key2.type = BTRFS_DIR_INDEX_KEY;
+			key2.offset = index;
+		} else {
+			key2.type = BTRFS_DIR_ITEM_KEY;
+			key2.offset = btrfs_name_hash(namebuf, name_len);
+		}
 
+		tmp_err |= find_dir_item(root, &key2, &location, namebuf,
+					 name_len, filetype);
+		/* find_dir_item may find index */
+		if (key2.type == BTRFS_DIR_INDEX_KEY)
+			index = key2.offset;
 next:
-		btrfs_release_path(&path);
+		btrfs_release_path(path);
+
+		print_dir_item_err(root, key, location.objectid,
+				   index, namebuf, name_len, filetype,
+				   tmp_err);
+
+		err |= tmp_err;
 		len = sizeof(*di) + name_len + data_len;
 		di = (struct btrfs_dir_item *)((char *)di + len);
 		cur += len;
-
 		if (key->type == BTRFS_DIR_INDEX_KEY && cur < total) {
 			error("root %llu DIR_INDEX[%llu %llu] should contain only one entry",
 			      root->objectid, key->objectid, key->offset);
@@ -4827,9 +4870,13 @@ next:
 		}
 	}
 
+	/* research path */
+	btrfs_release_path(path);
+	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	if (ret)
+		err |= ret > 0 ? ENOENT : ret;
 	return err;
 }
-
 /*
  * Check file extent datasum/hole, update the size of the file extents,
  * check and update the last offset of the file extent.
@@ -5209,7 +5256,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 					imode_to_type(mode), key.objectid,
 					key.offset);
 			}
-			ret = check_dir_item(root, &key, node, slot, &size,
+			ret = check_dir_item(root, &key, path, &size,
 					     ext_ref);
 			err |= ret;
 			break;
-- 
2.11.1



