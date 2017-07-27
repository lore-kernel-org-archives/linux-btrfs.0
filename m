Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41353 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751558AbdG0LWc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 07:22:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 08293AB1E
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 11:22:31 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove chunk_objectid argument from btrfs_make_block_group
Date: Thu, 27 Jul 2017 14:22:11 +0300
Message-Id: <1501154531-6948-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs_make_block_group is always called with chunk_objectid set to
BTRFS_FIRST_CHUNK_TREE_OBJECTID. There's no reason why this behavior will
change anytime soon, so let's remove the argument and decrease the cognitive
load when reading the code path. No functional change

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 6 +++---
 fs/btrfs/volumes.c     | 4 +---
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index a21a18809915..cd9497bcdb1e 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2670,8 +2670,7 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info);
 int btrfs_can_relocate(struct btrfs_fs_info *fs_info, u64 bytenr);
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info, u64 bytes_used,
-			   u64 type, u64 chunk_objectid, u64 chunk_offset,
-			   u64 size);
+			   u64 type, u64 chunk_offset, u64 size);
 struct btrfs_trans_handle *btrfs_start_trans_remove_block_group(
 				struct btrfs_fs_info *fs_info,
 				const u64 chunk_offset);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 463063fb4f07..fc9dc879cee2 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10179,8 +10179,7 @@ void btrfs_create_pending_block_groups(struct btrfs_trans_handle *trans,
 
 int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 			   struct btrfs_fs_info *fs_info, u64 bytes_used,
-			   u64 type, u64 chunk_objectid, u64 chunk_offset,
-			   u64 size)
+			   u64 type, u64 chunk_offset, u64 size)
 {
 	struct btrfs_block_group_cache *cache;
 	int ret;
@@ -10192,7 +10191,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	btrfs_set_block_group_used(&cache->item, bytes_used);
-	btrfs_set_block_group_chunk_objectid(&cache->item, chunk_objectid);
+	btrfs_set_block_group_chunk_objectid(&cache->item,
+					     BTRFS_FIRST_CHUNK_TREE_OBJECTID);
 	btrfs_set_block_group_flags(&cache->item, type);
 
 	cache->flags = type;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 83d77b2cc5d8..46fe5f2bb5e8 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4854,9 +4854,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 		goto error;
 	}
 
-	ret = btrfs_make_block_group(trans, info, 0, type,
-				     BTRFS_FIRST_CHUNK_TREE_OBJECTID,
-				     start, num_bytes);
+	ret = btrfs_make_block_group(trans, info, 0, type, start, num_bytes);
 	if (ret)
 		goto error_del_extent;
 
-- 
2.7.4

