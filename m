Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47010 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758543Ab3B0LRD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 06:17:03 -0500
Received: by mail-pa0-f43.google.com with SMTP id bh2so373228pad.30
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 03:17:02 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: wangshilong1991@gmail.com, miaox@cn.fujitsu.com, sensille@gmx.net
Subject: [PATCH 1/3] Btrfs: fix missing deleted items in btrfs_clean_quota_tree
Date: Wed, 27 Feb 2013 19:16:57 +0800
Message-Id: <1361963817-2283-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

Steps to reproduce:

	i=0
	ncases=100

	mkfs.btrfs <disk>
	mount <disk> <mnt>
	btrfs quota enable <mnt>
	btrfs qgroup create 2/1 <mnt>
	while [ $i -le $ncases ]
	do
		btrfs qgroup create 1/$i <mnt>
		btrfs qgroup assign 1/$i 2/1 <mnt>
		i=$(($i+1))
	done

	btrfs quota disable <mnt>
	umount <mnt>
	btrfsck <mnt>

You can also use the commands:
	btrfs-debug-tree <disk> | grep QGROUP

You will find there are still items existed.The reasons why this happens
is because the original code just checks slots[0]==0 and returns.
We try to fix it by deleting the leaf one by one.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/qgroup.c |   34 +++++++++++++++++++++-------------
 1 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 88ab785..f011d9b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -732,7 +732,9 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_path *path;
 	struct btrfs_key key;
+	struct extent_buffer *leaf = NULL;
 	int ret;
+	int nr = 0;
 
 	if (!root)
 		return -EINVAL;
@@ -741,24 +743,30 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	while (1) {
-		key.objectid = 0;
-		key.offset = 0;
-		key.type = 0;
+	path->leave_spinning = 1;
 
-		path->leave_spinning = 1;
+	key.objectid = 0;
+	key.offset = 0;
+	key.type = 0;
+
+	while (1) {
 		ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
-		if (ret > 0) {
-			if (path->slots[0] == 0)
-				break;
-			path->slots[0]--;
-		} else if (ret < 0) {
+		if (ret < 0)
+			goto out;
+		leaf = path->nodes[0];
+		nr = btrfs_header_nritems(leaf);
+		if (!nr)
 			break;
-		}
-
-		ret = btrfs_del_item(trans, root, path);
+		/*
+		 * delete the leaf one by one
+		 * since the whole tree is going
+		 * to be deleted.
+		 */
+		path->slots[0] = 0;
+		ret = btrfs_del_items(trans, root, path, 0, nr);
 		if (ret)
 			goto out;
+
 		btrfs_release_path(path);
 	}
 	ret = 0;
-- 
1.7.7.6

