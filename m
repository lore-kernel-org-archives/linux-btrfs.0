Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34835 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932462AbeCMKWg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Mar 2018 06:22:36 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F23F3ABB4
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Mar 2018 10:22:34 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH] btrfs: Document parameters of btrfs_reserve_extent
Date: Tue, 13 Mar 2018 12:22:32 +0200
Message-Id: <1520936552-11586-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function is the entry to the extent allocator and as such has
quite a number of parameters. Some of those have subtle effects on the
allocation algorithm. Document the parameters.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index bb1861033071..60ece25101ee 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7961,6 +7961,51 @@ static void dump_space_info(struct btrfs_fs_info *fs_info,
 	up_read(&info->groups_sem);
 }
 
+/*
+ * btrfs_reserve_extent - entry point to the extent allocator. Tries to find a
+ *			  hole that is at least as big as @num_bytes.
+ *
+ * @root           -	The root that will contains this extent
+ *
+ * @ram_bytes      -	The amount of space in ram that @num_bytes take. This
+ *			is used for accounting purposes. This value differs
+ *			than @num_bytes only in the case of compressed extents.
+ *
+ * @num_bytes      -	Number of bytes to allocates on-disk.
+ *
+ * @min_alloc_size -	Indicates the minimum amount of memory that the
+ *			allocator should try to satisfy. In some cases
+ *			@num_bytes may be larger than what is required and if
+ *			the filesystem is fragmented then allocation fails.
+ *			However, the presence of @min_alloc_size gives a
+ *			chance to try and satisfy the smaller allocation.
+ *
+ * @empty_size     -	A hint that you plan on doing more cow. This is the
+ *			size in bytes the allocator should try to find free
+ *			next to the block it returns.  This is just a hint and
+ *			may be ignored by the allocator.
+ *
+ * @hint_byte      -	Hint to the allocator to start searching above the byte
+ *			address passed. It might be ignored.
+ *
+ * @ins            -	This key is modified to record the found hole. It will
+ *			have the following values:
+ *			ins->objectid == start position
+ *			ins->flags = BTRFS_EXTENT_ITEM_KEY
+ *			ins->offset == the size of the hole.
+ *
+ * @is_data        -	Boolean flag indicating whether an extent is
+ *			allocated for data (true) or metadata (false)
+ *
+ * @delalloc       -	Boolean flag indicating whether this allocation is for
+ *			delalloc or not. If 'true' data_rwsem of block groups
+ *			is going to be acquired.
+ *
+ *
+ * Returns 0 when an allocation succeeded or < 0 when an error occurred. In
+ * case -ENOSPC is returned then @ins->offset will contain the size of the
+ * largest available hole the allocator managed to find.
+ */
 int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 			 u64 num_bytes, u64 min_alloc_size,
 			 u64 empty_size, u64 hint_byte,
-- 
2.7.4

