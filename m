Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34847 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751140AbdFBQ7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 12:59:37 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7B09BAAB9
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Jun 2017 16:59:36 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 3/8] btrfs: btrfs_bio_clone never fails, skip error handling
Date: Fri,  2 Jun 2017 18:58:36 +0200
Message-Id: <aa834758a79dc983410da678aac76d039b4cfdc2.1496422340.git.dsterba@suse.com>
In-Reply-To: <cover.1496422340.git.dsterba@suse.com>
References: <cover.1496422340.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update direct callers of btrfs_bio_clone that do error handling, that we
can now remove.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/inode.c   | 4 ----
 fs/btrfs/volumes.c | 1 -
 2 files changed, 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0a1ec5cd3b8f..c8ed81edd40e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8584,10 +8584,6 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
 	bio = btrfs_bio_clone(dio_bio, GFP_NOFS);
-	if (!bio) {
-		ret = -ENOMEM;
-		goto free_ordered;
-	}
 
 	dip = kzalloc(sizeof(*dip), GFP_NOFS);
 	if (!dip) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index e28c113785bb..864b203cc4aa 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6257,7 +6257,6 @@ int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 
 		if (dev_nr < total_devs - 1) {
 			bio = btrfs_bio_clone(first_bio, GFP_NOFS);
-			BUG_ON(!bio); /* -ENOMEM */
 		} else
 			bio = first_bio;
 
-- 
2.12.0

