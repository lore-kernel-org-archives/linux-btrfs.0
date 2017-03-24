Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63216 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932502AbdCXCAu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Mar 2017 22:00:50 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <bo.li.liu@oracle.com>
Subject: [PATCH v2 3/5] btrfs: scrub: Don't append on-disk pages for raid56 scrub
Date: Fri, 24 Mar 2017 10:00:25 +0800
Message-ID: <20170324020027.21228-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
References: <20170324020027.21228-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the following situation, scrub will calculate wrong parity to
overwrite correct one:

RAID5 full stripe:

Before
|     Dev 1      |     Dev  2     |     Dev 3     |
| Data stripe 1  | Data stripe 2  | Parity Stripe |
--------------------------------------------------- 0
| 0x0000 (Bad)   |     0xcdcd     |     0x0000    |
--------------------------------------------------- 4K
|     0xcdcd     |     0xcdcd     |     0x0000    |
...
|     0xcdcd     |     0xcdcd     |     0x0000    |
--------------------------------------------------- 64K

After scrubbing dev3 only:

|     Dev 1      |     Dev  2     |     Dev 3     |
| Data stripe 1  | Data stripe 2  | Parity Stripe |
--------------------------------------------------- 0
| 0xcdcd (Good)  |     0xcdcd     | 0xcdcd (Bad)  |
--------------------------------------------------- 4K
|     0xcdcd     |     0xcdcd     |     0x0000    |
...
|     0xcdcd     |     0xcdcd     |     0x0000    |
--------------------------------------------------- 64K

The reason is after raid56 read rebuild rbio->stripe_pages are all
correct recovered (0xcd for data stripes).

However when we check and repair parity, in
scrub_parity_check_and_repair(), we will appending pages in
sparity->spages list to rbio->bio_pages[], which contains old on-disk
data.

And when we submit parity data to disk, we calculate parity using
rbio->bio_pages[] first, if rbio->bio_pages[] not found, then fallback
to rbio->stripe_pages[].

The patch fix it by not appending pages from sparity->spages.
So finish_parity_scrub() will use rbio->stripe_pages[] which is correct.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6832feece7a7..2a5458004279 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2957,7 +2957,6 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 	struct bio *bio;
 	struct btrfs_raid_bio *rbio;
-	struct scrub_page *spage;
 	struct btrfs_bio *bbio = NULL;
 	u64 length;
 	int ret;
@@ -2987,9 +2986,6 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 	if (!rbio)
 		goto rbio_out;
 
-	list_for_each_entry(spage, &sparity->spages, list)
-		raid56_add_scrub_pages(rbio, spage->page, spage->logical);
-
 	scrub_pending_bio_inc(sctx);
 	raid56_parity_submit_scrub_rbio(rbio);
 	return;
-- 
2.12.1



