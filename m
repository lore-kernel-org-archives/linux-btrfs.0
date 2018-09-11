Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:35494 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbeIKW67 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 18:58:59 -0400
Received: by mail-qt0-f195.google.com with SMTP id j7-v6so29233848qtp.2
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:58:33 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 12/36] btrfs: don't use global rsv for chunk allocation
Date: Tue, 11 Sep 2018 13:57:43 -0400
Message-Id: <20180911175807.26181-13-josef@toxicpanda.com>
In-Reply-To: <20180911175807.26181-1-josef@toxicpanda.com>
References: <20180911175807.26181-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've done this forever because of the voodoo around knowing how much
space we have.  However we have better ways of doing this now, and on
normal file systems we'll easily have a global reserve of 512MiB, and
since metadata chunks are usually 1GiB that means we'll allocate
metadata chunks more readily.  Instead use the actual used amount when
determining if we need to allocate a chunk or not.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/extent-tree.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 1cf66a92829b..cb065c0c0b9b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4374,21 +4374,12 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
 static int should_alloc_chunk(struct btrfs_fs_info *fs_info,
 			      struct btrfs_space_info *sinfo, int force)
 {
-	struct btrfs_block_rsv *global_rsv = &fs_info->global_block_rsv;
 	u64 bytes_used = btrfs_space_info_used(sinfo, false);
 	u64 thresh;
 
 	if (force == CHUNK_ALLOC_FORCE)
 		return 1;
 
-	/*
-	 * We need to take into account the global rsv because for all intents
-	 * and purposes it's used space.  Don't worry about locking the
-	 * global_rsv, it doesn't change except when the transaction commits.
-	 */
-	if (sinfo->flags & BTRFS_BLOCK_GROUP_METADATA)
-		bytes_used += calc_global_rsv_need_space(global_rsv);
-
 	/*
 	 * in limited mode, we want to have some free space up to
 	 * about 1% of the FS size.
-- 
2.14.3
