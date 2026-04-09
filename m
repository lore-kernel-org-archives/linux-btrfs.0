Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC513CB2D9
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775756950; cv=none; b=agHkWTd7HGVkqzLFGnfZlbZKCBQT36dGVzRS6BieW9om3965Sjp9XyZu8y1hodhdZOPG9hPV43emdwSJxsw2GhFljKuWfa0DUuJYu7yZsFJM+1/APgRJbZSlzZILpBbUlIZGI6Gt/yHSiVrMDOnIMsxB7SWWl7hH4rwpGb//+Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775756950; c=relaxed/simple;
	bh=3wbebPS/GhCMxbUlGr6/ezc/s/akFBAb7p7RIBCBXgU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAFZ6OsTyBdbAUgWd96SNp1hlJDY0RO5ZSJZVc+EtcX3AVaHw2GvR564NTWriwzO4DZwsV+rU7OviVvSjjmhqQg4ZkxkT8MEq8x39Ecm/h4ZzxeG4kFYGHK0Q0USLFPdnSyFHbSsypwYetVJeTbnEin+kt2S3MXxSArrAoOGxZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=H7sDKd85; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GFf1XXy2; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="H7sDKd85";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GFf1XXy2"
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3CC007A019D;
	Thu,  9 Apr 2026 13:49:08 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 09 Apr 2026 13:49:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1775756948; x=
	1775843348; bh=u/kb1ZDFLiilABO5gatzmc3eaQB1oRSHhhflPQVkoIs=; b=H
	7sDKd85ixuY2cfi9OnFTRQPWQipmhm0BXOmSt+vpdIfAB+OBmt+SRoOmocsQYhQq
	6ruPGcm3u2x9LJyVvj+KKRdeGt3TYlRSzj46sMEW8LwaUctwXM0PUA+zBUnlrcLl
	i+Tyrupx2NGPWxJij1vUlM61S1gN+edrOLobhxaDK52fL1am/xieGUyWvp7iktM8
	fQBe/AvHd7LjwffzFkqBZ0tw66cbJGAHuEDzI31AvBDyl1LWh/H69QrbhFo5kxKZ
	TGusCdF9N/hKWvnCv0Du3WiFPMiy5lezJIodIuu45aQ42kFMKH/4lq4/yOFM8iGp
	vEgd3Y+W043XboFEeprNA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1775756948; x=1775843348; bh=u/kb1ZDFLiilABO5gatzmc3eaQB1
	oRSHhhflPQVkoIs=; b=GFf1XXy2iVV3p+LdGWKYkA+S/kWGQtQ3daTPWNdSb1im
	x7a4KkqA/aOQc/OIIt9gBrabu4XLAT3PSuPHAbgmQt/rtVJR3dHJacgyzZLPznYM
	6FYESZioHmk65IP5nWlcrmUIy20z7DmweSOAICejmbCMaxy66r7CTXBpp4fFQ4WX
	ITamSL/NDMYvg7uybrDQZmNRo/PjRylFjixdiikh2Xku/hjRzz9ML36fcKvA3vJW
	GiXc+wkbpsFqPDVgQ2UCLPxY5M75njmH5mSJ0NjHzepuR6fKg+/ToXHUub0jxR6g
	PX48/9GgsAkyX7d4G62fJ6nYYss6L1JPBuej63OEiw==
X-ME-Sender: <xms:lObXaQAsnv0wL4d9dCUKwseeeIiFC7KWR8fE38pQWmPCmZJpp8VDew>
    <xme:lObXaYhbdIBF3REO84wZpLFraCX-I9MTIvenpSg_KCjIbxh2gr59jv0kucxwXwq8a
    i81eUbVLw4SyDAoD9fBTgElo1wHtgPG3FvgoGWXYNWXI8F18boRYRgZ>
