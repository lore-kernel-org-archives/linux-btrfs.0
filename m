Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA2E20010C
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 00:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399341; cv=none; b=mfSy8nZsMcexhWXaDkQOAjaddrTdZA0lDG3ms7asDXKj03g3YToeAFQN86vzWyzbxKoRXyDR/m6yXEHn2gPduJID2iKjNqhisu7YIEROhQ6tbqOd2poQZ/WjK0Iz/JnaWNSQBFOv6z4fnzMG/6rjPIa/Y1khE5wyUzc18/FKQUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399341; c=relaxed/simple;
	bh=jF9eqeXciImnWnb2V1Sywik1snc7wSAvI5fHp/gdYvA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSsc2xTghv8FbJ/PvW4BBfxMl2SmSJ7jzDd391u/lSQkRzc2pgcbgbgRMah4yy+IdInB7aIgOK1P1GBeE9dWcyFAd37afWh11rbwwbQoo45oL7Ze9U/fhKMdPwV32bCqu9e8scYMaC7FH37rpC65Kf0Qgbpbz2YH65ca9k04FTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Z83JVgJ+; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=sWo7YmkE; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Z83JVgJ+";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="sWo7YmkE"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 936F9EC00AC;
	Tue, 24 Mar 2026 20:42:19 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 24 Mar 2026 20:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1774399339; x=
	1774485739; bh=Cz8GGzeNZ74wvLOum5P1aorCInIzCLcbwdlKRn2FhEo=; b=Z
	83JVgJ+vU6dDKm1Mp7/PjZPO9GbAAD7oiWjMo8rzyf9dOCVvpa/vpBAGkIh7utIi
	66RaeKMpTibar+8lLoZNWo7o2a2d9FS4eEPrlrMLN/rCmHzM5Rka9UmC63cCt2MD
	dvcFJjsEwDQJ+cvA9TDTSbEx59RaQWAO/sXlk5XLPuyFB7+Jl4zbff88kD0iGtvh
	d7KQ7pxwlb4dbhu+wHjqzaMRcYOr23Plb6bRaVDMtaMApdPJ109C4U5pkzgGSgzd
	8Cb5DzUQQpMopcNkKmwZ0X8V01l4dFj3mI2nytMvENOiLsBNa2wbztbi8k2lPbMs
	9nxaqG2A5jEmQ9x1N2z8A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1774399339; x=1774485739; bh=Cz8GGzeNZ74wvLOum5P1aorCInIz
	CLcbwdlKRn2FhEo=; b=sWo7YmkEEZqdBB8l6fg8E5KS1zekqiSU/QljxASbSsbz
	0Ho8d9Au7s7jZ7GbuVc9kUBpDJqQKyeT88pEt6ieple/HAGuCK3fcy1rtVVJi9dg
	hCrR7neNGIorVatf4kS4lZE2bKeV9GcsmEqZkEqynJYFnnNPWDGrHXRb7dK61ji1
	+ZJcXQ2cFGSoyRLXvYiMKpxDH+Mv9Lu8e0WiQJ4MjQ7GuS4tZrw1n1inAo0KdMHk
	gIXrdTBUCY9rpka4wbXlcsO0uckxnxYmjdKm+eT0au2f+o6cqTVopLBV4iOzGb2B
	MpYbBijnSSTiPfR/tNnyWnxU2M/jpjbr/5GSzXyU4A==
X-ME-Sender: <xms:ay_DacOQvK0DyPdetqcKmO3_rctqVXT0hmuRyS0ha6yhCvl2ALW5YA>
    <xme:ay_DaY90sMkEBT-hsmFhtaIKEaNDKmdbD1uNQnyek5obf-Z4gtd1NVmNxhvjdM1QY
    rny6OzTZeV5AwMmpFeEwJl7FwwAO47HsHpyoGJgQLf72TJJXs1XPHk>
X-ME-Received: <xmr:ay_DaQ4R9xIwhi3_CZAUlHS5f4Lkantn5NPHLwkMsN0xyORoucenyKEFTt_onFJqt4b1kZwyKG6qxyRgAY1Q51oAn0M>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdeftdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffvedvhe
    dtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepvddpmhhoug
    gvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomh
