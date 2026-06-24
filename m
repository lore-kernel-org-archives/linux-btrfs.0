Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000B43D1AB9
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 17:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782323835; cv=none; b=omygZQNNNTe7DLBsxux7Wv/30C5DGEHwSjuetQEmdSdb9fVfcJ7ANVtqcdipvR2mkRbVOI/aqvTCqx3NufOIx8TAzVSjJ6/1yrrKulWzuLQBjKkc8RDrtLuXg3grf5bXTIKHZFobBi/6ERd8Qcbjy1WHo/sX1VfQhw1G9w6NrHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782323835; c=relaxed/simple;
	bh=mr172Z7GOiNA+w3TBrGrKG4+dop09qooDm2WRxoaAPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YUOW2G6I63m9xGTXVOsSYOZk7Wl3qOk65SH2OqVU+kc0h+TeTHCBZ/08K3EiF0sgevfqA4TT0d9YtTk0FxaEB+f12vssemPYE5yQowY35DPO8fgucSR0jSayDo7EeYY9gvmAQHsaxgk2ghjfeyhaypZJgRmTaHDQSne0MU9nq3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JcLanls4; arc=none smtp.client-ip=209.85.128.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JcLanls4"
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-806449d108aso17827437b3.2
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 10:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782323833; x=1782928633; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BQmP+LtEKLPdkxwyFl0EdO4cdBMUjfCmhp6jcLaLCuk=;
        b=JcLanls4PgQXxY9ObR51mWt/PjHXQIYyENselF9OOYj7t++HDZ9lD7TG9NImvA30+x
         5s4tqKn/syZXiZFwO1bSIxVpc+15zb6gx+vTKJaLDQt6PJyxyuTpjP37hihaqKJV2G7s
         wrBIkTzWsv7DXBa6qYebRdgH21OW682GUC8Xovd3VOxY069nd2YeYH7OxWMw6Dk72vlR
         lNzxvn9uxoHcsJlXWqTwfSdFY0lfx1aH1nLpLiwuto2hiFSZQ+pZ07Vhe24z41b9XYlA
         QYk3R+hqww6q9RyRbkDSFwKBWIV5PmmrctKD6Wl50+i1kFSD5RMjOO4wsZTnvmOVykqE
         DImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782323833; x=1782928633;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQmP+LtEKLPdkxwyFl0EdO4cdBMUjfCmhp6jcLaLCuk=;
        b=eGz1ekig0lWM2kev46w45GN0KZksYqgCtynpvqtuUc699lAJ3EoROtAjbe0y4f3P2s
         N6oRZ4c2fS/EC58Foq5N5xKzaLjz8t5V+EY7/5YYHoJG96AF2bXM+J2Y63/3Z06gi15x
         ZP7jhxWnQk6QYneeA1/sgX08+sCWsEjE6cyeoCb3xuIspUyIpWYZiZxXOUvdOIMwbADY
         30LTRXQQq77TkBkuBwOvjEPOdnqwX3Q4tK2ZDjHtwhrHzQlRNxGoVamROANc9MD5vLrr
         5UTzAUDQgXX0DFtPswWYLFcuetGQYMKi/DFdBx0IBxbSzgC/hzwmRnzNswgDxpUtEGKY
         4EaQ==
X-Gm-Message-State: AOJu0YxeIcrtSKHCYFtPzD8D0PSF5LJ8fPLVLvv61dGD9SyDFyOMymmR
	L+tSq9NDmqQXk0T0aSDXynob6ID+wQEsaQJNbpi3u2/09CqQnno9ndQtJnen2OdT