X-ME-Received: <xmr:lObXaRMfcMGg6Y3smjfx3O6hYV6WhA1HJjqNw92TDiWWtExvqOQSgspGuc5cCwWY9s4C3O3l0Y64Zob41RcDS540eGc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddvjedufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvdehtd
    dufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:lObXaR6WBmCEbb-rTxESQC2uWmnPQdH2s7DUU5mhtlZZcxCQekZDhA>
    <xmx:lObXaX1cGx90j8Yi55tifYHocqP5LzFx7NZPDUReP6QI19I4pgAdEA>
    <xmx:lObXaaaakhqJqV1tiQV3VrTraJL_-L2SBzqnxGbqc-D2hTaJn35Ucw>
    <xmx:lObXaXCv-WdR1waUq6kQILj5EAQFEMRp07NnRxTtXBFRUnBuaL4tgQ>
    <xmx:lObXaUmn0jLmKnkk4iCAl1N5yicoVLuwQv-OG7UwFVD8sBJHDx_F2o_t>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Apr 2026 13:49:07 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v4 2/4] btrfs: account for compression in delalloc extent reservation
Date: Thu,  9 Apr 2026 10:48:49 -0700
Message-ID: <b1da881707fe4a7010c4b4543aafbee26fb70a45.1775756790.git.boris@bur.io>
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

The btrfs maximum uncompressed extent size is 128MiB. The maximum
compressed extent size in file extent space is 128KiB. Therefore, the
estimate for outstanding_extents is off by 3 orders of magnitude when
COMPRESS_FORCE is set or the inode is set to always compress.

Because we use re-calculation when necessary, rather than super detailed
extent tracking, we don't grow this reservation as the true number of
extents is revealed. We don't want to be too clever with it, however, as
we don't want the calculation to change for a given inode between
reservation and release, so we only rely on the forcing type flags.

With this change, we no longer under-reserve delayed refs reservations
for delalloc writes, even with compress-force.

Because this would turn count_max_extents() into a named shim for
div_u64(size + max_extent_size - 1, max_extent_size);
we can just get rid of it.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/btrfs_inode.h    |  2 +
 fs/btrfs/delalloc-space.c | 12 +++---
 fs/btrfs/fs.h             | 13 -------
 fs/btrfs/inode.c          | 78 ++++++++++++++++++++++++++++++++-------
 4 files changed, 72 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 55c272fe5d92..5368ef87b41a 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -510,6 +510,8 @@ static inline bool btrfs_inode_can_compress(const struct btrfs_inode *inode)
 	return true;
 }
 
+u64 btrfs_inode_max_extents(const struct btrfs_inode *inode, u64 size);
+
 static inline void btrfs_assert_inode_locked(struct btrfs_inode *inode)
 {
 	/* Immediately trigger a crash if the inode is not locked. */
diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 63e174cc9393..609ec75884cd 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -65,7 +65,7 @@
  *     This is the number of file extent items we'll need to handle all of the
  *     outstanding DELALLOC space we have in this inode.  We limit the maximum
  *     size of an extent, so a large contiguous dirty area may require more than
- *     one outstanding_extent, which is why count_max_extents() is used to
+ *     one outstanding_extent, which is why we use the max extent size to
  *     determine how many outstanding_extents get added.
  *
  *   ->csum_bytes
@@ -324,7 +324,7 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
 				    u64 *meta_reserve, u64 *qgroup_reserve)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	u64 nr_extents = count_max_extents(fs_info, num_bytes);
+	u64 nr_extents = btrfs_inode_max_extents(inode, num_bytes);
 	u64 csum_leaves;
 	u64 inode_update = btrfs_calc_metadata_size(fs_info, 1);
 
@@ -423,7 +423,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	 * racing with an ordered completion or some such that would think it
 	 * needs to free the reservation we just made.
 	 */
-	nr_extents = count_max_extents(fs_info, num_bytes);
+	nr_extents = btrfs_inode_max_extents(inode, num_bytes);
 	spin_lock(&inode->lock);
 	btrfs_mod_outstanding_extents(inode, nr_extents);
 	if (!(inode->flags & BTRFS_INODE_NODATASUM))
@@ -490,7 +490,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 	unsigned num_extents;
 
 	spin_lock(&inode->lock);
