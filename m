Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2103 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab2GFJVX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 05:21:23 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q669LDsF009989
	for <linux-btrfs@vger.kernel.org>; Fri, 6 Jul 2012 17:21:18 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4 v2] Btrfs: add ro notification to dump_space_info
Date: Fri, 6 Jul 2012 17:31:35 +0800
Message-Id: <1341567096-30304-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1341567096-30304-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1341567096-30304-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Block group has ro attributes, make dump_space_info show it.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
v1->v2: make printk more friendly to grep.

 fs/btrfs/extent-tree.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ae01bc8..f200e0c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5854,13 +5854,13 @@ static void dump_space_info(struct btrfs_space_info *info, u64 bytes,
 again:
 	list_for_each_entry(cache, &info->block_groups[index], list) {
 		spin_lock(&cache->lock);
-		printk(KERN_INFO "block group %llu has %llu bytes, %llu used "
-		       "%llu pinned %llu reserved\n",
+		printk(KERN_INFO "block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %s\n",
 		       (unsigned long long)cache->key.objectid,
 		       (unsigned long long)cache->key.offset,
 		       (unsigned long long)btrfs_block_group_used(&cache->item),
 		       (unsigned long long)cache->pinned,
-		       (unsigned long long)cache->reserved);
+		       (unsigned long long)cache->reserved,
+		       cache->ro ? "[readonly]" : "");
 		btrfs_dump_free_space(cache, bytes);
 		spin_unlock(&cache->lock);
 	}
-- 
1.6.5.2

