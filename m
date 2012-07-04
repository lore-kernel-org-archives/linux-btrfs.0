Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2243 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2GDNzv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jul 2012 09:55:51 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q64DgqJo028817
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Jul 2012 21:42:53 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/4] Btrfs: add ro notification to dump_space_info
Date: Wed, 4 Jul 2012 21:52:57 +0800
Message-Id: <1341409978-22423-3-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1341409978-22423-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1341409978-22423-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Block group has ro attributes, make dump_space_info show it.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bbe79ab..f29859b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5847,12 +5847,13 @@ again:
 	list_for_each_entry(cache, &info->block_groups[index], list) {
 		spin_lock(&cache->lock);
 		printk(KERN_INFO "block group %llu has %llu bytes, %llu used "
-		       "%llu pinned %llu reserved\n",
+		       "%llu pinned %llu reserved %s\n",
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

