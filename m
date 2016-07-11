Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1285 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758660AbcGKLdb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 07:33:31 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
	by cn.fujitsu.com (Postfix) with ESMTP id 34FBD4091D0E
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Jul 2016 19:32:21 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix free space calculation in dump_space_info()
Date: Mon, 11 Jul 2016 19:30:04 +0800
Message-Id: <20160711113004.4896-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs, btrfs_space_info's bytes_may_use is treated as fs used
space, as what we do in reserve_metadata_bytes() or
btrfs_alloc_data_chunk_ondemand(), so in dump_space_info(), when
calculating free space, we should also minus btrfs_space_info's
bytes_may_use.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 81310ff..f1cc8b8 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7694,8 +7694,8 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 	printk(KERN_INFO "BTRFS: space_info %llu has %llu free, is %sfull\n",
 	       info->flags,
 	       info->total_bytes - info->bytes_used - info->bytes_pinned -
-	       info->bytes_reserved - info->bytes_readonly,
-	       (info->full) ? "" : "not ");
+	       info->bytes_reserved - info->bytes_readonly -
+	       info->bytes_may_use, (info->full) ? "" : "not ");
 	printk(KERN_INFO "BTRFS: space_info total=%llu, used=%llu, pinned=%llu, "
 	       "reserved=%llu, may_use=%llu, readonly=%llu\n",
 	       info->total_bytes, info->bytes_used, info->bytes_pinned,
-- 
2.9.0



