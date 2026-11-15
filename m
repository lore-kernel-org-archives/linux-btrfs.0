Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785064;
	b=XIK+YSUSRqvx5HrGkn/XeE2fX2DhotN+EksR+ATgtBCJ1XSBm2Ph3QR7giHw7t6lUNGj
	 ZWqlKMZzeAhMkFEX01XfWrLOH0xdhpGvIGP4jgQo0Kq5gfJeQk0Mjm5rjWyylOtMEBHyT
	 IpBplQHjMSTd/wL6FGH+hhBcBE9xvZyZEdJ55C6WFyEkVTZCz9QEWGCGMQ11P9BJ2jj87
	 /Hmr1i1tYKSE/11RAlRQZOfNE36GkTBmyuyZlQeIWljhl5aKRUubcNLpReMXWfOa6vd8H
	 Axg6RagHH1SbmcqbwqSHU+oHXL2FylNvLTwHrp1AfzAr4ZFyd2hgq1j4gl6y8sWPWSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785064;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zIRCMnCmh0TbW9Y3nfJjlNJQfeeJ3tQBoST3rj6Xuhw=;
	b=aS0pcdPlPMLxuQEU6gQtx6xeMmfkdt7YneafOqytzSruz8+jDNz4/eJRLPZ32QEJvAJt
	 u44Slw75v+UUyZbgoBKFrJ+p5Vcdl4xoeMNfKRx8qDCPHtlIyPaE4dYzBhYFOZQ+pCIWq
	 UukJCIZz41gosXhN5l1PsvpZR/wvVorIhXVXeAJKh4lMOaxGA6hHXVZQDwUEjpy3wkLJx
	 /b4wE01PHhpmm21xf4IZjWXksHgOxEvBVy66NjL51M+33TT9ph93Pjr5ytmAroNeAvpGg
	 18jTcbhE3J7ijk4WpyhQqu/90WHFWBdvSrLHnkirZZKpjqfgHB9G86HNAR1RQdXWqNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=hGiMC94b;
	arc=none smtp.remote-ip=185.70.43.171
