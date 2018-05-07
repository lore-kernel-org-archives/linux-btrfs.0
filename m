Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45920 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751918AbeEGDKp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 May 2018 23:10:45 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 835044B34D53
        for <linux-btrfs@vger.kernel.org>; Mon,  7 May 2018 11:10:43 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 03/10] btrfs-progs: use btrfs_find_free_dir_index to find free inode index
Date: Mon, 7 May 2018 11:10:26 +0800
Message-ID: <20180507031033.4125-4-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
References: <20180507031033.4125-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have an existing function to find free inode index, we can
reuse it here.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
---
V3: add Reviewed-by from Qu Wenruo.

 inode.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/inode.c b/inode.c
index f9b72533f3a9..03b8be63eb0a 100644
--- a/inode.c
+++ b/inode.c
@@ -629,7 +629,7 @@ int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	struct btrfs_root_item root_item;
 	struct extent_buffer *leaf;
 	struct btrfs_key key;
-	u64 index = 2;
+	u64 index;
 	u64 offset;
 	char buf[BTRFS_NAME_LEN + 1]; /* for snprintf null */
 	int len;
@@ -640,28 +640,15 @@ int btrfs_link_subvol(struct btrfs_trans_handle *trans, struct btrfs_root *root,
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
2.17.0



