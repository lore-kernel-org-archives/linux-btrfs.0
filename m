Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48966 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754137AbeFTMta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:49:30 -0400
Received: from relay1.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 442B5AEC7
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jun 2018 12:49:29 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 33/34] btrfs: Remove fs_info from btrfs_force_chunk_alloc
Date: Wed, 20 Jun 2018 15:49:15 +0300
Message-Id: <1529498956-4241-34-git-send-email-nborisov@suse.com>
In-Reply-To: <1529498956-4241-1-git-send-email-nborisov@suse.com>
References: <1529498956-4241-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

It can be referenced from the passed transaction handle.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.h       | 3 +--
 fs/btrfs/extent-tree.c | 5 ++---
 fs/btrfs/relocation.c  | 3 +--
 fs/btrfs/volumes.c     | 2 +-
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index caeca7592013..2062b393e3fd 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2809,8 +2809,7 @@ int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
 				   u64 start, u64 end);
 int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
 			 u64 num_bytes, u64 *actual_bytes);
-int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info, u64 type);
+int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans, u64 type);
 int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range);
 
 int btrfs_init_space_info(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d6f82a5c79d3..c3c3e6f3b72c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9463,10 +9463,9 @@ int btrfs_inc_block_group_ro(struct btrfs_block_group_cache *cache)
 	return ret;
 }
 
-int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans,
-			    struct btrfs_fs_info *fs_info, u64 type)
+int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans, u64 type)
 {
-	u64 alloc_flags = get_alloc_profile(fs_info, type);
+	u64 alloc_flags = get_alloc_profile(trans->fs_info, type);
 
 	return do_chunk_alloc(trans, alloc_flags, CHUNK_ALLOC_FORCE);
 }
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index ef1b5aad035e..22214033a4a2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4169,8 +4169,7 @@ static noinline_for_stack int relocate_block_group(struct reloc_control *rc)
 		}
 	}
 	if (trans && progress && err == -ENOSPC) {
-		ret = btrfs_force_chunk_alloc(trans, fs_info,
-					      rc->block_group->flags);
+		ret = btrfs_force_chunk_alloc(trans, rc->block_group->flags);
 		if (ret == 1) {
 			err = 0;
 			progress = 0;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 36225e5b16e5..5bd6f3a40f9c 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3057,7 +3057,7 @@ static int btrfs_may_alloc_data_chunk(struct btrfs_fs_info *fs_info,
 			if (IS_ERR(trans))
 				return PTR_ERR(trans);
 
-			ret = btrfs_force_chunk_alloc(trans, fs_info,
+			ret = btrfs_force_chunk_alloc(trans,
 						      BTRFS_BLOCK_GROUP_DATA);
 			btrfs_end_transaction(trans);
 			if (ret < 0)
-- 
2.7.4

