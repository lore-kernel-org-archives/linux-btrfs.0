Received: from mail-yx2-f1.google.com (mail-yx2-f1.google.com [74.125.224.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323F3356759
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 23:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782949636; cv=none; b=h9d7XOkwc3H+lK/5XGPmj2AzIj2aBs5NC3eus2b6h1wh4thlFpuG4gLEjuQx6QlN2HBfkEe2bUwWdZ0JzV5woAixJn8YKH0m+zxJVr3E58Sgv5RgCxHAlU5J+Ppw3SiX2FiKu/B+EsOppSHtso+lpQ7RBbFlojF8IAsV3w68k2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782949636; c=relaxed/simple;
	bh=Ovo6thZfoTj+wJ72HLhzzoCQZa/MM6BWIY0EkLPgHq0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d6NoLuY8WcjMNKyRWHwZYtd0R5zVglUfc6PqitB8dcHBscAMqdLcQrf9GymKqEuvJJllMx4+jur2xJTdCnRkdar10pdbhX7Y+xE+M3tc8C2+f6fiuBiChhEWIgAegNWAGEY2BRSxU16/rWkbS7hzRiGA3td/AyPQqwkaOEeqCJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eT/TBBlg; arc=none smtp.client-ip=74.125.224.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eT/TBBlg"
Received: by mail-yx2-f1.google.com with SMTP id 00721157ae682-80247dc83e0so8757657b3.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 16:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782949633; x=1783554433; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dv224JNw24oDXgTnp7Xqr6pWwOmraj367ykV1xwtZjM=;
        b=eT/TBBlgeNWmM4Iuvthq+llzUYvZCbooLP6TcNfAmf6PtphNgSx0djCg9SV/UNTZi/
         GHuOCBE2gnt58HxzKI5K/Hx6HDgxMoVF5K+/UIqHXAAC6VHHwoW0TZJaGiSKOb8KhJq6
         TLpoX34EPcGtea1gBwXqb1r53N1fFxPwlD9nz9E9UGDH2Yj3B5C+a/lb2LYuO9nfIv3i
         oV9Rt1hrJcR2rW0//vtBeoLSy8fU7vmFKFaVnhZC8/wIl++ni3PW7MO56tI4QHSz7DdW
         UWwX54b7cASgH2Xss9Ku/EHnWb2vmvDAbFUe8LAAKTDaw5Z9revjO0j/DZBqMhnvmAEC
         ln5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782949633; x=1783554433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dv224JNw24oDXgTnp7Xqr6pWwOmraj367ykV1xwtZjM=;
        b=V9p9rhhnmAWlLviTPeVoxuINbtDk1IKZB17iDp3EweNZ1OfE3TtjR3ipcLZN99Bliq
         416D7YMtJ5ZcUZd/CjHgh9p7bNIFz96dL1xy68GV5wGv5s18GHLJK4R9vwNKmkZsBbZc
         tKqiAyEP90IldiGn71lUy74LyhT8ZI85EN8ckb+6lMG/O5puR2EhJGrDSOE1/ad0ArXW
         8XjoiSVpbhuYbQCYNIBkF4vR8zTGYOBSerNZtPQ7gGAurfNA8X+OuS0izM7tnn4CubZZ
         Q6PbLtbICkCTkA8ClNfUTwG4EBPwPkc9jXktLmxSNt3SrbSinXZ+VAXW7fcR0A7V2n8t
         A49w==
X-Forwarded-Encrypted: i=1; AHgh+Rq3y1Ac1KSsHAJ9aWRS3yzj5ImGj9AuU0w7StuNkhPdYYksmuIiI05nh6gKbl308Zh1ib8QZyeaNRLOrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjMj+0ThmqYungIaOP2cUihQxJgKnKHRyutWxhjuCIZRNO98Av
	QWtCfMmf/OOsmMeSvJARe20tw3YJ5T3kfiNBSctRfdiA+LnA7qgPRXaO
X-Gm-Gg: AfdE7cm6jyQJVcHqhabb8zAjQxUBNGDWfarsWltAuqIm9mx4UkZ7tQuMAjaHwGkEEiR
	9ObkfFSICuhOCHl8Fne5KELw53pXwLgzHz0bcHl2qfdpZT5kYmHjaIJpJ2G4QsmVNQBz+kTCrUY
	DldH15FdaTz+SKE4QTTBXQfamCvsWHcEw0fSYshE1k1C4XqXtD9ZWcajDcXgGo9WGtbkYzGYV0u
	7wixOysjF17l0VQJeADVmsq81O+32t8IJ56cT+PCmANXc4S8AcyQWquJOOM7QcoMd+iCp66SSEa
	jyptI8uKTTK3dS9qjzKh2oUUqzDTlYsaxyxLGfDcDqoNn4u7KgeCwFl/8SWRqsXk4e80No3fld4
	fyGqUnbXbfljU4bCGutXF7Mexq68pTsnPw0VyTp8olRWFj7BSLmYPVQrOzMjaeeG5LCacTooFKV
	ijlaB15A==
X-Received: by 2002:a05:690c:6a0c:b0:80c:e8d3:114e with SMTP id 00721157ae682-812eae80502mr45443477b3.38.1782949633151;
        Wed, 01 Jul 2026 16:47:13 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81448dd0217sm6235517b3.22.2026.07.01.16.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 16:47:12 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	Sun YangKai <sunk67188@gmail.com>,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v2] btrfs: replace writeback inhibition xarray with a fixed inline buffer
Date: Wed,  1 Jul 2026 16:47:10 -0700
Message-ID: <12d3c3f07b8610ca13b0f3f792d420541afb7b33.1782949130.git.loemra.dev@gmail.com>
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
non-evicting array. The test workload stresses amplification: it removes
16 heavily fragmented 64 MiB files in one transaction while background
writeback keeps writing out in-use metadata. A re-COW event is a buffer
already COWed in the running transaction that was written back and then
COWed again; the figure below is the ratio of re-COW events to first-COW
events summed across the eviction (n=5, lower is better):

  tracking                           re-COW per first-COW
  no inhibition                      6.1
  non-evicting array, 32 slots       3.8
  CLOCK array, 8 slots (this patch)  1.6
  unbounded xarray (reverted)        1.4

The non-evicting array fills with write-once buffers and stops covering
the buffers the handle keeps revisiting, so even at four times the slots
it leaves most of the amplification. CLOCK evicts the cold buffers and
keeps the revisited ones, recovering almost all of the unbounded benefit.
The eviction policy, not the buffer size, is what closes the gap.

eb->writeback_inhibitors and the WB_SYNC_ALL bypass in
lock_extent_buffer_for_io() are unchanged, so fsync and commit behavior
are unaffected. A reference is taken on each tracked buffer so it cannot
be freed while the array points at it; eviction drops that reference and
the inhibitor count.

Fixes: f9a48549a15a ("btrfs: inhibit extent buffer writeback to prevent COW amplification")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202603112240.f7605968-lkp@intel.com
Signed-off-by: Leo Martins <loemra.dev@gmail.com>
Reviewed-by: Sun YangKai <sunk67188@gmail.com>
---
v2:
- Present the amplification numbers as a table instead of prose (David Sterba).
- Use int for the loop indices and the slot local instead of u32 (David Sterba).
- Replace the BTRFS_INHIBITED_EBS_SLOTS comment with static_assert checks for
  the <= 32 bound and the power-of-two size (David Sterba).
- Widen inhibited_ebs_hand from u8 to u32; the handle stays in the same slab
  bucket and the u8 only left an alignment hole (David Sterba).
- Factor slot selection and eviction into btrfs_inhibit_claim_slot()
  (Sun YangKai).
- Add Reviewed-by from Sun YangKai.

v1: https://lore.kernel.org/linux-btrfs/e0d3d3ac7c585b023c2e14cec7e2b995b247b68e.1781728340.git.loemra.dev@gmail.com/

 fs/btrfs/extent_io.c   | 93 +++++++++++++++++++++++++++---------------
 fs/btrfs/transaction.c |  2 -
 fs/btrfs/transaction.h | 21 ++++++++--
 3 files changed, 78 insertions(+), 38 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 9d7ca80477fd..145b6cf37331 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2982,47 +2982,75 @@ static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 	kmem_cache_free(extent_buffer_cache, eb);
 }
 
