Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:59851 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbaAaQmV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jan 2014 11:42:21 -0500
Received: by mail-pa0-f42.google.com with SMTP id kl14so4651992pab.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jan 2014 08:42:20 -0800 (PST)
Received: from linux-b0ol.localdomain ([36.59.228.44])
        by mx.google.com with ESMTPSA id om6sm29181142pbc.43.2014.01.31.08.42.16
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jan 2014 08:42:20 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] Btrfs: switch to btrfs_previous_extent_item()
Date: Sat,  1 Feb 2014 00:42:04 +0800
Message-Id: <1391186525-2965-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Since we have introduced btrfs_previous_extent_item() to search previous
extent item, just switch into it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 34 +++-------------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index aded3ef..4f59f07 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1333,37 +1333,9 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
 	if (ret < 0)
 		return ret;
 
-	while (1) {
-		u32 nritems;
-		if (path->slots[0] == 0) {
-			btrfs_set_path_blocking(path);
-			ret = btrfs_prev_leaf(fs_info->extent_root, path);
-			if (ret != 0) {
-				if (ret > 0) {
-					pr_debug("logical %llu is not within "
-						 "any extent\n", logical);
-					ret = -ENOENT;
-				}
-				return ret;
-			}
-		} else {
-			path->slots[0]--;
-		}
-		nritems = btrfs_header_nritems(path->nodes[0]);
-		if (nritems == 0) {
-			pr_debug("logical %llu is not within any extent\n",
-				 logical);
-			return -ENOENT;
-		}
-		if (path->slots[0] == nritems)
-			path->slots[0]--;
-
-		btrfs_item_key_to_cpu(path->nodes[0], found_key,
-				      path->slots[0]);
-		if (found_key->type == BTRFS_EXTENT_ITEM_KEY ||
-		    found_key->type == BTRFS_METADATA_ITEM_KEY)
-			break;
-	}
+	ret = btrfs_previous_extent_item(fs_info->extent_root, path, 0);
+	if (ret)
+		return ret;
 
 	if (found_key->type == BTRFS_METADATA_ITEM_KEY)
 		size = fs_info->extent_root->leafsize;
-- 
1.8.4

