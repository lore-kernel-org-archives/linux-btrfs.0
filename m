Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40839 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753807AbdDFDRx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Apr 2017 23:17:53 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v4 4/7] btrfs: REQ_PREFLUSH does not use btrfs_end_bio() completion callback
Date: Thu,  6 Apr 2017 11:22:50 +0800
Message-Id: <20170406032253.14631-5-anand.jain@oracle.com>
In-Reply-To: <20170406032253.14631-1-anand.jain@oracle.com>
References: <20170406032253.14631-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

REQ_PREFLUSH bio to flush dev cache uses btrfs_end_empty_barrier()
completion callback only, as of now, and there it accounts for dev
stat flush errors BTRFS_DEV_STAT_FLUSH_ERRS, so remove it from the
btrfs_end_bio().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2-3: no change
v4: no change, but now the patch number is 4/7 in the set.

 fs/btrfs/volumes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 73d56eef5e60..1563ae03079b 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6010,9 +6010,6 @@ static void btrfs_end_bio(struct bio *bio)
 				else
 					btrfs_dev_stat_inc(dev,
 						BTRFS_DEV_STAT_READ_ERRS);
-				if (bio->bi_opf & REQ_PREFLUSH)
-					btrfs_dev_stat_inc(dev,
-						BTRFS_DEV_STAT_FLUSH_ERRS);
 				btrfs_dev_stat_print_on_error(dev);
 			}
 		}
-- 
2.10.0

