Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:65120 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaBXVQI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 16:16:08 -0500
From: Andrea Mazzoleni <amadvance@gmail.com>
To: clm@fb.com, jbacik@fb.com, neilb@suse.de
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-btrfs@vger.kernel.org, amadvance@gmail.com
Subject: [PATCH v5 2/3] fs: btrfs: Adds new par3456 modes to support up to six parities
Date: Mon, 24 Feb 2014 22:15:29 +0100
Message-Id: <1393276530-26423-3-git-send-email-amadvance@gmail.com>
In-Reply-To: <1393276530-26423-1-git-send-email-amadvance@gmail.com>
References: <1393276530-26423-1-git-send-email-amadvance@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Removes the RAID logic now handled in the new raid_gen() and raid_rec() calls
that hide all the details.
Replaces the faila/failb failure indexes with a fail[] vector that keeps
track of up to six failures.
Replaces the existing BLOCK_GROUP_RAID5/6 with new PAR1/2/3/4/5/6 ones that
handle up to six parities, and updates all the code to use them.

Signed-off-by: Andrea Mazzoleni <amadvance@gmail.com>
---
 fs/btrfs/Kconfig             |   1 +
 fs/btrfs/ctree.h             |  50 ++++++--
 fs/btrfs/disk-io.c           |   7 +-
 fs/btrfs/extent-tree.c       |  67 +++++++----
 fs/btrfs/inode.c             |   3 +-
 fs/btrfs/raid56.c            | 273 ++++++++++++++-----------------------------
 fs/btrfs/raid56.h            |  19 ++-
 fs/btrfs/scrub.c             |   3 +-
 fs/btrfs/volumes.c           | 144 +++++++++++++++--------
 include/trace/events/btrfs.h |  16 ++-
 include/uapi/linux/btrfs.h   |  19 ++-
 11 files changed, 313 insertions(+), 289 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index a66768e..fb011b8 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -6,6 +6,7 @@ config BTRFS_FS
 	select ZLIB_DEFLATE
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
+	select RAID_CAUCHY
 	select RAID6_PQ
 	select XOR_BLOCKS
 
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 2c1a42c..7e6d2bf 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -522,6 +522,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_PAR3456		(1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 #define BTRFS_FEATURE_COMPAT_SAFE_SET		0ULL
@@ -539,7 +540,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_PAR3456)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
@@ -983,8 +985,39 @@ struct btrfs_dev_replace_item {
 #define BTRFS_BLOCK_GROUP_RAID1		(1ULL << 4)
 #define BTRFS_BLOCK_GROUP_DUP		(1ULL << 5)
 #define BTRFS_BLOCK_GROUP_RAID10	(1ULL << 6)
-#define BTRFS_BLOCK_GROUP_RAID5         (1ULL << 7)
-#define BTRFS_BLOCK_GROUP_RAID6         (1ULL << 8)
+#define BTRFS_BLOCK_GROUP_PAR1     (1ULL << 7)
+#define BTRFS_BLOCK_GROUP_PAR2     (1ULL << 8)
+#define BTRFS_BLOCK_GROUP_PAR3     (1ULL << 9)
+#define BTRFS_BLOCK_GROUP_PAR4     (1ULL << 10)
+#define BTRFS_BLOCK_GROUP_PAR5     (1ULL << 11)
+#define BTRFS_BLOCK_GROUP_PAR6     (1ULL << 12)
+
+/* tags for all the parity groups */
+#define BTRFS_BLOCK_GROUP_PARX (BTRFS_BLOCK_GROUP_PAR1 | \
+				BTRFS_BLOCK_GROUP_PAR2 | \
+				BTRFS_BLOCK_GROUP_PAR3 | \
+				BTRFS_BLOCK_GROUP_PAR4 | \
+				BTRFS_BLOCK_GROUP_PAR5 | \
+				BTRFS_BLOCK_GROUP_PAR6)
+
+/* gets the parity number from the parity group */
+static inline int btrfs_flags_par(unsigned group)
+{
+	switch (group & BTRFS_BLOCK_GROUP_PARX) {
+	case BTRFS_BLOCK_GROUP_PAR1: return 1;
+	case BTRFS_BLOCK_GROUP_PAR2: return 2;
+	case BTRFS_BLOCK_GROUP_PAR3: return 3;
+	case BTRFS_BLOCK_GROUP_PAR4: return 4;
+	case BTRFS_BLOCK_GROUP_PAR5: return 5;
+	case BTRFS_BLOCK_GROUP_PAR6: return 6;
+	}
+
+	/* ensures that no multiple groups are defined */
+	BUG_ON(group & BTRFS_BLOCK_GROUP_PARX);
+
+	return 0;
+}
+
 #define BTRFS_BLOCK_GROUP_RESERVED	BTRFS_AVAIL_ALLOC_BIT_SINGLE
 
 enum btrfs_raid_types {
@@ -993,8 +1026,12 @@ enum btrfs_raid_types {
 	BTRFS_RAID_DUP,
 	BTRFS_RAID_RAID0,
 	BTRFS_RAID_SINGLE,
-	BTRFS_RAID_RAID5,
-	BTRFS_RAID_RAID6,
+	BTRFS_RAID_PAR1,
+	BTRFS_RAID_PAR2,
+	BTRFS_RAID_PAR3,
+	BTRFS_RAID_PAR4,
+	BTRFS_RAID_PAR5,
+	BTRFS_RAID_PAR6,
 	BTRFS_NR_RAID_TYPES
 };
 
@@ -1004,8 +1041,7 @@ enum btrfs_raid_types {
 
 #define BTRFS_BLOCK_GROUP_PROFILE_MASK	(BTRFS_BLOCK_GROUP_RAID0 |   \
 					 BTRFS_BLOCK_GROUP_RAID1 |   \
-					 BTRFS_BLOCK_GROUP_RAID5 |   \
-					 BTRFS_BLOCK_GROUP_RAID6 |   \
+					 BTRFS_BLOCK_GROUP_PARX |    \
 					 BTRFS_BLOCK_GROUP_DUP |     \
 					 BTRFS_BLOCK_GROUP_RAID10)
 /*
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 81ea553..9931cf3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3337,12 +3337,11 @@ int btrfs_calc_num_tolerated_disk_barrier_failures(
 					num_tolerated_disk_barrier_failures = 0;
 				else if (num_tolerated_disk_barrier_failures > 1) {
 					if (flags & (BTRFS_BLOCK_GROUP_RAID1 |
-					    BTRFS_BLOCK_GROUP_RAID5 |
 					    BTRFS_BLOCK_GROUP_RAID10)) {
 						num_tolerated_disk_barrier_failures = 1;
-					} else if (flags &
-						   BTRFS_BLOCK_GROUP_RAID6) {
-						num_tolerated_disk_barrier_failures = 2;
+					} else if (flags & BTRFS_BLOCK_GROUP_PARX) {
+						num_tolerated_disk_barrier_failures
+						 = btrfs_flags_par(flags);
 					}
 				}
 			}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 32312e0..a5d1f9d 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3516,21 +3516,35 @@ static u64 btrfs_reduce_alloc_profile(struct btrfs_root *root, u64 flags)
 	/* First, mask out the RAID levels which aren't possible */
 	if (num_devices == 1)
 		flags &= ~(BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID0 |
-			   BTRFS_BLOCK_GROUP_RAID5);
+			   BTRFS_BLOCK_GROUP_PAR1);
 	if (num_devices < 3)
