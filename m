Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35115 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdDJThs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 15:37:48 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v3AJblrS000335
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 19:37:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v3AJblda026251
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 19:37:47 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v3AJblIS031210
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 19:37:47 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: fix potential use-after-free for cloned bio
Date: Mon, 10 Apr 2017 12:36:26 -0700
Message-Id: <1491852986-7133-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

KASAN reports that there is a use-after-free case of bio in btrfs_map_bio.

If we need to submit IOs to several disks at a time, the original bio
would get cloned and mapped to the destination disk, but we really should
use the original bio instead of a cloned bio to do the sanity check
because cloned bios are likely to be freed by its endio.

Reported-by: Diego <diegocg@gmail.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 73d56ee..ab8a66d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6213,7 +6213,7 @@ int btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
 		dev = bbio->stripes[dev_nr].dev;
 		if (!dev || !dev->bdev ||
-		    (bio_op(bio) == REQ_OP_WRITE && !dev->writeable)) {
+		    (bio_op(first_bio) == REQ_OP_WRITE && !dev->writeable)) {
 			bbio_error(bbio, first_bio, logical);
 			continue;
 		}
-- 
2.5.5

