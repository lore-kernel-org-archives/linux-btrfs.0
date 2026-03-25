Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1EF20F067
	for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2026 00:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774399340; cv=none; b=PZuT7w53Bq4easW0nATpJXEsdCqBQpa44SJI92bcwdAjqnYwMZ29cyrdgGly35E94TW9IXtXtKFBz9fRK5p7PmImBxzg5Hhrnf6n4K69mZEsFiCqmyW3QJmKBTjGSgLBmC9ElFRcbjPAe9uA03iFThLKCIMwxOrcJtoHSl1BPRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774399340; c=relaxed/simple;
	bh=3Anhlz4Wlfw7E65XeFBJZ5nZc6PYWnEgMmPTQVhhV44=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AzxC/iLf/fQMH8MNUOOgjPHMOCUQUjoec5ee+M7QigMMYL/ekFN272YK9irzZgSXJrLgcEIkGt0rKLf2zeCVw8jnRwdhiTSD0XvYpTElDULEF86UFzDVDQ2mV8szSKzSMsUg+SOXphMx29QV5qiMZlXv2PterNZEaG5V8WOmYzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=Iiftiq0B; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=HXn91sAZ; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="Iiftiq0B";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="HXn91sAZ"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id EF086EC00AE;
	Tue, 24 Mar 2026 20:42:17 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 24 Mar 2026 20:42:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1774399337; x=
	1774485737; bh=CJvzKERbHeUkLzXtnwQTeiIEgpduTDZ37pVVgUHV/u0=; b=I
	iftiq0B183AyVzjExvwAS7NOb+cVhbA22mUcbN+muT2EhGug9ccmngwedBursGPO
	sxigVqsTR6idAimwW9ZGPCj/mQs9IrpazWBewQFjzqfiovO0TY3LF2G7yWVSI7BJ
	rt17ZdiZD8Cfg4VeDwY3KTkIsvl+N1a/a4QS3JXlH5wKnKHSisxQ8lhcIm7WtxF7
	GMnID2msUrICZbUk1PYoVZ9YRitn/PwTsyoIsZ5oESbI+s4qgd4P8/kOobVjiW1S
	1ZzsalJor6V9L+RI4pjf1bdBB213gvb019qa6pEYWc+FPdlgrWfGXrx/CsggTEXu
	YAkzDdyfC1+sHYHe4qQgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1774399337; x=1774485737; bh=CJvzKERbHeUkLzXtnwQTeiIEgpdu
	TDZ37pVVgUHV/u0=; b=HXn91sAZ5D0r0Mq6+FrUTq62eTKrM8OPIFF0VxVG9XNS
	uZ+1pnjxugzJ4XXuvGNwrY5jgfthnnzOEPx3C0+jtbTms7G6kawzEjKiLFY/+7OY
	hqpYOwu0IQYYuVCVb4ePyOPfdXVgBmfCfRo7IaMB5mJxRwNyxo4QT8y6IMnYlvPq
	zSYPgI4QISHrLi5CZe22eiSiDpEXU+eDqy8Yz8HqJ+krTqC+Ifwm5izRmjnzhuE4
	Xlce1aJYqtpxVz7qfdkbGRmCpWGDFhYRZcVYjdx8zeD1DEvKw8bceIdS5fhXDF43
	XZ551L48b3S1Jv3jTp/grPQGFpq/mOAringuIFlS1g==
X-ME-Sender: <xms:aS_DaT4bs8oRR5ubnKQoRJ10VGAlMhVqQXRsVr3UDHMuIfwlH4cYeQ>
    <xme:aS_Dae7sd_LGEtFcwAPrM6Nox82dysqHBKZ2yXq8WWZ5KRtP0TFp7oGx0NtuW6Via
    zS4UjgOGfxiWuYSf59LkBL6MvNxX7eySMMYwgzZ4lOULWjp_zEX_RU>
X-ME-Received: <xmr:aS_DaYGrnv_kp98P1yZ4qWNnVZ0OC5XTIeZKySd-OWsnJRfKIIyA2cBsAx6kqSeH59az87MVqyipP_iY656X27rYfRg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdeftdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffvedvhe
    dtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpegsohhrihhssegsuhhrrdhiohdpnhgspghrtghpthhtohepvddpmhhoug
    gvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqsghtrhhfshesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehfsgdrtghomh
