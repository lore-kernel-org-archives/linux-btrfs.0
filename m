Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34646 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab3FCTPT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 15:15:19 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E9FEA9A0365
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Jun 2013 13:15:18 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id YpwWoDhqzxMqJJFM (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 03 Jun 2013 13:15:18 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix the allocator
Date: Mon, 3 Jun 2013 15:15:15 -0400
Message-ID: <1370286915-3301-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The allocator looks for these hints when moving on to another block group which
will make it reset which block group it looks at, when we've already searched
that block group and didn't find any space to allocate, we need to fix this by
just letting the allocator make the determination if the block group is good
enough.  This also fixes a problem where if we couldn't find space in the block
group we were given we'd just error out instead of moving on to the next block
group.  Previously I couldn't fix some file systems that were relatively full,
but with this patch I can now run fsck on them with no allocation errors.
Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 extent-tree.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/extent-tree.c b/extent-tree.c
index 91bc513..566cdb4 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -246,24 +246,22 @@ static int noinline find_search_start(struct btrfs_root *root,
 {
 	int ret;
 	struct btrfs_block_group_cache *cache = *cache_ret;
-	u64 last;
+	u64 last = *start_ret;
 	u64 start = 0;
 	u64 end = 0;
 	u64 search_start = *start_ret;
 	int wrapped = 0;
 
-	if (!cache) {
+	if (!cache)
 		goto out;
-	}
 again:
 	ret = cache_block_group(root, cache);
 	if (ret)
 		goto out;
 
 	last = max(search_start, cache->key.objectid);
-	if (cache->ro || !block_group_bits(cache, data)) {
+	if (cache->ro || !block_group_bits(cache, data))
 		goto new_group;
-	}
 
 	while(1) {
 		ret = find_first_extent_bit(&root->fs_info->free_space_cache,
@@ -284,6 +282,7 @@ again:
 		return 0;
 	}
 out:
+	*start_ret = last;
 	cache = btrfs_lookup_block_group(root->fs_info, search_start);
 	if (!cache) {
 		printk("Unable to find block group for %llu\n",
@@ -297,7 +296,6 @@ new_group:
 wrapped:
 	cache = btrfs_lookup_first_block_group(root->fs_info, last);
 	if (!cache) {
-no_cache:
 		if (!wrapped) {
 			wrapped = 1;
 			last = search_start;
@@ -305,11 +303,6 @@ no_cache:
 		}
 		goto out;
 	}
-	cache = btrfs_find_block_group(root, cache, last, data, 0);
-	cache = btrfs_find_block_group(root, cache, last, data, 0);
-	if (!cache)
-		goto no_cache;
-
 	*cache_ret = cache;
 	goto again;
 }
@@ -2602,7 +2595,7 @@ check_failed:
 	ret = find_search_start(root, &block_group, &search_start,
 				total_needed, data);
 	if (ret)
-		goto error;
+		goto new_group;
 
 	ins->objectid = search_start;
 	ins->offset = num_bytes;
-- 
1.7.7.6

