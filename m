Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:2977 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752438AbeAZIaz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 Jan 2018 03:30:55 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 4852E49F19BC
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jan 2018 16:30:49 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH 08/15] btrfs-progs: lowmem check: call get_dir_isize() after repair
Date: Fri, 26 Jan 2018 16:35:12 +0800
Message-ID: <20180126083519.28373-9-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
References: <20180126083519.28373-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since lowmem repair may change size of inode item, introduce
get_dir_isize() to fetch isize after traversing items of inode.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index caac71a67472..e57eea4e61c9 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -5868,6 +5868,35 @@ out:
 	return ret;
 }
 
+static int get_dir_isize(struct btrfs_root *root, u64 ino, u64 *size_ret)
+{
+	struct btrfs_inode_item *ii;
+	struct btrfs_key key;
+	struct btrfs_path path;
+	int ret;
+
+	key.objectid = ino;
+	key.type = BTRFS_INODE_ITEM_KEY;
+	key.offset = 0;
+
+	btrfs_init_path(&path);
+	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret)
+		goto out;
+
+	ii = btrfs_item_ptr(path.nodes[0], path.slots[0],
+			    struct btrfs_inode_item);
+	*size_ret = btrfs_inode_size(path.nodes[0], ii);
+	ret = 0;
+out:
+	if (ret)
+		error("failed to get isize of inode %llu root %llu",
+		      ino, root->root_key.objectid);
+	return ret;
+}
+
 /*
  * Traverse the given DIR_ITEM/DIR_INDEX and check related INODE_ITEM and
  * call find_inode_ref() to check related INODE_REF/INODE_EXTREF.
@@ -6591,6 +6620,7 @@ out:
 		if (repair && (err & DIR_COUNT_AGAIN)) {
 			err &= ~DIR_COUNT_AGAIN;
 			count_dir_isize(root, inode_id, &size);
+			get_dir_isize(root, inode_id, &isize);
 		}
 
 		if ((nlink != 1 || refs != 1) && repair) {
-- 
2.16.1



