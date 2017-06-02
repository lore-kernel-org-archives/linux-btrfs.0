Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34857 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751140AbdFBQ7s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Jun 2017 12:59:48 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 41CD4ABB1
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Jun 2017 16:59:42 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 5/8] btrfs: sink gfp parameter to btrfs_bio_clone
Date: Fri,  2 Jun 2017 18:58:41 +0200
Message-Id: <383a5b09762c5ff16c9a68521184009fa95a87fc.1496422340.git.dsterba@suse.com>
In-Reply-To: <cover.1496422340.git.dsterba@suse.com>
References: <cover.1496422340.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All callers pass GFP_NOFS.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/extent_io.c | 4 ++--
 fs/btrfs/extent_io.h | 2 +-
 fs/btrfs/inode.c     | 2 +-
 fs/btrfs/volumes.c   | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a10906915bc9..a8f135286fa5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2675,13 +2675,13 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 	return bio;
 }
 
-struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask)
+struct bio *btrfs_bio_clone(struct bio *bio)
 {
 	struct btrfs_io_bio *btrfs_bio;
 	struct bio *new;
 
 	/* Bio allocation backed by a bioset does not fail */
-	new = bio_clone_fast(bio, gfp_mask, btrfs_bioset);
+	new = bio_clone_fast(bio, GFP_NOFS, btrfs_bioset);
 	btrfs_bio = btrfs_io_bio(new);
 	btrfs_bio->csum = NULL;
 	btrfs_bio->csum_allocated = NULL;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index e3512c5d8770..4fe643a5aeaf 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -466,7 +466,7 @@ struct bio *
 btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 		gfp_t gfp_flags);
 struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs);
-struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask);
+struct bio *btrfs_bio_clone(struct bio *bio);
 struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size);
 
 struct btrfs_fs_info;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index c8ed81edd40e..5112f2c45600 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8583,7 +8583,7 @@ static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
-	bio = btrfs_bio_clone(dio_bio, GFP_NOFS);
+	bio = btrfs_bio_clone(dio_bio);
 
 	dip = kzalloc(sizeof(*dip), GFP_NOFS);
 	if (!dip) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 864b203cc4aa..70bcebef7aa6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6256,7 +6256,7 @@ int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 		}
 
 		if (dev_nr < total_devs - 1) {
-			bio = btrfs_bio_clone(first_bio, GFP_NOFS);
+			bio = btrfs_bio_clone(first_bio);
 		} else
 			bio = first_bio;
 
-- 
2.12.0

