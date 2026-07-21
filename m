Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF427435A98
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 22:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673772; cv=none; b=lS2iYltMRdtkXheuOS6lWKnEsLxlw+Bg1n1PX6QlMTUPAbrxfqUDnNBZiEDD6R4m5B/m9j+1sUEsUoy5XlTHXy0RqkON154Co+h0SGlkzBVR2D8XL1WV6ONORbmRaBOae4/MzyYqCkRLiFnD1eevJKAF5uv7PWB71T25hNz+4ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673772; c=relaxed/simple;
	bh=iOoZi2SRtBwZ0gg7XTRlGFCkhoqEhbbLOs7XNId8gpM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ2pbOI2r0JwPCmqIQ02DJtmdcCOqyBvWm6HFFZ2B7jvKLr0FcRe4TH4ThF7Km6LJNpineoGwdhHKZPeu/gU2IDXlG7rs3SpiNUnijlO/6BwAiSqDLn71nl/iyMdBV81eHLnSzyC/rp2x64r5sU1tpLelPw1PeZ//oQvohE6Q/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=cEQhubWC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=RXHqnbec; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="cEQhubWC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="RXHqnbec"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 180FC1D000AE;
	Tue, 21 Jul 2026 18:42:50 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 21 Jul 2026 18:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784673769; x=
	1784760169; bh=IWHQmH+ewscp3QDYLHdnb/YeMTlsHaSIMwvOGxbeUlg=; b=c
	EQhubWCscePFCDqzBAMrKuPGOLQTeS2370eu+hPDwnDqrp4U64sPeEGhtxJejbAy
	pWOJTfKu30bOs4SAf6ghTU9ZbfOM4jOOxVFU7m1YBqFMWfaxgsEG0czzvKBqc5Hb
	HU4YKi2plPdmv66EoRy+q0oQsd5WaMY9/odTc3wRdwXIYQr3yxtYx8DBFhHJaNtO
	SORQTOfuyet7q7Ztk3KJGIQIJJ4lPBvz8qVLy6TIcEziZyK8JVfNULFBR2JXhzqy
	n8ERqgp4SQn7GBfssZxPpirn7m0RTfUjiLCL16T6p4mhtmErEegzw8XRp8LP9rVy
	m7LUfkBNmIPWikr2arnxQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1784673769; x=1784760169; bh=IWHQmH+ewscp3QDYLHdnb/YeMTls
	HaSIMwvOGxbeUlg=; b=RXHqnbecnPOfEXz4klsj8Ppx1iXN91OfsHQACls+uuqV
	3moNn3R2KFsNeoKzct+6m69QzoneMBftNmXD+KSIRJp8uvyNhyc5GxuqYs79/U1Z
	rvB3KPO5kk67BVAgbXo3VVJ2uq14txyvBYzNtnpcSpJp48QBFU8I4ANXFyhzGlJV
	/g+cTA6XyMGnmgxEzWJ1LEFCYpLohK8ebR5XaMB5Sw1HdHWrljpi9LZxMAn53WqW
	c3CxgAeJciHMnK/oDCSiNb6zo/Nq3Ag58u9N1oHjq7Tj8t2pNP1bCeqZWSqlx1je
	reMyniWLYnEyMvKe+DPYVsR/jQcgO0syyWbEH7MC4Q==
X-ME-Sender: <xms:6fVfanHmW2WddL1goIeGJoIRUBaccj56qeoyYu11Dbz3fE87DTnXWQ>
    <xme:6fVfaqVD6v9l7Mf5KNkYLM77_hnkDvyQt3djHZXNwgGDETeYZ1amXDjquDqu7QJA7
    iwicKz4YUlWWf8vaNQPPuk8gKjnoHALYibfsoiE1F6NMAp86nDD9Zo>
