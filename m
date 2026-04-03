Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F3C625
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 22:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775255285; cv=none; b=Erjwm5Yr5li1Kk1uEx9V+FHJ0AR7UM9NLjTWFx0aOsWUQXidgZ7cz8HC0Q4wHNgRyGO5nWe1hwyUUQD3D+u1uUD9fdq4wgSCFMIXn5tlJflR4eWVB5yuX9HLAgT9ckGrC12OMU3kZau4k6HZ69s20RwV/fR3NgP+RgRhn7CjI+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775255285; c=relaxed/simple;
	bh=YGA6U/g+YLCovWlc9jelz0CGDkfiPaOxXKCHLLUxMjQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIM5rymWE3Q1kdnkO2gXTx+L9ZH40yqMlMU9Z4PZMiaFGqYZ2Db7+4oRBzAA5GQrdof6tPY9nu5i3Lsb9c+8WpEXe5tTbbe4hbv4zi112sFgNV9caB+pjiZ7s2Hg7R46mN0+cVTcxHem8DLFdQyRFzfr3AqpsMMI8TUBw1KhCvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=kZqqGVFz; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=q8herA4e; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="kZqqGVFz";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="q8herA4e"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 625C3EC00B5;
	Fri,  3 Apr 2026 18:28:03 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 03 Apr 2026 18:28:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1775255283; x=
	1775341683; bh=rv6xRxh1NOOznrFelLW/CjZ3iG9rnnhnz4QW9AWQQJI=; b=k
	ZqqGVFzmb+W/04cSjYCpDGKpNz2ffzPP1gylV+wK4ZoWsiK/DCA1++3ERhGmU3vb
	OkPaKcz6SQ/I770u1FWtmHldNdOpBOdWjoCW7oZILJ1Ue/KsHVsxk62V53wSnIdF
	GQgxymVNv3Y5aeWQpju8YsUut43WOBAEzHMst2CJb+S2aDGQ64unrkEhlCR8+8Jp
	1XSRG64mt4ADb7CDEPqOLj2VOEKe6963H4gGRbDwbHRekCPAuW5WiHEd0ukISICP
	5w5A9vU9/qLTEhrcZ4k+eD0lDLx9RGrlXPo1r3Rs2f2NWbX1MvwP7OIR/47r/+EH
	vysmhqK0qOHKelXcC8vEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1775255283; x=1775341683; bh=rv6xRxh1NOOznrFelLW/CjZ3iG9r
	nnhnz4QW9AWQQJI=; b=q8herA4eUaJimUpHEOz4hiO/k4m6aJqVoudxFqzc+NW6
	EbVEIzPh3wgbw3Bn1w0QqRLZW4nEB/pdtW1dLdKEKTSrWPSWzBOwV69Os9WU1Yyo
	CWyfkS+1qxMhVFhr7EV0V7w2oew/ZZk6c8eHzZ9+LwwVTpkB/tUJ/YUQaQOFDP2u
	AxWvYombfpFwJHIpDqZFZ/eHuMgxocL0tGir0gaFaECyMQfLewPWzUYtIMXNk/Qs
	p4qpevd1XlSSY+j83zu7/1EjKJqDQXztFzn3xBeI6JpqlTtT6a6ZCd+CqPRorraP
	kfe13jIlbbJ2TeFpikRKPNgs70CfOfYXSaqO0ahv1A==
X-ME-Sender: <xms:8z7QaagCgXMChP_Gl_vAOMszRnbbpB882s7sTC5Kh6ZHeTPu9KSuzw>
    <xme:8z7QaRCxxBEXQED4FmLbKqGB8aDrH9D3i2LRBXY_dAZwnl4i3T1HIx7UAU6YmtS7T
    rHWey8B6rvXzEDJcszeWnFPAFX8w9hd62BoByw2WhgCUkez6XEUKFdu>
