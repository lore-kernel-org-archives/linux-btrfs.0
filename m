Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0240363C61
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 19:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775590228; cv=none; b=NZC5zRFqaBOelqC7Wui0DQhhO6ggLyFXEHC6TKzQCjFe97qLNYOOlACCoSjByPkX3GvOqrvWgha8zUzfbC+oBqLvP0lJEsxdLJXQi8qS5JaPMXiamJFOB2V6qH6HRtErwXbw1KjPL1alWfYrcTX/0e9lsFzvzxAqppRxx1UupyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775590228; c=relaxed/simple;
	bh=gIs+qafTGWhe5RMMTqf8okO4FEJoyPOlzwklmflLXns=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=deVC57dd33u1lviVtzfcx+S2WCZS0ymaKdePQ8f44YFFfJsJAvE4gEQrMmjzmd7tyfpdfmxWEwww7wxhX4peZg+vwBby4vTxgLyyM7+Qnti0pq9BjpqXDr0Kx6Zw9DPLSKzAq3+ISynPYXSR+HAUnropH7qbi3RPSPQNHIuMniE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=fxqJG3/S; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WtWky+qc; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="fxqJG3/S";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WtWky+qc"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 47ABD14001E9;
	Tue,  7 Apr 2026 15:30:26 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 07 Apr 2026 15:30:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1775590226; x=
	1775676626; bh=c0Mz/xemvkyedg+sH9yN1BgXOi4de7FA72hfOk/r2ag=; b=f
	xqJG3/SjXRQES+CYDTpoNNOm45DVAFRwoiErPvda7uS4Ip5hsZYhO0hosvlDBDMi
	qEYU6IvFo6Xop/X/sAnpehBGmkJe14bHRCsHVaDHLb9z95/Sy9mBCjeXTRL/3BmW
	BI81lanGv611oHEnm8+zgZPAMRGunGaIObXVRImJ15H3pvDgez/QKzP3GX9EFzsT
	n719Yzf2dROiU2cjF5JVxp5t8QEyfW/JbMOYAz0Bp+QcOcuWbMX6f/TyivTE7NOT
	GUmdEUoZkyt/kk7gyj53/9KcZZxf7zrh3NeiHgGEV1USn7xU9vTN6WABY+gkxHMi
	af1r+NpN/gRp7rUQGsTTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1775590226; x=1775676626; bh=c0Mz/xemvkyedg+sH9yN1BgXOi4d
	e7FA72hfOk/r2ag=; b=WtWky+qcZBtjaVCJBedlzVJAaMb5d1PEna6c9/rK1AZm
	wxPT+PaYnOtJiJxabRN5V+rAhXrq0yl19i7+U7BFmN5cBKrm8XBrm65piXjNF1iY
	d4z/iZADnkmoUEITr1/5+B2QPctezaEZhAv3zTCDGVVzUAyOK7uh67ebjjxgBtRR
	PuPXSjsZg3B5VYP2c+xHeX3ez3AlRAvaoQQb7bjKd9Gz0fvQPEnZZrtoXBsp1TP5
	OBs7vw1TIFXw2aHPx9ve+FtZifY29sC+nGtyj09AEXkw7hOzkdKHdND47fK6sOFd
	BHhWkSqLRwUpRtTHe/YhBSkGlOn/G96XFMNVlUM18w==
X-ME-Sender: <xms:UlvVaYJUegw43vgguzYNrB_3puSA0apqd4vlprdUb78AyjuLL04liA>
    <xme:UlvVaeJmbrTE2ryQvJDwUNw04BBgamI0IbzlKUpbE7uQQLeqnTRgcHcc0Q-0WVVPb
    D9SS_y1JZ7wyFG4PT24BtIBBgJyj_0dmsbA6krkgiXmg4evD2lOocho>
