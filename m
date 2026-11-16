Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788379;
	b=GwR2z65ebxT8tQXm54TrfD4BsS9itLXfbauu45afZ/J7LSTYym5ar/iccVz2AMgqkOiK
	 1x9nJdykjmkqoNtcsc+vZVNn9DXDT8SQsv78iKvxwyl56KPiTjbFwrd5U8sNPrgWUC46K
	 GkLKrFwBc3RfCtcUJHvVthUAAp3UYwuXHxpxl6krOkrYW8ARVWJSEMQ9xhp59fcWTg1bc
	 bprQuvzBfBVuptsQqcta5dfUZ90czWsjlnwHxqict1+cfyvNuLVnhxtqAlVkYRmYRXke+
	 k3lrXWVavTF+ZDeyrzj/6ECq9GaKids7zz2SIO3+MZNelA06h0TDS7DPXT+aLpeeRsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788379;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=9pkpJUlA+Pjn+QI+7UY2g15Pi6370Q1SasQb2h/Jn10=;
	b=W9jfBA37NLilqEnZjL6Y3IM4gdWjZjfTdxMgUzXa6noUnXXD/fN3d8ovZZkNMnpEBDdi
	 T6B6y4X8oO+tBiAgICgkgcq0ke3N+4iWm+zq/QqCaQT/KIWY38s76qHfdKe+eSDjvSIaK
	 55jSWJg7mcGBXEMmCLiyx6g1jOvvMOWkMxy/fB4BPWtE5neQbtpZy/RI+eeY4m9zC+K71
	 hbMC4aTy0YsXAXWMgZvwS0J3d4LrArBfFURALupgZkkWhnJDxbOTZ1lun3/+0b0e5tZdg
	 MYeFkvtWPrMcT+5hOmauofTy1Q9qmC7jLrQ6J73iWPcCrY6FEGqZs8tnlzYh9O6lX5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=pa9jN0LX;
	arc=none smtp.remote-ip=109.224.244.108
Received: from mail-244108.protonmail.ch (mail-244108.protonmail.ch [109.224.244.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA53606A330
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2026 00:19:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4FA53606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=pa9jN0LX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1794788375; x=1795047575;
	bh=9pkpJUlA+Pjn+QI+7UY2g15Pi6370Q1SasQb2h/Jn10=;
	h=From:To:Cc:Subject:Date:Message-ID:From:To:Cc:Date:Subject:
	 Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=pa9jN0LXyJelVMxDgnAV6Vk4rNG/YfdE9M64S+GlPWSQcdrfrMhBI17PN6Bbp5EDX
	 eAJbtJbhjfcPQ+dNaMsTtOY3AtWDDwLZp+ZybwwQlHlp7GWL7iYUalPCaq/I2G0WEy
	 FRunSNlvsdM+qOfVWHqbsZk0Ndz3kRETGNsxMLdPapHOM4ut4fLDFiYX5QoKtbdTfL
	 +xNcDCnRWX1lCo7U3sMKU5sZthZlLsPB1/g6knXJAvcvPh3Ztz0BvVDHptcdIKXBs0
	 aoBYf1wovjtNStZkVwrhAIE7SZ8Fe+ILlrgSDumbTWvBBB8l/ORW3N+c5i5YgRup5U
	 tyGYVqCqAx0og==
X-Pm-Submission-Id: 4jST4z3kh3z1DDLP
From: Miroslav Cimerman <mc@raidlab.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>,
	Chris Mason <mason@kernel.org>,
	Qu Wenruo <wqu@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] btrfs: raid56: fix use-after-free when waking up the rbio I/O waiter
Date: Mon, 16 Nov 2026 00:19:03 +0000
Message-ID: <20261116001903.63524-1-mc@raidlab.org>
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
atomic_read(&rbio->stripes_pending) == 0) and then can drop the last
reference to the rbio, which frees it.

