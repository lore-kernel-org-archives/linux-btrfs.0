Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387910AbeGWHWa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 03:22:30 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 80CA7AE50
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jul 2018 06:22:53 +0000 (UTC)
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: extent-tree: Remove dead alignment check
Date: Mon, 23 Jul 2018 14:22:46 +0800
Message-Id: <20180723062246.2885-1-wqu@suse.com>
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

However ALIGN() is rounding down, thus @search_start <= @offset.

That later (offset < search_start) check will never be true, but that
BUG_ON(offset > search_start) can be triggered as long as our @offset is
not aligned to @stripesize.

However we never has such report on this BUG_ON(), which means the
search result @offset is always aligned to @fs_info->stripesize (which
is also set to sector size at mkfs time), or it's handled by block group
range check.

Anyway, remove such dead unalignment check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f18e86177067..48a2aec7dc59 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7754,7 +7754,7 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			goto loop;
 		}
 checks:
-		search_start = ALIGN(offset, fs_info->stripesize);
+		search_start = round_down(offset, fs_info->stripesize);
 
 		/* move on to the next group */
 		if (search_start + num_bytes >
@@ -7763,11 +7763,6 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			goto loop;
 		}
 
-		if (offset < search_start)
-			btrfs_add_free_space(block_group, offset,
-					     search_start - offset);
-		BUG_ON(offset > search_start);
-
 		ret = btrfs_add_reserved_bytes(block_group, ram_bytes,
 				num_bytes, delalloc);
 		if (ret == -EAGAIN) {
-- 
2.18.0