X-ME-Received: <xmr:UlvVaWXQEQw2Sd_6KfG2Zu0X3_QigP3njwWeDGDR3OYbR7YOIzm5pZTVOh-7R1AmM_eZOhAeHD9Hk7wAZ9AYq61QuEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvudehtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvdehtd
    dufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:UlvVaQjCxv__Mx0TjIXKXsLb10V2VAeh5Uwdzr2Yj7W1vq0WecuMZQ>
    <xmx:UlvVaR9LGjM1l15DDcF2TRSNaQvjsLDkLgq4KjS4D1G_URqL0Sqmjw>
    <xmx:UlvVaaDB2yE-twg00J8GOPPSkVyLLXHj4Q4W0oNo4atak2OlvgeH4A>
    <xmx:UlvVaeLjm_WBC-fDzhcoEy_2QMm99SNbo9T_D357_qhWhSSrYH4a6w>
    <xmx:UlvVaeuO5_BE4W7BAgCYCmVYoLW9oUyM-5r4rrv8zPkFFfgPRm40P5fc>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Apr 2026 15:30:25 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v3 1/4] btrfs: reserve space for delayed_refs in delalloc
Date: Tue,  7 Apr 2026 12:30:11 -0700
Message-ID: <ab37e7be01a428f76651fa667d5ff2db28deae8e.1775589916.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775589916.git.boris@bur.io>
References: <cover.1775589916.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

delalloc uses a per-inode block_rsv to perform metadata reservations for
the cow operations it anticipates based on the number of outstanding
extents. This calculation is done based on inode->outstanding_extents in
btrfs_calculate_inode_block_rsv_size(). The reservation is *not*
meticulously tracked as each ordered_extent is actually created in
writeback, but rather delalloc attempts to over-estimate and the
writeback and ordered_extent finish portions are responsible to release
all the reservation.

However, there is a notable gap in this reservation, it reserves no
space for the resulting delayed_refs. If you compare to how
btrfs_start_transaction() reservations work, this is a noteable
difference.

As writeback actually occurs, and we trigger btrfs_finish_one_ordered(),
that function will start generating delayed refs, which will draw from
the trans_handle's delayed_refs_rsv via btrfs_update_delayed_refs_rsv():

For example, we can trace the primary data delayed ref:

btrfs_finish_one_ordered()
  insert_ordered_extent_file_extent()
    insert_reserved_file_extent()
      btrfs_alloc_reserved_file_extent()
        btrfs_add_delayed_data_ref()
          add_delayed_ref()
            btrfs_update_delayed_refs_rsv();

This trans_handle was created in finish_one_ordered() with
btrfs_join_transaction() which calls start_transaction with
num_items=0 and BTRFS_RESERVE_NO_FLUSH. As a result, this trans_handle
has no reserved in h->delayed_rsv, as neither the num_items reservation
nor the btrfs_delayed_refs_rsv_refill() reservation is run.

Thus, when btrfs_update_delayed_refs_rsv() runs, reserved_bytes is 0 and
fs_info->delayed_rsv->size grows but not fs_info->delayed_rsv->reserved.

If a large amount of writeback happens all at once (perhaps due to
dirty_ratio being tuned too high), this results in, among other things,
erroneous assessments of the amount of delayed_refs reserved in the
metadata space reclaim logic, like need_preemptive_reclaim() which
relies on fs_info->delayed_rsv->reserved and even worse, poor decision
making in btrfs_preempt_reclaim_metadata_space() which counts
delalloc_bytes like so:

  block_rsv_size = global_rsv_size +
          btrfs_block_rsv_reserved(delayed_block_rsv) +
          btrfs_block_rsv_reserved(delayed_refs_rsv) +
          btrfs_block_rsv_reserved(trans_rsv);
  delalloc_size = bytes_may_use - block_rsv_size;

So all that lost delayed refs usage gets accounted as delalloc_size and
leads to preemptive reclaim continuously choosing FLUSH_DELALLOC, which
further exacerbates the problem.

With enough writeback around, we can run enough delalloc that we get
into async reclaim which starts blocking start_transaction() and
eventually hits FLUSH_DELALLOC_WAIT/FLUSH_DELALLOC_FULL at which point
the filesystem gets heavily blocked on metadata space in reserve_space(),
blocking all new transaction work until all the ordered_extents finish.

