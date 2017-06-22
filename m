Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58294 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750847AbdFVNvc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 09:51:32 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0B98DABF4
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Jun 2017 13:51:31 +0000 (UTC)
From: jeffm@suse.com
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH v2 2/2] btrfs: Simplify math in should_alloc chunk
Date: Thu, 22 Jun 2017 09:51:48 -0400
Message-Id: <20170622135148.16730-2-jeffm@suse.com>
In-Reply-To: <20170622135148.16730-1-jeffm@suse.com>
References: <20170622135148.16730-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Nikolay Borisov <nborisov@suse.com>

Currently should_alloc_chunk uses ->total_bytes - ->bytes_readonly to
signify the total amount of bytes in this space info. However, given
Jeff's patch which adds bytes_pinned and bytes_may_use to the calculation
of num_allocated it becomes a lot more clear to just eliminate num_bytes
altogether and add the bytes_readonly to the amount of used space. That
way we don't change the results of the following statements. In the
process also start using btrfs_space_info_used.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/btrfs/extent-tree.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 88b04742beea..b8293062ac8e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4376,8 +4376,7 @@ static int should_alloc_chunk(struct btrfs_fs_info *fs_info,
 			      struct btrfs_space_info *sinfo, int force)
 {
 	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
-	u64 num_bytes = sinfo->total_bytes - sinfo->bytes_readonly;
-	u64 num_allocated = sinfo->bytes_used + sinfo->bytes_reserved + sinfo->bytes_pinned;
+	u64 bytes_used = btrfs_space_info_used(sinfo, false);
 	u64 thresh;
 
 	if (force == CHUNK_ALLOC_FORCE)
@@ -4389,7 +4388,7 @@ static int should_alloc_chunk(struct btrfs_fs_info *fs_info,
 	 * global_rsv, it doesn't change except when the transaction commits.
 	 */
 	if (sinfo->flags & BTRFS_BLOCK_GROUP_METADATA)
-		num_allocated += calc_global_rsv_need_space(global_rsv);
+		bytes_used += calc_global_rsv_need_space(global_rsv);
 
 	/*
 	 * in limited mode, we want to have some free space up to
@@ -4399,11 +4398,11 @@ static int should_alloc_chunk(struct btrfs_fs_info *fs_info,
 		thresh = btrfs_super_total_bytes(fs_info->super_copy);
 		thresh = max_t(u64, SZ_64M, div_factor_fine(thresh, 1));
 
-		if (num_bytes - num_allocated < thresh)
+		if (sinfo->total_bytes - bytes_used < thresh)
 			return 1;
 	}
 
-	if (num_allocated + SZ_2M < div_factor(num_bytes, 8))
+	if (bytes_used + SZ_2M < div_factor(sinfo->total_bytes, 8))
 		return 0;
 	return 1;
 }
-- 
2.11.0