X-ME-Proxy: <xmx:ay_Daf0fRxFDc3sYmhM_8D_JSuRmKN_k9OVvibAvcm4EPUe5bljREQ>
    <xmx:ay_DaXBqCA8G-jPhOUEpibo6ssRPHDmKCU_JpicljkC6siPZrDjZwg>
    <xmx:ay_DaR3dDdN615lUyxFN0E8VtrdQ-Efm00KWlkW0TKGVCQtkHceODw>
    <xmx:ay_DaRvm3ymFpYyCh9SJq28Wkp5-KMQA7UEftByM7cWrtdrICWHqBg>
    <xmx:ay_DabyqVEZcciKe35RGU4Ufm_ecw4Q96hmV9dygM3GQ-Ikgi3Op4uke>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Mar 2026 20:42:19 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 4/5] btrfs: make inode->outstanding_extents a u64
Date: Tue, 24 Mar 2026 17:41:52 -0700
Message-ID: <68e3e1c04fd2dde1d9200d20d516939603045706.1774398665.git.boris@bur.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774398665.git.boris@bur.io>
References: <cover.1774398665.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The maximum file size is MAX_LFS_FILESIZE = (loff_t)LLONG_MAX

As a result, the max extent size computation in btrfs has always been
bounded above by LLONG_MAX / 128MiB, which is ~ 2^63 / 2^27. This has
never fit in a u32. With the recent changes to also divide by 128KiB in
compressed cases, that bound is even higher. Whether or not it is likely
to happen, I think it is nice to try to capture the intent in the types,
so change outstanding_extents to u64, and make mod_outstanding_extents
try to capture some expectations around the size of its inputs.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/btrfs_inode.h       | 14 ++++++++++----
 fs/btrfs/delalloc-space.c    | 21 ++++++++++-----------
 fs/btrfs/inode.c             | 14 +++++++-------
 fs/btrfs/ordered-data.c      |  4 ++--
 fs/btrfs/tests/inode-tests.c | 18 +++++++++---------
 include/trace/events/btrfs.h |  8 ++++----
 6 files changed, 42 insertions(+), 37 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index cfeda43b01d7..af7d7244a94b 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -180,7 +180,7 @@ struct btrfs_inode {
 	 * items we think we'll end up using, and reserved_extents is the number
 	 * of extent items we've reserved metadata for. Protected by 'lock'.
 	 */
-	unsigned outstanding_extents;
+	u64 outstanding_extents;
 
 	/* used to order data wrt metadata */
 	spinlock_t ordered_tree_lock;
@@ -432,14 +432,20 @@ static inline bool is_data_inode(const struct btrfs_inode *inode)
 }
 
 static inline void btrfs_mod_outstanding_extents(struct btrfs_inode *inode,
-						 int mod)
+						 int mod, u64 nr_extents)
 {
+	s64 delta = mod * (s64)nr_extents;
+
 	lockdep_assert_held(&inode->lock);
-	inode->outstanding_extents += mod;
+	ASSERT(mod == 1 || mod == -1);
+	ASSERT(nr_extents <= S64_MAX);
+	ASSERT(mod == -1 || inode->outstanding_extents <= U64_MAX - nr_extents);
+	ASSERT(mod == 1 || inode->outstanding_extents >= nr_extents);
+	inode->outstanding_extents += delta;
 	if (btrfs_is_free_space_inode(inode))
 		return;
 	trace_btrfs_inode_mod_outstanding_extents(inode->root, btrfs_ino(inode),
-						  mod, inode->outstanding_extents);
+						  delta, inode->outstanding_extents);
 }
 
 /*
diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 2ceae1065f2c..55d0d18b5117 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -264,7 +264,7 @@ static void btrfs_inode_rsv_release(struct btrfs_inode *inode, bool qgroup_free)
  * ordered_extent.
  */
 static u64 delalloc_calc_delayed_refs_rsv(const struct btrfs_fs_info *fs_info,
-					  unsigned int nr_extents)
+					  u64 nr_extents)
 {
 	return btrfs_calc_delayed_ref_bytes(fs_info, nr_extents) +
 		btrfs_calc_insert_metadata_size(fs_info, nr_extents);
@@ -278,7 +278,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 	u64 reserve_size = 0;
 	u64 delayed_refs_size = 0;
 	u64 qgroup_rsv_size = 0;
-	unsigned outstanding_extents;
+	u64 outstanding_extents;
 
 	lockdep_assert_held(&inode->lock);
 	outstanding_extents = inode->outstanding_extents;
@@ -306,7 +306,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 	 *
 	 * This is overestimating in most cases.
 	 */
-	qgroup_rsv_size = (u64)outstanding_extents * fs_info->nodesize;
+	qgroup_rsv_size = outstanding_extents * fs_info->nodesize;
 
 	spin_lock(&block_rsv->lock);
 	block_rsv->size = reserve_size;
@@ -355,7 +355,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
 	u64 meta_reserve, delayed_refs_reserve, qgroup_reserve;
-	unsigned nr_extents;
+	u64 nr_extents;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 
@@ -411,7 +411,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	 */
 	nr_extents = btrfs_inode_max_extents(inode, num_bytes);
 	spin_lock(&inode->lock);
-	btrfs_mod_outstanding_extents(inode, nr_extents);
+	btrfs_mod_outstanding_extents(inode, 1, nr_extents);
 	if (!(inode->flags & BTRFS_INODE_NODATASUM))
 		inode->csum_bytes += disk_num_bytes;
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
@@ -475,11 +475,11 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
 void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	unsigned num_extents;
+	u64 num_extents;
 
 	spin_lock(&inode->lock);
 	num_extents = btrfs_inode_max_extents(inode, num_bytes);
-	btrfs_mod_outstanding_extents(inode, -num_extents);
+	btrfs_mod_outstanding_extents(inode, -1, num_extents);
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
 
@@ -493,16 +493,15 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 reserved_len, u64 new_len)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	const u32 reserved_num_extents = btrfs_inode_max_extents(inode, reserved_len);
-	const u32 new_num_extents = btrfs_inode_max_extents(inode, new_len);
-	const int diff_num_extents = new_num_extents - reserved_num_extents;
+	const u64 reserved_num_extents = btrfs_inode_max_extents(inode, reserved_len);
+	const u64 new_num_extents = btrfs_inode_max_extents(inode, new_len);
 
 	ASSERT(new_len <= reserved_len);
 	if (new_num_extents == reserved_num_extents)
 		return;
 
 	spin_lock(&inode->lock);