X-ME-Proxy: <xmx:aS_DafQ0a4UehtGNyoYcUg1Unu6DBOH9KDv1ohW4G5ATZaaiJpGI5A>
    <xmx:aS_DaZtB73KXS3nM2cl5OO2u3md_WZI_6vhkRxivnFyfNZPaDu5c7Q>
    <xmx:aS_DaWwcTGdsf_RzDlaNelO4Y1LEAdUOD40_VOVOGNp7PHNxGSK33A>
    <xmx:aS_Dab7UFRRrs56Orh1l0vP_nXTs8XjF-hLMLnPSIoxungavnMzZtA>
    <xmx:aS_DaWdzRcecprcxiR7OEn_ZHG_h1KPYPY5QoTyKYbjlGFnnhi0lYgrA>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Mar 2026 20:42:17 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 3/5] btrfs: account for compression in delalloc extent reservation
Date: Tue, 24 Mar 2026 17:41:51 -0700
Message-ID: <9197a800c67c3f0de9379a321296ff3e8ae949cb.1774398665.git.boris@bur.io>
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

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/btrfs_inode.h    |  3 ++
 fs/btrfs/delalloc-space.c | 13 ++++---
 fs/btrfs/fs.h             | 13 -------
 fs/btrfs/inode.c          | 78 ++++++++++++++++++++++++++++++++-------
 4 files changed, 74 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index dca4f6df7e95..cfeda43b01d7 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -513,6 +513,9 @@ static inline bool btrfs_inode_can_compress(const struct btrfs_inode *inode)
 	return true;
 }
 
+u64 btrfs_inode_max_extent_size(const struct btrfs_inode *inode);
+u64 btrfs_inode_max_extents(const struct btrfs_inode *inode, u64 size);
+
 static inline void btrfs_assert_inode_locked(struct btrfs_inode *inode)
 {
 	/* Immediately trigger a crash if the inode is not locked. */
diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 2eeafada96ec..2ceae1065f2c 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -6,6 +6,7 @@
 #include "delayed-ref.h"
 #include "block-rsv.h"
 #include "btrfs_inode.h"
+#include "compression.h"
 #include "space-info.h"
 #include "qgroup.h"
 #include "fs.h"
@@ -64,7 +65,7 @@
  *     This is the number of file extent items we'll need to handle all of the
  *     outstanding DELALLOC space we have in this inode.  We limit the maximum
  *     size of an extent, so a large contiguous dirty area may require more than
- *     one outstanding_extent, which is why count_max_extents() is used to
+ *     one outstanding_extent, which is why we use the max extent size to
  *     determine how many outstanding_extents get added.
  *
  *   ->csum_bytes
@@ -324,7 +325,7 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
 				    u64 *qgroup_reserve)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	u64 nr_extents = count_max_extents(fs_info, num_bytes);
+	u64 nr_extents = btrfs_inode_max_extents(inode, num_bytes);
 	u64 csum_leaves;
 	u64 inode_update = btrfs_calc_metadata_size(fs_info, 1);
 
@@ -408,7 +409,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	 * racing with an ordered completion or some such that would think it
 	 * needs to free the reservation we just made.
 	 */
-	nr_extents = count_max_extents(fs_info, num_bytes);
+	nr_extents = btrfs_inode_max_extents(inode, num_bytes);
 	spin_lock(&inode->lock);
 	btrfs_mod_outstanding_extents(inode, nr_extents);
 	if (!(inode->flags & BTRFS_INODE_NODATASUM))
@@ -477,7 +478,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 	unsigned num_extents;
 
 	spin_lock(&inode->lock);
-	num_extents = count_max_extents(fs_info, num_bytes);
+	num_extents = btrfs_inode_max_extents(inode, num_bytes);
 	btrfs_mod_outstanding_extents(inode, -num_extents);
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
@@ -492,8 +493,8 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
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
index 1f0f3282e4b8..e567b23efe39 100644
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
+	/* force compress always attempts compression */
+	if (btrfs_test_opt(inode->root->fs_info, FORCE_COMPRESS))
+		return true;
+
+	/* per-inode property: NOCOMPRESS cannot override this */
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
+u64 btrfs_inode_max_extent_size(const struct btrfs_inode *inode)
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

