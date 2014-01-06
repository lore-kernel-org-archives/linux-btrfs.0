Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:50765 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbaAFJcg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jan 2014 04:32:36 -0500
From: Andrea Mazzoleni <amadvance@gmail.com>
To: neilb@suse.de
Cc: clm@fb.com, jbacik@fb.com, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org,
        amadvance@gmail.com
Subject: [RFC v2 2/2] fs: btrfs: Extends btrfs/raid56 to support up to six parities
Date: Mon,  6 Jan 2014 10:31:56 +0100
Message-Id: <1389000716-3274-3-git-send-email-amadvance@gmail.com>
In-Reply-To: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
References: <1389000716-3274-1-git-send-email-amadvance@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch changes btrfs/raid56.c to use the new raid interface and
extends its support to an arbitrary number of parities.

More in details, the two faila/failb failure indexes are now replaced
with a fail[] vector that keeps track of up to six failures, and now
the new raid_par() and raid_rec() functions are used to handle with
parity instead of the old xor/raid6 ones.

Signed-off-by: Andrea Mazzoleni <amadvance@gmail.com>
---
 fs/btrfs/Kconfig   |   1 +
 fs/btrfs/raid56.c  | 278 ++++++++++++++++++-----------------------------------
 fs/btrfs/raid56.h  |  12 ++-
 fs/btrfs/volumes.c |   4 +-
 4 files changed, 102 insertions(+), 193 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index aa976ec..173fabe 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -5,6 +5,7 @@ config BTRFS_FS
 	select ZLIB_DEFLATE
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
+	select RAID_CAUCHY
 	select RAID6_PQ
 	select XOR_BLOCKS
 
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 24ac218..2ceff3a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -27,10 +27,9 @@
 #include <linux/capability.h>
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
-#include <linux/raid/pq.h>
+#include <linux/raid/raid.h>
 #include <linux/hash.h>
 #include <linux/list_sort.h>
-#include <linux/raid/xor.h>
 #include <linux/vmalloc.h>
 #include <asm/div64.h>
 #include "ctree.h"
