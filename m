Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:44266 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754671AbeE2XpB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 May 2018 19:45:01 -0400
Received: by mail-pf0-f194.google.com with SMTP id q22-v6so8033631pff.11
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2018 16:45:01 -0700 (PDT)
Date: Tue, 29 May 2018 16:44:59 -0700
From: Kees Cook <keescook@chromium.org>
To: David Sterba <dsterba@suse.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: raid56: Remove VLA usage
Message-ID: <20180529234459.GA15302@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In the quest to remove all stack VLA usage from the kernel[1], this
allocates the working buffers during regular init, instead of using stack
space. This refactors the allocation code a bit to make it easier
to review.

[1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/btrfs/raid56.c | 38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 9abd950e7f78..5e4ad134b9ad 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -163,6 +163,12 @@ struct btrfs_raid_bio {
 	 * bitmap to record which horizontal stripe has data
 	 */
 	unsigned long *dbitmap;
+
+	/* allocated with real_stripes-many pointers for finish_*() calls */
+	void **finish_pointers;
+
+	/* allocated with stripe_npages-many bits for finish_*() calls */
+	unsigned long *finish_pbitmap;
 };
 
 static int __raid56_parity_recover(struct btrfs_raid_bio *rbio);
@@ -981,9 +987,14 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	int stripe_npages = DIV_ROUND_UP(stripe_len, PAGE_SIZE);
 	void *p;
 
-	rbio = kzalloc(sizeof(*rbio) + num_pages * sizeof(struct page *) * 2 +
-		       DIV_ROUND_UP(stripe_npages, BITS_PER_LONG) *
-		       sizeof(long), GFP_NOFS);
+	rbio = kzalloc(sizeof(*rbio) +
+		       sizeof(*rbio->stripe_pages) * num_pages +
+		       sizeof(*rbio->bio_pages) * num_pages +
+		       sizeof(*rbio->finish_pointers) * real_stripes +
+		       sizeof(*rbio->dbitmap) * BITS_TO_LONGS(stripe_npages) +
+		       sizeof(*rbio->finish_pbitmap) *
+				BITS_TO_LONGS(stripe_npages),
+		       GFP_NOFS);
 	if (!rbio)
 		return ERR_PTR(-ENOMEM);
 
@@ -1005,13 +1016,20 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	atomic_set(&rbio->stripes_pending, 0);
 
 	/*
-	 * the stripe_pages and bio_pages array point to the extra
+	 * the stripe_pages, bio_pages, etc arrays point to the extra
 	 * memory we allocated past the end of the rbio
 	 */
 	p = rbio + 1;
-	rbio->stripe_pages = p;
-	rbio->bio_pages = p + sizeof(struct page *) * num_pages;
-	rbio->dbitmap = p + sizeof(struct page *) * num_pages * 2;
+#define CONSUME_ALLOC(ptr, count)	do {				\
+		ptr = p;						\
+		p = (unsigned char *)p + sizeof(*(ptr)) * (count);	\
+	} while (0)
+	CONSUME_ALLOC(rbio->stripe_pages, num_pages);
+	CONSUME_ALLOC(rbio->bio_pages, num_pages);
+	CONSUME_ALLOC(rbio->finish_pointers, real_stripes);
+	CONSUME_ALLOC(rbio->dbitmap, BITS_TO_LONGS(stripe_npages));
+	CONSUME_ALLOC(rbio->finish_pbitmap, BITS_TO_LONGS(stripe_npages));
+#undef  CONSUME_ALLOC
 
 	if (bbio->map_type & BTRFS_BLOCK_GROUP_RAID5)
 		nr_data = real_stripes - 1;
@@ -1180,7 +1198,7 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
 static noinline void finish_rmw(struct btrfs_raid_bio *rbio)
 {
 	struct btrfs_bio *bbio = rbio->bbio;
-	void *pointers[rbio->real_stripes];
+	void **pointers = rbio->finish_pointers;
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
@@ -2350,8 +2368,8 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 					 int need_check)
 {
 	struct btrfs_bio *bbio = rbio->bbio;
-	void *pointers[rbio->real_stripes];
-	DECLARE_BITMAP(pbitmap, rbio->stripe_npages);
+	void **pointers = rbio->finish_pointers;
+	unsigned long *pbitmap = rbio->finish_pbitmap;
 	int nr_data = rbio->nr_data;
 	int stripe;
 	int pagenr;
-- 
2.17.0


-- 
Kees Cook
Pixel Security
