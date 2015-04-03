Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26665 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751688AbbDCMNo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 08:13:44 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t33CCaKh020610
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 20:12:36 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 4/9] btrfs: Set relative data on clear btrfs_block_group_cache->pinned
Date: Fri, 3 Apr 2015 20:11:59 +0800
Message-ID: <3978a02f2c3cd102c4ed8115e0c69ddcc98f9ed4.1428062473.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1428062473.git.zhaolei@cn.fujitsu.com>
References: <cover.1428062473.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Bug1:
  space_info->bytes_readonly was set to very large(negative) value in
  btrfs_remove_block_group().

Reason:
  Current code set block_group_cache->pinned = 0 in btrfs_delete_unused_bgs(),
  but above space was not counted to space_info->bytes_readonly.

  Then in btrfs_remove_block_group():
    block_group->space_info->bytes_readonly -= block_group->key.offset;
  We can see following value in trace:
    btrfs_remove_block_group: pid=2677 comm=btrfs-cleaner WARNING: bytes_readonly=12582912, key.offset=134217728

Bug2:
  space_info->total_bytes_pinned grow to value larger than fs size.
  In a 1.2G fs, we can get following trace log:
  at first:
    ZL_DEBUG: add_pinned_bytes: pid=2710 comm=sync change total_bytes_pinned flags=1 869793792 + 95944704 = 965738496
  after some op:
    ZL_DEBUG: add_pinned_bytes: pid=2770 comm=sync change total_bytes_pinned flags=1 1780178944 + 95944704 = 1876123648
  after some op:
    ZL_DEBUG: add_pinned_bytes: pid=3193 comm=sync change total_bytes_pinned flags=1 2924568576 + 95551488 = 3020120064
  ...

Reason:
  Similar to bug1, we also need to adjust space_info->total_bytes_pinned
  in above code block.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 644468b..e04ea1f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -9654,8 +9654,18 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		mutex_unlock(&fs_info->unused_bg_unpin_mutex);
 
 		/* Reset pinned so btrfs_put_block_group doesn't complain */
+		spin_lock(&space_info->lock);
+		spin_lock(&block_group->lock);
+
+		space_info->bytes_pinned -= block_group->pinned;
+		space_info->bytes_readonly += block_group->pinned;
+		percpu_counter_add(&space_info->total_bytes_pinned,
+				   -block_group->pinned);
 		block_group->pinned = 0;
 
+		spin_unlock(&block_group->lock);
+		spin_unlock(&space_info->lock);
+
 		/*
 		 * Btrfs_remove_chunk will abort the transaction if things go
 		 * horribly wrong.
-- 
1.8.5.1

