Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24160 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751470AbdCADoI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Feb 2017 22:44:08 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E842147C4EBF
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Mar 2017 11:13:15 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo@cn.fujitsu.com>
Subject: [PATCH 10/20] btrfs-progs: dir-item.c: modify btrfs_insert_dir_item
Date: Wed, 1 Mar 2017 11:13:53 +0800
Message-ID: <20170301031403.23902-11-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
References: <20170301031403.23902-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the function 'btrfs_insert_dir_item', let it continue to
insert dir index if the dir item is existed and set ret value
to 0.

This further is for further repair.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 dir-item.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/dir-item.c b/dir-item.c
index 846fc292..a112ed72 100644
--- a/dir-item.c
+++ b/dir-item.c
@@ -135,7 +135,14 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 					name, name_len);
 	if (IS_ERR(dir_item)) {
 		ret = PTR_ERR(dir_item);
-		goto out;
+
+		/* Continue to insert item if existed */
+		if (ret == -EEXIST) {
+			ret = 0;
+			goto next;
+		} else {
+			goto out;
+		}
 	}
 
 	leaf = path->nodes[0];
@@ -149,6 +156,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 	write_extent_buffer(leaf, name, name_ptr, name_len);
 	btrfs_mark_buffer_dirty(leaf);
 
+next:
 	/* FIXME, use some real flag for selecting the extra index */
 	if (root == root->fs_info->tree_root) {
 		ret = 0;
@@ -162,8 +170,11 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans, struct btrfs_root
 					name, name_len);
 	if (IS_ERR(dir_item)) {
 		ret2 = PTR_ERR(dir_item);
+		if (ret2 == -EEXIST)
+			ret = 0;
 		goto out;
 	}
+
 	leaf = path->nodes[0];
 	btrfs_cpu_key_to_disk(&disk_key, location);
 	btrfs_set_dir_item_key(leaf, dir_item, &disk_key);
-- 
2.11.1



