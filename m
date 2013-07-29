Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36980 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab3G2W2D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jul 2013 18:28:03 -0400
Received: by mail-wg0-f47.google.com with SMTP id j13so5314512wgh.2
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jul 2013 15:28:01 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH v2] Btrfs-progs: add missing path alloc return value check
Date: Mon, 29 Jul 2013 23:27:53 +0100
Message-Id: <1375136873-11384-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1374216370-18953-1-git-send-email-fdmanana@gmail.com>
References: <1374216370-18953-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Also remove unused path in extent-tree.c:finish_current_insert().

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: added 1 more path alloc check and removed unnecessary path
    allocation in extent-tree.c:finish_current_insert().

 extent-tree.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index f597e16..e4adaa3 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1487,6 +1487,8 @@ int btrfs_lookup_extent_info(struct btrfs_trans_handle *trans,
 	}
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->reada = 1;
 
 	key.objectid = bytenr;
@@ -1577,6 +1579,8 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans,
 				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
 	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
 	path->reada = 1;
 
 	key.objectid = bytenr;
@@ -2078,7 +2082,6 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 	u64 end;
 	u64 priv;
 	struct btrfs_fs_info *info = extent_root->fs_info;
-	struct btrfs_path *path;
 	struct pending_extent_op *extent_op;
 	struct btrfs_key key;
 	int ret;
@@ -2086,8 +2089,6 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 		btrfs_fs_incompat(extent_root->fs_info,
 				  BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA);
 
-	path = btrfs_alloc_path();
-
 	while(1) {
 		ret = find_first_extent_bit(&info->extent_ins, 0, &start,
 					    &end, EXTENT_LOCKED);
@@ -2121,7 +2122,6 @@ static int finish_current_insert(struct btrfs_trans_handle *trans,
 				  GFP_NOFS);
 		kfree(extent_op);
 	}
-	btrfs_free_path(path);
 	return 0;
 }
 
-- 
1.7.9.5

