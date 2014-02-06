Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37147 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213AbaBFMEh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Feb 2014 07:04:37 -0500
Received: by mail-pb0-f50.google.com with SMTP id rq2so1660004pbb.23
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Feb 2014 04:04:37 -0800 (PST)
Received: from linux-b0ol.site ([223.65.190.181])
        by mx.google.com with ESMTPSA id n6sm2863338pbj.22.2014.02.06.04.04.34
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Feb 2014 04:04:36 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2 ] Btrfs: switch to btrfs_previous_extent_item()
Date: Thu,  6 Feb 2014 20:02:29 +0800
Message-Id: <1391688149-2319-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

Since we have introduced btrfs_previous_extent_item() to search previous
extent item, just switch into it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Changelog:
v1->v2:
	set @found_key properly and fix return value(thanks to Filipe)
---
 fs/btrfs/backref.c | 37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index c39891c..4dedb89 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1325,38 +1325,13 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
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
+	ret = btrfs_previous_extent_item(fs_info->extent_root, path, 0);
+	if (ret) {
+		if (ret > 0)
+			ret = -ENOENT;
+		return ret;
 	}
-
+	btrfs_item_key_to_cpu(path->nodes[0], found_key, path->slots[0]);
 	if (found_key->type == BTRFS_METADATA_ITEM_KEY)
 		size = fs_info->extent_root->leafsize;
 	else if (found_key->type == BTRFS_EXTENT_ITEM_KEY)
-- 
1.8.4

