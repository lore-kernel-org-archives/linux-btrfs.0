Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39929 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdEQXXb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 19:23:31 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4HNNUO3013271
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v4HNNUcx023881
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:30 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v4HNNUV1031796
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:30 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/8] Btrfs: new helper btrfs_bio_clone_partial
Date: Wed, 17 May 2017 16:22:46 -0600
Message-Id: <20170517222252.29242-3-bo.li.liu@oracle.com>
In-Reply-To: <20170517222252.29242-1-bo.li.liu@oracle.com>
References: <20170517222252.29242-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This adds a new helper btrfs_bio_clone_partial, it'll allocate a cloned
bio that only owns a part of the original bio's data.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 18 ++++++++++++++++++
 fs/btrfs/extent_io.h |  2 ++
 2 files changed, 20 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0d4aea4..47c0ee2 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2726,6 +2726,24 @@ struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	return bio;
 }
 
+struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask,
+				    int offset, int size)
+{
+	struct bio *bio;
+	struct btrfs_io_bio *btrfs_bio;
+
+	/* this will never fail when it's backed by a bioset */
+	bio = bio_clone_fast(orig, gfp_mask, btrfs_bioset);
+	ASSERT(bio);
+
+	btrfs_bio = btrfs_io_bio(bio);
+	btrfs_bio->csum = NULL;
+	btrfs_bio->csum_allocated = NULL;
+	btrfs_bio->end_io = NULL;
+
+	bio_trim(bio, offset >> 9, size >> 9);
+	return bio;
+}
 
 static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 				       unsigned long bio_flags)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 3e4fad4..b2235b5 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -460,6 +460,8 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
 		gfp_t gfp_flags);
 struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs);
 struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask);
+struct bio *btrfs_bio_clone_partial(struct bio *orig, gfp_t gfp_mask,
+				    int offset, int size);
 
 struct btrfs_fs_info;
 struct btrfs_inode;
-- 
2.9.4

