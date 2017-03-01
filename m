Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45969 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751665AbdCADSH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:07 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 4C5C448A2942
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:19 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 16/20] btrfs-progs: cmds-check.c: Introduce repair_dir_item
Date: Wed, 1 Mar 2017 11:13:59 +0800
Message-ID: <20170301031403.23902-17-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce 'repair_dir_item' to repair dir item/index missing/mismatch
and relative inode item missing while checking.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 9a76107e..1b35a5fd 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4906,6 +4906,60 @@ out:
 }
 
 /*
+ * Call repair_inode_item_missing and repair_ternary_lowmem to repair
+ *
+ * @diff_ret:     same as repair_ternary_lowmem
+ *
+ * Returns 0 means success
+ */
+static int repair_dir_item(struct btrfs_root *root, u64 dirid, u64 ino,
+			   u64 index, u8 filetype, char *namebuf, u32 name_len,
+			   int *err_ret)
+{
+	int ret = 0;
+
+	if (*err_ret & INODE_ITEM_MISSING) {
+		ret = repair_inode_item_missing(root, ino, filetype, *err_ret);
+		if (!ret)
+			*err_ret &= ~(INODE_ITEM_MISMATCH |
+				      INODE_ITEM_MISSING);
+	}
+
+	if (*err_ret & ~(INODE_ITEM_MISMATCH | INODE_ITEM_MISSING)) {
+		ret = repair_ternary_lowmem(root, dirid, ino, index, namebuf,
+					    name_len, filetype, *err_ret);
+		if (!ret) {
+			*err_ret &= ~(DIR_INDEX_MISMATCH | DIR_INDEX_MISSING);
+			*err_ret &= ~(DIR_ITEM_MISMATCH | DIR_ITEM_MISSING);
+			*err_ret &= ~(INODE_REF_MISSING);
+		}
+	}
+
+	return ret;
+}
+
+/*
+ * Research @path by the @key, if it fails then change path to previous item.
+ *
+ * returns 0 means success
+ * returns <0 means failure
+ * return >0 means jumped to previous item
+ */
+static int research_path(struct btrfs_root *root, struct btrfs_path *path,
+			 struct btrfs_key *key)
+{
+	int ret;
+	/* research path */
+	btrfs_release_path(path);
+	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	if (ret > 0) {
+		ret = btrfs_previous_item(root, path, key->objectid,
+					  key->type);
+	}
+
+	return ret;
+}
+/*
  * Traverse the given DIR_ITEM/DIR_INDEX and check related INODE_ITEM and
  * call find_inode_ref() to check related INODE_REF/INODE_EXTREF.If repair
  * is enable, do repair and research by @path->nodes[0].
@@ -4941,6 +4995,7 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 	int ret;
 	int err = 0;
 	int tmp_err;
+	int need_research = 0;
 
 	/*
 	 * For DIR_ITEM set index to (u64)-1, so that find_inode_ref
@@ -4948,10 +5003,22 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 	 */
 	index = (key->type == BTRFS_DIR_INDEX_KEY) ? key->offset : (u64)-1;
 
+research:
+	if (need_research) {
+		ret = research_path(root, path, key);
+		need_research = 0;
+		if (ret)
+			return ret > 0 ? 0 : ret;
+	}
+
+	err = 0;
+	cur = 0;
 	node = path->nodes[0];
 	slot = path->slots[0];
+
 	di = btrfs_item_ptr(node, slot, struct btrfs_dir_item);
 	total = btrfs_item_size_nr(node, slot);
+	memset(namebuf, 0, sizeof(namebuf) / sizeof(*namebuf));
 
 	while (cur < total) {
 		data_len = btrfs_dir_data_len(node, di);
@@ -5021,6 +5088,16 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 next:
 		btrfs_release_path(path);
 
+		if (tmp_err && repair) {
+			ret = repair_dir_item(root, key->objectid,
+					      location.objectid, index,
+					      imode_to_type(mode), namebuf,
+					      name_len, &tmp_err);
+			if (!ret) {
+				need_research = 1;
+				goto research;
+			}
+		}
 		print_dir_item_err(root, key, location.objectid,
 				   index, namebuf, name_len, filetype,
 				   tmp_err);
@@ -5043,6 +5120,7 @@ next:
 		err |= ret > 0 ? ENOENT : ret;
 	return err;
 }
+
 /*
  * Check file extent datasum/hole, update the size of the file extents,
  * check and update the last offset of the file extent.
-- 
2.11.1



