Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:33627 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751795AbeBBI2F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 03:28:05 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 5626E49F19C2
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Feb 2018 16:28:02 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 03/10] btrfs-progs: use btrfs_find_free_dir_index to find free inode index
Date: Fri, 2 Feb 2018 16:27:44 +0800
Message-ID: <20180202082751.26225-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
References: <20180202082751.26225-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have an existing function to find free inode index, we can
reuse it here.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 inode.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/inode.c b/inode.c
index 478036562652..86905365dfd8 100644
--- a/inode.c
+++ b/inode.c
@@ -628,7 +628,7 @@ int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	struct btrfs_inode_item *inode_item;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
-	u64 index = 2;
+	u64 index;
 	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
 	int len;
 	int i;
@@ -638,28 +638,15 @@ int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	if (len == 0 || len > BTRFS_NAME_LEN)
 		return -EINVAL;
 
-	/* find the free dir_index */
-	btrfs_init_path(&path);
-	key.objectid = dirid;
-	key.type = BTRFS_DIR_INDEX_KEY;
-	key.offset = (u64)-1;
-
-	ret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
-	if (ret <= 0) {
-		error("search for DIR_INDEX dirid %llu failed: %d",
-				(unsigned long long)dirid, ret);
+	/* add the dir_item/dir_index */
+	ret = btrfs_find_free_dir_index(root, dirid, &index);
+	if (ret < 0) {
+		error("unable to find free dir index dirid %llu failed: %d",
+		      (unsigned long long)dirid, ret);
 		goto fail;
 	}
 
-	if (path.slots[0] > 0) {
-		path.slots[0]--;
-		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
-		if (key.objectid == dirid && key.type == BTRFS_DIR_INDEX_KEY)
-			index = key.offset + 1;
-	}
-	btrfs_release_path(&path);
-
-	/* add the dir_item/dir_index */
+	btrfs_init_path(&path);
 	key.objectid = dirid;
 	key.offset = 0;
 	key.type =  BTRFS_INODE_ITEM_KEY;
-- 
2.16.1