-		flags &= ~BTRFS_BLOCK_GROUP_RAID6;
+		flags &= ~BTRFS_BLOCK_GROUP_PAR2;
 	if (num_devices < 4)
-		flags &= ~BTRFS_BLOCK_GROUP_RAID10;
+		flags &= ~(BTRFS_BLOCK_GROUP_RAID10 | BTRFS_BLOCK_GROUP_PAR3);
+	if (num_devices < 5)
+		flags &= ~BTRFS_BLOCK_GROUP_PAR4;
+	if (num_devices < 6)
+		flags &= ~BTRFS_BLOCK_GROUP_PAR5;
+	if (num_devices < 7)
+		flags &= ~BTRFS_BLOCK_GROUP_PAR6;
 
 	tmp = flags & (BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID0 |
-		       BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID5 |
-		       BTRFS_BLOCK_GROUP_RAID6 | BTRFS_BLOCK_GROUP_RAID10);
+		       BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_PARX |
+		       BTRFS_BLOCK_GROUP_RAID10);
 	flags &= ~tmp;
 
-	if (tmp & BTRFS_BLOCK_GROUP_RAID6)
-		tmp = BTRFS_BLOCK_GROUP_RAID6;
-	else if (tmp & BTRFS_BLOCK_GROUP_RAID5)
-		tmp = BTRFS_BLOCK_GROUP_RAID5;
+	if (tmp & BTRFS_BLOCK_GROUP_PAR6)
+		tmp = BTRFS_BLOCK_GROUP_PAR6;
+	else if (tmp & BTRFS_BLOCK_GROUP_PAR5)
+		tmp = BTRFS_BLOCK_GROUP_PAR5;
+	else if (tmp & BTRFS_BLOCK_GROUP_PAR4)
+		tmp = BTRFS_BLOCK_GROUP_PAR4;
+	else if (tmp & BTRFS_BLOCK_GROUP_PAR3)
+		tmp = BTRFS_BLOCK_GROUP_PAR3;
+	else if (tmp & BTRFS_BLOCK_GROUP_PAR2)
+		tmp = BTRFS_BLOCK_GROUP_PAR2;
+	else if (tmp & BTRFS_BLOCK_GROUP_PAR1)
+		tmp = BTRFS_BLOCK_GROUP_PAR1;
 	else if (tmp & BTRFS_BLOCK_GROUP_RAID10)
 		tmp = BTRFS_BLOCK_GROUP_RAID10;
 	else if (tmp & BTRFS_BLOCK_GROUP_RAID1)
