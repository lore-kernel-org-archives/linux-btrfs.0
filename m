Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbcBKQ5A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 11:57:00 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 96946AB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:56:59 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 2/9] btrfs: reada: use GFP_KERNEL everywhere
Date: Thu, 11 Feb 2016 17:56:59 +0100
Message-Id: <ed0244faf59e33ff915b83acd15c903b81fd357b.1455208920.git.dsterba@suse.com>
In-Reply-To: <cover.1455208920.git.dsterba@suse.com>
References: <cover.1455208920.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The readahead framework is not on the critical writeback path we don't
need to use GFP_NOFS for allocations. All error paths are handled and
the readahead failures are not fatal. The actual users (scrub,
dev-replace) will trigger reads if the blocks are not found in cache.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/reada.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
index 619f92963e27..c5f1773c4794 100644
--- a/fs/btrfs/reada.c
+++ b/fs/btrfs/reada.c
@@ -280,7 +280,7 @@ static struct reada_zone *reada_find_zone(struct btrfs_fs_info *fs_info,
 	end = start + cache->key.offset - 1;
 	btrfs_put_block_group(cache);
 
-	zone = kzalloc(sizeof(*zone), GFP_NOFS);
+	zone = kzalloc(sizeof(*zone), GFP_KERNEL);
 	if (!zone)
 		return NULL;
 
@@ -343,7 +343,7 @@ static struct reada_extent *reada_find_extent(struct btrfs_root *root,
 	if (re)
 		return re;
 
-	re = kzalloc(sizeof(*re), GFP_NOFS);
+	re = kzalloc(sizeof(*re), GFP_KERNEL);
 	if (!re)
 		return NULL;
 
@@ -566,7 +566,7 @@ static int reada_add_block(struct reada_control *rc, u64 logical,
 	if (!re)
 		return -1;
 
-	rec = kzalloc(sizeof(*rec), GFP_NOFS);
+	rec = kzalloc(sizeof(*rec), GFP_KERNEL);
 	if (!rec) {
 		reada_extent_put(root->fs_info, re);
 		return -ENOMEM;
@@ -791,7 +791,7 @@ static void reada_start_machine(struct btrfs_fs_info *fs_info)
 {
 	struct reada_machine_work *rmw;
 
-	rmw = kzalloc(sizeof(*rmw), GFP_NOFS);
+	rmw = kzalloc(sizeof(*rmw), GFP_KERNEL);
 	if (!rmw) {
 		/* FIXME we cannot handle this properly right now */
 		BUG();
@@ -926,7 +926,7 @@ struct reada_control *btrfs_reada_add(struct btrfs_root *root,
 		.offset = (u64)-1
 	};
 
-	rc = kzalloc(sizeof(*rc), GFP_NOFS);
+	rc = kzalloc(sizeof(*rc), GFP_KERNEL);
 	if (!rc)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.7.1

