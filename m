Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43292 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFXHjb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 03:39:31 -0400
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s5O7dT14020465
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 07:39:30 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet22.oracle.com (8.14.5+Sun/8.14.5) with ESMTP id s5O7dSiD026791
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 07:39:29 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s5O7dS5e011149
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Jun 2014 07:39:28 GMT
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: fix crash when mounting raid5 btrfs with missing disks
Date: Tue, 24 Jun 2014 15:39:16 +0800
Message-Id: <1403595556-32753-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The reproducer is

$ mkfs.btrfs D1 D2 D3 -mraid5
$ mkfs.ext4 D2 && mkfs.ext4 D3
$ mount D1 /btrfs -odegraded

-------------------

[   87.672992] ------------[ cut here ]------------
[   87.673845] kernel BUG at fs/btrfs/raid56.c:1828!
...
[   87.673845] RIP: 0010:[<ffffffff813efc7e>]  [<ffffffff813efc7e>] __raid_recover_end_io+0x4ae/0x4d0
...
[   87.673845] Call Trace:
[   87.673845]  [<ffffffff8116bbc6>] ? mempool_free+0x36/0xa0
[   87.673845]  [<ffffffff813f0255>] raid_recover_end_io+0x75/0xa0
[   87.673845]  [<ffffffff81447c5b>] bio_endio+0x5b/0xa0
[   87.673845]  [<ffffffff81447cb2>] bio_endio_nodec+0x12/0x20
[   87.673845]  [<ffffffff81374621>] end_workqueue_fn+0x41/0x50
[   87.673845]  [<ffffffff813ad2aa>] normal_work_helper+0xca/0x2c0
[   87.673845]  [<ffffffff8108ba2b>] process_one_work+0x1eb/0x530
[   87.673845]  [<ffffffff8108b9c9>] ? process_one_work+0x189/0x530
[   87.673845]  [<ffffffff8108c15b>] worker_thread+0x11b/0x4f0
[   87.673845]  [<ffffffff8108c040>] ? rescuer_thread+0x290/0x290
[   87.673845]  [<ffffffff810939c4>] kthread+0xe4/0x100
[   87.673845]  [<ffffffff810938e0>] ? kthread_create_on_node+0x220/0x220
[   87.673845]  [<ffffffff817e7c7c>] ret_from_fork+0x7c/0xb0
[   87.673845]  [<ffffffff810938e0>] ? kthread_create_on_node+0x220/0x220

-------------------

It's because that we miscalculate @rbio->bbio->error so that it doesn't
reach maximum of tolerable errors while it should have.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 fs/btrfs/raid56.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 4055291..4a88f07 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1956,9 +1956,10 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 	 * pages are going to be uptodate.
 	 */
 	for (stripe = 0; stripe < bbio->num_stripes; stripe++) {
-		if (rbio->faila == stripe ||
-		    rbio->failb == stripe)
+		if (rbio->faila == stripe || rbio->failb == stripe) {
+			atomic_inc(&rbio->bbio->error);
 			continue;
+		}
 
 		for (pagenr = 0; pagenr < nr_pages; pagenr++) {
 			struct page *p;
-- 
1.8.1.4

