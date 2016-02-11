Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbcBKQ5K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Feb 2016 11:57:10 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 69C2AAB9D
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Feb 2016 16:57:09 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/9] btrfs: fallocate: use GFP_KERNEL
Date: Thu, 11 Feb 2016 17:57:09 +0100
Message-Id: <32fc932e30c4b6a03847426f52e23459c9fb906f.1455208920.git.dsterba@suse.com>
In-Reply-To: <cover.1455208920.git.dsterba@suse.com>
References: <cover.1455208920.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fallocate is initiated from userspace and is not on the critical
writeback path, we don't need to use GFP_NOFS for allocations.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 098bb8f690c9..5d46fdc4651c 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2611,7 +2611,7 @@ static int add_falloc_range(struct list_head *head, u64 start, u64 len)
 		return 0;
 	}
 insert:
-	range = kmalloc(sizeof(*range), GFP_NOFS);
+	range = kmalloc(sizeof(*range), GFP_KERNEL);
 	if (!range)
 		return -ENOMEM;
 	range->start = start;
@@ -2712,7 +2712,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 			btrfs_put_ordered_extent(ordered);
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree,
 					     alloc_start, locked_end,
-					     &cached_state, GFP_NOFS);
+					     &cached_state, GFP_KERNEL);
 			/*
 			 * we can't wait on the range with the transaction
 			 * running or with the extent lock held
@@ -2806,7 +2806,7 @@ static long btrfs_fallocate(struct file *file, int mode,
 	}
 out_unlock:
 	unlock_extent_cached(&BTRFS_I(inode)->io_tree, alloc_start, locked_end,
-			     &cached_state, GFP_NOFS);
+			     &cached_state, GFP_KERNEL);
 out:
 	/*
 	 * As we waited the extent range, the data_rsv_map must be empty
-- 
2.7.1

