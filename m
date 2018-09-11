Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:44548 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbeIKW7C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:59:02 -0400
Received: by mail-qt0-f196.google.com with SMTP id k38-v6so29173610qtk.11
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:37 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 14/36] btrfs: reset max_extent_size properly
Date: Tue, 11 Sep 2018 13:57:45 -0400
Message-Id: <20180911175807.26181-15-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we use up our block group before allocating a new one we'll easily
get a max_extent_size that's set really really low, which will result in
a lot of fragmentation.  We need to make sure we're resetting the
max_extent_size when we add a new chunk or add new space.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 13441a293c73..44d59bee6e5e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4573,6 +4573,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 			goto out;
 	} else {
 		ret = 1;
+		space_info->max_extent_size = 0;
 	}
 
 	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
@@ -8084,11 +8085,17 @@ static int __btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
 	if (pin)
 		pin_down_extent(fs_info, cache, start, len, 1);
 	else {
+		struct btrfs_space_info *space_info = cache->space_info;
+
 		if (btrfs_test_opt(fs_info, DISCARD))
 			ret = btrfs_discard_extent(fs_info, start, len, NULL,
 					BTRFS_CLEAR_OP_DISCARD);
 		btrfs_add_free_space(cache, start, len);
 		btrfs_free_reserved_bytes(cache, len, delalloc);
+
+		spin_lock(&space_info->lock);
+		space_info->max_extent_size = 0;
+		spin_unlock(&space_info->lock);
 		trace_btrfs_reserved_extent_free(fs_info, start, len);
 	}
 
-- 
2.14.3
