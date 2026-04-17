Received: from out30-71.freemail.mail.aliyun.com (out30-71.freemail.mail.aliyun.com [115.124.30.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC22934DB7B;
	Fri, 17 Apr 2026 02:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776394324; cv=none; b=BSLh5cbSyoj0gpqmrpc2/PJQc0zxajxWY30BAWpxnG/MFqO7WHsniIxo+CSJcOQ7Y9jDdOw/KUZTqag8O3dcos03HIsPbqyYPmJPrP+UXkf2iu1UlyfcNFGSPc7akTGm5wD6qh8AB4mwY3IO1pQPY0xSmJ9D9+XOwqYUnps1Z+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776394324; c=relaxed/simple;
	bh=K79N5tOYUL+wtvj9gUjRKDva7lUXy9+AGdTdoyQGtCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s+pLRGCBpQvXoeHR78xeHn11XdDcKMSbHvKk/D2pYs7PDLz87qPzKGoRcFfjmn92KILG8xO9h9QGmK6sbjkn8Jge85Le/bVdU7ECJEXSFJa5qC73dCJKUBUdAfXQ5QRsY7ghNoNTCJTXOMSR85T5qcRv5DkNGtkP8+LIpGxZAg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=G0nDJCKR; arc=none smtp.client-ip=115.124.30.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="G0nDJCKR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1776394316; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=MpYk+L18ITpjpUvMt/NYKrzSvPcmsvHhxUXY2bYqr8E=;
	b=G0nDJCKRsqbxxBbrXQUlp+56Qm7WutHgeHdPUnVJEKXH3+x+ZmF4jwnnxWMgC7gX77gpRVS/DIoltsOIGcOGD/cULFyhT97p4imHFia9lQ8zKZMyvgqWho3PGWJI3voYlM5q47uT6R7B/jtewJUkVY6yQqFUtYm2YXqNlqJJQjc=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.07357559|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00957314-0.000734892-0.989692;FP=11435021075730546921|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=ruohanlan@aliyun.com;NM=1;PH=DS;RN=10;RT=10;SR=0;TI=SMTPD_---0X19nFyl_1776394314;
Received: from China-team(mailfrom:ruohanlan@aliyun.com fp:SMTPD_---0X19nFyl_1776394314 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 17 Apr 2026 10:51:55 +0800
From: Ruohan Lan <ruohanlan@aliyun.com>
To: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	naohiro.aota@wdc.com,
	wqu@suse.com,
	dsterba@suse.com,
	ruohanlan@aliyun.com,
	hch@lst.de,
	johannes.thumshirn@wdc.com
Subject: [PATCH 6.6.y 2/2] btrfs: fix error propagation of split bios
Date: Fri, 17 Apr 2026 10:51:16 +0800
Message-ID: <20260417025116.743-3-ruohanlan@aliyun.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260417025116.743-1-ruohanlan@aliyun.com>
References: <20260417025116.743-1-ruohanlan@aliyun.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit d48e1dea3931de64c26717adc2b89743c7ab6594 ]

The purpose of btrfs_bbio_propagate_error() shall be propagating an error
of split bio to its original btrfs_bio, and tell the error to the upper
layer. However, it's not working well on some cases.

* Case 1. Immediate (or quick) end_bio with an error

When btrfs sends btrfs_bio to mirrored devices, btrfs calls
btrfs_bio_end_io() when all the mirroring bios are completed. If that
btrfs_bio was split, it is from btrfs_clone_bioset and its end_io function
is btrfs_orig_write_end_io. For this case, btrfs_bbio_propagate_error()
accesses the orig_bbio's bio context to increase the error count.

That works well in most cases. However, if the end_io is called enough
fast, orig_bbio's (remaining part after split) bio context may not be
properly set at that time. Since the bio context is set when the orig_bbio
(the last btrfs_bio) is sent to devices, that might be too late for earlier
split btrfs_bio's completion.  That will result in NULL pointer
dereference.

That bug is easily reproducible by running btrfs/146 on zoned devices [1]
and it shows the following trace.

[1] You need raid-stripe-tree feature as it create "-d raid0 -m raid1" FS.

  BUG: kernel NULL pointer dereference, address: 0000000000000020
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: Oops: 0000 [#1] PREEMPT SMP PTI
  CPU: 1 UID: 0 PID: 13 Comm: kworker/u32:1 Not tainted 6.11.0-rc7-BTRFS-ZNS+ #474
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  Workqueue: writeback wb_workfn (flush-btrfs-5)
  RIP: 0010:btrfs_bio_end_io+0xae/0xc0 [btrfs]
  BTRFS error (device dm-0): bdev /dev/mapper/error-test errs: wr 2, rd 0, flush 0, corrupt 0, gen 0
  RSP: 0018:ffffc9000006f248 EFLAGS: 00010246
  RAX: 0000000000000000 RBX: ffff888005a7f080 RCX: ffffc9000006f1dc
  RDX: 0000000000000000 RSI: 000000000000000a RDI: ffff888005a7f080
  RBP: ffff888011dfc540 R08: 0000000000000000 R09: 0000000000000001
  R10: ffffffff82e508e0 R11: 0000000000000005 R12: ffff88800ddfbe58
  R13: ffff888005a7f080 R14: ffff888005a7f158 R15: ffff888005a7f158
  FS:  0000000000000000(0000) GS:ffff88803ea80000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000020 CR3: 0000000002e22006 CR4: 0000000000370ef0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  Call Trace:
   <TASK>
   ? __die_body.cold+0x19/0x26
   ? page_fault_oops+0x13e/0x2b0
   ? _printk+0x58/0x73
   ? do_user_addr_fault+0x5f/0x750
   ? exc_page_fault+0x76/0x240
   ? asm_exc_page_fault+0x22/0x30
   ? btrfs_bio_end_io+0xae/0xc0 [btrfs]
   ? btrfs_log_dev_io_error+0x7f/0x90 [btrfs]
   btrfs_orig_write_end_io+0x51/0x90 [btrfs]
   dm_submit_bio+0x5c2/0xa50 [dm_mod]
   ? find_held_lock+0x2b/0x80
   ? blk_try_enter_queue+0x90/0x1e0
   __submit_bio+0xe0/0x130
   ? ktime_get+0x10a/0x160
   ? lockdep_hardirqs_on+0x74/0x100
   submit_bio_noacct_nocheck+0x199/0x410
   btrfs_submit_bio+0x7d/0x150 [btrfs]
   btrfs_submit_chunk+0x1a1/0x6d0 [btrfs]
   ? lockdep_hardirqs_on+0x74/0x100
   ? __folio_start_writeback+0x10/0x2c0
   btrfs_submit_bbio+0x1c/0x40 [btrfs]
   submit_one_bio+0x44/0x60 [btrfs]
   submit_extent_folio+0x13f/0x330 [btrfs]
   ? btrfs_set_range_writeback+0xa3/0xd0 [btrfs]
   extent_writepage_io+0x18b/0x360 [btrfs]
   extent_write_locked_range+0x17c/0x340 [btrfs]
   ? __pfx_end_bbio_data_write+0x10/0x10 [btrfs]
   run_delalloc_cow+0x71/0xd0 [btrfs]
   btrfs_run_delalloc_range+0x176/0x500 [btrfs]
   ? find_lock_delalloc_range+0x119/0x260 [btrfs]
   writepage_delalloc+0x2ab/0x480 [btrfs]
   extent_write_cache_pages+0x236/0x7d0 [btrfs]
   btrfs_writepages+0x72/0x130 [btrfs]
   do_writepages+0xd4/0x240
   ? find_held_lock+0x2b/0x80
   ? wbc_attach_and_unlock_inode+0x12c/0x290
   ? wbc_attach_and_unlock_inode+0x12c/0x290
   __writeback_single_inode+0x5c/0x4c0
   ? do_raw_spin_unlock+0x49/0xb0
   writeback_sb_inodes+0x22c/0x560
   __writeback_inodes_wb+0x4c/0xe0
   wb_writeback+0x1d6/0x3f0
   wb_workfn+0x334/0x520
   process_one_work+0x1ee/0x570
   ? lock_is_held_type+0xc6/0x130
   worker_thread+0x1d1/0x3b0
   ? __pfx_worker_thread+0x10/0x10
   kthread+0xee/0x120
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x30/0x50
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  Modules linked in: dm_mod btrfs blake2b_generic xor raid6_pq rapl
  CR2: 0000000000000020

* Case 2. Earlier completion of orig_bbio for mirrored btrfs_bios

btrfs_bbio_propagate_error() assumes the end_io function for orig_bbio is
called last among split bios. In that case, btrfs_orig_write_end_io() sets
the bio->bi_status to BLK_STS_IOERR by seeing the bioc->error [2].
Otherwise, the increased orig_bio's bioc->error is not checked by anyone
and return BLK_STS_OK to the upper layer.

[2] Actually, this is not true. Because we only increases orig_bioc->errors
by max_errors, the condition "atomic_read(&bioc->error) > bioc->max_errors"
is still not met if only one split btrfs_bio fails.

* Case 3. Later completion of orig_bbio for un-mirrored btrfs_bios

In contrast to the above case, btrfs_bbio_propagate_error() is not working
well if un-mirrored orig_bbio is completed last. It sets
orig_bbio->bio.bi_status to the btrfs_bio's error. But, that is easily
over-written by orig_bbio's completion status. If the status is BLK_STS_OK,
the upper layer would not know the failure.

* Solution

Considering the above cases, we can only save the error status in the
orig_bbio (remaining part after split) itself as it is always
available. Also, the saved error status should be propagated when all the
split btrfs_bios are finished (i.e, bbio->pending_ios == 0).

This commit introduces "status" to btrfs_bbio and saves the first error of
split bios to original btrfs_bio's "status" variable. When all the split
bios are finished, the saved status is loaded into original btrfs_bio's
status.

With this commit, btrfs/146 on zoned devices does not hit the NULL pointer
dereference anymore.

Fixes: 852eee62d31a ("btrfs: allow btrfs_submit_bio to split bios")
CC: stable@vger.kernel.org # 6.6+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Ruohan Lan <ruohanlan@aliyun.com>
---
 fs/btrfs/bio.c | 37 +++++++++++++------------------------
 fs/btrfs/bio.h |  3 +++
 2 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 36b5ec9701d2..c074b3623e2c 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -51,6 +51,7 @@ void btrfs_bio_init(struct btrfs_bio *bbio, struct btrfs_fs_info *fs_info,
 	bbio->end_io = end_io;
 	bbio->private = private;
 	atomic_set(&bbio->pending_ios, 1);
+	WRITE_ONCE(bbio->status, BLK_STS_OK);
 }
 
 /*
@@ -122,41 +123,29 @@ static void __btrfs_bio_end_io(struct btrfs_bio *bbio)
 	}
 }
 
-static void btrfs_orig_write_end_io(struct bio *bio);
-
-static void btrfs_bbio_propagate_error(struct btrfs_bio *bbio,
-				       struct btrfs_bio *orig_bbio)
-{
-	/*
-	 * For writes we tolerate nr_mirrors - 1 write failures, so we can't
-	 * just blindly propagate a write failure here.  Instead increment the
-	 * error count in the original I/O context so that it is guaranteed to
-	 * be larger than the error tolerance.
-	 */
-	if (bbio->bio.bi_end_io == &btrfs_orig_write_end_io) {
-		struct btrfs_io_stripe *orig_stripe = orig_bbio->bio.bi_private;
-		struct btrfs_io_context *orig_bioc = orig_stripe->bioc;
-
-		atomic_add(orig_bioc->max_errors, &orig_bioc->error);
-	} else {
-		orig_bbio->bio.bi_status = bbio->bio.bi_status;
-	}
-}
-
 void btrfs_bio_end_io(struct btrfs_bio *bbio, blk_status_t status)
 {
 	bbio->bio.bi_status = status;
 	if (bbio->bio.bi_pool == &btrfs_clone_bioset) {
 		struct btrfs_bio *orig_bbio = bbio->private;
 
-		if (bbio->bio.bi_status)
-			btrfs_bbio_propagate_error(bbio, orig_bbio);
 		btrfs_cleanup_bio(bbio);
 		bbio = orig_bbio;
 	}
 
-	if (atomic_dec_and_test(&bbio->pending_ios))
+	/*
+	 * At this point, bbio always points to the original btrfs_bio. Save
+	 * the first error in it.
+	 */
+	if (status != BLK_STS_OK)
+		cmpxchg(&bbio->status, BLK_STS_OK, status);
+
+	if (atomic_dec_and_test(&bbio->pending_ios)) {
+		/* Load split bio's error which might be set above. */
+		if (status == BLK_STS_OK)
+			bbio->bio.bi_status = READ_ONCE(bbio->status);
 		__btrfs_bio_end_io(bbio);
+	}
 }
 
 static int next_repair_mirror(struct btrfs_failed_bio *fbio, int cur_mirror)
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index ca79decee060..264dda60a1cb 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -77,6 +77,9 @@ struct btrfs_bio {
 	/* File system that this I/O operates on. */
 	struct btrfs_fs_info *fs_info;
 
+	/* Save the first error status of split bio. */
+	blk_status_t status;
+
 	/*
 	 * This member must come last, bio_alloc_bioset will allocate enough
 	 * bytes for entire btrfs_bio but relies on bio being last.
-- 
2.43.0

