Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8363A269D18
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 22:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782254214; cv=none; b=FkZWVcETlnQTlKmzotgfa9F7tl8M2Y9Y0ucNlPgn91rieIu+XC4uNowKPMMWdlHiWqa//WwEVysVYLc3mLxsedyvfgI9fKPLWScTP3xcoexaPKcv2Gaym17nxZQDvVvZT5iorZX6nl9pXVsGAyoivE2J0p0hPnuzVl//s3AVmlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782254214; c=relaxed/simple;
	bh=Udnho4gGEAPyD1cs6ktJNI2v+dw4I3idNQI+yJBq5G0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8ZN3X6W28AAquaJC0SFRIIqQBzberE+LPzqWSjAt9BGzg23GsaLlp5bl9oG39RP4FUpvLc1qa7thq0Wk/86hNbdZxC/hgD9k08e560HRIdDSkEX7wkIs4LONiqkbiY2zMEkB+F8lkHcJRxoaYXH45fOYtCpi6ZLIpnCciO8SMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=XhZmPJDC; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=N0QdGDQj; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="XhZmPJDC";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="N0QdGDQj"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id CCA6BEC0317;
	Tue, 23 Jun 2026 18:36:52 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 23 Jun 2026 18:36:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1782254212; x=
	1782340612; bh=XJp0vkTOhRudTHnc8nKPx6pCRVI31dl2Bboj7nA6bIo=; b=X
	hZmPJDCny20A2HDXyUTEdwI7GMHxZn2HSGdVa7AYL0AM5xGmThagCnBgAwR4I+Tp
	hEjrh4zPtGv2wtOLJlLeXCgym2BpQxGUDKxrjo2OWxRWNHSIRiO8ibFsqDr78Rko
	5DkfBI4HDrtP9Bzlsixmi44La3VQewghunCREQOwAt0DtwM9goshkn7odEPEKgYi
	UcCmNp8E9s+IF66Zecof9j8m6XVkuTeagtZF5EE2mfWMfeda6BFE3MS1hwtl8e1S
	APF//0CACTB85IMTwtsHsrQZ3fl4ItgL95jgoGzu04ZV+1tA5ekcJEzW4PTMqhnI
	5yJvj2fq7KidZ6bDKOz/g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1782254212; x=1782340612; bh=XJp0vkTOhRudTHnc8nKPx6pCRVI3
	1dl2Bboj7nA6bIo=; b=N0QdGDQjwD5Pw077qaYQ7jhoDAXixkKBZibEskQiwIid
	TG+Er1Unu9fdFMsfwd67eJl05nBzEK5JdOnROhDziysaqgWoWGfPASK2cB/UAvDn
	Ispmx+9+rNEFIIwMmpyL2eAsVqsM6Lc+WLrzkjyaEBPRJzlUj7AvEpPIiZvoev9+
	3a29Y4jp8u8Qr/8wVye3ZiUCyiK+XjH+cxR6fpmAxUQ2OoA4ihs7ZoGGgAx8n0Eh
	qiBcw92WZofsbLhFjAuhcv51AFW3um1Nia+sS5lr5cMvxQtcc6RgtI4/820LooAx
	J/2BdBte01bPfKcxLq7R2AjHn16az+h+esskFCdWBg==
X-ME-Sender: <xms:hAo7ahHpGlSydLjt_qIFZbscsSvebsz3dui6MdIwQz1xID3-ZQ8J2w>
    <xme:hAo7asUhGm-oKm7N6Lw-2zkIzOW777qDfSJK5Q8yno2MoKejT7bYzrujX9MgmHk9t
    1yo413_RSlRIgBVkwyIjK5voLTSTtXqtBUUY-xjvS-uVtzBpYHnVA>
