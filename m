Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18979 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754443AbdEQXXd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 19:23:33 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4HNNWrN014238
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v4HNNVtc028257
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:32 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4HNNVnt023877
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:31 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 8/8] Btrfs: hardcode GFP_NOFS for btrfs_bio_clone_partial
Date: Wed, 17 May 2017 16:22:52 -0600
Message-Id: <20170517222252.29242-9-bo.li.liu@oracle.com>
In-Reply-To: <20170517222252.29242-1-bo.li.liu@oracle.com>
References: <20170517222252.29242-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We only pass GFP_NOFS to btrfs_bio_clone_partial, so lets hardcode it.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 5 ++---
 fs/btrfs/extent_io.h | 3 +--
 fs/btrfs/inode.c     | 2 +-
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index eb5229e..f70d9f88 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2726,14 +2726,13 @@ struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	return bio;
 }
 
-struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask,
-				    int offset, int size)
+struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size)
 {
 	struct bio *bio;
 	struct btrfs_io_bio *btrfs_bio;
 
 	/* this will never fail when it's backed by a bioset */
-	bio = bio_clone_fast(orig, gfp_mask, btrfs_bioset);
+	bio = bio_clone_fast(orig, GFP_NOFS, btrfs_bioset);
 	ASSERT(bio);
 
 	btrfs_bio = btrfs_io_bio(bio);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index b2235b5..512918c 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -460,8 +460,7 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 		gfp_t gfp_flags);
 struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs);
 struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask);
-struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask,
-				    int offset, int size);
+struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size);
 
 struct btrfs_fs_info;
 struct btrfs_inode;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 042a13e..f8590c9 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8368,7 +8368,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
 		 * This will never fail as it's passing GPF_NOFS and
 		 * the allocation is backed by btrfs_bioset.
 		 */
-		bio = btrfs_bio_clone_partial(orig_bio, GFP_NOFS, clone_offset,
+		bio = btrfs_bio_clone_partial(orig_bio, clone_offset,
 					      clone_len);
 		bio->bi_private = dip;
 		bio->bi_end_io = btrfs_end_dio_bio;
-- 
2.9.4

