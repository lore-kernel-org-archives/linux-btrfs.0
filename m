Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21728 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750857AbbGBGyg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jul 2015 02:54:36 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t626qr1v016085
	for <linux-btrfs@vger.kernel.org>; Thu, 2 Jul 2015 14:52:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/2] btrfs-progs: fsck:Add repair function for I_ERR_FILE_WRONG_NBYTES.
Date: Thu, 2 Jul 2015 14:52:30 +0800
Message-ID: <1435819951-16933-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some unknown kernel bug makes inode nbytes modification out of sync with
file extent update.

But it's quite easy to fix in btrfs-progs anyway.

So just fix it by adding a new function repair_inode_nbytes by using the
found_size in inode_record.

Reported-by: Christian <cdysthe@gmail.com>
Reported-by: Chris Murphy <lists@colorremedies.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 778f141..dd2fce3 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -1918,6 +1918,39 @@ static int repair_inode_orphan_item(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+static int repair_inode_nbytes(struct btrfs_trans_handle *trans,
+			       struct btrfs_root *root,
+			       struct btrfs_path *path,
+			       struct inode_record *rec)
+{
+	struct btrfs_inode_item *ei;
+	struct btrfs_key key;
+	int ret = 0;
+
+	key.objectid = rec->ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
+		goto out;
+	}
+
+	/* Since ret == 0, no need to check anything */
+	ei = btrfs_item_ptr(path->nodes[0], path->slots[0],
+			    struct btrfs_inode_item);
+	btrfs_set_inode_nbytes(path->nodes[0], ei, rec->found_size);
+	btrfs_mark_buffer_dirty(path->nodes[0]);
+	rec->errors &= ~I_ERR_FILE_NBYTES_WRONG;
+	printf("reset nbytes for ino %llu root %llu\n",
+	       rec->ino, root->root_key.objectid);
+out:
+	btrfs_release_path(path);
+	return ret;
+}
+
 static int add_missing_dir_index(struct btrfs_root *root,
 				 struct cache_tree *inode_cache,
 				 struct inode_record *rec,
@@ -2661,7 +2694,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 			     I_ERR_LINK_COUNT_WRONG |
 			     I_ERR_NO_INODE_ITEM |
 			     I_ERR_FILE_EXTENT_ORPHAN |
-			     I_ERR_FILE_EXTENT_DISCOUNT)))
+			     I_ERR_FILE_EXTENT_DISCOUNT|
+			     I_ERR_FILE_NBYTES_WRONG)))
 		return rec->errors;
 
 	path = btrfs_alloc_path();
@@ -2693,6 +2727,8 @@ static int try_repair_inode(struct btrfs_root *root, struct inode_record *rec)
 		ret = repair_inode_orphan_item(trans, root, path, rec);
 	if (!ret && rec->errors & I_ERR_LINK_COUNT_WRONG)
 		ret = repair_inode_nlinks(trans, root, path, rec);
+	if (!ret && rec->errors & I_ERR_FILE_NBYTES_WRONG)
+		ret = repair_inode_nbytes(trans, root, path, rec);
 	btrfs_commit_transaction(trans, root);
 	btrfs_free_path(path);
 	return ret;
-- 
2.4.4

