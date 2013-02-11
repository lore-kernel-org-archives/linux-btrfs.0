Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab3BKMd6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 07:33:58 -0500
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] btrfs: accept zero for balance usage filter
Date: Mon, 11 Feb 2013 13:33:52 +0100
Message-Id: <1360586032-22973-1-git-send-email-dsterba@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The condition can be relaxed to accept also 0 which will delete
unoccupied chunks and does not need space for the actual data
relocation. Until there is an automatic empty chunk reclaim, we
can use this as a last resort option under enospc.

CC: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.cz>
---

Also needs progs update, but is not required for the kernel side.

 fs/btrfs/volumes.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5cbb7f4..fb871d0 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2623,7 +2623,10 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
 		user_thresh = div_factor_fine(cache->key.offset,
 					      bargs->usage);
 
-	if (chunk_used < user_thresh)
+	pr_debug("btrfs: chunk_used %llu, user_thresh %llu\n",
+			(unsigned long long)chunk_used,
+			(unsigned long long)user_thresh);
+	if (chunk_used <= user_thresh)
 		ret = 0;
 
 	btrfs_put_block_group(cache);
-- 
1.7.9

