Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59403 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750890AbdIKGgX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 02:36:23 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2 2/7] btrfs-progs: Fix one-byte overlap bug in free_block_group_cache
Date: Mon, 11 Sep 2017 15:36:07 +0900
Message-Id: <20170911063612.32114-3-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
References: <20170911063612.32114-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

free_block_group_cache() calls clear_extent_bits() with wrong end, which
is one byte larger than the correct range.

This will cause the next adjacent cache state be split.
And due to the split, private pointer (which points to block group
cache) will be reset to NULL.

This is very hard to detect as this function only gets called in
cleanup_temp_chunks() which is just before mkfs finishes.
This bug only get exposed when reworking --rootdir option.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extent-tree.c b/extent-tree.c
index eed56886..525a237e 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3724,7 +3724,7 @@ static int free_block_group_cache(struct btrfs_trans_handle *trans,
 		btrfs_remove_free_space_cache(cache);
 		kfree(cache->free_space_ctl);
 	}
-	clear_extent_bits(&fs_info->block_group_cache, bytenr, bytenr + len,
+	clear_extent_bits(&fs_info->block_group_cache, bytenr, bytenr + len - 1,
 			  (unsigned int)-1);
 	ret = free_space_info(fs_info, flags, len, 0, NULL);
 	if (ret < 0)
-- 
2.14.1

