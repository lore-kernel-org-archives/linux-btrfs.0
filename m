Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36626 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387882AbeGWHrU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 03:47:20 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 620E6AEDF
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2018 06:47:38 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: extent-tree: Remove dead alignment check
Date: Mon, 23 Jul 2018 14:47:29 +0800
Message-Id: <20180723064729.9236-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In find_free_extent() under checks: tag, we have the following code

------
		search_start = ALIGN(offset, fs_info->stripesize);
		/* move on to the next group */
		if (search_start + num_bytes >
		    block_group->key.objectid + block_group->key.offset) {
			btrfs_add_free_space(block_group, offset, num_bytes);
			goto loop;
		}
		if (offset < search_start)
			btrfs_add_free_space(block_group, offset,
					     search_start - offset);
		BUG_ON(offset > search_start);
------

However ALIGN() is rounding up, thus @search_start >= @offset and that
BUG_ON() will never be triggered.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
  Fix my stupid error on judging whether ALIGN() is rounding up or down.
---
 fs/btrfs/extent-tree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f18e86177067..de4a85dfb98e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7754,7 +7754,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			goto loop;
 		}
 checks:
-		search_start = ALIGN(offset, fs_info->stripesize);
+		search_start = round_up(offset, fs_info->stripesize);
 
 		/* move on to the next group */
 		if (search_start + num_bytes >
@@ -7766,7 +7766,6 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 		if (offset < search_start)
 			btrfs_add_free_space(block_group, offset,
 					     search_start - offset);
-		BUG_ON(offset > search_start);
 
 		ret = btrfs_add_reserved_bytes(block_group, ram_bytes,
 				num_bytes, delalloc);
-- 
2.18.0