If the submitter checks the condition after the last decrement and
before the wake_up(), it does not sleep at all:

  CPU0 (endio, irq)                  CPU1 (submitter, rmw_rbio)
  raid_wait_write_end_io()           rmw_rbio()
  |                                  |-submit_write_bios()
  |                                  | \-submit_bio()
  |                                  |
  |                                  |-wait_event()
  |-bio_put()                        | ^^^ checks the condition without
  |                                  |     taking io_wait.lock
  |-atomic_dec_and_test()            |
  | ^^^ stripes_pending hits 0       |
  |                                  | ^^^ sees 0, doesn't sleep
  |                                  |
  |                                  \-rbio_orig_end_io()
  |                                    \-kfree()
  |                                      ^^^ last rbio reference, rbio
  |                                          freed
  |
  \-wake_up()
    \-_raw_spin_lock_irqsave()
      ^^^ io_wait.lock is in freed memory
      Too late.

Even when the submitter sleeps, the wake-up takes it off the wait
queue, so finish_wait() returns without taking the queue's lock while
wake_up() still holds it:

  CPU0 (endio, irq)                  CPU1 (submitter, rmw_rbio)
  raid_wait_write_end_io()           rmw_rbio()
  |                                  \-wait_event()
  |                                    |-prepare_to_wait_event()
  |                                    \-schedule()
  |-atomic_dec_and_test()
  | ^^^ stripes_pending hits 0
  |
  \-wake_up()
    \-__wake_up_common_lock()
      |-_raw_spin_lock_irqsave()
      |-__wake_up_common()
      | ^^^ autoremove_wake_function()
      |     takes the waiter off the
      |     queue and wakes CPU1       finish_wait()
      |                                |-list_empty_careful()
      |                                | ^^^ entry already removed,
      |                                |     returns without taking
      |                                |     io_wait.lock
      |                                |
      |                                \-rbio_orig_end_io()
      |                                  \-kfree()
      |                                    ^^^ rbio freed
      |
      \-_raw_spin_unlock_irqrestore()
        ^^^ io_wait.lock is in freed memory
        Too late.

The same happens on the read side (raid_wait_read_end_io() and
submit_read_wait_bio_list()) and in the parity scrub. On 6.12.117
(bio_endio() and the end_io function are tail calls, so they do not
show in the trace):

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

Fixes: d817ce35d24a ("btrfs: raid56: switch recovery path to a single function")
Fixes: 5eb30ee26fa4 ("btrfs: raid56: introduce the main entrance for RMW path")
Fixes: 6bfd0133bee2 ("btrfs: raid56: switch scrub path to use a single function")
Cc: stable@vger.kernel.org # 6.2+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
Changes in v2:
- ASCII race charts (Qu)
- drop the FuzzyRAID sentence and the completion.h include (Qu)

Found with FuzzyRAID, a fault-injection tester for RAID that is not
public yet. The analysis, the fix, the tests and the commit message
were prepared with the help of an LLM. I reviewed everything.

The crash: 4 of 10,711 fault-injection scenarios on a 3-device data
RAID5 in QEMU (6.12.117). With KASAN on v7.4-rc2, a test-only delay
(20 ms between the last decrement and the wake-up, 0.5 ms before the
read wait) shows the use-after-free above in the first pass of reads
over the RAID5 with one device dead. With this patch and the same
delay there is no report and every block reads back correctly.

v1: https://lore.kernel.org/linux-btrfs/20261115232358.58163-1-mc@raidlab.org/
---
 fs/btrfs/raid56.c | 30 ++++++++++++++++++++++--------
 fs/btrfs/raid56.h |  3 ++-
 2 files changed, 24 insertions(+), 9 deletions(-)

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
index 8700910b8dc9..c86ffd655360 100644
--- a/fs/btrfs/raid56.h
+++ b/fs/btrfs/raid56.h
@@ -175,7 +175,8 @@ struct btrfs_raid_bio {
 
 	atomic_t stripes_pending;
 
-	wait_queue_head_t io_wait;
+	/* Completed by the last end_io when stripes_pending drops to zero. */
+	struct completion io_done;
 
 	/* Bitmap to record which horizontal stripe has data */
 	unsigned long dbitmap;

base-commit: 3aefd67f08f8ed59ed0fa90619b25856df415031
-- 
2.53.0