-	num_extents = count_max_extents(fs_info, num_bytes);
+	num_extents = btrfs_inode_max_extents(inode, num_bytes);
 	btrfs_mod_outstanding_extents(inode, -num_extents);
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
@@ -505,8 +505,8 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 void btrfs_delalloc_shrink_extents(struct btrfs_inode *inode, u64 reserved_len, u64 new_len)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	const u32 reserved_num_extents = count_max_extents(fs_info, reserved_len);
-	const u32 new_num_extents = count_max_extents(fs_info, new_len);
+	const u32 reserved_num_extents = btrfs_inode_max_extents(inode, reserved_len);
+	const u32 new_num_extents = btrfs_inode_max_extents(inode, new_len);
 	const int diff_num_extents = new_num_extents - reserved_num_extents;
 
 	ASSERT(new_len <= reserved_len);
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index a4758d94b32e..2c1626155645 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1051,19 +1051,6 @@ static inline bool btrfs_is_zoned(const struct btrfs_fs_info *fs_info)
 	return IS_ENABLED(CONFIG_BLK_DEV_ZONED) && fs_info->zone_size > 0;
 }
 
-/*
- * Count how many fs_info->max_extent_size cover the @size
- */
-static inline u32 count_max_extents(const struct btrfs_fs_info *fs_info, u64 size)
-{
-#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-	if (!fs_info)
-		return div_u64(size + BTRFS_MAX_EXTENT_SIZE - 1, BTRFS_MAX_EXTENT_SIZE);
-#endif
-
-	return div_u64(size + fs_info->max_extent_size - 1, fs_info->max_extent_size);
-}
-
 static inline unsigned int btrfs_blocks_per_folio(const struct btrfs_fs_info *fs_info,
 						  const struct folio *folio)
 {
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 15945744a304..55255f3794c6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -747,6 +747,56 @@ static int add_async_extent(struct async_chunk *cow, u64 start, u64 ram_size,
 	return 0;
 }
 
+/*
+ * Check if compression will definitely be attempted for this inode based on
+ * mount options and inode properties.  Unlike inode_need_compress(), this does
+ * NOT run the compression heuristic or check range-specific conditions, so it
+ * is safe to call under locks (e.g. io_tree lock) and for reservation sizing.
+ *
+ * Only returns true for cases where BTRFS_INODE_NOCOMPRESS cannot be set at
+ * runtime (FORCE_COMPRESS and prop_compress), ensuring that the effective max
+ * extent size is stable across paired set/clear delalloc operations.
+ */
+static inline bool inode_may_compress(const struct btrfs_inode *inode)
+{
+	if (!btrfs_inode_can_compress(inode))
+		return false;
+
+	/* Force compress always attempts compression. */
+	if (btrfs_test_opt(inode->root->fs_info, FORCE_COMPRESS))
+		return true;
+
+	/* Per-inode property: NOCOMPRESS cannot override this. */
+	if (inode->prop_compress)
+		return true;
+
+	return false;
+}
+
+/*
+ * Return the effective maximum extent size for reservation accounting.
+ *
+ * When compression is guaranteed to be attempted (FORCE_COMPRESS or
+ * prop_compress), the compression path splits ranges into
+ * BTRFS_MAX_UNCOMPRESSED chunks, each producing an independent ordered
+ * extent.  Use that as the divisor instead of fs_info->max_extent_size
+ * to avoid severely undercounting outstanding extents.
+ */
+static u64 btrfs_inode_max_extent_size(const struct btrfs_inode *inode)
+{
+	if (inode_may_compress(inode))
+		return BTRFS_MAX_UNCOMPRESSED;
+
+	return inode->root->fs_info->max_extent_size;
+}
+
+u64 btrfs_inode_max_extents(const struct btrfs_inode *inode, u64 size)
+{
+	u64 max_extent_size = btrfs_inode_max_extent_size(inode);
+
+	return div_u64(size + max_extent_size - 1, max_extent_size);
+}
+
 /*
  * Check if the inode needs to be submitted to compression, based on mount
  * options, defragmentation, properties or heuristics.
@@ -2459,8 +2509,8 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_fol
 void btrfs_split_delalloc_extent(struct btrfs_inode *inode,
 				 struct extent_state *orig, u64 split)
 {
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	u64 size;
+	u64 max_extent_size = btrfs_inode_max_extent_size(inode);
 
 	lockdep_assert_held(&inode->io_tree.lock);
 
@@ -2469,8 +2519,8 @@ void btrfs_split_delalloc_extent(struct btrfs_inode *inode,
 		return;
 
 	size = orig->end - orig->start + 1;
-	if (size > fs_info->max_extent_size) {
-		u32 num_extents;
+	if (size > max_extent_size) {
+		u64 num_extents;
 		u64 new_size;
 
 		/*
@@ -2478,10 +2528,10 @@ void btrfs_split_delalloc_extent(struct btrfs_inode *inode,
 		 * applies here, just in reverse.
 		 */
 		new_size = orig->end - split + 1;
-		num_extents = count_max_extents(fs_info, new_size);
+		num_extents = btrfs_inode_max_extents(inode, new_size);
 		new_size = split - orig->start;
-		num_extents += count_max_extents(fs_info, new_size);
-		if (count_max_extents(fs_info, size) >= num_extents)
+		num_extents += btrfs_inode_max_extents(inode, new_size);
+		if (btrfs_inode_max_extents(inode, size) >= num_extents)
 			return;
 	}
 