+/*
+ * Claim a slot to track an extent buffer in, evicting the coldest tracked buffer
+ * when the array is full.
+ *
+ * Slots fill in order until the array is full. After that a CLOCK (second
+ * chance) scan advances the hand, clearing one reference bit per step, until it
+ * lands on an unreferenced slot whose buffer is evicted. Clearing a bit per step
+ * bounds the scan to BTRFS_INHIBITED_EBS_SLOTS iterations.
+ */
+static int btrfs_inhibit_claim_slot(struct btrfs_trans_handle *trans)
+{
+	int slot;
+
+	if (trans->nr_inhibited_ebs < BTRFS_INHIBITED_EBS_SLOTS)
+		return trans->nr_inhibited_ebs++;
+
+	while (trans->inhibited_ebs_referenced &
+	       (1U << trans->inhibited_ebs_hand)) {
+		trans->inhibited_ebs_referenced &=
+			~(1U << trans->inhibited_ebs_hand);
+		trans->inhibited_ebs_hand =
+			(trans->inhibited_ebs_hand + 1) %
+			BTRFS_INHIBITED_EBS_SLOTS;
+	}
+	slot = trans->inhibited_ebs_hand;
+	trans->inhibited_ebs_hand =
+		(trans->inhibited_ebs_hand + 1) % BTRFS_INHIBITED_EBS_SLOTS;
+
+	atomic_dec(&trans->inhibited_ebs[slot]->writeback_inhibitors);
+	free_extent_buffer(trans->inhibited_ebs[slot]);
+	return slot;
+}
+
 /*
  * Inhibit writeback on buffer during transaction.
  *
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
+	int slot;
 
 	lockdep_assert_held(&eb->lock);
-	/* Check if already inhibited by this handle. */
-	old = xa_load(&trans->writeback_inhibited_ebs, index);
-	if (old == eb)
-		return;
 
