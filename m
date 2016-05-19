Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39836 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbcESCyy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 22:54:54 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: [PATCH] btrfs-progs: Return earlier for previous item
Date: Thu, 19 May 2016 10:54:39 +0800
Message-Id: <1463626479-7628-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Follow kernel code to return earlier for btrfs_previous_item() function.

Before this patch, btrfs_previous_item() doesn't use its min_objectid to
exit, this makes caller to check key to exit, and if caller doesn't
check, it will iterate all previous item.

This patch will check min_objectid and type, to early return and save
some time.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 ctree.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/ctree.c b/ctree.c
index 079696e..a98ad18 100644
--- a/ctree.c
+++ b/ctree.c
@@ -2880,6 +2880,7 @@ int btrfs_previous_item(struct btrfs_root *root,
 {
 	struct btrfs_key found_key;
 	struct extent_buffer *leaf;
+	u32 nritems;
 	int ret;
 
 	while(1) {
@@ -2891,9 +2892,20 @@ int btrfs_previous_item(struct btrfs_root *root,
 			path->slots[0]--;
 		}
 		leaf = path->nodes[0];
+		nritems = btrfs_header_nritems(leaf);
+		if (nritems == 0)
+			return 1;
+		if (path->slots[0] == nritems)
+			path->slots[0]--;
+
 		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+		if (found_key.objectid < min_objectid)
+			break;
 		if (found_key.type == type)
 			return 0;
+		if (found_key.objectid == min_objectid &&
+		    found_key.type < type)
+			break;
 	}
 	return 1;
 }
-- 
2.8.2



