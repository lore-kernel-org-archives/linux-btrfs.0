Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39942 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754329AbdEQXXd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 19:23:33 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4HNNWi7013284
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:32 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v4HNNWEI023958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:32 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v4HNNTQ7005998
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 23:23:31 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/8] Btrfs: use bio_clone_fast to clone our bio
Date: Wed, 17 May 2017 16:22:45 -0600
Message-Id: <20170517222252.29242-2-bo.li.liu@oracle.com>
In-Reply-To: <20170517222252.29242-1-bo.li.liu@oracle.com>
References: <20170517222252.29242-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For raid1 and raid10, we clone the original bio to the bios which are then
sent to different disks.

Right now we use bio_clone_bioset to create a clone bio with iterating
bi_io_vec to initialize it.  This changes it to use bio_clone_fast()
which creates a clone bio but only copies the bi_io_vec pointer
instead of iterating bi_io_vec.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 27fdb25..0d4aea4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2700,7 +2700,7 @@ struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask)
 	struct btrfs_io_bio *btrfs_bio;
 	struct bio *new;
 
-	new = bio_clone_bioset(bio, gfp_mask, btrfs_bioset);
+	new = bio_clone_fast(bio, gfp_mask, btrfs_bioset);
 	if (new) {
 		btrfs_bio = btrfs_io_bio(new);
 		btrfs_bio->csum = NULL;
-- 
2.9.4