-	/* Take reference for the xarray entry. */
-	refcount_inc(&eb->refs);
-
-	old = xa_store(&trans->writeback_inhibited_ebs, index, eb, GFP_NOFS);
-	if (xa_is_err(old)) {
-		/* Allocation failed, just skip inhibiting this buffer. */
-		free_extent_buffer(eb);
-		return;
+	/* Already tracked: set its reference bit (second chance) and return. */
+	for (int i = 0; i < trans->nr_inhibited_ebs; i++) {
+		if (trans->inhibited_ebs[i] == eb) {
+			trans->inhibited_ebs_referenced |= 1U << i;
+			return;
+		}
 	}
 
-	/* Handle replacement of different eb at same index. */
-	if (old && old != eb) {
-		struct extent_buffer *old_eb = old;
-
-		atomic_dec(&old_eb->writeback_inhibitors);
-		free_extent_buffer(old_eb);
-	}
+	slot = btrfs_inhibit_claim_slot(trans);
 
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
@@ -3030,14 +3058,13 @@ void btrfs_inhibit_eb_writeback(struct btrfs_trans_handle *trans, struct extent_
  */
 void btrfs_uninhibit_all_eb_writeback(struct btrfs_trans_handle *trans)
 {
-	struct extent_buffer *eb;
-	unsigned long index;
-
-	xa_for_each(&trans->writeback_inhibited_ebs, index, eb) {
-		atomic_dec(&eb->writeback_inhibitors);
-		free_extent_buffer(eb);
+	for (int i = 0; i < trans->nr_inhibited_ebs; i++) {
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
index 7d70fe486758..e918dde76920 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -7,12 +7,12 @@
 #define BTRFS_TRANSACTION_H
 
 #include <linux/atomic.h>
+#include <linux/build_bug.h>
 #include <linux/refcount.h>
 #include <linux/list.h>
 #include <linux/time64.h>
 #include <linux/mutex.h>
 #include <linux/wait.h>
-#include <linux/xarray.h>
 #include "btrfs_inode.h"
 #include "delayed-ref.h"
 
@@ -23,6 +23,7 @@ struct btrfs_fs_info;
 struct btrfs_root_item;
 struct btrfs_root;
 struct btrfs_path;
+struct extent_buffer;
 
 /*
  * Signal that a direct IO write is in progress, to avoid deadlock for sync
@@ -136,6 +137,17 @@ enum {
 
 #define TRANS_EXTWRITERS	(__TRANS_START | __TRANS_ATTACH)
 
+/*
+ * Number of extent buffers a transaction handle tracks for writeback
+ * inhibition. The CLOCK reference bits pack into a u32 so this must not exceed
+ * 32, and keeping it a power of two lets the compiler reduce the CLOCK hand
+ * modulo to a mask.
+ */
+#define BTRFS_INHIBITED_EBS_SLOTS	8
+static_assert(BTRFS_INHIBITED_EBS_SLOTS <= 32);
+static_assert(BTRFS_INHIBITED_EBS_SLOTS != 0 &&
+	      (BTRFS_INHIBITED_EBS_SLOTS & (BTRFS_INHIBITED_EBS_SLOTS - 1)) == 0);
+
 struct btrfs_trans_handle {
 	u64 transid;
 	u64 bytes_reserved;
@@ -163,8 +175,11 @@ struct btrfs_trans_handle {
 	struct btrfs_fs_info *fs_info;
 	struct list_head new_bgs;
 	struct btrfs_block_rsv delayed_rsv;
-	/* Extent buffers with writeback inhibited by this handle. */
-	struct xarray writeback_inhibited_ebs;
+	/* Extent buffers this handle has inhibited writeback on. */
+	struct extent_buffer *inhibited_ebs[BTRFS_INHIBITED_EBS_SLOTS];
+	u32 inhibited_ebs_referenced;	/* CLOCK reference bit per slot */
+	u32 nr_inhibited_ebs;
+	u32 inhibited_ebs_hand;		/* CLOCK hand */
 };
 
 /*

base-commit: 12cdfd13afd5e929f359f0f9c0443e0cbd7f43fa
-- 
2.53.0-Meta

