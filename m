Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541AbbKSKoF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 05:44:05 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 73BEBAD07
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Nov 2015 10:43:41 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 1/3] btrfs tests: replace whole ops structure for free space tests
Date: Thu, 19 Nov 2015 11:42:24 +0100
Message-Id: <4f200592ebbc69605bcc13c0f92b24f78b450acb.1447929577.git.dsterba@suse.com>
In-Reply-To: <cover.1447929577.git.dsterba@suse.com>
References: <cover.1447929577.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Preparatory work for making btrfs_free_space_op constant. In
test_steal_space_from_bitmap_to_extent, we substitute use_bitmap with
own version thus preventing constification. We can rework it so we
replace the whole structure with the correct function pointers.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/tests/free-space-tests.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index c8c3d70c31ff..915e290896ca 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -445,9 +445,11 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 	int ret;
 	u64 offset;
 	u64 max_extent_size;
-
-	bool (*use_bitmap_op)(struct btrfs_free_space_ctl *,
-			      struct btrfs_free_space *);
+	struct btrfs_free_space_op test_free_space_ops = {
+		.recalc_thresholds = cache->free_space_ctl->op->recalc_thresholds,
+		.use_bitmap = test_use_bitmap,
+	};
+	struct btrfs_free_space_op *orig_free_space_ops;
 
 	test_msg("Running space stealing from bitmap to extent\n");
 
@@ -469,8 +471,8 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 	 * that forces use of bitmaps as soon as we have at least 1
 	 * extent entry.
 	 */
-	use_bitmap_op = cache->free_space_ctl->op->use_bitmap;
-	cache->free_space_ctl->op->use_bitmap = test_use_bitmap;
+	orig_free_space_ops = cache->free_space_ctl->op;
+	cache->free_space_ctl->op = &test_free_space_ops;
 
 	/*
 	 * Extent entry covering free space range [128Mb - 256Kb, 128Mb - 128Kb[
@@ -877,7 +879,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group_cache *cache)
 	if (ret)
 		return ret;
 
-	cache->free_space_ctl->op->use_bitmap = use_bitmap_op;
+	cache->free_space_ctl->op = orig_free_space_ops;
 	__btrfs_remove_free_space_cache(cache->free_space_ctl);
 
 	return 0;
-- 
2.6.2

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
