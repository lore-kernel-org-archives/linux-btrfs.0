Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49831 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936896AbeE1QNu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:13:50 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 93182AE65
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 16:13:47 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 01/11] btrfs-progs: check: Remove root argument from delete_extent_records
Date: Mon, 28 May 2018 09:36:40 +0300
Message-Id: <1527489410-3564-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is always passed the extent_root as "root" parameter. In
turn it uses the root parameter to mostly access fs_info and performs
only a single call to btrfs_update_block_group where it passses the
passed root. This is all redundant since fs_info can be referenced
from the transaction handle and in turn extent_root can be referenced
from the fs_info. So do that to simplify the function's signature.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 check/main.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/check/main.c b/check/main.c
index 68da994f7ae0..4cf243d9b379 100644
--- a/check/main.c
+++ b/check/main.c
@@ -6295,10 +6295,10 @@ static int free_extent_hook(struct btrfs_trans_handle *trans,
 }
 
 static int delete_extent_records(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
 				 struct btrfs_path *path,
 				 u64 bytenr)
 {
+	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_key key;
 	struct btrfs_key found_key;
 	struct extent_buffer *leaf;
@@ -6311,8 +6311,8 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 	key.offset = (u64)-1;
 
 	while (1) {
-		ret = btrfs_search_slot(trans, root->fs_info->extent_root,
-					&key, path, 0, 1);
+		ret = btrfs_search_slot(trans, fs_info->extent_root, &key,
+					path, 0, 1);
 		if (ret < 0)
 			break;
 
@@ -6354,7 +6354,7 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 			"repair deleting extent record: key [%llu,%u,%llu]\n",
 			found_key.objectid, found_key.type, found_key.offset);
 
-		ret = btrfs_del_item(trans, root->fs_info->extent_root, path);
+		ret = btrfs_del_item(trans, fs_info->extent_root, path);
 		if (ret)
 			break;
 		btrfs_release_path(path);
@@ -6362,10 +6362,10 @@ static int delete_extent_records(struct btrfs_trans_handle *trans,
 		if (found_key.type == BTRFS_EXTENT_ITEM_KEY ||
 		    found_key.type == BTRFS_METADATA_ITEM_KEY) {
 			u64 bytes = (found_key.type == BTRFS_EXTENT_ITEM_KEY) ?
-				found_key.offset : root->fs_info->nodesize;
+				found_key.offset : fs_info->nodesize;
 
-			ret = btrfs_update_block_group(root, bytenr,
-						       bytes, 0, 0);
+			ret = btrfs_update_block_group(fs_info->extent_root,
+						       bytenr, bytes, 0, 0);
 			if (ret)
 				break;
 		}
@@ -7293,8 +7293,7 @@ static int fixup_extent_refs(struct btrfs_fs_info *info,
 	}
 
 	/* step two, delete all the existing records */
-	ret = delete_extent_records(trans, info->extent_root, &path,
-				    rec->start);
+	ret = delete_extent_records(trans, &path, rec->start);
 
 	if (ret < 0)
 		goto out;
-- 
2.7.4

