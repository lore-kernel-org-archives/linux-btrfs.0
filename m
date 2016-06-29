Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15278 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbcF2FOA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 01:14:00 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
	by cn.fujitsu.com (Postfix) with ESMTP id C9DD94056401
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 13:13:52 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: fix free space calculation in dump_space_info()
Date: Wed, 29 Jun 2016 13:12:16 +0800
Message-Id: <20160629051216.16876-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 8550a0e..520ba8f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7747,8 +7747,8 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
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



