Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:3844 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932396AbcLLJiy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 04:38:54 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz, clm@fb.com
Subject: [PATCH 3/3] btrfs: raid56: Use correct stolen pages to calculate P/Q
Date: Mon, 12 Dec 2016 17:38:43 +0800
Message-Id: <20161212093843.8878-4-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161212093843.8878-1-quwenruo@cn.fujitsu.com>
References: <20161212093843.8878-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
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

The calltrace of such corruption is as following:

scrub_bio_end_io_worker() get called for each extent read out
|- scriub_block_complete()
   |- Data extent csum mismatch
   |- scrub_handle_errored_block
      |- scrub_recheck_block()
         |- scrub_submit_raid56_bio_wait()
            |- raid56_parity_recover()

Now we have a rbio with correct data stripe 1 recovered.
Let's call it "good_rbio".

scrub_parity_check_and_repair()
|- raid56_parity_submit_scrub_rbio()
   |- lock_stripe_add()
   |  |- steal_rbio()
   |     |- Recovered data are steal from "good_rbio", stored into
   |        rbio->stripe_pages[]
   |        Now rbio->bio_pages[] are bad data read from disk.
   |- async_scrub_parity()
      |- scrub_parity_work() (delayed_call to scrub_parity_work)

scrub_parity_work()
|- raid56_parity_scrub_stripe()
   |- validate_rbio_for_parity_scrub()
      |- finish_parity_scrub()
         |- Recalculate parity using *BAD* pages in rbio->bio_pages[]
            So good parity is overwritten with *BAD* one

The fix is to introduce 2 new members, bad_ondisk_a/b, to struct
btrfs_raid_bio, to info scrub code to use correct data pages to
re-calculate parity.

Reported-by: Goffredo Baroncelli <kreijack@inwind.it>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/raid56.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d2a9a1e..453eefd 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -133,6 +133,16 @@ struct btrfs_raid_bio {
 	/* second bad stripe (for raid6 use) */
 	int failb;
 
+	/*
+	 * For steal_rbio, we can steal recovered correct page,
+	 * but in finish_parity_scrub(), we still use bad on-disk
+	 * page to calculate parity.
+	 * Use these members to info finish_parity_scrub() to use
+	 * correct pages
+	 */
+	int bad_ondisk_a;
+	int bad_ondisk_b;
+
 	int scrubp;
 	/*
 	 * number of pages needed to represent the full
@@ -310,6 +320,12 @@ static void steal_rbio(struct btrfs_raid_bio *src, struct btrfs_raid_bio *dest)
 	if (!test_bit(RBIO_CACHE_READY_BIT, &src->flags))
 		return;
 
+	/* Record recovered stripe number */
+	if (src->faila != -1)
+		dest->bad_ondisk_a = src->faila;
+	if (src->failb != -1)
+		dest->bad_ondisk_b = src->failb;
+
 	for (i = 0; i < dest->nr_pages; i++) {
 		s = src->stripe_pages[i];
 		if (!s || !PageUptodate(s)) {
@@ -999,6 +1015,8 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	rbio->stripe_npages = stripe_npages;
 	rbio->faila = -1;
 	rbio->failb = -1;
+	rbio->bad_ondisk_a = -1;
+	rbio->bad_ondisk_b = -1;
 	atomic_set(&rbio->refs, 1);
 	atomic_set(&rbio->error, 0);
 	atomic_set(&rbio->stripes_pending, 0);
@@ -2261,6 +2279,9 @@ static int alloc_rbio_essential_pages(struct btrfs_raid_bio *rbio)
 	int bit;
 	int index;
 	struct page *page;
+	struct page *bio_page;
+	void *ptr;
+	void *bio_ptr;
 
 	for_each_set_bit(bit, rbio->dbitmap, rbio->stripe_npages) {
 		for (i = 0; i < rbio->real_stripes; i++) {
@@ -2271,6 +2292,23 @@ static int alloc_rbio_essential_pages(struct btrfs_raid_bio *rbio)
 			page = alloc_page(GFP_NOFS | __GFP_HIGHMEM);
 			if (!page)
 				return -ENOMEM;
+
+			/*
+			 * It's possible that only several pages need recover,
+			 * and rest are all good.
+			 * In that case we need to copy good bio pages into
+			 * stripe_pages[], as we will use stripe_pages[] other
+			 * than bio_pages[] in finish_parity_scrub().
+			 */
+			bio_page = page_in_rbio(rbio, i, bit, 0);
+			if ((i == rbio->bad_ondisk_a ||
+			     i == rbio->bad_ondisk_b) && bio_page) {
+				ptr = kmap(page);
+				bio_ptr = kmap(bio_page);
+				memcpy(ptr, bio_ptr, PAGE_SIZE);
+				kunmap(bio_page);
+				kunmap(page);
+			}
 			rbio->stripe_pages[index] = page;
 		}
 	}
@@ -2282,6 +2320,7 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 {
 	struct btrfs_bio *bbio = rbio->bbio;
 	void *pointers[rbio->real_stripes];
+	struct page *mapped_pages[rbio->real_stripes];
 	DECLARE_BITMAP(pbitmap, rbio->stripe_npages);
 	int nr_data = rbio->nr_data;
 	int stripe;
@@ -2342,12 +2381,24 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 		void *parity;
 		/* first collect one page from each data stripe */
 		for (stripe = 0; stripe < nr_data; stripe++) {
-			p = page_in_rbio(rbio, stripe, pagenr, 0);
+
+			/*
+			 * Use stolen recovered page other than bad
+			 * on disk pages
+			 */
+			if (stripe == rbio->bad_ondisk_a ||
+			    stripe == rbio->bad_ondisk_b)
+				p = rbio_stripe_page(rbio, stripe, pagenr);
+			else
+				p = page_in_rbio(rbio, stripe, pagenr, 0);
 			pointers[stripe] = kmap(p);
+			mapped_pages[stripe] = p;
 		}
 
 		/* then add the parity stripe */
-		pointers[stripe++] = kmap(p_page);
+		pointers[stripe] = kmap(p_page);
+		mapped_pages[stripe] = p_page;
+		stripe++;
 
 		if (q_stripe != -1) {
 
@@ -2355,7 +2406,9 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 			 * raid6, add the qstripe and call the
 			 * library function to fill in our p/q
 			 */
-			pointers[stripe++] = kmap(q_page);
+			pointers[stripe] = kmap(q_page);
+			mapped_pages[stripe] = q_page;
+			stripe++;
 
 			raid6_call.gen_syndrome(rbio->real_stripes, PAGE_SIZE,
 						pointers);
@@ -2375,8 +2428,9 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
 			bitmap_clear(rbio->dbitmap, pagenr, 1);
 		kunmap(p);
 
+		/* Free mapped pages */
 		for (stripe = 0; stripe < rbio->real_stripes; stripe++)
-			kunmap(page_in_rbio(rbio, stripe, pagenr, 0));
+			kunmap(mapped_pages[stripe]);
 	}
 
 	__free_page(p_page);
-- 
2.10.2



