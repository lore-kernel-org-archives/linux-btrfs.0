Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425275AbeE1PyV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:54:21 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A387ADC6
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 15:54:20 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 10/11] btrfs-progs: Remove root argument from write_one_cache_group
Date: Mon, 28 May 2018 09:36:49 +0300
Message-Id: <1527489410-3564-11-git-send-email-nborisov@suse.com>
In-Reply-To: <1527489410-3564-1-git-send-email-nborisov@suse.com>
References: <1527489410-3564-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It's not needed since we can acquire a reference to the fs_info from
the transaction handle already passed.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 24fb96492c13..1694c479cc2b 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -1699,13 +1699,12 @@ int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 }
 
 static int write_one_cache_group(struct btrfs_trans_handle *trans,
-				 struct btrfs_root *root,
 				 struct btrfs_path *path,
 				 struct btrfs_block_group_cache *cache)
 {
 	int ret;
 	int pending_ret;
-	struct btrfs_root *extent_root = root->fs_info->extent_root;
+	struct btrfs_root *extent_root = trans->fs_info->extent_root;
 	unsigned long bi;
 	struct extent_buffer *leaf;
 
@@ -1765,7 +1764,7 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans,
 				  BLOCK_GROUP_DIRTY);
 
 		cache = (struct btrfs_block_group_cache *)(unsigned long)ptr;
-		ret = write_one_cache_group(trans, root, path, cache);
+		ret = write_one_cache_group(trans, path, cache);
 	}
 	btrfs_free_path(path);
 	return 0;
-- 
2.7.4

