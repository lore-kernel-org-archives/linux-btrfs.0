Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49930 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751429AbdKVBiU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 20:38:20 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAM1cJeA023601
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:20 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vAM1cJ29022916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:19 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAM1cJRp014774
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 01:38:19 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/7] Btrfs: keep a copy of bi_iter in btrfs_io_bio
Date: Tue, 21 Nov 2017 17:35:52 -0700
Message-Id: <20171122003558.28722-2-bo.li.liu@oracle.com>
In-Reply-To: <20171122003558.28722-1-bo.li.liu@oracle.com>
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before this, we only keep a copy of bi_iter for cloned bio so that we
can iterate bvec in endio with bio_for_each_segment(), and we iterate
normal bio with bio_for_each_segment_all().

However, in the following patches, I'd add retry on write errors where
I'd like to process both cloned bio and normal bio in the same way.

This keeps a copy of bi_iter in btrfs_io_bio before we submit bio so
that in endio we can iter the bio with bio_for_each_segment() only.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 2 --
 fs/btrfs/volumes.c   | 3 ++-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f64d05a..043b7df 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2689,7 +2689,6 @@ struct bio *btrfs_bio_clone(struct bio *bio)
 	new = bio_clone_fast(bio, GFP_NOFS, btrfs_bioset);
 	btrfs_bio = btrfs_io_bio(new);
 	btrfs_io_bio_init(btrfs_bio);
-	btrfs_bio->iter = bio->bi_iter;
 	return new;
 }
 
@@ -2716,7 +2715,6 @@ struct bio *btrfs_bio_clone_partial(struct bio *orig, int offset, int size)
 	btrfs_io_bio_init(btrfs_bio);
 
 	bio_trim(bio, offset >> 9, size >> 9);
-	btrfs_bio->iter = bio->bi_iter;
 	return bio;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c70fd0f..4835136 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6113,9 +6113,10 @@ static void submit_stripe_bio(struct btrfs_bio *bbio, struct bio *bio,
 	struct btrfs_fs_info *fs_info = bbio->fs_info;
 
 	bio->bi_private = bbio;
-	btrfs_io_bio(bio)->stripe_index = dev_nr;
 	bio->bi_end_io = btrfs_end_bio;
 	bio->bi_iter.bi_sector = physical >> 9;
+	btrfs_io_bio(bio)->stripe_index = dev_nr;
+	btrfs_io_bio(bio)->iter = bio->bi_iter;
 #ifdef DEBUG
 	{
 		struct rcu_string *name;
-- 
2.9.4

