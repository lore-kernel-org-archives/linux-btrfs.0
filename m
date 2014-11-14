Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26264 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965581AbaKNNtc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 08:49:32 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id sAEDnFAJ005831
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Nov 2014 21:49:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 7/9] Btrfs, replace: write dirty pages into the replace target device
Date: Fri, 14 Nov 2014 21:50:59 +0800
Message-ID: <1415973061-8643-8-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
References: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The implementation is simple:
- In order to avoid changing the code logic of btrfs_map_bio and
  RAID56, we add the stripes of the replace target devices at the
  end of the stripe array in btrfs bio, and we sort those target
  device stripes in the array. And we keep the number of the target
  device stripes in the btrfs bio.
- Except write operation on RAID56, all the other operation don't
  take the target device stripes into account.
- When we do write operation, we read the data from the common devices
  and calculate the parity. Then write the dirty data and new parity
  out, at this time, we will find the relative replace target stripes
  and wirte the relative data into it.

Note: The function that copying old data on the source device to
the target device was implemented in the past, it is similar to
the other RAID type.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/raid56.c  | 104 +++++++++++++++++++++++++++++++++--------------------
 fs/btrfs/volumes.c |  26 ++++++++++++--
 fs/btrfs/volumes.h |  10 ++++--
 3 files changed, 97 insertions(+), 43 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index a13eb1b..7ad9546a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -124,6 +124,8 @@ struct btrfs_raid_bio {
 	/* number of data stripes (no p/q) */
 	int nr_data;
 
+	int real_stripes;
+
 	int stripe_npages;
 	/*
 	 * set if we're doing a parity rebuild
@@ -619,7 +621,7 @@ static struct page *rbio_pstripe_page(struct btrfs_raid_bio *rbio, int index)
  */
 static struct page *rbio_qstripe_page(struct btrfs_raid_bio *rbio, int index)
 {
-	if (rbio->nr_data + 1 == rbio->bbio->num_stripes)
+	if (rbio->nr_data + 1 == rbio->real_stripes)
 		return NULL;
 
 	index += ((rbio->nr_data + 1) * rbio->stripe_len) >>
@@ -959,7 +961,8 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_root *root,
 {
 	struct btrfs_raid_bio *rbio;
 	int nr_data = 0;
-	int num_pages = rbio_nr_pages(stripe_len, bbio->num_stripes);
+	int real_stripes = bbio->num_stripes - bbio->num_tgtdevs;
+	int num_pages = rbio_nr_pages(stripe_len, real_stripes);
 	int stripe_npages = DIV_ROUND_UP(stripe_len, PAGE_SIZE);
 	void *p;
 
@@ -979,6 +982,7 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_root *root,
 	rbio->fs_info = root->fs_info;
 	rbio->stripe_len = stripe_len;
 	rbio->nr_pages = num_pages;
+	rbio->real_stripes = real_stripes;
 	rbio->stripe_npages = stripe_npages;
 	rbio->faila = -1;
 	rbio->failb = -1;
@@ -995,10 +999,10 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_root *root,
 	rbio->bio_pages = p + sizeof(struct page *) * num_pages;
 	rbio->dbitmap = p + sizeof(struct page *) * num_pages * 2;
 
-	if (raid_map[bbio->num_stripes - 1] == RAID6_Q_STRIPE)
-		nr_data = bbio->num_stripes - 2;
+	if (raid_map[real_stripes - 1] == RAID6_Q_STRIPE)
+		nr_data = real_stripes - 2;
 	else
-		nr_data = bbio->num_stripes - 1;
+		nr_data = real_stripes - 1;
 
 	rbio->nr_data = nr_data;
 	return rbio;
@@ -1110,7 +1114,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 static void validate_rbio_for_rmw(struct btrfs_raid_bio *rbio)
 {
 	if (rbio->faila >= 0 || rbio->failb >= 0) {
-		BUG_ON(rbio->faila == rbio->bbio->num_stripes - 1);
+		BUG_ON(rbio->faila == rbio->real_stripes - 1);
 		__raid56_parity_recover(rbio);
 	} else {
 		finish_rmw(rbio);
@@ -1171,7 +1175,7 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 {
 	struct btrfs_bio *bbio = rbio->bbio;
-	void *pointers[bbio->num_stripes];
+	void *pointers[rbio->real_stripes];
 	int stripe_len = rbio->stripe_len;
 	int nr_data = rbio->nr_data;
 	int stripe;
@@ -1185,11 +1189,11 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 
 	bio_list_init(&bio_list);
 
-	if (bbio->num_stripes - rbio->nr_data == 1) {
-		p_stripe = bbio->num_stripes - 1;
-	} else if (bbio->num_stripes - rbio->nr_data == 2) {
-		p_stripe = bbio->num_stripes - 2;
-		q_stripe = bbio->num_stripes - 1;
+	if (rbio->real_stripes - rbio->nr_data == 1) {
+		p_stripe = rbio->real_stripes - 1;
+	} else if (rbio->real_stripes - rbio->nr_data == 2) {
+		p_stripe = rbio->real_stripes - 2;
+		q_stripe = rbio->real_stripes - 1;
 	} else {
 		BUG();
 	}
@@ -1246,7 +1250,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 			SetPageUptodate(p);
 			pointers[stripe++] = kmap(p);
 
-			raid6_call.gen_syndrome(bbio->num_stripes, PAGE_SIZE,
+			raid6_call.gen_syndrome(rbio->real_stripes, PAGE_SIZE,
 						pointers);
 		} else {
 			/* raid5 */
@@ -1255,7 +1259,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 		}
 
 
-		for (stripe = 0; stripe < bbio->num_stripes; stripe++)
+		for (stripe = 0; stripe < rbio->real_stripes; stripe++)
 			kunmap(page_in_rbio(rbio, stripe, pagenr, 0));
 	}
 
@@ -1264,7 +1268,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 	 * higher layers (the bio_list in our rbio) and our p/q.  Ignore
 	 * everything else.
 	 */
-	for (stripe = 0; stripe < bbio->num_stripes; stripe++) {
+	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
 		for (pagenr = 0; pagenr < pages_per_stripe; pagenr++) {
 			struct page *page;
 			if (stripe < rbio->nr_data) {
@@ -1282,6 +1286,32 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 		}
 	}
 
+	if (likely(!bbio->num_tgtdevs))
+		goto write_data;
+
+	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
+		if (!bbio->tgtdev_map[stripe])
+			continue;
+
+		for (pagenr = 0; pagenr < pages_per_stripe; pagenr++) {
+			struct page *page;
+			if (stripe < rbio->nr_data) {
+				page = page_in_rbio(rbio, stripe, pagenr, 1);
+				if (!page)
+					continue;
+			} else {
+			       page = rbio_stripe_page(rbio, stripe, pagenr);
+			}
+
+			ret = rbio_add_io_page(rbio, &bio_list, page,
+					       rbio->bbio->tgtdev_map[stripe],
+					       pagenr, rbio->stripe_len);
+			if (ret)
+				goto cleanup;
+		}
+	}
+
+write_data:
 	atomic_set(&rbio->stripes_pending, bio_list_size(&bio_list));
 	BUG_ON(atomic_read(&rbio->stripes_pending) == 0);
 
@@ -1320,7 +1350,8 @@ static int find_bio_stripe(struct btrfs_raid_bio *rbio,
 		stripe = &rbio->bbio->stripes[i];
 		stripe_start = stripe->physical;
 		if (physical >= stripe_start &&
-		    physical < stripe_start + rbio->stripe_len) {
+		    physical < stripe_start + rbio->stripe_len &&
+		    bio->bi_bdev == stripe->dev->bdev) {
 			return i;
 		}
 	}
@@ -1769,7 +1800,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 	int err;
 	int i;
 
-	pointers = kzalloc(rbio->bbio->num_stripes * sizeof(void *),
+	pointers = kzalloc(rbio->real_stripes * sizeof(void *),
 			   GFP_NOFS);
 	if (!pointers) {
 		err = -ENOMEM;
@@ -1799,7 +1830,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 		/* setup our array of pointers with pages
 		 * from each stripe
 		 */
-		for (stripe = 0; stripe < rbio->bbio->num_stripes; stripe++) {
+		for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
 			/*
 			 * if we're rebuilding a read, we have to use
 			 * pages from the bio list
@@ -1814,7 +1845,7 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 		}
 
 		/* all raid6 handling here */
-		if (rbio->raid_map[rbio->bbio->num_stripes - 1] ==
+		if (rbio->raid_map[rbio->real_stripes - 1] ==
 		    RAID6_Q_STRIPE) {
 
 			/*
@@ -1864,10 +1895,10 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 			}
 
 			if (rbio->raid_map[failb] == RAID5_P_STRIPE) {
-				raid6_datap_recov(rbio->bbio->num_stripes,
+				raid6_datap_recov(rbio->real_stripes,
 						  PAGE_SIZE, faila, pointers);
 			} else {
-				raid6_2data_recov(rbio->bbio->num_stripes,
+				raid6_2data_recov(rbio->real_stripes,
 						  PAGE_SIZE, faila, failb,
 						  pointers);
 			}
@@ -1909,7 +1940,7 @@ pstripe:
 				}
 			}
 		}
-		for (stripe = 0; stripe < rbio->bbio->num_stripes; stripe++) {
+		for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
 			/*
 			 * if we're rebuilding a read, we have to use
 			 * pages from the bio list
@@ -1990,7 +2021,6 @@ static void raid_recover_end_io(struct bio *bio, int err)
 static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 {
 	int bios_to_read = 0;
-	struct btrfs_bio *bbio = rbio->bbio;
 	struct bio_list bio_list;
 	int ret;
 	int nr_pages = DIV_ROUND_UP(rbio->stripe_len, PAGE_CACHE_SIZE);
@@ -2011,7 +2041,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 	 * stripe cache, it is possible that some or all of these
 	 * pages are going to be uptodate.
 	 */
-	for (stripe = 0; stripe < bbio->num_stripes; stripe++) {
+	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
 		if (rbio->faila == stripe || rbio->failb == stripe) {
 			atomic_inc(&rbio->error);
 			continue;
@@ -2117,7 +2147,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 	 * asking for mirror 3
 	 */
 	if (mirror_num == 3)
-		rbio->failb = bbio->num_stripes - 2;
+		rbio->failb = rbio->real_stripes - 2;
 
 	ret = lock_stripe_add(rbio);
 
@@ -2192,7 +2222,7 @@ raid56_parity_alloc_scrub_rbio(struct btrfs_root *root, struct bio *bio,
 	 */
 	set_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
 
-	for (i = 0; i < bbio->num_stripes; i++) {
+	for (i = 0; i < rbio->real_stripes; i++) {
 		if (bbio->stripes[i].dev == scrub_dev) {
 			rbio->scrubp = i;
 			break;
@@ -2233,7 +2263,7 @@ static int alloc_rbio_essential_pages(struct btrfs_raid_bio *rbio)
 	struct page *page;
 
 	for_each_set_bit(bit, rbio->dbitmap, rbio->stripe_npages) {
-		for (i = 0; i < rbio->bbio->num_stripes; i++) {
+		for (i = 0; i < rbio->real_stripes; i++) {
 			index = i * rbio->stripe_npages + bit;
 			if (rbio->stripe_pages[index])
 				continue;
@@ -2275,8 +2305,7 @@ static void raid_write_parity_end_io(struct bio *bio, int err)
 static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 					 int need_check)
 {
-	struct btrfs_bio *bbio = rbio->bbio;
-	void *pointers[bbio->num_stripes];
+	void *pointers[rbio->real_stripes];
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
@@ -2290,11 +2319,11 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 
 	bio_list_init(&bio_list);
 
-	if (bbio->num_stripes - rbio->nr_data == 1) {
-		p_stripe = bbio->num_stripes - 1;
-	} else if (bbio->num_stripes - rbio->nr_data == 2) {
-		p_stripe = bbio->num_stripes - 2;
-		q_stripe = bbio->num_stripes - 1;
+	if (rbio->real_stripes - rbio->nr_data == 1) {
+		p_stripe = rbio->real_stripes - 1;
+	} else if (rbio->real_stripes - rbio->nr_data == 2) {
+		p_stripe = rbio->real_stripes - 2;
+		q_stripe = rbio->real_stripes - 1;
 	} else {
 		BUG();
 	}
@@ -2345,7 +2374,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 			 */
 			pointers[stripe++] = kmap(q_page);
 
-			raid6_call.gen_syndrome(bbio->num_stripes, PAGE_SIZE,
+			raid6_call.gen_syndrome(rbio->real_stripes, PAGE_SIZE,
 						pointers);
 		} else {
 			/* raid5 */
@@ -2363,7 +2392,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 			bitmap_clear(rbio->dbitmap, pagenr, 1);
 		kunmap(p);
 
-		for (stripe = 0; stripe < bbio->num_stripes; stripe++)
+		for (stripe = 0; stripe < rbio->real_stripes; stripe++)
 			kunmap(page_in_rbio(rbio, stripe, pagenr, 0));
 	}
 
@@ -2513,7 +2542,6 @@ static void raid56_parity_scrub_end_io(struct bio *bio, int err)
 static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
 {
 	int bios_to_read = 0;
-	struct btrfs_bio *bbio = rbio->bbio;
 	struct bio_list bio_list;
 	int ret;
 	int pagenr;
@@ -2531,7 +2559,7 @@ static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
 	 * build a list of bios to read all the missing parts of this
 	 * stripe
 	 */
-	for (stripe = 0; stripe < bbio->num_stripes; stripe++) {
+	for (stripe = 0; stripe < rbio->real_stripes; stripe++) {
 		for_each_set_bit(pagenr, rbio->dbitmap, rbio->stripe_npages) {
 			struct page *page;
 			/*
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 05cf489..28d42ba 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4882,13 +4882,15 @@ static inline int parity_smaller(u64 a, u64 b)
 static void sort_parity_stripes(struct btrfs_bio *bbio, u64 *raid_map)
 {
 	struct btrfs_bio_stripe s;
+	int real_stripes = bbio->num_stripes - bbio->num_tgtdevs;
 	int i;
 	u64 l;
 	int again = 1;
+	int m;
 
 	while (again) {
 		again = 0;
-		for (i = 0; i < bbio->num_stripes - 1; i++) {
+		for (i = 0; i < real_stripes - 1; i++) {
 			if (parity_smaller(raid_map[i], raid_map[i+1])) {
 				s = bbio->stripes[i];
 				l = raid_map[i];
@@ -4896,6 +4898,14 @@ static void sort_parity_stripes(struct btrfs_bio *bbio, u64 *raid_map)
 				raid_map[i] = raid_map[i+1];
 				bbio->stripes[i+1] = s;
 				raid_map[i+1] = l;
+
+				if (bbio->tgtdev_map) {
+					m = bbio->tgtdev_map[i];
+					bbio->tgtdev_map[i] =
+							bbio->tgtdev_map[i + 1];
+					bbio->tgtdev_map[i + 1] = m;
+				}
+
 				again = 1;
 			}
 		}
@@ -4924,6 +4934,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	int ret = 0;
 	int num_stripes;
 	int max_errors = 0;
+	int tgtdev_indexes = 0;
 	struct btrfs_bio *bbio = NULL;
 	struct btrfs_dev_replace *dev_replace = &fs_info->dev_replace;
 	int dev_replace_is_ongoing = 0;
@@ -5235,14 +5246,19 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			num_alloc_stripes <<= 1;
 		if (rw & REQ_GET_READ_MIRRORS)
 			num_alloc_stripes++;
+		tgtdev_indexes = num_stripes;
 	}
-	bbio = kzalloc(btrfs_bio_size(num_alloc_stripes), GFP_NOFS);
+
+	bbio = kzalloc(btrfs_bio_size(num_alloc_stripes, tgtdev_indexes),
+		       GFP_NOFS);
 	if (!bbio) {
 		kfree(raid_map);
 		ret = -ENOMEM;
 		goto out;
 	}
 	atomic_set(&bbio->error, 0);
+	if (dev_replace_is_ongoing)
+		bbio->tgtdev_map = (int *)(bbio->stripes + num_alloc_stripes);
 
 	if (rw & REQ_DISCARD) {
 		int factor = 0;
@@ -5327,6 +5343,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS))
 		max_errors = btrfs_chunk_max_errors(map);
 
+	tgtdev_indexes = 0;
 	if (dev_replace_is_ongoing && (rw & (REQ_WRITE | REQ_DISCARD)) &&
 	    dev_replace->tgtdev != NULL) {
 		int index_where_to_add;
@@ -5355,8 +5372,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 				new->physical = old->physical;
 				new->length = old->length;
 				new->dev = dev_replace->tgtdev;
+				bbio->tgtdev_map[i] = index_where_to_add;
 				index_where_to_add++;
 				max_errors++;
+				tgtdev_indexes++;
 			}
 		}
 		num_stripes = index_where_to_add;
@@ -5402,7 +5421,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 				tgtdev_stripe->length =
 					bbio->stripes[index_srcdev].length;
 				tgtdev_stripe->dev = dev_replace->tgtdev;
+				bbio->tgtdev_map[index_srcdev] = num_stripes;
 
+				tgtdev_indexes++;
 				num_stripes++;
 			}
 		}
@@ -5412,6 +5433,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	bbio->num_stripes = num_stripes;
 	bbio->max_errors = max_errors;
 	bbio->mirror_num = mirror_num;
+	bbio->num_tgtdevs = tgtdev_indexes;
 
 	/*
 	 * this is the case that REQ_READ && dev_replace_is_ongoing &&
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 01094bb..70be257 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -292,7 +292,7 @@ struct btrfs_bio_stripe {
 struct btrfs_bio;
 typedef void (btrfs_bio_end_io_t) (struct btrfs_bio *bio, int err);
 
-#define BTRFS_BIO_ORIG_BIO_SUBMITTED	0x1
+#define BTRFS_BIO_ORIG_BIO_SUBMITTED	(1 << 0)
 
 struct btrfs_bio {
 	atomic_t stripes_pending;
@@ -305,6 +305,8 @@ struct btrfs_bio {
 	int max_errors;
 	int num_stripes;
 	int mirror_num;
+	int num_tgtdevs;
+	int *tgtdev_map;
 	struct btrfs_bio_stripe stripes[];
 };
 
@@ -387,8 +389,10 @@ struct btrfs_balance_control {
 int btrfs_account_dev_extents_size(struct btrfs_device *device, u64 start,
 				   u64 end, u64 *length);
 
-#define btrfs_bio_size(n) (sizeof(struct btrfs_bio) + \
-			    (sizeof(struct btrfs_bio_stripe) * (n)))
+#define btrfs_bio_size(total_stripes, real_stripes)		\
+	(sizeof(struct btrfs_bio) +				\
+	 (sizeof(struct btrfs_bio_stripe) * (total_stripes)) +	\
+	 (sizeof(int) * (real_stripes)))
 
 int btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		    u64 logical, u64 *length,
-- 
1.9.3