X-ME-Received: <xmr:8z7Qafu53Ja7byReK3sPUlrS0dc7DZ4prD9vyhRnLx97tv4M8VeWvaBdVIp2wA93Hk2bDkANou1rl_vrZnfw1TWn6fM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddutddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertdertd
    dtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheq
    necuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvdehtd
    dufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepsghorhhishessghurhdrihhopdhnsggprhgtphhtthhopedvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesfhgsrdgtohhm
X-ME-Proxy: <xmx:8z7Qaeb6UNBJUoPPL-hVR-XHlXVNOOyojDp6kRwiLJ5Om1qjZ44ufA>
    <xmx:8z7QaaX1sx2ss-Utg6w741jH4t1AHO3A0OFZKtBUyuXKt4pTn62otw>
    <xmx:8z7Qaa7ABXwgtBglpZFagHxasZH1lDpo7j73eJ0V7SgWa55hbsMfzQ>
    <xmx:8z7QadgQjFl64YuoXpkN1qvdqIvGdDoY70_A3-R9njgU3atXaz0kwg>
    <xmx:8z7QaXH0tsN2i14crEUm2EXipxJxeK4ZgsK7kUC5v31hvH8nErPWVzma>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Apr 2026 18:28:02 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 3/5] btrfs: account for compression in delalloc extent reservation
Date: Fri,  3 Apr 2026 15:27:53 -0700
Message-ID: <f408808263a63e3b0d13f225b9bb245e0acc5a30.1775255085.git.boris@bur.io>
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
index 55c272fe5d92..fad61b4d94a7 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -510,6 +510,9 @@ static inline bool btrfs_inode_can_compress(const struct btrfs_inode *inode)
 	return true;
 }
 
+u64 btrfs_inode_max_extent_size(const struct btrfs_inode *inode);
+u64 btrfs_inode_max_extents(const struct btrfs_inode *inode, u64 size);
+
 static inline void btrfs_assert_inode_locked(struct btrfs_inode *inode)
 {
 	/* Immediately trigger a crash if the inode is not locked. */
diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index c2e5c7758ed5..2c99e332e25b 100644
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
@@ -65,7 +66,7 @@
  *     This is the number of file extent items we'll need to handle all of the
  *     outstanding DELALLOC space we have in this inode.  We limit the maximum
  *     size of an extent, so a large contiguous dirty area may require more than
- *     one outstanding_extent, which is why count_max_extents() is used to
+ *     one outstanding_extent, which is why we use the max extent size to
  *     determine how many outstanding_extents get added.
  *
  *   ->csum_bytes
@@ -314,7 +315,7 @@ static void calc_inode_reservations(struct btrfs_inode *inode,
 				    u64 *qgroup_reserve)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	u64 nr_extents = count_max_extents(fs_info, num_bytes);
+	u64 nr_extents = btrfs_inode_max_extents(inode, num_bytes);
 	u64 csum_leaves;
 	u64 inode_update = btrfs_calc_metadata_size(fs_info, 1);
 
@@ -415,7 +416,7 @@ int btrfs_delalloc_reserve_metadata(struct btrfs_inode *inode, u64 num_bytes,
 	 * racing with an ordered completion or some such that would think it
 	 * needs to free the reservation we just made.
 	 */
-	nr_extents = count_max_extents(fs_info, num_bytes);
+	nr_extents = btrfs_inode_max_extents(inode, num_bytes);
 	spin_lock(&inode->lock);
 	btrfs_mod_outstanding_extents(inode, nr_extents);
 	if (!(inode->flags & BTRFS_INODE_NODATASUM))
@@ -482,7 +483,7 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
 	unsigned num_extents;
 
 	spin_lock(&inode->lock);
-	num_extents = count_max_extents(fs_info, num_bytes);
+	num_extents = btrfs_inode_max_extents(inode, num_bytes);
 	btrfs_mod_outstanding_extents(inode, -num_extents);
 	btrfs_calculate_inode_block_rsv_size(fs_info, inode);
 	spin_unlock(&inode->lock);
@@ -497,8 +498,8 @@ void btrfs_delalloc_release_extents(struct btrfs_inode *inode, u64 num_bytes)
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
index c57473030814..1e53ff65d1a7 100644
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