X-ME-Received: <xmr:6fVfamwB6hWXdFjTfknodMs9QFLWbqD8YKGOGlq-4YFt312qkMdvcSZKUkiTn9d8zLT02Z56b-iNkuDF51v9O01CLkU>
X-ME-Proxy-Cause: dmFkZTEbGhZQ2KPGCv4m9/uqwPjtzlg+Bsb7VSsQoPYiEUNm36YbIDZ5gceB5ElRO6jkc0
    5mj9hnmT5F76vtMDwTHLfZ39jmdwpgaAWrLygZ40Davu7NxrXStPdvsuxIewp5uCVN8qtY
    H6wGJiRJx6ijWTkOWvzN7jtvd5R7zvgwHGhzleXv9DTaHPASFITDuAI7wCyd7Cox0xRbu+
    P6i18dSo74GUMAVnVcpdS7YC7a2gN49XUqdgqYF2/s7W5QCFuZNdA0/LU7C1vkiXb13+Bu
    eP4u9BpFM4CsdbHM1Xz5C+NQ/yLl0sm9BNvetBY8GHtdqMDMn6RHKEOeww87B8M4fL21Q7
    M/cpG6ONZAUsmULQa18GaLHtGn5qbM7wi6OliME3oEf/yoxo19mO0PERZ4unTsnZ7I9eU9
    8kFkcW6iwdRqZggfYZE5mnu2zeUEQcSBlnU1r2M7coc4Brfw6y9JEK3dgDR9sPb/eFoW4p
    saRLHFHTquJlzArA3x4kcuTrwlSprAuj3Z41LKh+UFZGx7HfrSqEqwvyVa3m7MOsWEBVZZ
    ikHF8Wmtx4elWEO9xadVNy8N6xFGX1VO1MUoOvgiXn78QeRBa1BZHknp3Um/rFSnJpGQwX
    XL5L2b/kQZItAZ8P2kzKMW6GPwM6kL8K1MM6GJhK1WItDC+arO7t5Kf1s90A
X-ME-Proxy: <xmx:6fVfagPsU7GSDx5H1L_FG4Hke5Pfjl-0KzrlTAIcZcMya56BrLk5iA>
    <xmx:6fVfav6sUP0TCDNfQUmex4oz2CJMq9Sueh-aXrwVFkJMUwW7clFrIg>
    <xmx:6fVfapPHhbJx8aG4WVofUxziKo7TwINnEhBOKmjj2cKLpouAUdRPgA>
    <xmx:6fVfalm-XIXhxYoIQZAhP3eztPb6ubd22UPpFvdL58QtxodJgOugrA>
    <xmx:6fVfakpMZ6demB7A5F0Xs66cjh2kBZ7bcMaDE9G6L8QRIE94jw3x0rJ->
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Jul 2026 18:42:49 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 3/4] btrfs: enable unlocked NOFAIL retry for eb allocations
Date: Tue, 21 Jul 2026 15:42:14 -0700
Message-ID: <014ef7a5136d2933cd987b75daedeabe204d4e17.1784673567.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1784673567.git.boris@bur.io>
References: <cover.1784673567.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we have the btrfs_eb_prealloc struct to carry the allocation
and the "needs prealloc" signal, wire that up between the various
search_slot style callers down into alloc_extent_buffer.

If the prealloc struct indicates that it supports a nowait try, then
alloc_extent_buffer tries to allocate NOWAIT. If that succeeds, great.
Otherwise, we return EAGAIN and signal via the struct that preallocation
is required. The caller then does the allocation and tries again with
the eb, bfs, and folios wired through in the prealloc struct.

If unlock-and-allocate retries are not supported then we just use the
normal gfp flags like before.

Note that there are still two GFP_NOFS allocations, as far as I know,
that happen under the lock and cannot be preallocated:
  - the __xa_cmpxchg to insert the eb into the eb xarray
  - the xarray allocations for filemap_add_folio to add the folios to
    the btree_inode mapping.

The former we could wire up with xa_reserve if we signaled the "prealloc
start" back up to the retry point. However, since there is no concept of
reservation in the filemap xarray, it seemed relatively unhelpful to
bother. These allocations are relatively small cached slab allocations,
so hopefully we can move the needle on reclaim stalls without reserving
them.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/ctree.c     | 21 ++++++++++++++++++---
 fs/btrfs/extent_io.c | 27 +++++++++++++++++++++------
 fs/btrfs/extent_io.h |  6 +++++-
 fs/btrfs/subpage.c   |  7 ++++---
 fs/btrfs/subpage.h   |  3 ++-
 5 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 261ef4ec7d1b..8fe330d81b8f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -2006,7 +2006,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	u8 lowest_level = 0;
 	int min_write_lock_level;
 	int prev_cmp;
