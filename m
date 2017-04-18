Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37183 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754585AbdDRBRx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Apr 2017 21:17:53 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v3I1HqLt027540
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v3I1HqUV026000
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:52 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v3I1HqKK021776
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Apr 2017 01:17:52 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/6] Btrfs: use bio_clone_fast to clone our bio
Date: Mon, 17 Apr 2017 18:16:22 -0700
Message-Id: <1492478187-24875-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For raid1 and raid10, we clone the original bio to the bios which are then
sent to different disks.

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
2.5.5