X-Gm-Gg: AfdE7cncS++BpimrZkEsXB9yOz7jdMYr3QFh4ATmy8N3105DqmLOCu+a7xYUw8FoP+R
	UZa92JaYz2DCiX02EGOORqWjX6YI1GF0hDIKcL3pXbTnlMTelIgnU1/PkHBhcgoCkdObiu3Mui3
	raFR9taKLgwAK3QF0R+UO2gxj/HarmREXcmWy/c8DyvK2A8vt17azn5QO/Q6YOnp5fnEpE8kCi0
	B5rxx4nzreg2ahYP6DaqGCYdO9s4MAnkX17p0NxAXPKeaBiYtwVvDfh3UXz4xlQOie+E/IYQAJ2
	87OKzf76AxnBtzz4e4rOxFT4AbBNnPfg8tkZ0jqLtil4d9/ARBESYCnfXjQyl9uhO33mt7SGhlL
	bmwPZMfvRPEY0UUh7+h4KbkZOD/CPBYwdZQf8SNj69aCBWGxjkNwdeQyJxBf6wgaKKAjMpfwT9T
	JDiKFSgg==
X-Received: by 2002:a05:690c:6b83:b0:7e1:fbf:aa7f with SMTP id 00721157ae682-807f457c17emr43073287b3.34.1782323832814;
        Wed, 24 Jun 2026 10:57:12 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:3::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-802606a918bsm61914377b3.43.2026.06.24.10.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 10:57:12 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	David Sterba <dsterba@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	Sun YangKai <sunk67188@gmail.com>