If we had an accurate view of the reservation for delayed refs, then we
could mostly break this feedback loop in preemptive reclaim, and
generally would be able to make more accurate decisions with regards to
metadata space reclamation.

This patch adds extra metadata reservation to the inode's block_rsv to
account for the delayed refs. When the ordered_extent finishes and we
are about to do work in the transaction that uses delayed refs, we
migrate enough for 1 extent. Since this is not necessarily perfect, we
have to be careful and do a "soft" migrate which succeeds even if there
is not enough reservation. This is strictly better than what we have and
also matches how the delayed ref rsv gets used in the transaction at
btrfs_update_delayed_refs_rsv().

Aside from this data delayed_ref, there are also some metadata
delayed_refs to consider. These are:
- subvolume tree for the file extent item
- csum tree for data csums
- raid stripe tree if enabled
- free space tree if enabled

So account for those delayed_refs in the reservation as well. This
greatly increases the size of the reservation as each metadata cow
results in two delayed refs: one add for the new block in
btrfs_alloc_tree_block() and one drop for the old in
btrfs_free_tree_block(). As a result, to be completely conservative,
we need to reserve 2 delayed refs worth of space for each cow.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/delalloc-space.c | 56 +++++++++++++++++++++++++++++++++++++++
 fs/btrfs/delalloc-space.h |  3 +++
 fs/btrfs/inode.c          |  2 ++
 fs/btrfs/transaction.c    | 36 +++++++++++--------------
 4 files changed, 76 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 0970799d0aa4..c99f516ce8af 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -1,13 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include "linux/btrfs_tree.h"
 #include "messages.h"
 #include "ctree.h"
 #include "delalloc-space.h"
+#include "delayed-ref.h"
 #include "block-rsv.h"
 #include "btrfs_inode.h"
 #include "space-info.h"
 #include "qgroup.h"
 #include "fs.h"
+#include "transaction.h"
 
 /*
  * HOW DOES THIS WORK
@@ -247,6 +250,38 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 						   qgroup_to_release);
 }
 
+/*
+ * Each delalloc extent could become an ordered_extent and end up inserting a
+ * new data extent and modify a number of btrees. Each of those is associated with
+ * adding delayed refs which need a corresponding delayed refs reservation.
+ *
+ * Each metadata cow operation results in an add and a drop delayed ref, both of
+ * which call add_delayed_ref() and ultimately btrfs_update_delayed_refs_rsv(),
+ * so each must account for 2 delayed refs.
+ */
+static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_inode *inode, u64 nr_extents)
+{
+	const struct btrfs_fs_info *fs_info = inode->root->fs_info;
+
+	/*
+	 * Factor for how many delayed refs updates we will generate per extent.
+	 * Non-optional:
+	 * extent tree: 1 data delayed ref.
+	 * subvolume tree: 1 cow => 2 metadata delayed refs.
+	 */
+	int factor = 3;
+
+	/* The remaining trees are only written to conditionally. */
+	if (!(inode->flags & BTRFS_INODE_NODATASUM))
+		factor += 2;
+	if (btrfs_test_opt(fs_info, FREE_SPACE_TREE))
+		factor += 2;
+	if (btrfs_fs_incompat(fs_info, RAID_STRIPE_TREE))
+		factor += 2;
+
+	return btrfs_calc_insert_metadata_size(fs_info, nr_extents) * factor;
+}
+
 static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 						 struct btrfs_inode *inode)
 {
@@ -266,6 +301,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 		reserve_size = btrfs_calc_insert_metadata_size(fs_info,
 						outstanding_extents);
 		reserve_size += btrfs_calc_metadata_size(fs_info, 1);
+		reserve_size += delalloc_calc_delayed_refs_rsv(inode, outstanding_extents);
 	}
 	if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
 		u64 csum_leaves;
@@ -309,9 +345,29 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
 	 * for an inode update.
 	 */
 	*meta_reserve += inode_update;
+
+	*meta_reserve += delalloc_calc_delayed_refs_rsv(inode, nr_extents);
+
 	*qgroup_reserve = nr_extents * fs_info->nodesize;
 }
 
