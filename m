Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19888 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752028AbbBXPik (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Feb 2015 10:38:40 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t1OFbmMt007327
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Feb 2015 23:37:48 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 3/3] btrfs: Remove BUG_ON() when failed searching block_group_cache in unpin_extent_range()
Date: Tue, 24 Feb 2015 23:37:29 +0800
Message-ID: <1424792249-26672-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Above BUG_ON() was triggered only one time in my test, but hadn't
happened again in same env.

The reason maybe:
A block group which include pinned space was removed before
unpin_extent_range(), and no other block_group_cache after
"start" pos, so the code entered into above BUG_ON().

To support auto-remove-bgs, we can remove above BUG_ON(), and bypass
removed bgs.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8b51eb5..ef0b40d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5751,7 +5751,8 @@ static int unpin_extent_range(struct btrfs_root *root, u64 start, u64 end,
 			if (cache)
 				btrfs_put_block_group(cache);
 			cache = btrfs_lookup_block_group(fs_info, start);
-			BUG_ON(!cache); /* Logic error */
+			if (!cache)
+				break;
 		}
 
 		len = cache->key.objectid + cache->key.offset - start;
-- 
1.8.5.1

