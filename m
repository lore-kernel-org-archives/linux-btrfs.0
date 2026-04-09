Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2289F2E7162
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 17:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775756948; cv=none; b=n+/qAY0rFqZV4T2rKH3H0G0cNQpfYM8+8ipumm7JznM/zh1nWbNZ7ScOPdNhlRUN55FZZU/IJTTA1KkjHJzYDDf6QuEYreBXwvXTzDmTLufe6+cfUIHyfe4QF12gij5Qd//Ycj5XQnEVvH6e5jswc9s3iB0CcZ07wwbKgWk2o3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775756948; c=relaxed/simple;
	bh=z/eEvSKTHYaBOw1uF7e+D+Ps+njXaRk63a31qEUkOO8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wwv6LWsITknGzX+G+a1HFxbJGY33HPyj/UZ0TeSSQbkGj4lLP1BQS7DinHUEGBtKU0gq1RwdHdGIH+rC2tg+tYQy6hWB/YiLeBgWAFDetp3J8iiWu39B+U/yJhp5Qv2h+AC3odHqKd0/dLnJDZwd6JVsGaU+jRDyYLtg6QaIZVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=lSZckH7V; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=DsYeb1Kv; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="lSZckH7V";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="DsYeb1Kv"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 5BCDA1D000F5;
	Thu,  9 Apr 2026 13:49:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 09 Apr 2026 13:49:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1775756946; x=
	1775843346; bh=Ts0fSeus8GGKGJwvJmXkVz8OkHDwjTvUomx+WBgjz5A=; b=l
	SZckH7V8zm8J81FFsqLQUeiaiRjAj1WidB7bMSZbZFucq2MvoxAeKPmtmpg3isL3
	Xqe8ceFqHsra2e1Mu4MXE0CN/t+QnRl2fHGX+2VdtpZRrv/3MsIRAZ8eIC45RDU5
	zJuOlr5kOMFiecLEmWGZURjmLH7nZtJzJBkEl+WW0y+24KWIMgNI9trbM7IwepWD
	t3U9hr+6bky8HhLTdXx4BFUTULGxLDuVw8dexMxIgiEzdBeP9kJZHQFWdsJB9Gzo
	pkEl0j+/+1c5hQ2X4I/MhpGLz4v3dq3KSWhdX++rQJBrPJgq/pBSSB4DuvmyHmth
	kZkrDtiyxvQyaet++lXtQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1775756946; x=1775843346; bh=Ts0fSeus8GGKGJwvJmXkVz8OkHDw
	jTvUomx+WBgjz5A=; b=DsYeb1Kv/pnP77113Ur0RskIQe7cNaFKEujA+Cg0hS0K
	jskJyKNSuzbFp7TocDkD+hCeASkMKg3TZZgLnjB82maRRL5A/FNAkPI+ZbBIm8FK
	gwH0htZbAPfBbXnp/0JSBuoWXh89jXQ1zDU52OdpPc6fGYBcoHPBNNwSJswwiwPu
	mT9Zbmcjdp5rwEsrAxHdPKy3lbZfiN7taP8e48bFJbvo0LTb5n0zU+t/yoLtha4Q
	H2qMrD1bie/NkB31+wSHxlQKCow39zp5NlzdeArK6fypOix4o0ubvLFqHIlQkkkn
	tNk/QP0PRIggmkPwdYqfFJLlmA9bRi2/WVYLDFBvXQ==
X-ME-Sender: <xms:kubXaet7B4BnqUfO7d9F_j_aikTatbDv7VMuMd3L5bzvzuXQcHHvZw>
    <xme:kubXaZeEvBu9I82jLZspvmrXYNvGFeG40pAFUD_au4rdmNho3Dn5nB5zHk5MiHaeH
    OzSugkUIi6zzWrLD-v478NzGALvupPygCAPswgvza-63TfLFJ7gRpE>
X-ME-Received: <xmr:kubXaXYU4Y_AHKOAVbmWl7079lckzyAjUwgN4MArArmA-OYDHgt8ecpJDa6WIzw97omc0O1_U95CU9-4TreZOSncd7A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvjedufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvdehtd
    dufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:kubXaUUD2tNJVDKV7UpwoBp3CVii4XEQmAnhkPOaxJkXWTfssgq40A>
    <xmx:kubXaRjgJda6TspTj6HQOuPTPm7LNqANsRIya5qJv3olSHSvYvCO6w>
    <xmx:kubXaaXlLTlDL7eKwAKtQ-DsjWH3-sFFXBerSIFdFU0BL_B5ArbUzQ>
    <xmx:kubXaQO4jTphY0kYmcQPQUFYmwTJSv-iPwcNObij50DDBmOiHDuC5A>
    <xmx:kubXaWQU5mW6YhkWREGyX9xZI2SLCXgfMSGfROIAXpEbBKVfXoF8vOm0>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 13:49:05 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v4 1/4] btrfs: reserve space for delayed_refs in delalloc
Date: Thu,  9 Apr 2026 10:48:48 -0700
Message-ID: <05bde74e587402f5d77897f0507a292ab9522355.1775756789.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775756789.git.boris@bur.io>
References: <cover.1775756789.git.boris@bur.io>
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
 fs/btrfs/delalloc-space.c | 52 +++++++++++++++++++++++++++++++++++++++
 fs/btrfs/delalloc-space.h |  3 +++
 fs/btrfs/inode.c          |  2 ++
 fs/btrfs/transaction.c    | 36 +++++++++++----------------
 4 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 0970799d0aa4..63e174cc9393 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -3,11 +3,13 @@
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
@@ -247,6 +249,35 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
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
+	/*
+	 * Factor for how many delayed refs updates we will generate per extent.
+	 * Non-optional: extent tree, subvolume tree
+	 */
+	int factor = 4;
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
@@ -266,6 +297,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 		reserve_size = btrfs_calc_insert_metadata_size(fs_info,
 						outstanding_extents);
 		reserve_size += btrfs_calc_metadata_size(fs_info, 1);
+		reserve_size += delalloc_calc_delayed_refs_rsv(inode, outstanding_extents);
 	}
 	if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
 		u64 csum_leaves;
@@ -309,9 +341,29 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
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