-	struct btrfs_eb_prealloc pa = { 0 };
+	struct btrfs_eb_prealloc pa = { .supports_nowait = true };
 
 	if (!root)
 		return -EINVAL;
@@ -2061,6 +2061,11 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	}
 
 again:
+	if (pa.needs_prealloc) {
+		ret = btrfs_init_eb_prealloc(fs_info, &pa, false);
+		if (ret)
+			goto done;
+	}
 	prev_cmp = -1;
 	b = btrfs_search_slot_get_root(root, p, write_lock_level);
 	if (IS_ERR(b)) {
@@ -2264,7 +2269,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 	int level;
 	int lowest_unlock = 1;
 	u8 lowest_level = 0;
-	struct btrfs_eb_prealloc pa = { 0 };
+	struct btrfs_eb_prealloc pa = { .supports_nowait = true };
 
 	lowest_level = p->lowest_level;
 	WARN_ON(p->nodes[0] != NULL);
@@ -2276,6 +2281,11 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 	}
 
 again:
+	if (pa.needs_prealloc) {
+		ret = btrfs_init_eb_prealloc(fs_info, &pa, false);
+		if (ret)
+			goto done;
+	}
 	b = btrfs_get_old_root(root, time_seq);
 	if (unlikely(!b)) {
 		ret = -EIO;
@@ -4788,7 +4798,7 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 	struct extent_buffer *next;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key key;
-	struct btrfs_eb_prealloc pa = { 0 };
+	struct btrfs_eb_prealloc pa = { .supports_nowait = true };
 	bool need_commit_sem = false;
 	u32 nritems;
 	int ret;
@@ -4807,6 +4817,11 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 
 	btrfs_item_key_to_cpu(path->nodes[0], &key, nritems - 1);
 again:
+	if (pa.needs_prealloc) {
+		ret = btrfs_init_eb_prealloc(fs_info, &pa, false);
+		if (ret)
+			goto done;
+	}
 	level = 1;
 	next = NULL;
 	btrfs_release_path(path);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 373bdf2db0d5..1a40250e1e83 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3531,18 +3531,28 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
 /*
  * Allocate the extent_buffer, its folios, and btrfs_folio_state, if needed.
  *
+ * @pa:	The holder struct to do the allocation in.
+ * @nowait: Whether to do a speculative GFP_NOWAIT allocation while holding locks.
+ *
  * Return 0 on success and a negative errno otherwise. On failure, pa->eb/bfs
- * will be NULL.
+ * will be NULL. If @nowait=true, then on ENOMEM, mark @pa->needs_prealloc and
+ * return -EAGAIN to signal the caller to unlock and retry.
  */
 int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
-			   struct btrfs_eb_prealloc *pa)
+			   struct btrfs_eb_prealloc *pa, bool nowait)
 {
+	gfp_t gfp = nowait ? GFP_NOWAIT : GFP_NOFS | __GFP_NOFAIL;
 	int ret;
 
 	ASSERT(!pa->eb, "unexpected non-null eb: %p", pa->eb);
 	ASSERT(!pa->bfs, "unexpected non-null bfs: %p", pa->bfs);
+	pa->needs_prealloc = false;
 
-	pa->eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
+	pa->eb = kmem_cache_zalloc(extent_buffer_cache, gfp);
+	if (!pa->eb) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	/* alloc_eb_folio_array() needs len; init_extent_buffer() sets it again later. */
 	pa->eb->len = fs_info->nodesize;
 
@@ -3555,7 +3565,7 @@ int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
 	 */
 	if (btrfs_meta_is_subpage(fs_info)) {
 		pa->bfs = btrfs_alloc_folio_state(fs_info, PAGE_SIZE,
-						  BTRFS_SUBPAGE_METADATA);
+						  BTRFS_SUBPAGE_METADATA, gfp);
 		if (IS_ERR(pa->bfs)) {
 			ret = PTR_ERR(pa->bfs);
 			pa->bfs = NULL;
@@ -3568,7 +3578,7 @@ int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
 	 * below (added to LRU, served by btree_migrate_folio), so request
 	 * __GFP_MOVABLE so the page allocator places them in MOVABLE pageblocks.
 	 */
-	ret = alloc_eb_folio_array(pa->eb, GFP_NOFS | __GFP_NOFAIL | __GFP_MOVABLE);
+	ret = alloc_eb_folio_array(pa->eb, gfp | __GFP_MOVABLE);
 	if (ret < 0)
 		goto free_bfs;
 
@@ -3580,6 +3590,11 @@ int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
 free_eb:
 	kmem_cache_free(extent_buffer_cache, pa->eb);
 	pa->eb = NULL;
+out:
+	if (nowait && ret == -ENOMEM) {
+		pa->needs_prealloc = true;
+		ret = -EAGAIN;
+	}
 	return ret;
 }
 
@@ -3636,7 +3651,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 		return eb;
 
 	if (!pa->eb) {
-		ret = btrfs_init_eb_prealloc(fs_info, pa);
+		ret = btrfs_init_eb_prealloc(fs_info, pa, pa->supports_nowait);
 		if (ret)
 			return ERR_PTR(ret);
 	}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 5722864e0411..1916f1b16088 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -132,6 +132,10 @@ struct extent_buffer {
 struct btrfs_eb_prealloc {
 	struct extent_buffer *eb;
 	struct btrfs_folio_state *bfs;
+	/* eb alloc may use GFP_NOWAIT; caller can drop locks and retry. */
+	bool supports_nowait;
+	/* GFP_NOWAIT eb alloc failed; preallocate again and retry. */
+	bool needs_prealloc;
 };
 
 struct btrfs_eb_write_context {
@@ -289,7 +293,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  struct btrfs_eb_prealloc *pa,
 					  u64 start, u64 owner_root, int level);
 int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
-			   struct btrfs_eb_prealloc *pa);
+			   struct btrfs_eb_prealloc *pa, bool nowait);
 void btrfs_free_eb_prealloc(struct btrfs_eb_prealloc *pa);
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 						u64 start);
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 2a9397be8116..4fe437442148 100644
--- a/fs/btrfs/subpage.c
+++ b/fs/btrfs/subpage.c
@@ -59,7 +59,7 @@ int btrfs_attach_folio_state(const struct btrfs_fs_info *fs_info,
 	if (type == BTRFS_SUBPAGE_DATA && !btrfs_is_subpage(fs_info, folio))
 		return 0;
 
-	bfs = btrfs_alloc_folio_state(fs_info, folio_size(folio), type);
+	bfs = btrfs_alloc_folio_state(fs_info, folio_size(folio), type, GFP_NOFS);
 	if (IS_ERR(bfs))
 		return PTR_ERR(bfs);
 
@@ -86,7 +86,8 @@ void btrfs_detach_folio_state(const struct btrfs_fs_info *fs_info, struct folio
 }
 
 struct btrfs_folio_state *btrfs_alloc_folio_state(const struct btrfs_fs_info *fs_info,
-						  size_t fsize, enum btrfs_folio_type type)
+						  size_t fsize, enum btrfs_folio_type type,
+						  gfp_t gfp)
 {
 	struct btrfs_folio_state *ret;
 	unsigned int real_size;
@@ -96,7 +97,7 @@ struct btrfs_folio_state *btrfs_alloc_folio_state(const struct btrfs_fs_info *fs
 	real_size = struct_size(ret, bitmaps,
 			BITS_TO_LONGS(btrfs_bitmap_nr_max *
 				      (fsize >> fs_info->sectorsize_bits)));
-	ret = kzalloc(real_size, GFP_NOFS);
+	ret = kzalloc(real_size, gfp);
 	if (!ret)
 		return ERR_PTR(-ENOMEM);
 
diff --git a/fs/btrfs/subpage.h b/fs/btrfs/subpage.h
index c6d7394e6418..dc0e9c33210e 100644
--- a/fs/btrfs/subpage.h
+++ b/fs/btrfs/subpage.h
@@ -102,7 +102,8 @@ void btrfs_detach_folio_state(const struct btrfs_fs_info *fs_info, struct folio
 
 /* Allocate additional data where page represents more than one sector */
 struct btrfs_folio_state *btrfs_alloc_folio_state(const struct btrfs_fs_info *fs_info,
-						  size_t fsize, enum btrfs_folio_type type);
+						  size_t fsize, enum btrfs_folio_type type,
+						  gfp_t gfp);
 static inline void btrfs_free_folio_state(struct btrfs_folio_state *bfs)
 {
 	kfree(bfs);
-- 
2.55.0

