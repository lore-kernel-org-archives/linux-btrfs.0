Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:8134 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbbFLHHj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 03:07:39 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t5C763ql032686
	for <linux-btrfs@vger.kernel.org>; Fri, 12 Jun 2015 15:06:03 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs: [RFC] Don't use workqueue for raid56 parity scrub
Date: Fri, 12 Jun 2015 15:06:00 +0800
Message-ID: <e11384e9d3f8a3d87ca1f4c57ac699d15153c3a9.1434092619.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

The code in workqueue only do fast initialization and submit a bio
in end, plus, it will not called in interrupe context, no need to
queue a work for this type of work.

Call it directly will make code simple, easy to debug and reduce
potential problem.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/btrfs/raid56.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index fa72068..eea86d1 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2557,7 +2557,7 @@ static void raid56_parity_scrub_end_io(struct bio *bio, int err)
 	validate_rbio_for_parity_scrub(rbio);
 }
 
-static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
+static void async_scrub_parity(struct btrfs_raid_bio *rbio)
 {
 	int bios_to_read = 0;
 	struct bio_list bio_list;
@@ -2646,23 +2646,6 @@ finish:
 	validate_rbio_for_parity_scrub(rbio);
 }
 
-static void scrub_parity_work(struct btrfs_work *work)
-{
-	struct btrfs_raid_bio *rbio;
-
-	rbio = container_of(work, struct btrfs_raid_bio, work);
-	raid56_parity_scrub_stripe(rbio);
-}
-
-static void async_scrub_parity(struct btrfs_raid_bio *rbio)
-{
-	btrfs_init_work(&rbio->work, btrfs_rmw_helper,
-			scrub_parity_work, NULL, NULL);
-
-	btrfs_queue_work(rbio->fs_info->rmw_workers,
-			 &rbio->work);
-}
-
 void raid56_parity_submit_scrub_rbio(struct btrfs_raid_bio *rbio)
 {
 	if (!lock_stripe_add(rbio))
-- 
1.8.5.1

