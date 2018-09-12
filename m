Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38623 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbeILRyW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 13:54:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id t84-v6so1022754pgb.5
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 05:49:59 -0700 (PDT)
From: damenly.su@gmail.com
To: linux-btrfs@vger.kernel.org
Cc: suy.fnst@cn.fujitsu.com
Subject: [PATCH v2 4/7] btrfs-progs: lowmem: search key of root again after check_fs_root() under repair
Date: Wed, 12 Sep 2018 20:49:21 +0000
Message-Id: <20180912204924.10089-5-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20180912204924.10089-1-suy.fnst@cn.fujitsu.com>
References: <20180912204924.10089-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Su Yue <suy.fnst@cn.fujitsu.com>

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
 check/mode-lowmem.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 89a304bbdd69..8fc9edab1d66 100644
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
@@ -5000,6 +5004,17 @@ int check_fs_roots_lowmem(struct btrfs_fs_info *fs_info)
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
+			BUG_ON(ret);
+		}
 		ret = btrfs_next_item(tree_root, &path);
 		if (ret > 0)
 			goto out;
-- 
2.18.0