-	btrfs_mod_outstanding_extents(inode, diff_num_extents);
+	btrfs_mod_outstanding_extents(inode, -1, reserved_num_extents - new_num_extents);
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e567b23efe39..887f1a5dba9f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2536,7 +2536,7 @@ void btrfs_split_delalloc_extent(struct btrfs_inode *inode,
 	}
 
 	spin_lock(&inode->lock);
-	btrfs_mod_outstanding_extents(inode, 1);
+	btrfs_mod_outstanding_extents(inode, 1, 1);
 	spin_unlock(&inode->lock);
 }
 
@@ -2566,7 +2566,7 @@ void btrfs_merge_delalloc_extent(struct btrfs_inode *inode, struct extent_state
 	/* we're not bigger than the max, unreserve the space and go */
 	if (new_size <= max_extent_size) {
 		spin_lock(&inode->lock);
-		btrfs_mod_outstanding_extents(inode, -1);
+		btrfs_mod_outstanding_extents(inode, -1, 1);
 		spin_unlock(&inode->lock);
 		return;
 	}
@@ -2597,7 +2597,7 @@ void btrfs_merge_delalloc_extent(struct btrfs_inode *inode, struct extent_state
 		return;
 
 	spin_lock(&inode->lock);
-	btrfs_mod_outstanding_extents(inode, -1);
+	btrfs_mod_outstanding_extents(inode, -1, 1);
 	spin_unlock(&inode->lock);
 }
 
@@ -2666,10 +2666,10 @@ void btrfs_set_delalloc_extent(struct btrfs_inode *inode, struct extent_state *s
 	if (!(state->state & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		u64 len = state->end + 1 - state->start;
 		u64 prev_delalloc_bytes;
-		u32 num_extents = btrfs_inode_max_extents(inode, len);
+		u64 num_extents = btrfs_inode_max_extents(inode, len);
 
 		spin_lock(&inode->lock);
-		btrfs_mod_outstanding_extents(inode, num_extents);
+		btrfs_mod_outstanding_extents(inode, 1, num_extents);
 		spin_unlock(&inode->lock);
 
 		/* For sanity tests */
@@ -2712,7 +2712,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	u64 len = state->end + 1 - state->start;
-	u32 num_extents = btrfs_inode_max_extents(inode, len);
+	u64 num_extents = btrfs_inode_max_extents(inode, len);
 
 	lockdep_assert_held(&inode->io_tree.lock);
 
@@ -2732,7 +2732,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 		u64 new_delalloc_bytes;
 
 		spin_lock(&inode->lock);
-		btrfs_mod_outstanding_extents(inode, -num_extents);
+		btrfs_mod_outstanding_extents(inode, -1, num_extents);
 		spin_unlock(&inode->lock);
 
 		/*
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index d39f1c49d1cf..14b49cb33bb0 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -223,7 +223,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	 * smallest the extent is going to get.
 	 */
 	spin_lock(&inode->lock);
-	btrfs_mod_outstanding_extents(inode, 1);
+	btrfs_mod_outstanding_extents(inode, 1, 1);
 	spin_unlock(&inode->lock);
 
 out:
@@ -655,7 +655,7 @@ void btrfs_remove_ordered_extent(struct btrfs_ordered_extent *entry)
 	btrfs_lockdep_acquire(fs_info, btrfs_trans_pending_ordered);
 	/* This is paired with alloc_ordered_extent(). */
 	spin_lock(&btrfs_inode->lock);
-	btrfs_mod_outstanding_extents(btrfs_inode, -1);
+	btrfs_mod_outstanding_extents(btrfs_inode, -1, 1);
 	spin_unlock(&btrfs_inode->lock);
 	if (root != fs_info->tree_root) {
 		u64 release;
diff --git a/fs/btrfs/tests/inode-tests.c b/fs/btrfs/tests/inode-tests.c
index b04fbcaf0a1d..e63afbb9be2b 100644
--- a/fs/btrfs/tests/inode-tests.c
+++ b/fs/btrfs/tests/inode-tests.c
@@ -931,7 +931,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 1) {
 		ret = -EINVAL;
-		test_err("miscount, wanted 1, got %u",
+		test_err("miscount, wanted 1, got %llu",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -946,7 +946,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 2) {
 		ret = -EINVAL;
-		test_err("miscount, wanted 2, got %u",
+		test_err("miscount, wanted 2, got %llu",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -962,7 +962,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 2) {
 		ret = -EINVAL;
-		test_err("miscount, wanted 2, got %u",
+		test_err("miscount, wanted 2, got %llu",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -978,7 +978,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 2) {
 		ret = -EINVAL;
-		test_err("miscount, wanted 2, got %u",
+		test_err("miscount, wanted 2, got %llu",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -996,7 +996,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 4) {
 		ret = -EINVAL;
-		test_err("miscount, wanted 4, got %u",
+		test_err("miscount, wanted 4, got %llu",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1013,7 +1013,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 3) {
 		ret = -EINVAL;
-		test_err("miscount, wanted 3, got %u",
+		test_err("miscount, wanted 3, got %llu",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1029,7 +1029,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 4) {
 		ret = -EINVAL;
-		test_err("miscount, wanted 4, got %u",
+		test_err("miscount, wanted 4, got %llu",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1047,7 +1047,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	}
 	if (BTRFS_I(inode)->outstanding_extents != 3) {
 		ret = -EINVAL;
-		test_err("miscount, wanted 3, got %u",
+		test_err("miscount, wanted 3, got %llu",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
@@ -1061,7 +1061,7 @@ static int test_extent_accounting(u32 sectorsize, u32 nodesize)
 	}
 	if (BTRFS_I(inode)->outstanding_extents) {
 		ret = -EINVAL;
-		test_err("miscount, wanted 0, got %u",
+		test_err("miscount, wanted 0, got %llu",
 			 BTRFS_I(inode)->outstanding_extents);
 		goto out;
 	}
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8ad7a2d76c1d..caabdc8d9eed 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -2003,15 +2003,15 @@ DEFINE_EVENT(btrfs__prelim_ref, btrfs_prelim_ref_insert,
 );
 
 TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
-	TP_PROTO(const struct btrfs_root *root, u64 ino, int mod, unsigned outstanding),
+	TP_PROTO(const struct btrfs_root *root, u64 ino, s64 mod, u64 outstanding),
 
 	TP_ARGS(root, ino, mod, outstanding),
 
 	TP_STRUCT__entry_btrfs(
 		__field(	u64, root_objectid	)
 		__field(	u64, ino		)
-		__field(	int, mod		)
-		__field(	unsigned, outstanding	)
+		__field(	s64, mod		)
+		__field(	u64, outstanding	)
 	),
 
 	TP_fast_assign_btrfs(root->fs_info,
@@ -2021,7 +2021,7 @@ TRACE_EVENT(btrfs_inode_mod_outstanding_extents,
 		__entry->outstanding    = outstanding;
 	),
 
-	TP_printk_btrfs("root=%llu(%s) ino=%llu mod=%d outstanding=%u",
+	TP_printk_btrfs("root=%llu(%s) ino=%llu mod=%lld outstanding=%llu",
 			show_root_type(__entry->root_objectid),
 			__entry->ino, __entry->mod, __entry->outstanding)
 );
-- 
2.53.0