Cc: kernel test robot <oliver.sang@intel.com>
Subject: [PATCH] btrfs: replace writeback inhibition xarray with a fixed inline buffer
Date: Wed, 24 Jun 2026 10:57:03 -0700
Message-ID: <e0d3d3ac7c585b023c2e14cec7e2b995b247b68e.1781728340.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit f9a48549a15a ("btrfs: inhibit extent buffer writeback to prevent
COW amplification") tracks the extent buffers a transaction handle has
inhibited in a per-handle xarray. Keying the tracking to the transaction
handle is correct, but using an xarray for it causes two problems in
production.

First, a write_iops regression. Every COW calls
btrfs_inhibit_eb_writeback() from btrfs_force_cow_block() and
should_cow_block(), which does an xa_store() keyed by eb->start. The
kernel test robot reported a 22.6% fio.write_iops regression on a
single-task 4k randwrite workload (ftruncate ioengine, buffered IO) on
btrfs. The cost is the per-COW xarray store done on every COW'd block.
Replacing it with a non-allocating fixed buffer recovers the lost
throughput, and that buffer does more per-COW bookkeeping yet still
recovers, so the cost is the xarray operation itself rather than the
extra tracking work.

Second, an unbounded cleanup walk. btrfs_uninhibit_all_eb_writeback()
iterates every eb the handle inhibited with xa_for_each(). A single
handle that COWs a very large number of blocks (inode eviction, or
truncate of a file with many extents, where btrfs_truncate_inode_items()
loops over many search_again descents under one handle) makes that walk
arbitrarily long. It runs in __btrfs_end_transaction() before
num_writers is dropped, so it blocks the committing thread; this shows up
as multi-second stalls and RCU stall reports.

Replace the xarray with a fixed inline array on btrfs_trans_handle,
managed with a CLOCK (second-chance) eviction policy. Inhibiting a buffer
becomes an array append with no allocation and no tree walk, and the
end-of-handle cleanup is bounded by the array size.

The set that actually needs protection is the working set the handle
revisits across search_again descents, the search path frontier, which is
on the order of the tree height. It is not every block the handle ever
COWs. should_cow_block() re-inhibiting an already tracked buffer marks it
referenced, so revisited buffers survive eviction while write-once buffers
are reclaimed first. A small fixed buffer is therefore enough where a
non-evicting array would either overflow or have to grow without bound.
BTRFS_INHIBITED_EBS_SLOTS is 8 and the reference bits pack into a u32.

The CLOCK eviction is what justifies the extra complexity over a plain
non-evicting array. On a workload built to stress amplification, removing
16 heavily fragmented 64 MiB files in one transaction while background
writeback keeps writing out in-use metadata, counting re-COW events (a
buffer already COWed in the running transaction, written back, then COWed
again) against first-COW events and summing across the eviction (n=5),
re-COWs outnumber first COWs about 6.1 to 1 with no inhibition, 3.8 to 1
with a non-evicting array of 32 slots, 1.6 to 1 with this 8 slot CLOCK
array, and 1.4 to 1 with the reverted unbounded xarray. The non-evicting
array fills with write-once buffers and stops covering the buffers the
handle keeps revisiting, so even at four times the slots it leaves most of
the amplification. CLOCK evicts the cold buffers and keeps the revisited
ones, which recovers almost all of the unbounded benefit. The eviction
policy, not the buffer size, is what closes the gap.

eb->writeback_inhibitors and the WB_SYNC_ALL bypass in
lock_extent_buffer_for_io() are unchanged, so fsync and commit behavior
are unaffected. A reference is taken on each tracked buffer so it cannot
be freed while the array points at it; eviction drops that reference and
the inhibitor count.

Fixes: f9a48549a15a ("btrfs: inhibit extent buffer writeback to prevent COW amplification")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202603112240.f7605968-lkp@intel.com
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
---
 fs/btrfs/extent_io.c   | 78 +++++++++++++++++++++++++-----------------
 fs/btrfs/transaction.c |  2 --
 fs/btrfs/transaction.h | 15 ++++++--
 3 files changed, 59 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9d7ca80477fd..1845a617fb10 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2988,41 +2988,58 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
  * @trans:  transaction handle that will own the inhibitor
  * @eb:      extent buffer to inhibit writeback on
  *
- * Attempt to track this extent buffer in the transaction's inhibited set.  If
- * memory allocation fails, the buffer is simply not tracked. It may be written
- * back and need re-COW, which is the original behavior.  This is acceptable
- * since inhibiting writeback is an optimization.
+ * Attempt to track this extent buffer in the transaction's inhibited set.  When
+ * the set is full the coldest tracked buffer is evicted instead.  An untracked
+ * buffer may be written back and need re-COW, which is the original behavior.
+ * This is acceptable since inhibiting writeback is an optimization.
  */
-void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans, struct extent_buffer *eb)
+void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans,
+				struct extent_buffer *eb)
 {
-	unsigned long index = eb->start >> trans->fs_info->nodesize_bits;
-	void *old;
+	u32 slot;
 
 	lockdep_assert_held(&eb->lock);
-	/* Check if already inhibited by this handle. */
-	old = xa_load(&trans->writeback_inhibited_ebs, index);
-	if (old == eb)
-		return;
-
-	/* Take reference for the xarray entry. */
-	refcount_inc(&eb->refs);
 
-	old = xa_store(&trans->writeback_inhibited_ebs, index, eb, GFP_NOFS);
-	if (xa_is_err(old)) {
-		/* Allocation failed, just skip inhibiting this buffer. */
-		free_extent_buffer(eb);
-		return;
+	/* Already tracked: set its reference bit (second chance) and return. */
+	for (u32 i = 0; i < trans->nr_inhibited_ebs; i++) {
+		if (trans->inhibited_ebs[i] == eb) {
+			trans->inhibited_ebs_referenced |= 1U << i;
+			return;
+		}
 	}
 
-	/* Handle replacement of different eb at same index. */
-	if (old && old != eb) {
-		struct extent_buffer *old_eb = old;
+	if (trans->nr_inhibited_ebs < BTRFS_INHIBITED_EBS_SLOTS) {
+		slot = trans->nr_inhibited_ebs++;
+	} else {
+		/*
+		 * Full: advance the CLOCK hand, clearing reference bits until a
+		 * slot without one is found and evicted. Clearing a bit per step
+		 * bounds this to BTRFS_INHIBITED_EBS_SLOTS iterations.
+		 */
+		while (trans->inhibited_ebs_referenced &
+		       (1U << trans->inhibited_ebs_hand)) {
+			trans->inhibited_ebs_referenced &=
+				~(1U << trans->inhibited_ebs_hand);
+			trans->inhibited_ebs_hand =
+				(trans->inhibited_ebs_hand + 1) %
+				BTRFS_INHIBITED_EBS_SLOTS;
+		}
+		slot = trans->inhibited_ebs_hand;
+		trans->inhibited_ebs_hand =
+			(trans->inhibited_ebs_hand + 1) % BTRFS_INHIBITED_EBS_SLOTS;
 
-		atomic_dec(&old_eb->writeback_inhibitors);
-		free_extent_buffer(old_eb);
+		atomic_dec(&trans->inhibited_ebs[slot]->writeback_inhibitors);
+		free_extent_buffer(trans->inhibited_ebs[slot]);
 	}
 
+	/*
+	 * Pin the eb while the array holds a raw pointer to it; the counter is
+	 * what lock_extent_buffer_for_io() checks.
+	 */
+	refcount_inc(&eb->refs);
 	atomic_inc(&eb->writeback_inhibitors);
+	trans->inhibited_ebs[slot] = eb;
+	trans->inhibited_ebs_referenced |= 1U << slot;
 }
 
 /*
@@ -3030,14 +3047,13 @@ void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans, struct extent_
  */
 void btrfs_uninhibit_all_eb_writeback(struct btrfs_trans_handle *trans)
 {
-	struct extent_buffer *eb;
-	unsigned long index;
-
-	xa_for_each(&trans->writeback_inhibited_ebs, index, eb) {
-		atomic_dec(&eb->writeback_inhibitors);
-		free_extent_buffer(eb);
+	for (u32 i = 0; i < trans->nr_inhibited_ebs; i++) {
+		atomic_dec(&trans->inhibited_ebs[i]->writeback_inhibitors);
+		free_extent_buffer(trans->inhibited_ebs[i]);
 	}
-	xa_destroy(&trans->writeback_inhibited_ebs);
+	trans->nr_inhibited_ebs = 0;
+	trans->inhibited_ebs_referenced = 0;
+	trans->inhibited_ebs_hand = 0;
 }
 
 static struct extent_buffer *__alloc_extent_buffer(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 4358f4b63057..b4b8d587effb 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -697,8 +697,6 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 		goto alloc_fail;
 	}
 
-	xa_init(&h->writeback_inhibited_ebs);
-
 	/*
 	 * If we are JOIN_NOLOCK we're already committing a transaction and
 	 * waiting on this guy, so we don't need to do the sb_start_intwrite
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 7d70fe486758..8f628d79d4f0 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -12,7 +12,6 @@
 #include <linux/time64.h>
 #include <linux/mutex.h>
 #include <linux/wait.h>
-#include <linux/xarray.h>
 #include "btrfs_inode.h"
 #include "delayed-ref.h"
 
@@ -23,6 +22,7 @@ struct btrfs_fs_info;
 struct btrfs_root_item;
 struct btrfs_root;
 struct btrfs_path;
+struct extent_buffer;
 
 /*
  * Signal that a direct IO write is in progress, to avoid deadlock for sync
@@ -136,6 +136,12 @@ enum {
 
 #define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
 
+/*
+ * Must stay <= 32: the CLOCK reference bits pack into the u32
+ * inhibited_ebs_referenced.
+ */
+#define BTRFS_INHIBITED_EBS_SLOTS	8
+
 struct btrfs_trans_handle {
 	u64 transid;
 	u64 bytes_reserved;
@@ -163,8 +169,11 @@ struct btrfs_trans_handle {
 	struct btrfs_fs_info *fs_info;
 	struct list_head new_bgs;
 	struct btrfs_block_rsv delayed_rsv;
-	/* Extent buffers with writeback inhibited by this handle. */
-	struct xarray writeback_inhibited_ebs;
+	/* Extent buffers this handle has inhibited writeback on. */
+	struct extent_buffer *inhibited_ebs[BTRFS_INHIBITED_EBS_SLOTS];
+	u32 inhibited_ebs_referenced;	/* CLOCK reference bit per slot */
+	u32 nr_inhibited_ebs;
+	u8 inhibited_ebs_hand;		/* CLOCK hand */
 };
 
 /*
-- 
2.53.0-Meta

