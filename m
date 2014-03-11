Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22248 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbaCKKbN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 06:31:13 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s2BAV9Qh024881
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 18:31:11 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] Btrfs-progs: mkfs: make sure we can deal with hard links with -r option
Date: Tue, 11 Mar 2014 18:29:09 +0800
Message-Id: <1394533749-3138-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394533749-3138-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1394533749-3138-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkdir -p /tmp/test
 # touch /tmp/test/file
 # ln /tmp/test/file /tmp/test/hardlinks
 # mkfs.btrfs -f /dev/sda13 -r /tmp/test
 # btrfs check /dev/sda13

To deal with hard link, we must deal with inode with same inode id rather
than increase inode id by ourselves.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 mkfs.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 2f7dfef..b9385bc 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -380,7 +380,10 @@ static int add_directory_items(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_dir_item(trans, root, name, name_len,
 				    parent_inum, &location,
 				    filetype, index_cnt);
-
+	if (ret)
+		return ret;
+	ret = btrfs_insert_inode_ref(trans, root, name, name_len,
+				     objectid, parent_inum, index_cnt);
 	*dir_index_cnt = index_cnt;
 	index_cnt++;
 
@@ -493,9 +496,7 @@ static int add_inode_items(struct btrfs_trans_handle *trans,
 	struct btrfs_inode_item btrfs_inode;
 	u64 objectid;
 	u64 inode_size = 0;
-	int name_len;
 
-	name_len = strlen(name);
 	fill_inode_item(trans, root, &btrfs_inode, st);
 	objectid = self_objectid;
 
@@ -509,16 +510,8 @@ static int add_inode_items(struct btrfs_trans_handle *trans,
 	btrfs_set_key_type(&inode_key, BTRFS_INODE_ITEM_KEY);
 
 	ret = btrfs_insert_inode(trans, root, objectid, &btrfs_inode);
-	if (ret)
-		goto fail;
-
-	ret = btrfs_insert_inode_ref(trans, root, name, name_len,
-				     objectid, parent_inum, dir_index_cnt);
-	if (ret)
-		goto fail;
 
 	*inode_ret = btrfs_inode;
-fail:
 	return ret;
 }
 
@@ -826,7 +819,7 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 				goto fail;
 			}
 
-			cur_inum = ++highest_inum + BTRFS_FIRST_FREE_OBJECTID;
+			cur_inum = st.st_ino;
 			ret = add_directory_items(trans, root,
 						  cur_inum, parent_inum,
 						  cur_file->d_name,
@@ -840,6 +833,10 @@ static int traverse_directory(struct btrfs_trans_handle *trans,
 					      cur_file->d_name, cur_inum,
 					      parent_inum, dir_index_cnt,
 					      &cur_inode);
+			if (ret == -EEXIST) {
+				BUG_ON(st.st_nlink <= 1);
+				continue;
+			}
 			if (ret) {
 				fprintf(stderr, "add_inode_items failed\n");
 				goto fail;
-- 
1.9.0

