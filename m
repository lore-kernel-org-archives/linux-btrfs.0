Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51790 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752064AbdIDGlT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 02:41:19 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/5] btrfs-progs: Fix one-byte overlap bug in free_block_group_cache
Date: Mon,  4 Sep 2017 15:41:06 +0900
Message-Id: <20170904064110.25951-2-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
References: <20170904064110.25951-1-quwenruo.btrfs@gmx.com>
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
index 46b8a05c..3039d254 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -3726,7 +3726,7 @@ static int free_block_group_cache(struct btrfs_trans_handle *trans,
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

