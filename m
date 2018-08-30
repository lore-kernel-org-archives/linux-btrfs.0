Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33843 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH3VqH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:07 -0400
Received: by mail-qt0-f193.google.com with SMTP id m13-v6so11333170qth.1
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:52 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id k21-v6sm3963986qtj.11.2018.08.30.10.42.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:42:51 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 13/35] btrfs: reset max_extent_size properly
Date: Thu, 30 Aug 2018 13:42:03 -0400
Message-Id: <20180830174225.2200-14-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
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
index 22e1f9f55f4f..f4e7caf37d6c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4565,6 +4565,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans, u64 flags,
 			goto out;
 	} else {
 		ret = 1;
+		space_info->max_extent_size = 0;
 	}
 
 	space_info->force_alloc = CHUNK_ALLOC_NO_FORCE;
@@ -8064,11 +8065,17 @@ static int __btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info,
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
