Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48427 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3IKTgi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Sep 2013 15:36:38 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 761737C06AD
	for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 13:36:38 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id TpeYKa8ZL8ZvnDNj (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 11 Sep 2013 13:36:37 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: drop dir i_size when adding new names on replay V2
Date: Wed, 11 Sep 2013 15:36:35 -0400
Message-ID: <1378928195-27370-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So if we have dir_index items in the log that means we also have the inode item
as well, which means that the inode's i_size is correct.  However when we
process dir_index'es we call btrfs_add_link() which will increase the
directory's i_size for the new entry.  To fix this we need to just set the dir
items i_size to 0, and then as we find dir_index items we adjust the i_size.
btrfs_add_link() will do it for new entries, and if the entry already exists we
can just add the name_len to the i_size ourselves.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: just reset the directory size to 0 and re-add names as we process them.

 fs/btrfs/tree-log.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c91309d..79f057c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -394,6 +394,7 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 		if (inode_item) {
 			struct btrfs_inode_item *item;
 			u64 nbytes;
+			u32 mode;
 
 			item = btrfs_item_ptr(path->nodes[0], path->slots[0],
 					      struct btrfs_inode_item);
@@ -401,9 +402,19 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 			item = btrfs_item_ptr(eb, slot,
 					      struct btrfs_inode_item);
 			btrfs_set_inode_nbytes(eb, item, nbytes);
+
+			/*
+			 * If this is a directory we need to reset the i_size to
+			 * 0 so that we can set it up properly when replaying
+			 * the rest of the items in this log.
+			 */
+			mode = btrfs_inode_mode(eb, item);
+			if (S_ISDIR(mode))
+				btrfs_set_inode_size(eb, item, 0);
 		}
 	} else if (inode_item) {
 		struct btrfs_inode_item *item;
+		u32 mode;
 
 		/*
 		 * New inode, set nbytes to 0 so that the nbytes comes out
@@ -411,6 +422,15 @@ static noinline int overwrite_item(struct btrfs_trans_handle *trans,
 		 */
 		item = btrfs_item_ptr(eb, slot, struct btrfs_inode_item);
 		btrfs_set_inode_nbytes(eb, item, 0);
+
+		/*
+		 * If this is a directory we need to reset the i_size to 0 so
+		 * that we can set it up properly when replaying the rest of
+		 * the items in this log.
+		 */
+		mode = btrfs_inode_mode(eb, item);
+		if (S_ISDIR(mode))
+			btrfs_set_inode_size(eb, item, 0);
 	}
 insert:
 	btrfs_release_path(path);
@@ -1497,6 +1517,7 @@ static noinline int insert_one_name(struct btrfs_trans_handle *trans,
 		iput(inode);
 		return -EIO;
 	}
+
 	ret = btrfs_add_link(trans, dir, inode, name, name_len, 1, index);
 
 	/* FIXME, put inode into FIXUP list */
@@ -1535,6 +1556,7 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 	u8 log_type;
 	int exists;
 	int ret = 0;
+	bool update_size = (key->type == BTRFS_DIR_INDEX_KEY);
 
 	dir = read_one_inode(root, key->objectid);
 	if (!dir)
@@ -1605,6 +1627,10 @@ static noinline int replay_one_name(struct btrfs_trans_handle *trans,
 		goto insert;
 out:
 	btrfs_release_path(path);
+	if (!ret && update_size) {
+		btrfs_i_size_write(dir, dir->i_size + name_len * 2);
+		ret = btrfs_update_inode(trans, root, dir);
+	}
 	kfree(name);
 	iput(dir);
 	return ret;
@@ -1615,6 +1641,7 @@ insert:
 			      name, name_len, log_type, &log_key);
 	if (ret && ret != -ENOENT)
 		goto out;
+	update_size = false;
 	ret = 0;
 	goto out;
 }
-- 
1.7.7.6

