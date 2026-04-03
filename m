Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3367352F95
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 22:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775255287; cv=none; b=d4cKjWmUvWua2SEDNlufV3le7icbkL6SXcpPgYVcxF6NjSNQEm1g1VO3LJrBAdjnA+PFWExslwekhys3rxpPNbfoV8M+Ecj1GwJzsJD8lMsxJLn+GE9l3w0TNSHmNXQLcF3QWQlapkqUnPjj00Lgka1bQwlzJTdF19FK2/Xbu0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775255287; c=relaxed/simple;
	bh=01PzXlzomfpDTeKeaseVI+dHbgb/MtvXb6aD5PJ+08w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bfjPRXcHpddfn8BIRI+uKYkqMoAxZ+SxqkqwrpN4HBYpE9jH8OiEOlysnSq5HeoJNax6YUghq2n9LP5tsUQiqFXDIZxuuyA5fMbmYQjr+8d5wVDC1ICa+U8MhW/qV1GVhIXG5KimNJtKkFOch9fvFz+i8YbwQa/PLx4yKxTrQ2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=NfxBlIOq; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NoxAY+Xe; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="NfxBlIOq";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NoxAY+Xe"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 0B9FB14000CB;
	Fri,  3 Apr 2026 18:28:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Fri, 03 Apr 2026 18:28:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1775255285; x=
	1775341685; bh=ixLjghp11nHA0XTsXBwaf1hrqJU7wgZtgoeqT6n1Erc=; b=N
	fxBlIOqov6QAVBZLsksq6wywwgckbhgCOup5bvfRUuTHGrpzyOILawdJU+V6E0s9
	LzHeyQbLEz4HNWzuMjTKj/+MmsFLjkMQAdDrHdijgoAONVV0eJ21Psv2EWEmnwQE
	O6CeMFeNVDB/DOHI6cT7Ay9RBzguJq5xsIP0Da1oUxYk3HcdaxGQROC6CRLTrBzn
	UoE9oU4/+WqAAytWGiW69mPmV4tmVonrKTgkl0o3sluX7ARnXTQZpKBenrRq+/5u
	M+VtEdOmpcymGeVw00zLsAxB3qD9VfaRefcHL7FpLnvk98KEi3ku6GNHdC36UJYW
	pV2n5ccFv1TG0N1qPTrpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1775255285; x=1775341685; bh=ixLjghp11nHA0XTsXBwaf1hrqJU7
	wgZtgoeqT6n1Erc=; b=NoxAY+Xej9vODVuuJUevmFp8S45K+8n13D0lUIIrbdNf
	gnvgm9th+oGv1TzhSj30JuLkEeaYz6yANMdldsmhuMEfRJcC9EOSz41e225tHrVV
	njFm/kRnaSE0Hzq2MZC6TEPvhYoFk+03fKiBOkf2+wphTpYJ/TStmq/FvgW/uefF
	ZZBVI5iYM0VXhvLwEdHB9IieunEQ19Nh4XJXY64aQYvc6CfMAej0SsUYm0IBVc1U
	ODJTFdruzEq/gMBnPd2eOL6Cvcq2iiXsw5IPWxRApKLCIvchGTg909OTV1mJZqDz
	iEQxtUDHkMoRzl4QcECOxbzZ9mIJ0VC171DqhEDUXA==
X-ME-Sender: <xms:9D7QaSxoF5Vu1prBqW6TfY25qen_YNPKbU4sRpssMm-3AxHtlCJl4w>
    <xme:9D7QaUSCsovR8KP66du9sCV1wIAN0rOKXlf9u2IuuxSTvl8w0dWXuQRiyfdF9KXn1
    Fn6rse94PgLFEdHLXpDfjbHG4EVBpgESvajAkR5Ir09Ne_nTMRjWkk>
X-ME-Received: <xmr:9D7QaR-FAx-cz6aSFoptREO19gMs8fmtAXuZDjGxcnxDZvUj5dq8SgdO_rNt0mEgeq279_BXiGWOQ-oz6ewi-krkJGE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvdehtd
    dufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:9D7QaTrRhyDRjRlolQR14fwLqiv5sorU94vMU2lN7C8G666cLqx6Bg>
    <xmx:9D7QaWmvDPcBn6M4pK08v0FNZGRbjHSwql0W11npGIEkcXlIHt2DPA>
    <xmx:9D7QaSLxYvZqpFMPCa6kEVTNDni_LHmWEhD-jFmhWurL20hxaDMfaw>
    <xmx:9D7QaTzqsW-Fd1u1FnO9JTOLVzfwM68GbtY1D6lDfvkDzH7a7j7cQA>
    <xmx:9T7QaTXgY9qze2xvkH9F5N5gZ5Etry9Y5FyFBtNY-ateWvn7g-9MbnUJ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Apr 2026 18:28:04 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 4/5] btrfs: make inode->outstanding_extents a u64
Date: Fri,  3 Apr 2026 15:27:54 -0700
Message-ID: <2e52baa8f1c0513c4fa08b38a0bfd3c7d5e16108.1775255085.git.boris@bur.io>
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
 fs/btrfs/delalloc-space.c    | 19 +++++++++----------
 fs/btrfs/inode.c             | 14 +++++++-------
 fs/btrfs/ordered-data.c      |  4 ++--
 fs/btrfs/tests/inode-tests.c | 18 +++++++++---------
 include/trace/events/btrfs.h |  8 ++++----
 6 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index fad61b4d94a7..259af3f6ebb5 100644
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
@@ -429,14 +429,20 @@ static inline bool is_data_inode(const struct btrfs_inode *inode)
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
index 2c99e332e25b..f4851cc7e2a8 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -274,7 +274,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
 	u64 reserve_size = 0;
 	u64 qgroup_rsv_size = 0;
-	unsigned outstanding_extents;
+	u64 outstanding_extents;
 
 	lockdep_assert_held(&inode->lock);
 	outstanding_extents = inode->outstanding_extents;
@@ -301,7 +301,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
 	 *
 	 * This is overestimating in most cases.
 	 */
-	qgroup_rsv_size = (u64)outstanding_extents * fs_info->nodesize;
+	qgroup_rsv_size = outstanding_extents * fs_info->nodesize;
 
 	spin_lock(&block_rsv->lock);
 	block_rsv->size = reserve_size;
@@ -364,7 +364,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_block_rsv *block_rsv = &inode->block_rsv;
 	u64 meta_reserve, qgroup_reserve;
-	unsigned nr_extents;
+	u64 nr_extents;
 	enum btrfs_reserve_flush_enum flush = BTRFS_RESERVE_FLUSH_ALL;
 	int ret = 0;
 
@@ -418,7 +418,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	 */
 	nr_extents = btrfs_inode_max_extents(inode, num_bytes);
 	spin_lock(&inode->lock);
-	btrfs_mod_outstanding_extents(inode, nr_extents);
+	btrfs_mod_outstanding_extents(inode, 1, nr_extents);
 	if (!(inode->flags & BTRFS_INODE_NODATASUM))
 		inode->csum_bytes += disk_num_bytes;
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
@@ -480,11 +480,11 @@ void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
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
 
@@ -498,16 +498,15 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
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
index 1e53ff65d1a7..965c2739d33b 100644
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

