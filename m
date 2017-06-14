Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41105 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754320AbdFNIfn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Jun 2017 04:35:43 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3ECD5AC8C
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Jun 2017 08:35:42 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Use btrfs_space_info_used instead of opencoding it
Date: Wed, 14 Jun 2017 11:35:34 +0300
Message-Id: <1497429334-18467-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 4c0d3980fe3f..a08a743a8e09 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4935,9 +4935,8 @@ btrfs_calc_reclaim_metadata_size(struct btrfs_root *root,
 			   BTRFS_RESERVE_FLUSH_ALL))
 		return 0;
 
-	used = space_info->bytes_used + space_info->bytes_reserved +
-	       space_info->bytes_pinned + space_info->bytes_readonly +
-	       space_info->bytes_may_use;
+	used = btrfs_space_info_used(space_info, true);
+
 	if (can_overcommit(root, space_info, SZ_1M, BTRFS_RESERVE_FLUSH_ALL))
 		expected = div_factor_fine(space_info->total_bytes, 95);
 	else
@@ -5378,9 +5377,7 @@ static void space_info_add_old_bytes(struct btrfs_fs_info *fs_info,
 	 * overcommit, and if we can't then we just need to free up our space
 	 * and not satisfy any requests.
 	 */
-	used = space_info->bytes_used + space_info->bytes_reserved +
-		space_info->bytes_pinned + space_info->bytes_readonly +
-		space_info->bytes_may_use;
+	used = btrfs_space_info_used(space_info, true);
 	if (used - num_bytes >= space_info->total_bytes)
 		check_overcommit = true;
 again:
-- 
2.7.4

