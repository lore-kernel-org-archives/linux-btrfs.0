Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:62874 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752476AbcKUIuz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Nov 2016 03:50:55 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: kreijack@inwind.it, ce3g8jdj@umail.furryterror.org
Subject: [PATCH] btrfs: raid56: Use correct stolen pages to calculate P/Q
Date: Mon, 21 Nov 2016 16:50:16 +0800
Message-Id: <20161121085016.7148-1-quwenruo@cn.fujitsu.com>
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
Thanks to the above hell of delayed function all and damn stupid code
logical, such bug is quite hard to trace.

The damn kernel scrub is already multi-thread, why do such meaningless
delayed function call again and again?

What's wrong with single thread scrub?
We can do thing like in each stripe for raid56 which is easy and
straightforward, only delayed thing is to wake up waiter:

	lock_full_stripe()
	if (!is_parity_stripe()) {
		prepare_data_stripe_bios()
		submit_and_wait_bios()
		if (check_csum() == 0)
			goto out;
	}
	prepare_full_stripe_bios()
	submit_and_wait_bios()

	recover_raid56_stipres();
	prepare_full_stripe_write_bios()
	submit_and_wait_bios()

out:
  	unlock_full_stripe()

We really need to re-work the whole damn scrub code.

Also, we need to enhance btrfs-progs to detect scrub problem(my
submitted offline scrub is good enough for such usage), and tools to
corrupt extents reliably to put it into xfstests test cases.

RAID56 scrub code is neither tested nor well-designed.
---
 fs/btrfs/raid56.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index d016d4a..87e3565 100644
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
@@ -998,6 +1014,8 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_root *root,
 	rbio->stripe_npages = stripe_npages;
 	rbio->faila = -1;
 	rbio->failb = -1;
+	rbio->bad_ondisk_a = -1;
+	rbio->bad_ondisk_b = -1;
 	atomic_set(&rbio->refs, 1);
 	atomic_set(&rbio->error, 0);
 	atomic_set(&rbio->stripes_pending, 0);
@@ -2352,7 +2370,16 @@ static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
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
 		}
 
-- 
2.10.2