Received: from mail-43171.protonmail.ch (mail-43171.protonmail.ch [185.70.43.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4E5606A31F
	for <linux-btrfs@vger.kernel.org>; Sun, 15 Nov 2026 23:24:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B4E5606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=hGiMC94b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1794785060; x=1795044260;
	bh=zIRCMnCmh0TbW9Y3nfJjlNJQfeeJ3tQBoST3rj6Xuhw=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=hGiMC94bZXbyf8rQVvkDJrHhY3ZgkNPcgFNdVXOopKogfIoh4PYNfUUsMBOOthRlD
	 BBg1jH3xCgf7oOTCVNEAqGuiXsm97gOZlYLET95RFip9H78LYl4gwrIpr18hLzwv1l
	 mK72QJmSWpl3EMgC7Im9QMYY+Ev/w1jLgkh40/u9sd/gm+6LKrxP9Oro3l+LvqDUHe
	 bSUXO8rNUtxajPOWgIlbKXXg8Ahz+NfnEEpGE/slzq89DD3xomq1VmJyZLoZTL55fD
	 4DNncxwGmOK53rv854LQzNSueAe2ZRtnoDjsp1wXCR4MheANTCTGZtZhZkDQ+STwE1
	 SLEuE3B5f31yg==
X-Pm-Submission-Id: 4jSRsF0L0nz1DDLP
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] btrfs: raid56: fix use-after-free when waking up the rbio I/O waiter
Date: Sun, 15 Nov 2026 23:23:57 +0000
Message-ID: <20261115232358.58163-1-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The end_io functions of the RAID56 read and write bios decrement
rbio->stripes_pending and call wake_up(&rbio->io_wait) when it drops
to zero. The submitter waits with wait_event(rbio->io_wait,
atomic_read(&rbio->stripes_pending) == 0).

wait_event() checks the condition before it sleeps, without the wait
queue's lock. If the submitter checks it after the last decrement and
before the wake_up(), it does not sleep, finishes the operation and
can drop the last reference to the rbio, which frees it. Even when
the submitter sleeps, the wake-up removes it from the wait queue, so
finish_wait() returns without taking the queue's lock while wake_up()
may still hold it. Either way, wake_up() then uses a wait queue in
freed memory, in interrupt context. On 6.12.117 (bio_endio() and the
end_io function are tail calls, so they do not show in the trace):

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: 0010:__wake_up_common+0x25/0xa0
  Call Trace:
   <IRQ>
   __wake_up+0x31/0x60
   blk_update_request+0xfd/0x410
   blk_mq_end_request+0x1d/0x1a0
  Kernel panic - not syncing: Fatal exception in interrupt

With KASAN on v7.4-rc2 and a test-only delay between the decrement
and the wake-up:

  BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x76/0xe0
   __wake_up+0x1c/0x60
   raid_wait_read_end_io+0x132/0x10f0
   blk_update_request+0x21e/0xea0
  Allocated by task 82:
   alloc_rbio.isra.0+0xa8/0xbf0
   raid56_parity_recover+0x10a/0x9c0
  Freed by task 84:
   kfree+0x154/0x420
   rbio_orig_end_io+0x1c4/0x340
   recover_rbio+0x393/0x590

Wait with a completion instead. complete() wakes the waiter under the
completion's lock and does not touch it afterwards, and
wait_for_completion() returns only after taking that lock, so the
rbio may be freed as soon as the wait returns. The parity scrub waits
for its writes only when finish_parity_scrub() submitted them.

Found with FuzzyRAID, a fault-injection tester for RAID.

Fixes: d817ce35d24a ("btrfs: raid56: switch recovery path to a single function")
Fixes: 5eb30ee26fa4 ("btrfs: raid56: introduce the main entrance for RMW path")
Fixes: 6bfd0133bee2 ("btrfs: raid56: switch scrub path to use a single function")
Cc: stable@vger.kernel.org # 6.2+
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
FuzzyRAID is not public yet. The analysis, the fix, the tests and the
commit message were prepared with the help of an LLM. I reviewed
everything.

The crash: 4 of 10,711 fault-injection scenarios on a 3-device data
RAID5 in QEMU (6.12.117). With KASAN on v7.4-rc2, a test-only delay
(20 ms between the last decrement and the wake-up, 0.5 ms before the
read wait) shows the use-after-free above in the first pass of reads
over the RAID5 with one device dead. With this patch and the same
delay there is no report and every block reads back correctly.
---
 fs/btrfs/raid56.c | 30 ++++++++++++++++++++++--------
 fs/btrfs/raid56.h |  4 +++-
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index a8a8004bb14c..60f270c3a339 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1019,7 +1019,7 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	}
 
 	bio_list_init(&rbio->bio_list);
-	init_waitqueue_head(&rbio->io_wait);
+	init_completion(&rbio->io_done);
 	INIT_LIST_HEAD(&rbio->plug_list);
 	spin_lock_init(&rbio->bio_list_lock);
 	INIT_LIST_HEAD(&rbio->stripe_cache);
@@ -1619,7 +1619,19 @@ static void raid_wait_read_end_io(struct bio *bio)
 
 	bio_put(bio);
 	if (atomic_dec_and_test(&rbio->stripes_pending))
