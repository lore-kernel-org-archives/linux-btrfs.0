Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA2D3815D6
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 22:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775255282; cv=none; b=l/SfUGYkqJzdqbBdxRcnzmVa67vYlISNb+tPcZ9PbcQhbEIDnZ8p1MiIhBoaDBCHGIpZhCFcQzvPfPvRa9yHg//YufVp+xXJODk6KXDIeO6vvz3myYfmfYpb456cjP7TL4b7M3Jiwtz/M3fgnCwzEW8MYKKHZfp4s5OWotdTrE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775255282; c=relaxed/simple;
	bh=1bT1ew9gN7QpZCPPm1siaZ0GAp3GCBoKnfosgoi95DA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtlwIA2nKJa1v0yLqPCxe83ZbBrhLbEW2PgnZcEZjlRa68e622oOmUSI3Rac+HDbHKw8bMbGt7SOmT+JLl4FbzoaqQDoAU8GVXt4YJCp5nbQC/cWZpP5Q8yyCoctVetChewDYK7HG0njOuzoF3i/4V42/nKkGPvvCT25EBtBgSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=QX/cm8Pm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=n+1bfgMf; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="QX/cm8Pm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="n+1bfgMf"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 313B214000AE;
	Fri,  3 Apr 2026 18:28:00 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Fri, 03 Apr 2026 18:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1775255280; x=
	1775341680; bh=bb3L9M57EezjsBtSQBckk2eMh4sWTfyLjyh7UMFc9Ns=; b=Q
	X/cm8PmJ6dMx03tNho297Iv7tp/3WUAmXGGJCJQE0xc4OT9tIO8UaLeInkJYZcn4
	ANf+7oHql1v7JbKi+iPE5MkIVIwcxVnPXxh0Ds45PYowq7KAdn1xrVoukomAELPd
	pae8DEOSwYEne44xhT8nSRmPpwEAyt75tVLzOQ1+yM1Mm6TICDen0FjO20J4dchy
	7+yZKxXVLwThnXT9SCO6FN6CnchCVNjaVsygjs59b4ruXCKaALUaI8C8TnLGVAs+
	VpZt6e/GdL+UFMIbd995OqMp4S3OXXZA4sUXOQX10b4ujem/s5naWQB4ya09gYgB
	TBsesrGOlx9KvRr2bDklg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1775255280; x=1775341680; bh=bb3L9M57EezjsBtSQBckk2eMh4sW
	TfyLjyh7UMFc9Ns=; b=n+1bfgMfGtxYcFG55FXjcMiJHLJUcRlDFkJBkDb9Yuwg
	FuYCo+203Ln81ZFIgDIew5w+3TSXdoT8tw6OvgmB0Zj53o1M1yUhOA4CClgzz5WU
	iKv3jNal190Spuute1V3tzIODyV+1Vl9ZneZD+bR+heuMLCWSYlOQucD1niOMBz1
	TKAWRwtaq1P2fRISW7+0XhW2rmXUan53FQ85rChiAs2U9jeaAvz+q8HbsjmRxEWK
	h+v0pJKiFoGJtYsrm8dhXI3iPKKRsnXlDPPLJHUPbqiRFxfEE1Erj22RgtWHaMv9
	/YjIayO4cf2CVFvf9HfEgIGiHj2do9Y0Eaf5yyJJSQ==
X-ME-Sender: <xms:7z7QaS_erRm-3mgd6sw0QZls5RoKl2Zq4fDVev7GXMbCSMcpu4jUoA>
    <xme:7z7QaYtzjZITXLdA-tH_nSb36umKQ2HCmEu0wCpWvB1lVMSmePUfOU1YLgitUHEkK
    mFCevRr9dYtQExdWs77ih4XRFOnaHzmvKqLoVbAj6KPQAv1v7p-qTY>
X-ME-Received: <xmr:7z7QaVoKdr4DQuyGo_P6hVGBYEmb6HSzpUXwhSYaD41GA_BdHYGuehWGj-CASiHvGAGY51iqbZeNomL3J9naXkjBkDA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvdehtd
    dufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:7z7QaVmNYeTod-AebKZbtpjwmVEIMpMnxCJ1eLtDrluxaZCjttORVg>
    <xmx:7z7QaZyiWUjsOTc1_L6Cd_kGWRfJmUSQAwt8KFGjkpS8F2hPZfccaQ>
    <xmx:7z7QadlPqiMcAGbNTZupyVwpH2HfFhywou2nmPSOQELC2PZxbET6Og>
    <xmx:7z7QaSeo4dhoCRA40Nq0zXEahnjTgm5Te3is3fcFlQseyxjWMH8n5g>
    <xmx:8D7QaehoYTkKM5GrEfPmbyXMrLBMHw3soZ_-LzsJFQdKnHDqVcRzwE_0>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Apr 2026 18:27:59 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 1/5] btrfs: reserve space for delayed_refs in delalloc
Date: Fri,  3 Apr 2026 15:27:51 -0700
Message-ID: <0f736c6cf8027adb16d7c6c29443afb03ceaf24b.1775255085.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775255085.git.boris@bur.io>
References: <cover.1775255085.git.boris@bur.io>
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
btrfs_update_delayed_refs_rsv()