@@ -125,11 +124,11 @@ struct btrfs_raid_bio {
 	 */
 	int read_rebuild;
 
-	/* first bad stripe */
-	int faila;
+	/* bad stripes */
+	int fail[RAID_PARITY_MAX];
 
-	/* second bad stripe (for raid6 use) */
-	int failb;
+	/* number of bad stripes in fail[] */
+	int nr_fail;
 
 	/*
 	 * number of pages needed to represent the full
@@ -496,26 +495,6 @@ static void cache_rbio(struct btrfs_raid_bio *rbio)
 }
 
 /*
- * helper function to run the xor_blocks api.  It is only
- * able to do MAX_XOR_BLOCKS at a time, so we need to
- * loop through.
- */
-static void run_xor(void **pages, int src_cnt, ssize_t len)
-{
-	int src_off = 0;
-	int xor_src_cnt = 0;
-	void *dest = pages[src_cnt];
-
-	while(src_cnt > 0) {
-		xor_src_cnt = min(src_cnt, MAX_XOR_BLOCKS);
-		xor_blocks(xor_src_cnt, len, dest, pages + src_off);
-
-		src_cnt -= xor_src_cnt;
-		src_off += xor_src_cnt;
-	}
-}
-
-/*
  * returns true if the bio list inside this rbio
  * covers an entire stripe (no rmw required).
  * Must be called with the bio list lock held, or
@@ -587,25 +566,18 @@ static int rbio_can_merge(struct btrfs_raid_bio *last,
 }
 
 /*
- * helper to index into the pstripe
+ * helper to index into the parity stripe
+ * returns null if there is no stripe
  */
-static struct page *rbio_pstripe_page(struct btrfs_raid_bio *rbio, int index)
+static struct page *rbio_pstripe_page(struct btrfs_raid_bio *rbio,
+	int index, int parity)
 {
-	index += (rbio->nr_data * rbio->stripe_len) >> PAGE_CACHE_SHIFT;
-	return rbio->stripe_pages[index];
-}
-
-/*
- * helper to index into the qstripe, returns null
- * if there is no qstripe
- */
-static struct page *rbio_qstripe_page(struct btrfs_raid_bio *rbio, int index)
-{
-	if (rbio->nr_data + 1 == rbio->bbio->num_stripes)
+	if (rbio->nr_data + parity >= rbio->bbio->num_stripes)
 		return NULL;
 
-	index += ((rbio->nr_data + 1) * rbio->stripe_len) >>
-		PAGE_CACHE_SHIFT;
+	index += ((rbio->nr_data + parity) * rbio->stripe_len)
+		>> PAGE_CACHE_SHIFT;
+
 	return rbio->stripe_pages[index];
 }
 
@@ -946,8 +918,7 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_root *root,
 	rbio->fs_info = root->fs_info;
 	rbio->stripe_len = stripe_len;
 	rbio->nr_pages = num_pages;
-	rbio->faila = -1;
-	rbio->failb = -1;
+	rbio->nr_fail = 0;
 	atomic_set(&rbio->refs, 1);
 
 	/*
@@ -958,10 +929,10 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_root *root,
 	rbio->stripe_pages = p;
 	rbio->bio_pages = p + sizeof(struct page *) * num_pages;
 
-	if (raid_map[bbio->num_stripes - 1] == RAID6_Q_STRIPE)
-		nr_data = bbio->num_stripes - 2;
-	else
-		nr_data = bbio->num_stripes - 1;
+	/* get the number of data stripes removing all the parities */
+	nr_data = bbio->num_stripes;
+	while (nr_data > 0 && is_parity_stripe(raid_map[nr_data - 1]))
+		--nr_data;
 
 	rbio->nr_data = nr_data;
 	return rbio;
@@ -1072,8 +1043,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
  */
 static void validate_rbio_for_rmw(struct btrfs_raid_bio *rbio)
 {
-	if (rbio->faila >= 0 || rbio->failb >= 0) {
-		BUG_ON(rbio->faila == rbio->bbio->num_stripes - 1);
+	if (rbio->nr_fail > 0) {
 		__raid56_parity_recover(rbio);
 	} else {
 		finish_rmw(rbio);
@@ -1137,10 +1107,10 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 	void *pointers[bbio->num_stripes];
 	int stripe_len = rbio->stripe_len;
 	int nr_data = rbio->nr_data;
+	int nr_parity;
+	int parity;
 	int stripe;
 	int pagenr;
-	int p_stripe = -1;
-	int q_stripe = -1;
 	struct bio_list bio_list;
 	struct bio *bio;
 	int pages_per_stripe = stripe_len >> PAGE_CACHE_SHIFT;
@@ -1148,14 +1118,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 
 	bio_list_init(&bio_list);
 
-	if (bbio->num_stripes - rbio->nr_data == 1) {
-		p_stripe = bbio->num_stripes - 1;
-	} else if (bbio->num_stripes - rbio->nr_data == 2) {
-		p_stripe = bbio->num_stripes - 2;
-		q_stripe = bbio->num_stripes - 1;
-	} else {
-		BUG();
-	}
+	nr_parity = bbio->num_stripes - rbio->nr_data;
 
 	/* at this point we either have a full stripe,
 	 * or we've read the full stripe from the drive.
@@ -1194,29 +1157,15 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 			pointers[stripe] = kmap(p);
 		}
 
-		/* then add the parity stripe */
-		p = rbio_pstripe_page(rbio, pagenr);
-		SetPageUptodate(p);
-		pointers[stripe++] = kmap(p);
-
-		if (q_stripe != -1) {
-
-			/*
-			 * raid6, add the qstripe and call the
-			 * library function to fill in our p/q
-			 */
-			p = rbio_qstripe_page(rbio, pagenr);
+		/* then add the parity stripes */
+		for (parity = 0; parity < nr_parity; ++parity) {
+			p = rbio_pstripe_page(rbio, pagenr, parity);
 			SetPageUptodate(p);
 			pointers[stripe++] = kmap(p);
-
-			raid6_call.gen_syndrome(bbio->num_stripes, PAGE_SIZE,
-						pointers);
-		} else {
-			/* raid5 */
-			memcpy(pointers[nr_data], pointers[0], PAGE_SIZE);
-			run_xor(pointers + 1, nr_data - 1, PAGE_CACHE_SIZE);
 		}
 
+		/* compute the parity */
+		raid_par(rbio->nr_data, nr_parity, PAGE_SIZE, pointers);
 
 		for (stripe = 0; stripe < bbio->num_stripes; stripe++)
 			kunmap(page_in_rbio(rbio, stripe, pagenr, 0));
@@ -1321,24 +1270,25 @@ static int fail_rbio_index(struct btrfs_raid_bio *rbio, int failed)
 {
 	unsigned long flags;
 	int ret = 0;
+	int i;
 
 	spin_lock_irqsave(&rbio->bio_list_lock, flags);
 
 	/* we already know this stripe is bad, move on */
-	if (rbio->faila == failed || rbio->failb == failed)
-		goto out;
+	for (i = 0; i < rbio->nr_fail; ++i)
+		if (rbio->fail[i] == failed)
+			goto out;
 
-	if (rbio->faila == -1) {
-		/* first failure on this rbio */
-		rbio->faila = failed;
-		atomic_inc(&rbio->bbio->error);
-	} else if (rbio->failb == -1) {
-		/* second failure on this rbio */
-		rbio->failb = failed;
-		atomic_inc(&rbio->bbio->error);
-	} else {
+	if (rbio->nr_fail == RAID_PARITY_MAX) {
 		ret = -EIO;
+		goto out;
 	}
+
+	/* new failure on this rbio */
+	rbio->fail[rbio->nr_fail] = failed;
+	++rbio->nr_fail;
+	atomic_inc(&rbio->bbio->error);
+
 out:
 	spin_unlock_irqrestore(&rbio->bio_list_lock, flags);
 
@@ -1724,8 +1674,10 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 {
 	int pagenr, stripe;
 	void **pointers;
-	int faila = -1, failb = -1;
+	int ifail;
 	int nr_pages = (rbio->stripe_len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	int nr_parity;
+	int nr_fail;
 	struct page *page;
 	int err;
 	int i;
@@ -1737,8 +1689,11 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 		goto cleanup_io;
 	}
 
-	faila = rbio->faila;
-	failb = rbio->failb;
+	nr_parity = rbio->bbio->num_stripes - rbio->nr_data;
+	nr_fail = rbio->nr_fail;
+
+	/* ensure that the fail indexes are in order */
+	raid_sort(nr_fail, rbio->fail);
 
 	if (rbio->read_rebuild) {
 		spin_lock_irq(&rbio->bio_list_lock);
@@ -1752,98 +1707,30 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 		/* setup our array of pointers with pages
 		 * from each stripe
 		 */
+		ifail = 0;
 		for (stripe = 0; stripe < rbio->bbio->num_stripes; stripe++) {
 			/*
 			 * if we're rebuilding a read, we have to use
 			 * pages from the bio list
 			 */
 			if (rbio->read_rebuild &&
-			    (stripe == faila || stripe == failb)) {
+			    rbio->fail[ifail] == stripe) {
 				page = page_in_rbio(rbio, stripe, pagenr, 0);
+				++ifail;
 			} else {
 				page = rbio_stripe_page(rbio, stripe, pagenr);
 			}
 			pointers[stripe] = kmap(page);
 		}
 
-		/* all raid6 handling here */
-		if (rbio->raid_map[rbio->bbio->num_stripes - 1] ==
-		    RAID6_Q_STRIPE) {
-
-			/*
-			 * single failure, rebuild from parity raid5
-			 * style
-			 */
-			if (failb < 0) {
-				if (faila == rbio->nr_data) {
-					/*
-					 * Just the P stripe has failed, without
-					 * a bad data or Q stripe.
-					 * TODO, we should redo the xor here.
-					 */
-					err = -EIO;
-					goto cleanup;
-				}
-				/*
-				 * a single failure in raid6 is rebuilt
-				 * in the pstripe code below
-				 */
-				goto pstripe;
-			}
-
-			/* make sure our ps and qs are in order */
-			if (faila > failb) {
-				int tmp = failb;
-				failb = faila;
-				faila = tmp;
-			}
-
-			/* if the q stripe is failed, do a pstripe reconstruction
-			 * from the xors.
-			 * If both the q stripe and the P stripe are failed, we're
-			 * here due to a crc mismatch and we can't give them the
-			 * data they want
-			 */
-			if (rbio->raid_map[failb] == RAID6_Q_STRIPE) {
-				if (rbio->raid_map[faila] == RAID5_P_STRIPE) {
-					err = -EIO;
-					goto cleanup;
-				}
-				/*
-				 * otherwise we have one bad data stripe and
-				 * a good P stripe.  raid5!
-				 */
-				goto pstripe;
-			}
-
-			if (rbio->raid_map[failb] == RAID5_P_STRIPE) {
-				raid6_datap_recov(rbio->bbio->num_stripes,
-						  PAGE_SIZE, faila, pointers);
-			} else {
-				raid6_2data_recov(rbio->bbio->num_stripes,
-						  PAGE_SIZE, faila, failb,
-						  pointers);
-			}
-		} else {
-			void *p;
-
-			/* rebuild from P stripe here (raid5 or raid6) */
-			BUG_ON(failb != -1);
-pstripe:
-			/* Copy parity block into failed block to start with */
-			memcpy(pointers[faila],
-			       pointers[rbio->nr_data],
-			       PAGE_CACHE_SIZE);
-
-			/* rearrange the pointer array */
-			p = pointers[faila];
-			for (stripe = faila; stripe < rbio->nr_data - 1; stripe++)
-				pointers[stripe] = pointers[stripe + 1];
-			pointers[rbio->nr_data - 1] = p;
-
-			/* xor in the rest */
-			run_xor(pointers, rbio->nr_data - 1, PAGE_CACHE_SIZE);
+		/* if we have too many failure */
+		if (nr_fail > nr_parity) {
+			err = -EIO;
+			goto cleanup;
 		}
+		raid_rec(nr_fail, rbio->fail, rbio->nr_data, nr_parity,
+			PAGE_SIZE, pointers);
+
 		/* if we're doing this rebuild as part of an rmw, go through
 		 * and set all of our private rbio pages in the
 		 * failed stripes as uptodate.  This way finish_rmw will
@@ -1852,24 +1739,23 @@ pstripe:
 		 */
 		if (!rbio->read_rebuild) {
 			for (i = 0;  i < nr_pages; i++) {
-				if (faila != -1) {
-					page = rbio_stripe_page(rbio, faila, i);
-					SetPageUptodate(page);
-				}
-				if (failb != -1) {
-					page = rbio_stripe_page(rbio, failb, i);
+				for (ifail = 0; ifail < nr_fail; ++ifail) {
+					int sfail = rbio->fail[ifail];
+					page = rbio_stripe_page(rbio, sfail, i);
 					SetPageUptodate(page);
 				}
 			}
 		}
+		ifail = 0;
 		for (stripe = 0; stripe < rbio->bbio->num_stripes; stripe++) {
 			/*
 			 * if we're rebuilding a read, we have to use
 			 * pages from the bio list
 			 */
 			if (rbio->read_rebuild &&
-			    (stripe == faila || stripe == failb)) {
+			    rbio->fail[ifail] == stripe) {
 				page = page_in_rbio(rbio, stripe, pagenr, 0);
+				++ifail;
 			} else {
 				page = rbio_stripe_page(rbio, stripe, pagenr);
 			}
@@ -1891,8 +1777,7 @@ cleanup_io:
 
 		rbio_orig_end_io(rbio, err, err == 0);
 	} else if (err == 0) {
-		rbio->faila = -1;
-		rbio->failb = -1;
+		rbio->nr_fail = 0;
 		finish_rmw(rbio);
 	} else {
 		rbio_orig_end_io(rbio, err, 0);
@@ -1939,6 +1824,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 	int bios_to_read = 0;
 	struct btrfs_bio *bbio = rbio->bbio;
 	struct bio_list bio_list;
+	int ifail;
 	int ret;
 	int nr_pages = (rbio->stripe_len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	int pagenr;
@@ -1953,15 +1839,20 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 
 	atomic_set(&rbio->bbio->error, 0);
 
+	/* ensure that the fail indexes are in order */
+	raid_sort(rbio->nr_fail, rbio->fail);
+
 	/*
 	 * read everything that hasn't failed.  Thanks to the
 	 * stripe cache, it is possible that some or all of these
 	 * pages are going to be uptodate.
 	 */
+	ifail = 0;
 	for (stripe = 0; stripe < bbio->num_stripes; stripe++) {
-		if (rbio->faila == stripe ||
-		    rbio->failb == stripe)
+		if (rbio->fail[ifail] == stripe) {
+			++ifail;
 			continue;
+		}
 
 		for (pagenr = 0; pagenr < nr_pages; pagenr++) {
 			struct page *p;
@@ -2037,6 +1928,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 {
 	struct btrfs_raid_bio *rbio;
 	int ret;
+	int i;
 
 	rbio = alloc_rbio(root, bbio, raid_map, stripe_len);
 	if (IS_ERR(rbio))
@@ -2046,21 +1938,33 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 	bio_list_add(&rbio->bio_list, bio);
 	rbio->bio_list_bytes = bio->bi_size;
 
-	rbio->faila = find_logical_bio_stripe(rbio, bio);
-	if (rbio->faila == -1) {
+	rbio->fail[0] = find_logical_bio_stripe(rbio, bio);
+	if (rbio->fail[0] == -1) {
 		BUG();
 		kfree(raid_map);
 		kfree(bbio);
 		kfree(rbio);
 		return -EIO;
 	}
+	rbio->nr_fail = 1;
 
 	/*
-	 * reconstruct from the q stripe if they are
-	 * asking for mirror 3
+	 * Reconstruct from other parity stripes if they are
+	 * asking for different mirrors.
+	 * For each mirror we disable one extra parity to trigger
+	 * a different recovery.
+	 * With mirror_num == 2 we disable nothing and we reconstruct
+	 * with the first parity, with mirror_num == 3 we disable the
+	 * first parity and then we reconstruct with the second,
+	 * and so on, up to mirror_num == 7 where we disable the first 5
+	 * parity levels and we recover with the 6 one.
 	 */
-	if (mirror_num == 3)
-		rbio->failb = bbio->num_stripes - 2;
+	if (mirror_num > 2 && mirror_num - 2 < RAID_PARITY_MAX) {
+		for (i = 0; i < mirror_num - 2; ++i) {
+			rbio->fail[rbio->nr_fail] = rbio->nr_data + i;
+			++rbio->nr_fail;
+		}
+	}
 
 	ret = lock_stripe_add(rbio);
 
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index ea5d73b..8adc48d 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -33,11 +33,15 @@ static inline int nr_data_stripes(struct map_lookup *map)
 {
 	return map->num_stripes - nr_parity_stripes(map);
 }
-#define RAID5_P_STRIPE ((u64)-2)
-#define RAID6_Q_STRIPE ((u64)-1)
 
-#define is_parity_stripe(x) (((x) == RAID5_P_STRIPE) ||		\
-			     ((x) == RAID6_Q_STRIPE))
+#define RAID_PAR1_STRIPE ((u64)-6)
+#define RAID_PAR2_STRIPE ((u64)-5)
+#define RAID_PAR3_STRIPE ((u64)-4)
+#define RAID_PAR4_STRIPE ((u64)-3)
+#define RAID_PAR5_STRIPE ((u64)-2)
+#define RAID_PAR6_STRIPE ((u64)-1)
+
+#define is_parity_stripe(x) (((u64)(x) >= RAID_PAR1_STRIPE))
 
 int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 				 struct btrfs_bio *bbio, u64 *raid_map,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 92303f4..bf593f7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4918,10 +4918,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 				raid_map[(i+rot) % num_stripes] =
 					em->start + (tmp + i) * map->stripe_len;
 
-			raid_map[(i+rot) % map->num_stripes] = RAID5_P_STRIPE;
+			raid_map[(i+rot) % map->num_stripes] = RAID_PAR1_STRIPE;
 			if (map->type & BTRFS_BLOCK_GROUP_RAID6)
 				raid_map[(i+rot+1) % num_stripes] =
-					RAID6_Q_STRIPE;
+					RAID_PAR2_STRIPE;
 
 			*length = map->stripe_len;
 			stripe_index = 0;
-- 
1.7.12.1