X-ME-Received: <xmr:hAo7agxVXPTB0EQn1LyXHI75ccR7TRUsrqMb64A9taP7E1HT15afZEJi2XvE9ZXijfLIE8U4uaOm6z7fykP_GpWk7yY>
X-ME-Proxy-Cause: dmFkZTG0eSrOaR2/NvW7kOIp6rm2GZD/7MomAFlj8zI4Q6RIHxMgHaQBlid7+eke8OAClh
    3cRciZF4Nzuc9lCg5PeAmS8oBtzDzfmmjL/GBRATujaehT7KSz3pi7OMw/SGzoqiRm8kWF
    DbskeNjKEK2RY+pL59jcwdN9d+f3kZLrnkJWn/pPToXsyu9VJrM/WsG0pSKrTCr1fDu7lZ
    0ZRZ6MczXAPM6DuTtMt8J6zet0k73qu2emXdXVhp7JeDi1UkncliQxQf0Zcywr8nUPEcAX
    LTbVNsuPjbdbi8wazA+POR6Qo4rBUb6zkTl7jjXvfCYGmbfuU5RT2MfoaXCGOj91lO7Pk7
    nR/IligeFnKDGZj3T1sQ6HQu1r4mV6jSUyorO6SozqgdLLUi+W7djDanGGRz8VIUt2vSFd
    koLP2yJaBnR/ok9qy0taxmOYuZaQHPK/tl+k7dGofojdkToWJNAqvbmvX/Appr1PIFGr9U
    kANn9PpZIBgzWd55uatnl8s0fGTnR82AhtkwjGpOrtgqmYslrr+egArawvG28Yk5FHctGH
    n+RxVktKe2hqOR80QSk7Qkur2t8czdqHI3yrFW/5bKAkDGF6cmHLoiw+OAhZBSXlL03s7Z
    n6AHO8m5Xmb1DUsLRNy/C/hdnVYw5i7ACdHXd8IT1+wXr/K+ydthrN92U+UQ
X-ME-Proxy: <xmx:hAo7aiNHo_aRNfpAf2rqKmQPrSEDJyyxtdudBIlDr9poTxhiQ6MdHA>
    <xmx:hAo7ap45eY1dTd395336jINFz2fNAW2OYsIkrsw7OyHOcTz5YiPpKw>
    <xmx:hAo7arNnoeUofxnQnxlaFTwRfvQ3T-0vfZDLaPbgJ15pYOBzJzZVZg>
    <xmx:hAo7avmrfHdTF9wp599ArPO7bJPhJe2ofyF0SnmbxYqhzm9dF1xK0w>
    <xmx:hAo7auqo8ubypEz5lkEH7LezVyl0fJmoBry84Gn-6WiquaLZlOP7IrmC>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Jun 2026 18:36:52 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 3/5] btrfs: enable unlocked NOFAIL retry for eb allocations
Date: Tue, 23 Jun 2026 15:35:38 -0700
Message-ID: <9992fe0377c5677284887298fc80ebf52eec9a6a.1782249000.git.boris@bur.io>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782249000.git.boris@bur.io>
References: <cover.1782249000.git.boris@bur.io>
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
index 4d6bd7535a65..94fa9a6c3978 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3477,18 +3477,28 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
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
 
@@ -3501,7 +3511,7 @@ int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
 	 */
 	if (btrfs_meta_is_subpage(fs_info)) {
 		pa->bfs = btrfs_alloc_folio_state(fs_info, PAGE_SIZE,
-						  BTRFS_SUBPAGE_METADATA);
+						  BTRFS_SUBPAGE_METADATA, gfp);
 		if (IS_ERR(pa->bfs)) {
 			ret = PTR_ERR(pa->bfs);
 			pa->bfs = NULL;
@@ -3514,7 +3524,7 @@ int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
 	 * below (added to LRU, served by btree_migrate_folio), so request
 	 * __GFP_MOVABLE so the page allocator places them in MOVABLE pageblocks.
 	 */
-	ret = alloc_eb_folio_array(pa->eb, GFP_NOFS | __GFP_NOFAIL | __GFP_MOVABLE);
+	ret = alloc_eb_folio_array(pa->eb, gfp | __GFP_MOVABLE);
 	if (ret < 0)
 		goto free_bfs;
 
@@ -3526,6 +3536,11 @@ int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
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
 
@@ -3582,7 +3597,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 		return eb;
 
 	if (!pa->eb) {
-		ret = btrfs_init_eb_prealloc(fs_info, pa);
+		ret = btrfs_init_eb_prealloc(fs_info, pa, pa->supports_nowait);
 		if (ret)
 			return ERR_PTR(ret);
 	}
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 26d941504ae1..a8bbd2e0aff0 100644
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
@@ -284,7 +288,7 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 					  struct btrfs_eb_prealloc *pa,
 					  u64 start, u64 owner_root, int level);
 int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
-			   struct btrfs_eb_prealloc *pa);
+			   struct btrfs_eb_prealloc *pa, bool nowait);
 void btrfs_free_eb_prealloc(struct btrfs_eb_prealloc *pa);
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 						u64 start);
diff --git a/fs/btrfs/subpage.c b/fs/btrfs/subpage.c
index 56060acac2e9..13323d94a56e 100644
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
2.54.0