This is not a perfect fix for the most pathological cases, but is the
infrastructure needed to keep working on the problem.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/delalloc-space.c | 43 ++++++++++++++++++++++++++++++++++++---
 fs/btrfs/delalloc-space.h |  3 +++
 fs/btrfs/inode.c          |  5 ++++-
 fs/btrfs/transaction.c    | 36 ++++++++++++++------------------
 4 files changed, 62 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 0970799d0aa4..a087be55409f 100644
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
@@ -240,6 +242,7 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 	if (released > 0)
 		trace_btrfs_space_reservation(fs_info, "delalloc",
 					      btrfs_ino(inode), released, 0);
+
 	if (qgroup_free)
 		btrfs_qgroup_free_meta_prealloc(inode->root, qgroup_to_release);
 	else
@@ -247,6 +250,16 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
 						   qgroup_to_release);
 }
 
+/*
+ * Each delalloc extent could become an ordered_extent and end up inserting a
+ * new extent into the extent and free space trees. So we must reserve
+ * delayed ref space up front for that.
+ */
+static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_fs_info *fs_info, u64 nr_extents)
+{
+	return btrfs_calc_delayed_ref_bytes(fs_info, nr_extents);
+}
+
 static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 						 struct btrfs_inode *inode)
 {
@@ -266,6 +279,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 		reserve_size = btrfs_calc_insert_metadata_size(fs_info,
 						outstanding_extents);
 		reserve_size += btrfs_calc_metadata_size(fs_info, 1);
+		reserve_size += delalloc_calc_delayed_refs_rsv(fs_info, outstanding_extents);
 	}
 	if (!(inode->flags & BTRFS_INODE_NODATASUM)) {
 		u64 csum_leaves;
@@ -289,7 +303,8 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 
 static void calc_inode_reservations(struct btrfs_inode *inode,
 				    u64 num_bytes, u64 disk_num_bytes,
-				    u64 *meta_reserve, u64 *qgroup_reserve)
+				    u64 *meta_reserve,
+				    u64 *qgroup_reserve)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	u64 nr_extents = count_max_extents(fs_info, num_bytes);
@@ -309,9 +324,31 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
 	 * for an inode update.
 	 */
 	*meta_reserve += inode_update;
+
+	*meta_reserve += delalloc_calc_delayed_refs_rsv(fs_info, nr_extents);
+
 	*qgroup_reserve = nr_extents * fs_info->nodesize;
 }
 
+u64 btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *trans,
+                                           struct btrfs_inode *inode)
+{
+       struct btrfs_block_rsv *inode_rsv = &inode->block_rsv;
+       struct btrfs_block_rsv *trans_rsv = &trans->delayed_rsv;
+       u64 num_bytes = delalloc_calc_delayed_refs_rsv(trans->fs_info, 1);
+
+       spin_lock(&inode_rsv->lock);
+       num_bytes = min(num_bytes, inode_rsv->reserved);
+       inode_rsv->reserved -= num_bytes;
+       inode_rsv->full = (inode_rsv->reserved >= inode_rsv->size);
+       spin_unlock(&inode_rsv->lock);
+
+       btrfs_block_rsv_add_bytes(trans_rsv, num_bytes, true);
+       trans->delayed_refs_bytes_reserved += num_bytes;
+
+       return num_bytes;
+}
+
 int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 				    u64 disk_num_bytes, bool noflush)
 {
@@ -358,8 +395,8 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 						 noflush);
 	if (ret)
 		return ret;
-	ret = btrfs_reserve_metadata_bytes(block_rsv->space_info, meta_reserve,
-					   flush);
+	ret = btrfs_reserve_metadata_bytes(block_rsv->space_info,
+					   meta_reserve, flush);
 	if (ret) {
 		btrfs_qgroup_free_meta_prealloc(root, qgroup_reserve);
 		return ret;
diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
index 6119c0d3f883..b058e884879b 100644
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
+u64 btrfs_delalloc_migrate_delayed_refs_rsv(struct btrfs_trans_handle *trans,
+                                           struct btrfs_inode *inode);
 
 #endif /* BTRFS_DELALLOC_SPACE_H */
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 808e52aa6ef2..c57473030814 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -653,6 +653,7 @@ static noinline int __cow_file_range_inline(struct btrfs_inode *inode,
 		goto out;
 	}
 	trans->block_rsv = &inode->block_rsv;
+	btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
 
 	drop_args.path = path;
 	drop_args.start = 0;
@@ -3297,6 +3298,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		}
 	} else {
 		BUG_ON(root == fs_info->tree_root);
+		btrfs_delalloc_migrate_delayed_refs_rsv(trans, inode);
 		ret = insert_ordered_extent_file_extent(trans, ordered_extent);
 		if (unlikely(ret < 0)) {
 			btrfs_abort_transaction(trans, ret);
@@ -8074,9 +8076,10 @@ struct inode *btrfs_alloc_inode(struct super_block *sb)
 
 	spin_lock_init(&ei->lock);
 	ei->outstanding_extents = 0;
-	if (sb->s_magic != BTRFS_TEST_MAGIC)
+	if (sb->s_magic != BTRFS_TEST_MAGIC) {
 		btrfs_init_metadata_block_rsv(fs_info, &ei->block_rsv,
 					      BTRFS_BLOCK_RSV_DELALLOC);
+	}
 	ei->runtime_flags = 0;
 	ei->prop_compress = BTRFS_COMPRESS_NONE;
 	ei->defrag_compress = BTRFS_COMPRESS_NONE;
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

