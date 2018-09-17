Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:63019 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727099AbeIQMsT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Sep 2018 08:48:19 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 4FA834B6EC90
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Sep 2018 15:22:01 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH v3 4/7] btrfs-progs: lowmem: search key of root again after check_fs_root() after repair
Date: Mon, 17 Sep 2018 15:28:49 +0800
Message-ID: <20180917072852.25831-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
References: <20180917072852.25831-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In check_fs_roots_lowmem(), we do search and follow the resulted path
to call check_fs_root(), then call btrfs_next_item() to check next
root.
However, if repair is enabled, the root tree can be cowed, the
existed path can cause strange errors.

Solution:
  If repair, save the key before calling check_fs_root,
  search the saved key again before checking next root.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 4db12cc7f9fe..db44456fd85b 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -4967,9 +4967,13 @@ int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info)
 	}
 
 	while (1) {
+		struct btrfs_key saved_key;
+
 		node = path.nodes[0];
 		slot = path.slots[0];
 		btrfs_item_key_to_cpu(node, &key, slot);
+		if (repair)
+			saved_key = key;
 		if (key.objectid > BTRFS_LAST_FREE_OBJECTID)
 			goto out;
 		if (key.type == BTRFS_ROOT_ITEM_KEY &&
@@ -5000,6 +5004,24 @@ int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info)
 			err |= ret;
 		}
 next:
+		/*
+		 * Since root tree can be cowed during repair,
+		 * here search the saved key again.
+		 */
+		if (repair) {
+			btrfs_release_path(&path);
+			ret = btrfs_search_slot(NULL, fs_info->tree_root,
+						&saved_key, &path, 0, 0);
+			/* Repair never deletes trees, search must succeed. */
+			if (ret > 0)
+				ret = -ENOENT;
+			if (ret) {
+				error(
+			"search root key[%llu %u %llu] failed after repair: %s",
+				      saved_key.objectid, saved_key.type,
+				      saved_key.offset, strerror(-ret));
+			}
+		}
 		ret = btrfs_next_item(tree_root, &path);
 		if (ret > 0)
 			goto out;
-- 
2.17.1