@@ -3769,8 +3783,7 @@ static u64 get_system_chunk_thresh(struct btrfs_root *root, u64 type)
 
 	if (type & (BTRFS_BLOCK_GROUP_RAID10 |
 		    BTRFS_BLOCK_GROUP_RAID0 |
-		    BTRFS_BLOCK_GROUP_RAID5 |
-		    BTRFS_BLOCK_GROUP_RAID6))
+		    BTRFS_BLOCK_GROUP_PARX))
 		num_dev = root->fs_info->fs_devices->rw_devices;
 	else if (type & BTRFS_BLOCK_GROUP_RAID1)
 		num_dev = 2;
@@ -6104,10 +6117,18 @@ int __get_raid_index(u64 flags)
 		return BTRFS_RAID_DUP;
 	else if (flags & BTRFS_BLOCK_GROUP_RAID0)
 		return BTRFS_RAID_RAID0;
-	else if (flags & BTRFS_BLOCK_GROUP_RAID5)
-		return BTRFS_RAID_RAID5;
-	else if (flags & BTRFS_BLOCK_GROUP_RAID6)
-		return BTRFS_RAID_RAID6;
+	else if (flags & BTRFS_BLOCK_GROUP_PAR1)
+		return BTRFS_RAID_PAR1;
+	else if (flags & BTRFS_BLOCK_GROUP_PAR2)
+		return BTRFS_RAID_PAR2;
+	else if (flags & BTRFS_BLOCK_GROUP_PAR3)
+		return BTRFS_RAID_PAR3;
+	else if (flags & BTRFS_BLOCK_GROUP_PAR4)
+		return BTRFS_RAID_PAR4;
+	else if (flags & BTRFS_BLOCK_GROUP_PAR5)
+		return BTRFS_RAID_PAR5;
+	else if (flags & BTRFS_BLOCK_GROUP_PAR6)
+		return BTRFS_RAID_PAR6;
 
 	return BTRFS_RAID_SINGLE; /* BTRFS_BLOCK_GROUP_SINGLE */
 }
@@ -6123,8 +6144,12 @@ static const char *btrfs_raid_type_names[BTRFS_NR_RAID_TYPES] = {
 	[BTRFS_RAID_DUP]	= "dup",
 	[BTRFS_RAID_RAID0]	= "raid0",
 	[BTRFS_RAID_SINGLE]	= "single",
-	[BTRFS_RAID_RAID5]	= "raid5",
-	[BTRFS_RAID_RAID6]	= "raid6",
+	[BTRFS_RAID_PAR1]	= "raid5",
+	[BTRFS_RAID_PAR2]	= "raid6",
+	[BTRFS_RAID_PAR3]	= "par3",
+	[BTRFS_RAID_PAR4]	= "par4",
+	[BTRFS_RAID_PAR5]	= "par5",
+	[BTRFS_RAID_PAR6]	= "par6",
 };
 
 static const char *get_raid_name(enum btrfs_raid_types type)
@@ -6269,8 +6294,7 @@ search:
 		if (!block_group_bits(block_group, flags)) {
 		    u64 extra = BTRFS_BLOCK_GROUP_DUP |
 				BTRFS_BLOCK_GROUP_RAID1 |
-				BTRFS_BLOCK_GROUP_RAID5 |
-				BTRFS_BLOCK_GROUP_RAID6 |
+				BTRFS_BLOCK_GROUP_PARX |
 				BTRFS_BLOCK_GROUP_RAID10;
 
 			/*
@@ -7856,7 +7880,7 @@ static u64 update_block_group_flags(struct btrfs_root *root, u64 flags)
 		root->fs_info->fs_devices->missing_devices;
 
 	stripped = BTRFS_BLOCK_GROUP_RAID0 |
-		BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6 |
+		BTRFS_BLOCK_GROUP_PARX |
 		BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10;
 
 	if (num_devices == 1) {
@@ -8539,8 +8563,7 @@ int btrfs_read_block_groups(struct btrfs_root *root)
 		if (!(get_alloc_profile(root, space_info->flags) &
 		      (BTRFS_BLOCK_GROUP_RAID10 |
 		       BTRFS_BLOCK_GROUP_RAID1 |
-		       BTRFS_BLOCK_GROUP_RAID5 |
-		       BTRFS_BLOCK_GROUP_RAID6 |
+		       BTRFS_BLOCK_GROUP_PARX |
 		       BTRFS_BLOCK_GROUP_DUP)))
 			continue;
 		/*
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index d3d4448..46b4b49 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7184,8 +7184,7 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	}
 
 	/* async crcs make it difficult to collect full stripe writes. */
-	if (btrfs_get_alloc_profile(root, 1) &
-	    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6))
+	if (btrfs_get_alloc_profile(root, 1) & BTRFS_BLOCK_GROUP_PARX)
 		async_submit = 0;
 	else
 		async_submit = 1;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 9af0b25..c7573dc 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -27,10 +27,10 @@
 #include <linux/capability.h>
 #include <linux/ratelimit.h>
 #include <linux/kthread.h>
