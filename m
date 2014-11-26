Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17394 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751688AbaKZNDU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 08:03:20 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAQD2x06015507
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 21:02:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v3 05/11] Btrfs, raid56: use a variant to record the operation type
Date: Wed, 26 Nov 2014 21:04:45 +0800
Message-ID: <1417007091-11885-6-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1417007091-11885-1-git-send-email-miaox@cn.fujitsu.com>

We will introduce new operation type later, if we still use integer
variant as bool variant to record the operation type, we would add new
variant and increase the size of raid bio structure. It is not good,
by this patch, we define different number for different operation,
and we can just use a variant to record the operation type.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v3:
- None.
---
 fs/btrfs/raid56.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 6013d88..bfc406d 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -62,6 +62,11 @@
 
 #define RBIO_CACHE_SIZE 1024
 
+enum btrfs_rbio_ops {
+	BTRFS_RBIO_WRITE	= 0,
+	BTRFS_RBIO_READ_REBUILD	= 1,
+};
+
 struct btrfs_raid_bio {
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_bio *bbio;
@@ -124,7 +129,7 @@ struct btrfs_raid_bio {
 	 * differently from a parity rebuild as part of
 	 * rmw
 	 */
-	int read_rebuild;
+	enum btrfs_rbio_ops operation;
 
 	/* first bad stripe */
 	int faila;
@@ -147,7 +152,6 @@ struct btrfs_raid_bio {
 
 	atomic_t refs;
 
-
 	atomic_t stripes_pending;
 
 	atomic_t error;
@@ -583,8 +587,7 @@ static int rbio_can_merge(struct btrfs_raid_bio *last,
 		return 0;
 
 	/* reads can't merge with writes */
-	if (last->read_rebuild !=
-	    cur->read_rebuild) {
+	if (last->operation != cur->operation) {
 		return 0;
 	}
 
@@ -777,9 +780,9 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 			spin_unlock(&rbio->bio_list_lock);
 			spin_unlock_irqrestore(&h->lock, flags);
 
-			if (next->read_rebuild)
+			if (next->operation == BTRFS_RBIO_READ_REBUILD)
 				async_read_rebuild(next);
-			else {
+			else if (next->operation == BTRFS_RBIO_WRITE){
 				steal_rbio(rbio, next);
 				async_rmw_stripe(next);
 			}
@@ -1713,6 +1716,7 @@ int raid56_parity_write(struct btrfs_root *root, struct bio *bio,
 	}
 	bio_list_add(&rbio->bio_list, bio);
 	rbio->bio_list_bytes = bio->bi_iter.bi_size;
+	rbio->operation = BTRFS_RBIO_WRITE;
 
 	/*
 	 * don't plug on full rbios, just get them out the door
@@ -1761,7 +1765,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 	faila = rbio->faila;
 	failb = rbio->failb;
 
-	if (rbio->read_rebuild) {
+	if (rbio->operation == BTRFS_RBIO_READ_REBUILD) {
 		spin_lock_irq(&rbio->bio_list_lock);
 		set_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
 		spin_unlock_irq(&rbio->bio_list_lock);
@@ -1778,7 +1782,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 			 * if we're rebuilding a read, we have to use
 			 * pages from the bio list
 			 */
-			if (rbio->read_rebuild &&
+			if (rbio->operation == BTRFS_RBIO_READ_REBUILD &&
 			    (stripe == faila || stripe == failb)) {
 				page = page_in_rbio(rbio, stripe, pagenr, 0);
 			} else {
@@ -1871,7 +1875,7 @@ pstripe:
 		 * know they can be trusted.  If this was a read reconstruction,
 		 * other endio functions will fiddle the uptodate bits
 		 */
-		if (!rbio->read_rebuild) {
+		if (rbio->operation == BTRFS_RBIO_WRITE) {
 			for (i = 0;  i < nr_pages; i++) {
 				if (faila != -1) {
 					page = rbio_stripe_page(rbio, faila, i);
@@ -1888,7 +1892,7 @@ pstripe:
 			 * if we're rebuilding a read, we have to use
 			 * pages from the bio list
 			 */
-			if (rbio->read_rebuild &&
+			if (rbio->operation == BTRFS_RBIO_READ_REBUILD &&
 			    (stripe == faila || stripe == failb)) {
 				page = page_in_rbio(rbio, stripe, pagenr, 0);
 			} else {
@@ -1904,7 +1908,7 @@ cleanup:
 
 cleanup_io:
 
-	if (rbio->read_rebuild) {
+	if (rbio->operation == BTRFS_RBIO_READ_REBUILD) {
 		if (err == 0)
 			cache_rbio_pages(rbio);
 		else
@@ -2042,7 +2046,7 @@ out:
 	return 0;
 
 cleanup:
-	if (rbio->read_rebuild)
+	if (rbio->operation == BTRFS_RBIO_READ_REBUILD)
 		rbio_orig_end_io(rbio, -EIO, 0);
 	return -EIO;
 }
@@ -2068,7 +2072,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 
 	if (hold_bbio)
 		set_bit(RBIO_HOLD_BBIO_MAP_BIT, &rbio->flags);
-	rbio->read_rebuild = 1;
+	rbio->operation = BTRFS_RBIO_READ_REBUILD;
 	bio_list_add(&rbio->bio_list, bio);
 	rbio->bio_list_bytes = bio->bi_iter.bi_size;
 
-- 
1.9.3