-		wake_up(&rbio->io_wait);
+		complete(&rbio->io_done);
+}
+
+/*
+ * Prepare to wait for the nr bios about to be submitted. With none there is
+ * nothing to wait for.
+ */
+static void rbio_prepare_io_wait(struct btrfs_raid_bio *rbio, int nr)
+{
+	reinit_completion(&rbio->io_done);
+	atomic_set(&rbio->stripes_pending, nr);
+	if (nr == 0)
+		complete(&rbio->io_done);
 }
 
 static void submit_read_wait_bio_list(struct btrfs_raid_bio *rbio,
@@ -1627,7 +1639,7 @@ static void submit_read_wait_bio_list(struct btrfs_raid_bio *rbio,
 {
 	struct bio *bio;
 
-	atomic_set(&rbio->stripes_pending, bio_list_size(bio_list));
+	rbio_prepare_io_wait(rbio, bio_list_size(bio_list));
 	while ((bio = bio_list_pop(bio_list))) {
 		bio->bi_end_io = raid_wait_read_end_io;
 
@@ -1640,7 +1652,7 @@ static void submit_read_wait_bio_list(struct btrfs_raid_bio *rbio,
 		submit_bio(bio);
 	}
 
-	wait_event(rbio->io_wait, atomic_read(&rbio->stripes_pending) == 0);
+	wait_for_completion_io(&rbio->io_done);
 }
 
 static int alloc_rbio_data_pages(struct btrfs_raid_bio *rbio)
@@ -2329,7 +2341,7 @@ static void raid_wait_write_end_io(struct bio *bio)
 		rbio_update_error_bitmap(rbio, bio);
 	bio_put(bio);
 	if (atomic_dec_and_test(&rbio->stripes_pending))
-		wake_up(&rbio->io_wait);
+		complete(&rbio->io_done);
 }
 
 static void submit_write_bios(struct btrfs_raid_bio *rbio,
@@ -2337,7 +2349,7 @@ static void submit_write_bios(struct btrfs_raid_bio *rbio,
 {
 	struct bio *bio;
 
-	atomic_set(&rbio->stripes_pending, bio_list_size(bio_list));
+	rbio_prepare_io_wait(rbio, bio_list_size(bio_list));
 	while ((bio = bio_list_pop(bio_list))) {
 		bio->bi_end_io = raid_wait_write_end_io;
 
@@ -2444,7 +2456,7 @@ static void rmw_rbio(struct btrfs_raid_bio *rbio)
 	/* We should have at least one bio assembled. */
 	ASSERT(bio_list_size(&bio_list));
 	submit_write_bios(rbio, &bio_list);
-	wait_event(rbio->io_wait, atomic_read(&rbio->stripes_pending) == 0);
+	wait_for_completion_io(&rbio->io_done);
 
 	/* We may have more errors than our tolerance during the read. */
 	for (sectornr = 0; sectornr < rbio->stripe_nsectors; sectornr++) {
@@ -2915,7 +2927,9 @@ static void scrub_rbio(struct btrfs_raid_bio *rbio)
 	 * and writeback the good content.
 	 */
 	ret = finish_parity_scrub(rbio);
-	wait_event(rbio->io_wait, atomic_read(&rbio->stripes_pending) == 0);
+	/* It submitted its writes if and only if it returned 0. */
+	if (ret == 0)
+		wait_for_completion_io(&rbio->io_done);
 	for (sector_nr = 0; sector_nr < rbio->stripe_nsectors; sector_nr++) {
 		int found_errors;
 
diff --git a/fs/btrfs/raid56.h b/fs/btrfs/raid56.h
index 8700910b8dc9..6c82a975eb68 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -12,6 +12,7 @@
 #include <linux/spinlock.h>
 #include <linux/bio.h>
 #include <linux/refcount.h>
+#include <linux/completion.h>
 #include <linux/workqueue.h>
 #include "volumes.h"
 
@@ -175,7 +176,8 @@ struct btrfs_raid_bio {
 
 	atomic_t stripes_pending;
 
-	wait_queue_head_t io_wait;
+	/* Completed by the last end_io when stripes_pending drops to zero. */
+	struct completion io_done;
 
 	/* Bitmap to record which horizontal stripe has data */
 	unsigned long dbitmap;

base-commit: 3aefd67f08f8ed59ed0fa90619b25856df415031
-- 
2.53.0

