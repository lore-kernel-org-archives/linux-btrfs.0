Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45969 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751037AbdCADSA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:18:00 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5A7A647C4EBE
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:15 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 09/20] btrfs-progs: cmds-check.c: introduce count_dir_isize
Date: Wed, 1 Mar 2017 11:13:52 +0800
Message-ID: <20170301031403.23902-10-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce 'count_dir_isize' to get dir isize.
This function is called only under lowmme repair mode.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 3 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 44abb282..685f4f5d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4738,6 +4738,93 @@ static void print_dir_item_err(struct btrfs_root *root, struct btrfs_key *key,
 
 }
 
+static int __count_dir_isize(struct btrfs_root *root, u64 ino,
+			 int type, u64 *size_ret)
+{
+	struct btrfs_key key;
+	struct btrfs_path path;
+	u32 len;
+	struct btrfs_dir_item *di;
+	int ret;
+	int cur = 0;
+	int total = 0;
+
+	ASSERT(size_ret);
+	*size_ret = 0;
+
+	key.objectid = ino;
+	key.type = type;
+	key.offset = (u64)-1;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret < 0) {
+		ret = -EIO;
+		goto out;
+	}
+	/* if found, go to spacial case */
+	if (ret == 0)
+		goto special_case;
+
+loop:
+	ret = btrfs_previous_item(root, &path, ino, type);
+
+	if (ret) {
+		ret = 0;
+		goto out;
+	}
+
+special_case:
+
+	di = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_dir_item);
+	cur = 0;
+	total = btrfs_item_size_nr(path.nodes[0], path.slots[0]);
+
+	while (cur < total) {
+		len = btrfs_dir_name_len(path.nodes[0], di);
+		if (len > BTRFS_NAME_LEN)
+			len = BTRFS_NAME_LEN;
+		*size_ret += len;
+
+		len += btrfs_dir_data_len(path.nodes[0], di);
+		len += sizeof(*di);
+		di = (struct btrfs_dir_item *)((char *)di + len);
+		cur += len;
+	}
+	goto loop;
+
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
+static int count_dir_isize(struct btrfs_root *root, u64 ino, u64 *size)
+{
+	ASSERT(size);
+	u64 item_size;
+	u64 index_size;
+	int ret;
+
+	ret = __count_dir_isize(root, ino, BTRFS_DIR_ITEM_KEY,
+				&item_size);
+	if (ret)
+		goto out;
+
+	ret = __count_dir_isize(root, ino, BTRFS_DIR_INDEX_KEY,
+			       &index_size);
+	if (ret)
+		goto out;
+
+	*size = item_size + index_size;
+
+out:
+	if (ret)
+		error("Failed to count root %llu INODE[%llu] root size",
+		      root->objectid, ino);
+	return ret;
+}
+
 /*
  * Traverse the given DIR_ITEM/DIR_INDEX and check related INODE_ITEM and
  * call find_inode_ref() to check related INODE_REF/INODE_EXTREF.If repair
@@ -4807,7 +4894,6 @@ static int check_dir_item(struct btrfs_root *root, struct btrfs_key *key,
 				key->objectid, key->offset);
 		}
 		(*size) += name_len;
-
 		read_extent_buffer(node, namebuf, (unsigned long)(di + 1),
 				   len);
 		filetype = btrfs_dir_type(node, di);
@@ -5256,8 +5342,7 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 					imode_to_type(mode), key.objectid,
 					key.offset);
 			}
-			ret = check_dir_item(root, &key, path, &size,
-					     ext_ref);
+			ret = check_dir_item(root, &key, path, &size, ext_ref);
 			err |= ret;
 			break;
 		case BTRFS_EXTENT_DATA_KEY:
@@ -5280,6 +5365,10 @@ static int check_inode_item(struct btrfs_root *root, struct btrfs_path *path,
 	}
 
 out:
+	/* Only get isize again since it costs time much */
+	if (repair)
+		count_dir_isize(root, inode_id, &size);
+
 	/* verify INODE_ITEM nlink/isize/nbytes */
 	if (dir) {
 		if (nlink != 1) {
-- 
2.11.1



