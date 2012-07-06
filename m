Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:2103 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab2GFJV0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jul 2012 05:21:26 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id q669LHAr009994
	for <linux-btrfs@vger.kernel.org>; Fri, 6 Jul 2012 17:21:18 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/4 v2] Btrfs: do not count in readonly bytes
Date: Fri, 6 Jul 2012 17:31:36 +0800
Message-Id: <1341567096-30304-4-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1341567096-30304-1-git-send-email-liubo2009@cn.fujitsu.com>
References: <1341567096-30304-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a block group is ro, do not count its entries in when we dump space info.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/free-space-cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index a70c54e..2d5b42e 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1967,7 +1967,7 @@ void btrfs_dump_free_space(struct btrfs_block_group_cache *block_group,
 
 	for (n = rb_first(&ctl->free_space_offset); n; n = rb_next(n)) {
 		info = rb_entry(n, struct btrfs_free_space, offset_index);
-		if (info->bytes >= bytes)
+		if (info->bytes >= bytes && !block_group->ro)
 			count++;
 		printk(KERN_CRIT "entry offset %llu, bytes %llu, bitmap %s\n",
 		       (unsigned long long)info->offset,
-- 
1.6.5.2