@@ -2498,9 +2548,9 @@ void btrfs_split_delalloc_extent(struct btrfs_inode *inode,
 void btrfs_merge_delalloc_extent(struct btrfs_inode *inode, struct extent_state *new,
 				 struct extent_state *other)
 {
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	u64 new_size, old_size;
-	u32 num_extents;
+	u64 max_extent_size = btrfs_inode_max_extent_size(inode);
+	u64 num_extents;
 
 	lockdep_assert_held(&inode->io_tree.lock);
 
@@ -2514,7 +2564,7 @@ void btrfs_merge_delalloc_extent(struct btrfs_inode *inode, struct extent_state
 		new_size = other->end - new->start + 1;
 
 	/* we're not bigger than the max, unreserve the space and go */
-	if (new_size <= fs_info->max_extent_size) {
+	if (new_size <= max_extent_size) {
 		spin_lock(&inode->lock);
 		btrfs_mod_outstanding_extents(inode, -1);
 		spin_unlock(&inode->lock);
@@ -2540,10 +2590,10 @@ void btrfs_merge_delalloc_extent(struct btrfs_inode *inode, struct extent_state
 	 * this case.
 	 */
 	old_size = other->end - other->start + 1;
-	num_extents = count_max_extents(fs_info, old_size);
+	num_extents = btrfs_inode_max_extents(inode, old_size);
 	old_size = new->end - new->start + 1;
-	num_extents += count_max_extents(fs_info, old_size);
-	if (count_max_extents(fs_info, new_size) >= num_extents)
+	num_extents += btrfs_inode_max_extents(inode, old_size);
+	if (btrfs_inode_max_extents(inode, new_size) >= num_extents)
 		return;
 
 	spin_lock(&inode->lock);
@@ -2616,7 +2666,7 @@ void btrfs_set_delalloc_extent(struct btrfs_inode *inode, struct extent_state *s
 	if (!(state->state & EXTENT_DELALLOC) && (bits & EXTENT_DELALLOC)) {
 		u64 len = state->end + 1 - state->start;
 		u64 prev_delalloc_bytes;
-		u32 num_extents = count_max_extents(fs_info, len);
+		u32 num_extents = btrfs_inode_max_extents(inode, len);
 
 		spin_lock(&inode->lock);
 		btrfs_mod_outstanding_extents(inode, num_extents);
@@ -2662,7 +2712,7 @@ void btrfs_clear_delalloc_extent(struct btrfs_inode *inode,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	u64 len = state->end + 1 - state->start;
-	u32 num_extents = count_max_extents(fs_info, len);
+	u32 num_extents = btrfs_inode_max_extents(inode, len);
 
 	lockdep_assert_held(&inode->io_tree.lock);
 
-- 
2.53.0