-#include <linux/raid/pq.h>
+#include <linux/raid/raid.h>
+#include <linux/raid/helper.h>
 #include <linux/hash.h>
 #include <linux/list_sort.h>
-#include <linux/raid/xor.h>
 #include <linux/vmalloc.h>
 #include <asm/div64.h>
 #include "ctree.h"
@@ -125,11 +125,11 @@ struct btrfs_raid_bio {
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
@@ -496,26 +496,6 @@ static void cache_rbio(struct btrfs_raid_bio *rbio)
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
@@ -587,25 +567,18 @@ static int rbio_can_merge(struct btrfs_raid_bio *last,
 }
 
 /*
- * helper to index into the pstripe
- */
-static struct page *rbio_pstripe_page(struct btrfs_raid_bio *rbio, int index)
-{
-	index += (rbio->nr_data * rbio->stripe_len) >> PAGE_CACHE_SHIFT;
-	return rbio->stripe_pages[index];
-}
-
-/*
- * helper to index into the qstripe, returns null
- * if there is no qstripe
+ * helper to index into the parity stripe
+ * returns null if there is no stripe
  */
-static struct page *rbio_qstripe_page(struct btrfs_raid_bio *rbio, int index)
+static struct page *rbio_pstripe_page(struct btrfs_raid_bio *rbio,
+	int index, int parity)
 {
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
 
@@ -946,8 +919,7 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_root *root,
 	rbio->fs_info = root->fs_info;
 	rbio->stripe_len = stripe_len;
 	rbio->nr_pages = num_pages;
-	rbio->faila = -1;
-	rbio->failb = -1;
+	rbio->nr_fail = 0;
 	atomic_set(&rbio->refs, 1);
 
 	/*
@@ -958,10 +930,10 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_root *root,
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
@@ -1072,8 +1044,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
  */
 static void validate_rbio_for_rmw(struct btrfs_raid_bio *rbio)
 {
-	if (rbio->faila >= 0 || rbio->failb >= 0) {
-		BUG_ON(rbio->faila == rbio->bbio->num_stripes - 1);
+	if (rbio->nr_fail > 0) {
 		__raid56_parity_recover(rbio);
 	} else {
 		finish_rmw(rbio);
@@ -1137,10 +1108,10 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
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
@@ -1148,14 +1119,7 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 
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
@@ -1194,29 +1158,15 @@ static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
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
+		raid_gen(rbio->nr_data, nr_parity, PAGE_SIZE, pointers);
 
 		for (stripe = 0; stripe < bbio->num_stripes; stripe++)
 			kunmap(page_in_rbio(rbio, stripe, pagenr, 0));
@@ -1321,24 +1271,25 @@ static int fail_rbio_index(struct btrfs_raid_bio *rbio, int failed)
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
+	raid_insert(rbio->nr_fail, rbio->fail, failed);
+	++rbio->nr_fail;
+	atomic_inc(&rbio->bbio->error);
+
 out:
 	spin_unlock_irqrestore(&rbio->bio_list_lock, flags);
 
@@ -1724,8 +1675,10 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
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
@@ -1737,8 +1690,8 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
 		goto cleanup_io;
 	}
 
-	faila = rbio->faila;
-	failb = rbio->failb;
+	nr_parity = rbio->bbio->num_stripes - rbio->nr_data;
+	nr_fail = rbio->nr_fail;
 
 	if (rbio->read_rebuild) {
 		spin_lock_irq(&rbio->bio_list_lock);
@@ -1752,98 +1705,30 @@ static void __raid_recover_end_io(struct btrfs_raid_bio *rbio)
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
@@ -1852,24 +1737,23 @@ pstripe:
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
@@ -1891,8 +1775,7 @@ cleanup_io:
 
 		rbio_orig_end_io(rbio, err, err == 0);
 	} else if (err == 0) {
-		rbio->faila = -1;
-		rbio->failb = -1;
+		rbio->nr_fail = 0;
 		finish_rmw(rbio);
 	} else {
 		rbio_orig_end_io(rbio, err, 0);
@@ -1939,6 +1822,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 	int bios_to_read = 0;
 	struct btrfs_bio *bbio = rbio->bbio;
 	struct bio_list bio_list;
+	int ifail;
 	int ret;
 	int nr_pages = (rbio->stripe_len + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	int pagenr;
@@ -1958,10 +1842,12 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
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
@@ -2037,6 +1923,7 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 {
 	struct btrfs_raid_bio *rbio;
 	int ret;
+	int i;
 
 	rbio = alloc_rbio(root, bbio, raid_map, stripe_len);
 	if (IS_ERR(rbio))
@@ -2046,21 +1933,33 @@ int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 	bio_list_add(&rbio->bio_list, bio);
 	rbio->bio_list_bytes = bio->bi_iter.bi_size;
 
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
+			raid_insert(rbio->nr_fail, rbio->fail, rbio->nr_data + i);
+			++rbio->nr_fail;
+		}
+	}
 
 	ret = lock_stripe_add(rbio);
 
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index ea5d73b..b1082b6 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -21,23 +21,22 @@
 #define __BTRFS_RAID56__
 static inline int nr_parity_stripes(struct map_lookup *map)
 {
-	if (map->type & BTRFS_BLOCK_GROUP_RAID5)
-		return 1;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
-		return 2;
-	else
-		return 0;
+	return btrfs_flags_par(map->type);
 }
 
 static inline int nr_data_stripes(struct map_lookup *map)
 {
 	return map->num_stripes - nr_parity_stripes(map);
 }
-#define RAID5_P_STRIPE ((u64)-2)
-#define RAID6_Q_STRIPE ((u64)-1)
 
-#define is_parity_stripe(x) (((x) == RAID5_P_STRIPE) ||		\
-			     ((x) == RAID6_Q_STRIPE))
+#define BTRFS_RAID_PAR1_STRIPE ((u64)-6)
+#define BTRFS_RAID_PAR2_STRIPE ((u64)-5)
+#define BTRFS_RAID_PAR3_STRIPE ((u64)-4)
+#define BTRFS_RAID_PAR4_STRIPE ((u64)-3)
+#define BTRFS_RAID_PAR5_STRIPE ((u64)-2)
+#define BTRFS_RAID_PAR6_STRIPE ((u64)-1)
+
+#define is_parity_stripe(x) (((u64)(x) >= BTRFS_RAID_PAR1_STRIPE))
 
 int raid56_parity_recover(struct btrfs_root *root, struct bio *bio,
 				 struct btrfs_bio *bbio, u64 *raid_map,
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index efba5d1..495c13e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2259,8 +2259,7 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
 	int extent_mirror_num;
 	int stop_loop;
 
-	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
-			 BTRFS_BLOCK_GROUP_RAID6)) {
+	if (map->type & BTRFS_BLOCK_GROUP_PARX) {
 		if (num >= nr_data_stripes(map)) {
 			return 0;
 		}
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index bab0b84..acafb50 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1525,17 +1525,41 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
 		goto out;
 	}
 
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID5) &&
+	if ((all_avail & BTRFS_BLOCK_GROUP_PAR1) &&
 	    root->fs_info->fs_devices->rw_devices <= 2) {
 		ret = BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET;
 		goto out;
 	}
-	if ((all_avail & BTRFS_BLOCK_GROUP_RAID6) &&
+
+	if ((all_avail & BTRFS_BLOCK_GROUP_PAR2) &&
 	    root->fs_info->fs_devices->rw_devices <= 3) {
 		ret = BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET;
 		goto out;
 	}
 
+	if ((all_avail & BTRFS_BLOCK_GROUP_PAR3) &&
+	    root->fs_info->fs_devices->rw_devices <= 4) {
+		ret = BTRFS_ERROR_DEV_PAR3_MIN_NOT_MET;
+		goto out;
+	}
+
+	if ((all_avail & BTRFS_BLOCK_GROUP_PAR4) &&
+	    root->fs_info->fs_devices->rw_devices <= 5) {
+		ret = BTRFS_ERROR_DEV_PAR4_MIN_NOT_MET;
+		goto out;
+	}
+
+	if ((all_avail & BTRFS_BLOCK_GROUP_PAR5) &&
+	    root->fs_info->fs_devices->rw_devices <= 6) {
+		ret = BTRFS_ERROR_DEV_PAR5_MIN_NOT_MET;
+		goto out;
+	}
+
+	if ((all_avail & BTRFS_BLOCK_GROUP_PAR6) &&
+	    root->fs_info->fs_devices->rw_devices <= 7) {
+		ret = BTRFS_ERROR_DEV_PAR6_MIN_NOT_MET;
+		goto out;
+	}
 	if (strcmp(device_path, "missing") == 0) {
 		struct list_head *devices;
 		struct btrfs_device *tmp;
@@ -2797,10 +2821,8 @@ static int chunk_drange_filter(struct extent_buffer *leaf,
 	if (btrfs_chunk_type(leaf, chunk) & (BTRFS_BLOCK_GROUP_DUP |
 	     BTRFS_BLOCK_GROUP_RAID1 | BTRFS_BLOCK_GROUP_RAID10)) {
 		factor = num_stripes / 2;
-	} else if (btrfs_chunk_type(leaf, chunk) & BTRFS_BLOCK_GROUP_RAID5) {
-		factor = num_stripes - 1;
-	} else if (btrfs_chunk_type(leaf, chunk) & BTRFS_BLOCK_GROUP_RAID6) {
-		factor = num_stripes - 2;
+	} else if (btrfs_chunk_type(leaf, chunk) & BTRFS_BLOCK_GROUP_PARX) {
+		factor = num_stripes - btrfs_flags_par(btrfs_chunk_type(leaf, chunk));
 	} else {
 		factor = num_stripes;
 	}
@@ -3158,10 +3180,18 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	else if (num_devices > 1)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID0 | BTRFS_BLOCK_GROUP_RAID1);
 	if (num_devices > 2)
-		allowed |= BTRFS_BLOCK_GROUP_RAID5;
+		allowed |= BTRFS_BLOCK_GROUP_PAR1;
 	if (num_devices > 3)
 		allowed |= (BTRFS_BLOCK_GROUP_RAID10 |
-			    BTRFS_BLOCK_GROUP_RAID6);
+			    BTRFS_BLOCK_GROUP_PAR2);
+	if (num_devices > 4)
+		allowed |= BTRFS_BLOCK_GROUP_PAR3;
+	if (num_devices > 5)
+		allowed |= BTRFS_BLOCK_GROUP_PAR4;
+	if (num_devices > 6)
+		allowed |= BTRFS_BLOCK_GROUP_PAR5;
+	if (num_devices > 7)
+		allowed |= BTRFS_BLOCK_GROUP_PAR6;
 	if ((bctl->data.flags & BTRFS_BALANCE_ARGS_CONVERT) &&
 	    (!alloc_profile_is_valid(bctl->data.target, 1) ||
 	     (bctl->data.target & ~allowed))) {
@@ -3201,8 +3231,7 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
 	/* allow to reduce meta or sys integrity only if force set */
 	allowed = BTRFS_BLOCK_GROUP_DUP | BTRFS_BLOCK_GROUP_RAID1 |
 			BTRFS_BLOCK_GROUP_RAID10 |
-			BTRFS_BLOCK_GROUP_RAID5 |
-			BTRFS_BLOCK_GROUP_RAID6;
+			BTRFS_BLOCK_GROUP_PARX;
 	do {
 		seq = read_seqbegin(&fs_info->profiles_lock);
 
@@ -3940,7 +3969,7 @@ static struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 1,
 		.ncopies	= 1,
 	},
-	[BTRFS_RAID_RAID5] = {
+	[BTRFS_RAID_PAR1] = {
 		.sub_stripes	= 1,
 		.dev_stripes	= 1,
 		.devs_max	= 0,
@@ -3948,7 +3977,7 @@ static struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 1,
 		.ncopies	= 2,
 	},
-	[BTRFS_RAID_RAID6] = {
+	[BTRFS_RAID_PAR2] = {
 		.sub_stripes	= 1,
 		.dev_stripes	= 1,
 		.devs_max	= 0,
@@ -3956,6 +3985,38 @@ static struct btrfs_raid_attr btrfs_raid_array[BTRFS_NR_RAID_TYPES] = {
 		.devs_increment	= 1,
 		.ncopies	= 3,
 	},
+	[BTRFS_RAID_PAR3] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 4,
+		.devs_increment	= 1,
+		.ncopies	= 4,
+	},
+	[BTRFS_RAID_PAR4] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 5,
+		.devs_increment	= 1,
+		.ncopies	= 5,
+	},
+	[BTRFS_RAID_PAR5] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 6,
+		.devs_increment	= 1,
+		.ncopies	= 6,
+	},
+	[BTRFS_RAID_PAR6] = {
+		.sub_stripes	= 1,
+		.dev_stripes	= 1,
+		.devs_max	= 0,
+		.devs_min	= 7,
+		.devs_increment	= 1,
+		.ncopies	= 7,
+	},
 };
 
 static u32 find_raid56_stripe_len(u32 data_devices, u32 dev_stripe_target)
@@ -3966,7 +4027,7 @@ static u32 find_raid56_stripe_len(u32 data_devices, u32 dev_stripe_target)
 
 static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 {
-	if (!(type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)))
+	if (!(type & BTRFS_BLOCK_GROUP_PARX))
 		return;
 
 	btrfs_set_fs_incompat(info, RAID56);
@@ -4134,15 +4195,11 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	 */
 	data_stripes = num_stripes / ncopies;
 
-	if (type & BTRFS_BLOCK_GROUP_RAID5) {
-		raid_stripe_len = find_raid56_stripe_len(ndevs - 1,
+	if (type & BTRFS_BLOCK_GROUP_PARX) {
+		int nr_par = btrfs_flags_par(type);
+		raid_stripe_len = find_raid56_stripe_len(ndevs - nr_par,
 				 btrfs_super_stripesize(info->super_copy));
-		data_stripes = num_stripes - 1;
-	}
-	if (type & BTRFS_BLOCK_GROUP_RAID6) {
-		raid_stripe_len = find_raid56_stripe_len(ndevs - 2,
-				 btrfs_super_stripesize(info->super_copy));
-		data_stripes = num_stripes - 2;
+		data_stripes = num_stripes - nr_par;
 	}
 
 	/*
@@ -4500,10 +4557,8 @@ int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
 		ret = map->num_stripes;
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID10)
 		ret = map->sub_stripes;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID5)
-		ret = 2;
-	else if (map->type & BTRFS_BLOCK_GROUP_RAID6)
-		ret = 3;
+	else if (map->type & BTRFS_BLOCK_GROUP_PARX)
+		ret = 1 + btrfs_flags_par(map->type);
 	else
 		ret = 1;
 	free_extent_map(em);
@@ -4532,10 +4587,9 @@ unsigned long btrfs_full_stripe_len(struct btrfs_root *root,
 
 	BUG_ON(em->start > logical || em->start + em->len < logical);
 	map = (struct map_lookup *)em->bdev;
-	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
-			 BTRFS_BLOCK_GROUP_RAID6)) {
+	if (map->type & BTRFS_BLOCK_GROUP_PARX)
 		len = map->stripe_len * nr_data_stripes(map);
-	}
+
 	free_extent_map(em);
 	return len;
 }
@@ -4555,8 +4609,7 @@ int btrfs_is_parity_mirror(struct btrfs_mapping_tree *map_tree,
 
 	BUG_ON(em->start > logical || em->start + em->len < logical);
 	map = (struct map_lookup *)em->bdev;
-	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
-			 BTRFS_BLOCK_GROUP_RAID6))
+	if (map->type & BTRFS_BLOCK_GROUP_PARX)
 		ret = 1;
 	free_extent_map(em);
 	return ret;
@@ -4694,7 +4747,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	stripe_offset = offset - stripe_offset;
 
 	/* if we're here for raid56, we need to know the stripe aligned start */
-	if (map->type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
+	if (map->type & BTRFS_BLOCK_GROUP_PARX) {
 		unsigned long full_stripe_len = stripe_len * nr_data_stripes(map);
 		raid56_full_stripe_start = offset;
 
@@ -4707,8 +4760,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 
 	if (rw & REQ_DISCARD) {
 		/* we don't discard raid56 yet */
-		if (map->type &
-		    (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6)) {
+		if (map->type & BTRFS_BLOCK_GROUP_PARX) {
 			ret = -EOPNOTSUPP;
 			goto out;
 		}
@@ -4718,7 +4770,7 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		/* For writes to RAID[56], allow a full stripeset across all disks.
 		   For other RAID types and for RAID[56] reads, just allow a single
 		   stripe (on a single disk). */
-		if (map->type & (BTRFS_BLOCK_GROUP_RAID5 | BTRFS_BLOCK_GROUP_RAID6) &&
+		if (map->type & BTRFS_BLOCK_GROUP_PARX &&
 		    (rw & REQ_WRITE)) {
 			max_len = stripe_len * nr_data_stripes(map) -
 				(offset - raid56_full_stripe_start);
@@ -4882,13 +4934,12 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 			mirror_num = stripe_index - old_stripe_index + 1;
 		}
 
-	} else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
-				BTRFS_BLOCK_GROUP_RAID6)) {
+	} else if (map->type & BTRFS_BLOCK_GROUP_PARX) {
 		u64 tmp;
 
 		if (bbio_ret && ((rw & REQ_WRITE) || mirror_num > 1)
 		    && raid_map_ret) {
-			int i, rot;
+			int i, j, rot;
 
 			/* push stripe_nr back to the start of the full stripe */
 			stripe_nr = raid56_full_stripe_start;
@@ -4917,10 +4968,8 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 				raid_map[(i+rot) % num_stripes] =
 					em->start + (tmp + i) * map->stripe_len;
 
-			raid_map[(i+rot) % map->num_stripes] = RAID5_P_STRIPE;
-			if (map->type & BTRFS_BLOCK_GROUP_RAID6)
-				raid_map[(i+rot+1) % num_stripes] =
-					RAID6_Q_STRIPE;
+			for (j = 0; j < btrfs_flags_par(map->type); j++)
+				raid_map[(i+rot+j) % num_stripes] = BTRFS_RAID_PAR1_STRIPE + j;
 
 			*length = map->stripe_len;
 			stripe_index = 0;
@@ -4928,8 +4977,9 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 		} else {
 			/*
 			 * Mirror #0 or #1 means the original data block.
-			 * Mirror #2 is RAID5 parity block.
-			 * Mirror #3 is RAID6 Q block.
+			 * Mirror #2 is RAID5/PAR1 P block.
+			 * Mirror #3 is RAID6/PAR2 Q block.
+			 * .. and so on up to PAR6
 			 */
 			stripe_index = do_div(stripe_nr, nr_data_stripes(map));
 			if (mirror_num > 1)
@@ -5049,11 +5099,10 @@ static int __btrfs_map_block(struct btrfs_fs_info *fs_info, int rw,
 	if (rw & (REQ_WRITE | REQ_GET_READ_MIRRORS)) {
 		if (map->type & (BTRFS_BLOCK_GROUP_RAID1 |
 				 BTRFS_BLOCK_GROUP_RAID10 |
-				 BTRFS_BLOCK_GROUP_RAID5 |
 				 BTRFS_BLOCK_GROUP_DUP)) {
 			max_errors = 1;
-		} else if (map->type & BTRFS_BLOCK_GROUP_RAID6) {
-			max_errors = 2;
+		} else if (map->type & BTRFS_BLOCK_GROUP_PARX) {
+			max_errors = btrfs_flags_par(map->type);
 		}
 	}
 
@@ -5212,8 +5261,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 		do_div(length, map->num_stripes / map->sub_stripes);
 	else if (map->type & BTRFS_BLOCK_GROUP_RAID0)
 		do_div(length, map->num_stripes);
-	else if (map->type & (BTRFS_BLOCK_GROUP_RAID5 |
-			      BTRFS_BLOCK_GROUP_RAID6)) {
+	else if (map->type & BTRFS_BLOCK_GROUP_PARX) {
 		do_div(length, nr_data_stripes(map));
 		rmap_len = map->stripe_len * nr_data_stripes(map);
 	}
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 3176cdc..98a9c78 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -58,8 +58,12 @@ struct extent_buffer;
 	{ BTRFS_BLOCK_GROUP_RAID1,	"RAID1"}, 	\
 	{ BTRFS_BLOCK_GROUP_DUP,	"DUP"}, 	\
 	{ BTRFS_BLOCK_GROUP_RAID10,	"RAID10"}, 	\
-	{ BTRFS_BLOCK_GROUP_RAID5,	"RAID5"},	\
-	{ BTRFS_BLOCK_GROUP_RAID6,	"RAID6"}
+	{ BTRFS_BLOCK_GROUP_PAR1,	"RAID5"},	\
+	{ BTRFS_BLOCK_GROUP_PAR2,	"RAID6"},	\
+	{ BTRFS_BLOCK_GROUP_PAR3,	"PAR3"},	\
+	{ BTRFS_BLOCK_GROUP_PAR4,	"PAR4"},	\
+	{ BTRFS_BLOCK_GROUP_PAR5,	"PAR5"},	\
+	{ BTRFS_BLOCK_GROUP_PAR6,	"PAR6"}
 
 #define BTRFS_UUID_SIZE 16
 
@@ -623,8 +627,12 @@ DEFINE_EVENT(btrfs_delayed_ref_head,  run_delayed_ref_head,
 		{ BTRFS_BLOCK_GROUP_RAID1, 	"RAID1" },	\
 		{ BTRFS_BLOCK_GROUP_DUP, 	"DUP"	},	\
 		{ BTRFS_BLOCK_GROUP_RAID10, 	"RAID10"},	\
-		{ BTRFS_BLOCK_GROUP_RAID5, 	"RAID5"	},	\
-		{ BTRFS_BLOCK_GROUP_RAID6, 	"RAID6"	})
+		{ BTRFS_BLOCK_GROUP_PAR1,	"RAID5"	},	\
+		{ BTRFS_BLOCK_GROUP_PAR2,	"RAID6"	},	\
+		{ BTRFS_BLOCK_GROUP_PAR3,	"PAR3"	},	\
+		{ BTRFS_BLOCK_GROUP_PAR4,	"PAR4"	},	\
+		{ BTRFS_BLOCK_GROUP_PAR5,	"PAR5"	},	\
+		{ BTRFS_BLOCK_GROUP_PAR6,	"PAR6"	})
 
 DECLARE_EVENT_CLASS(btrfs__chunk,
 
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index b4d6909..ba120ba 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -488,8 +488,13 @@ enum btrfs_err_code {
 	BTRFS_ERROR_DEV_TGT_REPLACE,
 	BTRFS_ERROR_DEV_MISSING_NOT_FOUND,
 	BTRFS_ERROR_DEV_ONLY_WRITABLE,
-	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
+	BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS,
+	BTRFS_ERROR_DEV_PAR3_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_PAR4_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_PAR5_MIN_NOT_MET,
+	BTRFS_ERROR_DEV_PAR6_MIN_NOT_MET
 };
+
 /* An error code to error string mapping for the kernel
 *  error codes
 */
@@ -501,9 +506,9 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 		case BTRFS_ERROR_DEV_RAID10_MIN_NOT_MET:
 			return "unable to go below four devices on raid10";
 		case BTRFS_ERROR_DEV_RAID5_MIN_NOT_MET:
-			return "unable to go below two devices on raid5";
+			return "unable to go below two devices on raid5/par1";
 		case BTRFS_ERROR_DEV_RAID6_MIN_NOT_MET:
-			return "unable to go below three devices on raid6";
+			return "unable to go below three devices on raid6/par2";
 		case BTRFS_ERROR_DEV_TGT_REPLACE:
 			return "unable to remove the dev_replace target dev";
 		case BTRFS_ERROR_DEV_MISSING_NOT_FOUND:
@@ -513,6 +518,14 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
 		case BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS:
 			return "add/delete/balance/replace/resize operation "\
 				"in progress";
+		case BTRFS_ERROR_DEV_PAR3_MIN_NOT_MET:
+			return "unable to go below four devices on par3";
+		case BTRFS_ERROR_DEV_PAR4_MIN_NOT_MET:
+			return "unable to go below five devices on par4";
+		case BTRFS_ERROR_DEV_PAR5_MIN_NOT_MET:
+			return "unable to go below six devices on par5";
+		case BTRFS_ERROR_DEV_PAR6_MIN_NOT_MET:
+			return "unable to go below seven devices on par5";
 		default:
 			return NULL;
 	}
-- 
1.7.12.1

