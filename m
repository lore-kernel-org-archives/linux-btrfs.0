Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:34263 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731656AbeGSPd5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 11:33:57 -0400
Received: by mail-qk0-f196.google.com with SMTP id b66-v6so4410987qkj.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Jul 2018 07:50:26 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH 13/22] btrfs: reset max_extent_size properly
Date: Thu, 19 Jul 2018 10:49:57 -0400
Message-Id: <20180719145006.17532-13-josef@toxicpanda.com>
In-Reply-To: <20180719145006.17532-1-josef@toxicpanda.com>
References: <20180719145006.17532-1-josef@toxicpanda.com>
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
index c20675c265c5..e057d9b2d959 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4657,6 +4657,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
 			goto out;
 	} else {
 		ret = 1;
+		space_info->max_extent_size = 0;
 	}
 
 	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
@@ -8199,10 +8200,16 @@ static int __btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
 	if (pin)
 		pin_down_extent(fs_info, cache, start, len, 1);
 	else {
+		struct btrfs_space_info *space_info = cache->space_info;
+
 		if (btrfs_test_opt(fs_info, DISCARD))
 			ret = btrfs_discard_extent(fs_info, start, len, NULL);
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

