Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:39486 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeH3VqE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 30 Aug 2018 17:46:04 -0400
Received: by mail-qt0-f194.google.com with SMTP id o15-v6so11286379qtk.6
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Aug 2018 10:42:49 -0700 (PDT)
Received: from localhost ([107.15.81.208])
        by smtp.gmail.com with ESMTPSA id f23-v6sm4870934qtc.65.2018.08.30.10.42.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Aug 2018 10:42:47 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 11/35] btrfs: don't use global rsv for chunk allocation
Date: Thu, 30 Aug 2018 13:42:01 -0400
Message-Id: <20180830174225.2200-12-josef@toxicpanda.com>
In-Reply-To: <20180830174225.2200-1-josef@toxicpanda.com>
References: <20180830174225.2200-1-josef@toxicpanda.com>
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
index df826f713034..783341e3653e 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4366,21 +4366,12 @@ static inline u64 calc_global_rsv_need_space(struct btrfs_block_rsv *global)
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
