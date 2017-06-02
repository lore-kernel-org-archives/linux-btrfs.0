Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:37699 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751138AbdFBIVg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Jun 2017 04:21:36 -0400
Received: by mail-it0-f42.google.com with SMTP id m47so10042866iti.0
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Jun 2017 01:21:35 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Cc: kernel-team@fb.com, stable@vger.kernel.org
Subject: [PATCH] Btrfs: fix delalloc accounting leak caused by u32 overflow
Date: Fri,  2 Jun 2017 01:20:01 -0700
Message-Id: <4d268ba97ee6511e4a8c42d39c64316d20eed9d0.1496391402.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Omar Sandoval <osandov@fb.com>

btrfs_calc_trans_metadata_size() does an unsigned 32-bit multiplication,
which can overflow if num_items >= 4 GB / (nodesize * BTRFS_MAX_LEVEL * 2).
For a nodesize of 16kB, this overflow happens at 16k items. Usually,
num_items is a small constant passed to btrfs_start_transaction(), but
we also use btrfs_calc_trans_metadata_size() for metadata reservations
for extent items in btrfs_delalloc_{reserve,release}_metadata().

In drop_outstanding_extents(), num_items is calculated as
inode->reserved_extents - inode->outstanding_extents. The difference
between these two counters is usually small, but if many delalloc
extents are reserved and then the outstanding extents are merged in
btrfs_merge_extent_hook(), the difference can become large enough to
overflow in btrfs_calc_trans_metadata_size().

The overflow manifests itself as a leak of a multiple of 4 GB in
delalloc_block_rsv and the metadata bytes_may_use counter. This in turn
can cause early ENOSPC errors. Additionally, these WARN_ONs in
extent-tree.c will be hit when unmounting:

    WARN_ON(fs_info->delalloc_block_rsv.size > 0);
    WARN_ON(fs_info->delalloc_block_rsv.reserved > 0);
    WARN_ON(space_info->bytes_pinned > 0 ||
            space_info->bytes_reserved > 0 ||
            space_info->bytes_may_use > 0);

Fix it by casting nodesize to a u64 so that
btrfs_calc_trans_metadata_size() does a full 64-bit multiplication.
While we're here, do the same in btrfs_calc_trunc_metadata_size(); this
can't overflow with any existing uses, but it's better to be safe here
than have another hard-to-debug problem later on.

Cc: stable@vger.kernel.org
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/ctree.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 643c70d2b2e6..4f8f75d9e839 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2563,7 +2563,7 @@ u64 btrfs_csum_bytes_to_leaves(struct btrfs_fs_info *fs_info, u64 csum_bytes);
 static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info *fs_info,
 						 unsigned num_items)
 {
-	return fs_info->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
+	return (u64)fs_info->nodesize * BTRFS_MAX_LEVEL * 2 * num_items;
 }
 
 /*
@@ -2573,7 +2573,7 @@ static inline u64 btrfs_calc_trans_metadata_size(struct btrfs_fs_info *fs_info,
 static inline u64 btrfs_calc_trunc_metadata_size(struct btrfs_fs_info *fs_info,
 						 unsigned num_items)
 {
-	return fs_info->nodesize * BTRFS_MAX_LEVEL * num_items;
+	return (u64)fs_info->nodesize * BTRFS_MAX_LEVEL * num_items;
 }
 
 int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
-- 
2.13.0

