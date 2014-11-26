Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33668 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751565AbaKZNDW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 08:03:22 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAQD31hA015516
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 21:03:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 08/11] Btrfs, replace: write raid56 parity into the replace target device
Date: Wed, 26 Nov 2014 21:04:48 +0800
Message-ID: <1417007091-11885-9-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>

This function reused the code of parity scrub, and we just write
the right parity or corrected parity into the target device before
the parity scrub end.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v3:
- None.
---
 fs/btrfs/raid56.c | 23 +++++++++++++++++++++++
 fs/btrfs/scrub.c  |  2 +-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 6f82c1b..cfa449f 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2311,7 +2311,9 @@ static void raid_write_parity_end_io(struct bio *bio, int err)
 static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 					 int need_check)
 {
+	struct btrfs_bio *bbio = rbio->bbio;
 	void *pointers[rbio->real_stripes];
+	DECLARE_BITMAP(pbitmap, rbio->stripe_npages);
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
@@ -2321,6 +2323,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 	struct page *q_page = NULL;
 	struct bio_list bio_list;
 	struct bio *bio;
+	int is_replace = 0;
 	int ret;
 
 	bio_list_init(&bio_list);
@@ -2334,6 +2337,11 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 		BUG();
 	}
 
+	if (bbio->num_tgtdevs && bbio->tgtdev_map[rbio->scrubp]) {
+		is_replace = 1;
+		bitmap_copy(pbitmap, rbio->dbitmap, rbio->stripe_npages);
+	}
+
 	/*
 	 * Because the higher layers(scrubber) are unlikely to
 	 * use this area of the disk again soon, so don't cache
@@ -2422,6 +2430,21 @@ writeback:
 			goto cleanup;
 	}
 
+	if (!is_replace)
+		goto submit_write;
+
+	for_each_set_bit(pagenr, pbitmap, rbio->stripe_npages) {
+		struct page *page;
+
+		page = rbio_stripe_page(rbio, rbio->scrubp, pagenr);
+		ret = rbio_add_io_page(rbio, &bio_list, page,
+				       bbio->tgtdev_map[rbio->scrubp],
+				       pagenr, rbio->stripe_len);
+		if (ret)
+			goto cleanup;
+	}
+
+submit_write:
 	nr_data = bio_list_size(&bio_list);
 	if (!nr_data) {
 		/* Every parity is right */
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 7f95afc..0ae837f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2714,7 +2714,7 @@ static void scrub_parity_check_and_repair(struct scrub_parity *sparity)
 		goto out;
 
 	length = sparity->logic_end - sparity->logic_start + 1;
-	ret = btrfs_map_sblock(sctx->dev_root->fs_info, REQ_GET_READ_MIRRORS,
+	ret = btrfs_map_sblock(sctx->dev_root->fs_info, WRITE,
 			       sparity->logic_start,
 			       &length, &bbio, 0, &raid_map);
 	if (ret || !bbio || !raid_map)
-- 
1.9.3

