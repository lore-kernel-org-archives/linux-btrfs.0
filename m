Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750998AbdHaKGm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 06:06:42 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8F840AB43
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 10:06:41 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Remove redundant forward declarations
Date: Thu, 31 Aug 2017 11:48:51 +0300
Message-Id: <1504169331-24953-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some static functions are needlessly forward declared. Let's remove those
declarations since they add no value.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Here is a less invasive version of my previous patch removing the fwd 
declarations in extent-tree. This time I've limited myself to only those 
declarations which can be removed without moving code around and creating
needless noise. 

 fs/btrfs/extent-tree.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 21c78c48e15b..4c9e87efdaa1 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -61,9 +61,6 @@ enum {
 	CHUNK_ALLOC_FORCE = 2,
 };
 
-static int update_block_group(struct btrfs_trans_handle *trans,
-			      struct btrfs_fs_info *fs_info, u64 bytenr,
-			      u64 num_bytes, int alloc);
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			       struct btrfs_fs_info *fs_info,
 				struct btrfs_delayed_ref_node *node, u64 parent,
@@ -91,17 +88,8 @@ static int find_next_key(struct btrfs_path *path, int level,
 static void dump_space_info(struct btrfs_fs_info *fs_info,
 			    struct btrfs_space_info *info, u64 bytes,
 			    int dump_block_groups);
-static int btrfs_add_reserved_bytes(struct btrfs_block_group_cache *cache,
-				    u64 ram_bytes, u64 num_bytes, int delalloc);
-static int btrfs_free_reserved_bytes(struct btrfs_block_group_cache *cache,
-				     u64 num_bytes, int delalloc);
 static int block_rsv_use_bytes(struct btrfs_block_rsv *block_rsv,
 			       u64 num_bytes);
-static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
-				    struct btrfs_space_info *space_info,
-				    u64 orig_bytes,
-				    enum btrfs_reserve_flush_enum flush,
-				    bool system_chunk);
 static void space_info_add_new_bytes(struct btrfs_fs_info *fs_info,
 				     struct btrfs_space_info *space_info,
 				     u64 num_bytes);
-- 
2.7.4