+void btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *trans,
+					     struct btrfs_inode *inode)
+{
+       struct btrfs_block_rsv *inode_rsv = &inode->block_rsv;
+       struct btrfs_block_rsv *trans_rsv = &trans->delayed_rsv;
+       u64 num_bytes = delalloc_calc_delayed_refs_rsv(inode, 1);
+
+       spin_lock(&inode_rsv->lock);
+       num_bytes = min(num_bytes, inode_rsv->reserved);
+       inode_rsv->reserved -= num_bytes;
+       inode_rsv->full = (inode_rsv->reserved >= inode_rsv->size);
+       spin_unlock(&inode_rsv->lock);
+
+       btrfs_block_rsv_add_bytes(trans_rsv, num_bytes, true);
+       trans->delayed_refs_bytes_reserved += num_bytes;
+}
+
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 				    u64 disk_num_bytes, bool noflush)
 {
diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
index 6119c0d3f883..bd7041166987 100644
--- a/fs/btrfs/delalloc-space.h
+++ b/fs/btrfs/delalloc-space.h
@@ -8,6 +8,7 @@
 struct extent_changeset;
 struct btrfs_inode;
 struct btrfs_fs_info;
+struct btrfs_trans_handle;
 
 int btrfs_alloc_data_chunk_ondemand(const struct btrfs_inode *inode, u64 bytes);
 int btrfs_check_data_free_space(struct btrfs_inode *inode,
@@ -27,5 +28,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 				    u64 disk_num_bytes, bool noflush);
 void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes);
 void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 reserved_len, u64 new_len);
+void btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *trans,
+					     struct btrfs_inode *inode);
 
 #endif /* BTRFS_DELALLOC_SPACE_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 40474014c03f..15945744a304 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -653,6 +653,7 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
 		goto out;
 	}
 	trans->block_rsv = &inode->block_rsv;
+	btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
 
 	drop_args.path = path;
 	drop_args.start = 0;
@@ -3259,6 +3260,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 	}
 
 	trans->block_rsv = &inode->block_rsv;
+	btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
 
 	ret = btrfs_insert_raid_extent(trans, ordered_extent);
 	if (unlikely(ret)) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 248adb785051..55791bb100a2 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1047,29 +1047,23 @@ static void btrfs_trans_release_metadata(struct btrfs_trans_handle *trans)
 		return;
 	}
 
-	if (!trans->bytes_reserved) {
-		ASSERT(trans->delayed_refs_bytes_reserved == 0,
-		       "trans->delayed_refs_bytes_reserved=%llu",
-		       trans->delayed_refs_bytes_reserved);
-		return;
+	if (trans->bytes_reserved) {
+		ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
+		trace_btrfs_space_reservation(fs_info, "transaction",
+					trans->transid, trans->bytes_reserved, 0);
+		btrfs_block_rsv_release(fs_info, trans->block_rsv,
+					trans->bytes_reserved, NULL);
+		trans->bytes_reserved = 0;
 	}
 
-	ASSERT(trans->block_rsv == &fs_info->trans_block_rsv);
-	trace_btrfs_space_reservation(fs_info, "transaction",
-				      trans->transid, trans->bytes_reserved, 0);
-	btrfs_block_rsv_release(fs_info, trans->block_rsv,
-				trans->bytes_reserved, NULL);
-	trans->bytes_reserved = 0;
-
-	if (!trans->delayed_refs_bytes_reserved)
-		return;
-
-	trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
-				      trans->transid,
-				      trans->delayed_refs_bytes_reserved, 0);
-	btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
-				trans->delayed_refs_bytes_reserved, NULL);
-	trans->delayed_refs_bytes_reserved = 0;
+	if (trans->delayed_refs_bytes_reserved) {
+		trace_btrfs_space_reservation(fs_info, "local_delayed_refs_rsv",
+					trans->transid,
+					trans->delayed_refs_bytes_reserved, 0);
+		btrfs_block_rsv_release(fs_info, &trans->delayed_rsv,
+					trans->delayed_refs_bytes_reserved, NULL);
+		trans->delayed_refs_bytes_reserved = 0;
+	}
 }
 
 static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
-- 
2.53.0

