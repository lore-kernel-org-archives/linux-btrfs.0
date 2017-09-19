Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35177 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdITAwA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 20:52:00 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v8K0pxL4015305
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 00:52:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v8K0pxKZ025555
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 00:51:59 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v8K0px4q007806
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 00:51:59 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use btrfs_op instead of bio_op in __btrfs_map_block
Date: Tue, 19 Sep 2017 17:50:09 -0600
Message-Id: <20170919235009.30720-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This seems to be a leftover of commit cf8cddd38bab ("btrfs: don't
abuse REQ_OP_* flags for btrfs_map_block").

It should use btrfs_op() helper to provide one of 'enum btrfs_map_op'
types.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bd679bc..bd7b75d3 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6229,7 +6229,7 @@ blk_status_t btrfs_map_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 	map_length = length;
 
 	btrfs_bio_counter_inc_blocked(fs_info);
-	ret = __btrfs_map_block(fs_info, bio_op(bio), logical,
+	ret = __btrfs_map_block(fs_info, btrfs_op(bio), logical,
 				&map_length, &bbio, mirror_num, 1);
 	if (ret) {
 		btrfs_bio_counter_dec(fs_info);
-- 
2.9.4

