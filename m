Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F0443E495
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 22:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673771; cv=none; b=MOuxqpaA954dcVIw2hPDvXyguKfHKFWJC4avubuWmJQ4MYOoS+8WcyvvHyvGAEc04ZcF+MWRfL9wqcsxoJpT/O9TA2tCXlPdDliazlNgnMWnftz2BDwtQtd2annbhrkQTBPdMq/8THWrnCtBpZ5zsE01IQnn43GZZLoKyvgkLDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673771; c=relaxed/simple;
	bh=Xjf3N08qnWpznW96Is/TEMDPAxV6h+6eLiA5tXpm14o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AJlE7EDrrgQuqr7Lq1UI5fHjF5yZ7heA8FsnhTn39AHTb8QLKXBmGFCqs40wTTr1jFEwCYdqiAhIjRgwG5K619bHa234WxPxwHzGQFKiZs4ETsuE6efLYGrSL5bt51OoXJpO2hlQ3YOLpRYpbi0gwDgvmfsZuvuyMrIR5fQWMXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=U5wjqXJQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=da1LKTQb; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="U5wjqXJQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="da1LKTQb"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.stl.internal (Postfix) with ESMTP id 4C1A81D000B1;
	Tue, 21 Jul 2026 18:42:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 21 Jul 2026 18:42:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784673768; x=
	1784760168; bh=AkVcq+9ayzqDhcoDuPoUEHkzzD5+GZbsSvU55H8cTUQ=; b=U
	5wjqXJQ6EY73sc7DGJ55PA8r1W9HDTJdnrjJ938Hk7ld71SC1Vu89HYSX5zIvFYV
	V1p6zPv+8LZEInmK/wBCtwHGZgAsVbufU9KgaY6qmOzMv2g1Ne3ayPYFFSC8BFoO
	4XQhH7Tej3VlLAiMfcySzdtyQQX0LgnHkaRADI617mtTdGn4ElJT4+mCKfmJJBsM
	iv5hVtiALs8RiLHw/YkYBmMoqblytN3+vcDhpmZNXcgtKYuezkpFsLGFZEUi8n9z
	O8qYZ72Pjs8ZkVp/4k7jSjmJ49y9uaMXqWzR5T1LM6IAnd6vkpXHpV95BZPiBO9h
	4PNtF96YJL3eCwAMuixeA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1784673768; x=1784760168; bh=AkVcq+9ayzqDhcoDuPoUEHkzzD5+
	GZbsSvU55H8cTUQ=; b=da1LKTQbF0QNX8TraAeIxBE0tUtjRElB5xlr2ensR/vg
	2Sw2+KEFGT8MedGbViXBIjYfcI2gjmyrUm25fMoLKkTwJT8DIvK3IYct2xGPEvIi
	zISSzZTYw9V3rf0263FCV230h9DiLbqtQ2PpK6RP3/FAx0IfdUQ3OKmfVvaPh2U3
	xgv4n2uZdNGRRPGohd98E0peRtBaOzqbaDzVLO4IToqgaDScLFgxNnw9U9kGmmjo
	I6cxO2B7Y5umNtN4+uJY5CTNVH2UI3Y6897PYVV6vaVJUb2VGU/L3+N8RMDJkv7O
	mnz4jwMxElgtqm3Lmkqm9s/qX/57hZVz0kac1FXk4w==
X-ME-Sender: <xms:6PVfasuBOoQgJXFKqlqg4IA_Pjrbnp9a6s8CdhqRWDX6M0zCccjb7g>
    <xme:6PVfavdEPWeWGO6rLcEGDCuBykK2Yk40yuq_GFg-5X0nFi1RBmAvS0QelG0RpyhjU
    7-aiq3TpOWftjyHBTYS7aQvXZS91ded7Av5QEQ59gOFBXHn3x121chu>
X-ME-Received: <xmr:6PVfalY9Cfs26t7NNN4kKg4dDHxbvEzH4-5t93bDxqd-XFurFKxbTYeO0nYXDbjNCcMjC89QUdPl2EAOrNhhjyYRoFs>
X-ME-Proxy-Cause: dmFkZTE6tUjMYsQUsR34gCpt2nSr/69ApxXSMyG5rrTD08NxB81cfGeohUWD/e33uyicNC
    y+WdnSBRhdiyS4cGhmQxf1TnGYTqxxcxEO3rUlbmYbcj+dmC2hh05IsOuXCGDQHgXK7/Kt
    io5klZ80UiOeUvrki7josxkbC4J0dN1UIsgcq0XdhgrWljvrFwX+DJA2mw0Q55MTEE6Eiz
    5gQe7xhLHZsj0R9Y2bU7/i0dGZRak2Su7TqDV2A6n64gu/AaoLWRvVnv135mT2iLc0589p
    t6A1wC4ak0d2ZD88xY/eA+Jo3Ht9YK2E+Y5EqyNvjk5wJs0M+14Sek2BEWbgC292ApLjb6
    vG1PT1olbJM+Oh7XdRw2e2emQO+QshDkeOypnXWssQ2tqj9Cmxp9IEYZFVl0gDTjPjzj8Z
    ZeKSrJYwsfmw34fJV4Fd1Iqlvnv8S6kmDk4S80RN3/tq7IFgj11V4zTQeXfNnmL4wcR1LW
    LpqGwVErmPALyjudWV1oTx7M7tntL0AKdlThFGP/5ou864PWLw/ShHXu9CrpCbRSG7QVWA
    Xe0M7Z0nco8HlnCSnmolR42A8G2sHjJVl5nWXc7f4IFHyITmsHWSQuX1d7JJlmDffMxQVc
    BpGDot8xp09xy5Kyb6ckePiW8h+yGjJ7oSF7b7vxpjOdFN+8/JkkbV2fwabQ
X-ME-Proxy: <xmx:6PVfaqWqLHfnC5nsqiXfaWsNn9onrMbtrvP_nyrVNTO0rPWuO8rVxQ>
    <xmx:6PVfavhjNy9aCTIrgvaQu3W0Y9gzIa7g6HsS4eryZGeJdU5MVCocoQ>
    <xmx:6PVfagVMnrRE9klwpDIy2wAtZL2DBeQ5oJMFVI2lA8Ga7nWueBnohA>
    <xmx:6PVfauOO42WNuVAaBTIyuNZup2p_SLw6jzkP12yVbB2T3s_MTUJ2UQ>
    <xmx:6PVfakQIZ3zNkG-ojQDfUnrvbbPKebXKdG8DdMgXT3pIvjm5QkM8Qx9X>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Jul 2026 18:42:47 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 2/4] btrfs: add struct btrfs_eb_prealloc
Date: Tue, 21 Jul 2026 15:42:13 -0700
Message-ID: <ce1a151d14bc3162af23ef6d6bcdbd6210ce5a1e.1784673567.git.boris@bur.io>
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

In further preparation for supporting NOFAIL allocations with retries
outside the critical section, add a struct to carry the extent_buffer
and btrfs_folio_state we need to allocate.

Refactor the allocation pathways to use the new struct but with no
functional change. Wire empty prealloc structs in from callers.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/ctree.c       |  21 +++--
 fs/btrfs/disk-io.c     |   6 +-
 fs/btrfs/disk-io.h     |   2 +
 fs/btrfs/extent-tree.c |   6 +-
 fs/btrfs/extent_io.c   | 179 ++++++++++++++++++++++++++++-------------
 fs/btrfs/extent_io.h   |  19 +++++
 fs/btrfs/tree-log.c    |   3 +-
 7 files changed, 168 insertions(+), 68 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 49fb6b816aa9..261ef4ec7d1b 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1460,6 +1460,7 @@ static noinline void unlock_up(struct btrfs_path *path, int level,
  */
 static int
 read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
+		      struct btrfs_eb_prealloc *pa,
 		      struct extent_buffer **eb_ret, int slot,
 		      const struct btrfs_key *key)
 {
@@ -1546,7 +1547,8 @@ read_block_for_search(struct btrfs_root *root, struct btrfs_path *p,
 	if (p->reada != READA_NONE)
 		reada_for_search(fs_info, p, parent_level, slot, key->objectid);
 
-	tmp = btrfs_find_create_tree_block(fs_info, blocknr, check.owner_root, check.level);
+	tmp = btrfs_find_create_tree_block(fs_info, pa, blocknr,
+					   check.owner_root, check.level);
 	if (IS_ERR(tmp)) {
 		ret = PTR_ERR(tmp);
 		tmp = NULL;
@@ -2004,6 +2006,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	u8 lowest_level = 0;
 	int min_write_lock_level;
 	int prev_cmp;
+	struct btrfs_eb_prealloc pa = { 0 };
 
 	if (!root)
 		return -EINVAL;
@@ -2187,7 +2190,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			goto done;
 		}
 
-		ret2 = read_block_for_search(root, p, &b, slot, key);
+		ret2 = read_block_for_search(root, p, &pa, &b, slot, key);
 		if (ret2 == -EAGAIN && !p->nowait) {
 			trace_btrfs_search_slot_restart(root, level, "read_block");
 			goto again;
@@ -2234,6 +2237,8 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 			ret = ret2;
 	}
 
+	btrfs_free_eb_prealloc(&pa);
+
 	return ret;
 }
 ALLOW_ERROR_INJECTION(btrfs_search_slot, ERRNO);
@@ -2259,6 +2264,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 	int level;
 	int lowest_unlock = 1;
 	u8 lowest_level = 0;
+	struct btrfs_eb_prealloc pa = { 0 };
 
 	lowest_level = p->lowest_level;
 	WARN_ON(p->nodes[0] != NULL);
@@ -2316,7 +2322,7 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 			goto done;
 		}
 
-		ret2 = read_block_for_search(root, p, &b, slot, key);
+		ret2 = read_block_for_search(root, p, &pa, &b, slot, key);
 		if (ret2 == -EAGAIN && !p->nowait)
 			goto again;
 		if (ret2) {
@@ -2339,6 +2345,8 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
 	if (ret < 0)
 		btrfs_release_path(p);
 
+	btrfs_free_eb_prealloc(&pa);
+
 	return ret;
 }
 
@@ -4780,6 +4788,7 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 	struct extent_buffer *next;
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key key;
+	struct btrfs_eb_prealloc pa = { 0 };
 	bool need_commit_sem = false;
 	u32 nritems;
 	int ret;
@@ -4880,7 +4889,7 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 		}
 
 		next = c;
-		ret = read_block_for_search(root, path, &next, slot, &key);
+		ret = read_block_for_search(root, path, &pa, &next, slot, &key);
 		if (ret == -EAGAIN && !path->nowait)
 			goto again;
 
@@ -4923,7 +4932,7 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 		if (!level)
 			break;
 
-		ret = read_block_for_search(root, path, &next, 0, &key);
+		ret = read_block_for_search(root, path, &pa, &next, 0, &key);
 		if (ret == -EAGAIN && !path->nowait)
 			goto again;
 
@@ -4956,6 +4965,8 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 			ret = ret2;
 	}
 
+	btrfs_free_eb_prealloc(&pa);
+
 	return ret;
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 37fc0d6b960d..f7fa2c4bcac8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -590,12 +590,13 @@ static const struct address_space_operations btree_aops = {
 
 struct extent_buffer *btrfs_find_create_tree_block(
 						struct btrfs_fs_info *fs_info,
+						struct btrfs_eb_prealloc *pa,
 						u64 bytenr, u64 owner_root,
 						int level)
 {
 	if (btrfs_is_testing(fs_info))
 		return alloc_test_extent_buffer(fs_info, bytenr);
-	return alloc_extent_buffer(fs_info, bytenr, owner_root, level);
+	return alloc_extent_buffer(fs_info, pa, bytenr, owner_root, level);
 }
 
 /*
@@ -608,12 +609,13 @@ struct extent_buffer *btrfs_find_create_tree_block(
 struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 				      struct btrfs_tree_parent_check *check)
 {
+	struct btrfs_eb_prealloc pa = { 0 };
 	struct extent_buffer *buf = NULL;
 	int ret;
 
 	ASSERT(check);
 
-	buf = btrfs_find_create_tree_block(fs_info, bytenr, check->owner_root,
+	buf = btrfs_find_create_tree_block(fs_info, &pa, bytenr, check->owner_root,
 					   check->level);
 	if (IS_ERR(buf))
 		return buf;
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 9185f8f02eeb..290508894f7c 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -15,6 +15,7 @@
 struct block_device;
 struct super_block;
 struct extent_buffer;
+struct btrfs_eb_prealloc;
 struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_fs_info;
@@ -48,6 +49,7 @@ struct extent_buffer *read_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr,
 				      struct btrfs_tree_parent_check *check);
 struct extent_buffer *btrfs_find_create_tree_block(
 						struct btrfs_fs_info *fs_info,
+						struct btrfs_eb_prealloc *pa,
 						u64 bytenr, u64 owner_root,
 						int level);
 int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 235381b31298..0c28fa07f370 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -5260,10 +5260,11 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      enum btrfs_lock_nesting nest)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_eb_prealloc pa = { 0 };
 	struct extent_buffer *buf;
 	u64 lockdep_owner = owner;
 
-	buf = btrfs_find_create_tree_block(fs_info, bytenr, owner, level);
+	buf = btrfs_find_create_tree_block(fs_info, &pa, bytenr, owner, level);
 	if (IS_ERR(buf))
 		return buf;
 
@@ -5917,6 +5918,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 				 struct walk_control *wc)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_eb_prealloc pa = { 0 };
 	u64 bytenr;
 	u64 generation;
 	u64 owner_root = 0;
@@ -5939,7 +5941,7 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 
 	bytenr = btrfs_node_blockptr(path->nodes[level], path->slots[level]);
 
-	next = btrfs_find_create_tree_block(fs_info, bytenr, btrfs_root_id(root),
+	next = btrfs_find_create_tree_block(fs_info, &pa, bytenr, btrfs_root_id(root),
 					    level - 1);
 	if (IS_ERR(next))
 		return PTR_ERR(next);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3ab6b143dbc4..373bdf2db0d5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3428,7 +3428,7 @@ static bool check_eb_alignment(struct btrfs_fs_info *fs_info, u64 start)
  * The caller needs to free the existing folios and retry using the same order.
  */
 static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
-				      struct btrfs_folio_state *prealloc,
+				      struct btrfs_eb_prealloc *pa,
 				      struct extent_buffer **found_eb_ret)
 {
 
@@ -3450,6 +3450,7 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
 	if (!ret)
 		goto finish;
 
+	/* ret == -EEXIST: a folio already lives at this index. */
 	existing_folio = filemap_lock_folio(mapping, index + i);
 	/* The page cache only exists for a very short time, just retry. */
 	if (IS_ERR(existing_folio))
@@ -3458,7 +3459,27 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
 	/* For now, we should only have single-page folios for btree inode. */
 	ASSERT(folio_nr_pages(existing_folio) == 1);
 
+	/*
+	 * TODO: Special handling for a corner case where the order of
+	 * folios mismatch between the new eb and filemap.
+	 *
+	 * This happens when:
+	 *
+	 * - the new eb is using higher order folio
+	 *
+	 * - the filemap is still using 0-order folios for the range
+	 *   This can happen at the previous eb allocation, and we don't
+	 *   have higher order folio for the call.
+	 *
+	 * - the existing eb has already been freed
+	 *
+	 * In this case, we have to free the existing folios first, and
+	 * re-allocate using the same order.
+	 * Thankfully this is not going to happen yet, as we're still
+	 * using 0-order folios.
+	 */
 	if (folio_size(existing_folio) != eb->folio_size) {
+		DEBUG_WARN("folio order mismatch between new eb and filemap");
 		folio_unlock(existing_folio);
 		folio_put(existing_folio);
 		return -EAGAIN;
@@ -3489,8 +3510,10 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
 	eb->folio_size = folio_size(eb->folios[i]);
 	eb->folio_shift = folio_shift(eb->folios[i]);
 	/* Should not fail, as we have preallocated the memory. */
-	ret = attach_extent_buffer_folio(eb, eb->folios[i], prealloc);
+	ret = attach_extent_buffer_folio(eb, eb->folios[i], pa->bfs);
 	ASSERT(!ret);
+	/* The subpage state, if any, is now attached to the folio or freed. */
+	pa->bfs = NULL;
 	/*
 	 * To inform we have an extra eb under allocation, so that
 	 * detach_extent_buffer_page() won't release the folio private when the
@@ -3505,17 +3528,94 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
 	return 0;
 }
 
+/*
+ * Allocate the extent_buffer, its folios, and btrfs_folio_state, if needed.
+ *
+ * Return 0 on success and a negative errno otherwise. On failure, pa->eb/bfs
+ * will be NULL.
+ */
+int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
+			   struct btrfs_eb_prealloc *pa)
+{
+	int ret;
+
+	ASSERT(!pa->eb, "unexpected non-null eb: %p", pa->eb);
+	ASSERT(!pa->bfs, "unexpected non-null bfs: %p", pa->bfs);
+
+	pa->eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
+	/* alloc_eb_folio_array() needs len; init_extent_buffer() sets it again later. */
+	pa->eb->len = fs_info->nodesize;
+
+	/*
+	 * Preallocate folio private for subpage case, so that we won't
+	 * allocate memory with i_private_lock nor page lock hold.
+	 *
+	 * The memory will be freed by attach_extent_buffer_page() or freed
+	 * manually if we exit earlier.
+	 */
+	if (btrfs_meta_is_subpage(fs_info)) {
+		pa->bfs = btrfs_alloc_folio_state(fs_info, PAGE_SIZE,
+						  BTRFS_SUBPAGE_METADATA);
+		if (IS_ERR(pa->bfs)) {
+			ret = PTR_ERR(pa->bfs);
+			pa->bfs = NULL;
+			goto free_eb;
+		}
+	}
+
+	/*
+	 * Allocate all pages first. These will be attached to btree_inode->i_mapping
+	 * below (added to LRU, served by btree_migrate_folio), so request
+	 * __GFP_MOVABLE so the page allocator places them in MOVABLE pageblocks.
+	 */
+	ret = alloc_eb_folio_array(pa->eb, GFP_NOFS | __GFP_NOFAIL | __GFP_MOVABLE);
+	if (ret < 0)
+		goto free_bfs;
+
+	return 0;
+
+free_bfs:
+	btrfs_free_folio_state(pa->bfs);
+	pa->bfs = NULL;
+free_eb:
+	kmem_cache_free(extent_buffer_cache, pa->eb);
+	pa->eb = NULL;
+	return ret;
+}
+
+/*
+ * Used to cleanup a btrfs_eb_prealloc which had its contents allocated but
+ * folios not yet attached and eb/bfs consumed, and refs still 0.
+ *
+ * Safe to call on a fully used btrfs_eb_prealloc as the internal structs will
+ * be null once they are owned by the context using them.
+ */
+void btrfs_free_eb_prealloc(struct btrfs_eb_prealloc *pa)
+{
+	if (!pa->eb)
+		return;
+
+	for (int i = 0; i < num_extent_pages(pa->eb); i++) {
+		if (pa->eb->folios[i])
+			folio_put(pa->eb->folios[i]);
+	}
+	btrfs_free_folio_state(pa->bfs);
+	kmem_cache_free(extent_buffer_cache, pa->eb);
+	pa->eb = NULL;
+	pa->bfs = NULL;
+}
+
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
+					  struct btrfs_eb_prealloc *pa,
 					  u64 start, u64 owner_root, int level)
 {
 	int attached = 0;
 	struct extent_buffer *eb;
 	struct extent_buffer *existing_eb = NULL;
-	struct btrfs_folio_state *prealloc = NULL;
 	u64 lockdep_owner = owner_root;
 	bool page_contig = true;
 	bool uptodate = true;
-	int ret;
+	int ret = 0;
 
 	if (check_eb_alignment(fs_info, start))
 		return ERR_PTR(-EINVAL);
@@ -3535,7 +3635,13 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 	if (eb)
 		return eb;
 
-	eb = kmem_cache_zalloc(extent_buffer_cache, GFP_NOFS | __GFP_NOFAIL);
+	if (!pa->eb) {
+		ret = btrfs_init_eb_prealloc(fs_info, pa);
+		if (ret)
+			return ERR_PTR(ret);
+	}
+	eb = pa->eb;
+	pa->eb = NULL;
 	init_extent_buffer(fs_info, eb, start);
 
 	/*
@@ -3547,66 +3653,18 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 
 	btrfs_set_buffer_lockdep_class(lockdep_owner, eb, level);
 
-	/*
-	 * Preallocate folio private for subpage case, so that we won't
-	 * allocate memory with i_private_lock nor page lock hold.
-	 *
-	 * The memory will be freed by attach_extent_buffer_page() or freed
-	 * manually if we exit earlier.
-	 */
-	if (btrfs_meta_is_subpage(fs_info)) {
-		prealloc = btrfs_alloc_folio_state(fs_info, PAGE_SIZE, BTRFS_SUBPAGE_METADATA);
-		if (IS_ERR(prealloc)) {
-			ret = PTR_ERR(prealloc);
-			goto out;
-		}
-	}
-
-reallocate:
-	/*
-	 * Allocate all pages first. These will be attached to btree_inode->i_mapping
-	 * below (added to LRU, served by btree_migrate_folio), so request
-	 * __GFP_MOVABLE so the page allocator places them in MOVABLE pageblocks.
-	 */
-	ret = alloc_eb_folio_array(eb, GFP_NOFS | __GFP_NOFAIL | __GFP_MOVABLE);
-	if (ret < 0) {
-		btrfs_free_folio_state(prealloc);
-		goto out;
-	}
-
 	/* Attach all pages to the filemap. */
 	for (int i = 0; i < num_extent_folios(eb); i++) {
 		struct folio *folio;
 
-		ret = attach_eb_folio_to_filemap(eb, i, prealloc, &existing_eb);
+		ret = attach_eb_folio_to_filemap(eb, i, pa, &existing_eb);
 		if (ret > 0) {
 			ASSERT(existing_eb);
 			goto out;
 		}
-
-		/*
-		 * TODO: Special handling for a corner case where the order of
-		 * folios mismatch between the new eb and filemap.
-		 *
-		 * This happens when:
-		 *
-		 * - the new eb is using higher order folio
-		 *
-		 * - the filemap is still using 0-order folios for the range
-		 *   This can happen at the previous eb allocation, and we don't
-		 *   have higher order folio for the call.
-		 *
-		 * - the existing eb has already been freed
-		 *
-		 * In this case, we have to free the existing folios first, and
-		 * re-allocate using the same order.
-		 * Thankfully this is not going to happen yet, as we're still
-		 * using 0-order folios.
-		 */
-		if (unlikely(ret == -EAGAIN)) {
-			DEBUG_WARN("folio order mismatch between new eb and filemap");
-			goto reallocate;
-		}
+		/* -EAGAIN: folio order mismatch, unreachable with 0-order folios. */
+		if (ret < 0)
+			goto out;
 		attached++;
 
 		/*
@@ -3683,6 +3741,10 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 out:
 	WARN_ON(!refcount_dec_and_test(&eb->refs));
 
+	/* attach hands off pa->bfs; free it if we bailed first. */
+	btrfs_free_folio_state(pa->bfs);
+	pa->bfs = NULL;
+
 	/*
 	 * Any attached folios need to be detached before we unlock them.  This
 	 * is because when we're inserting our new folios into the mapping, and
@@ -4737,6 +4799,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 		.level = level,
 		.transid = gen
 	};
+	struct btrfs_eb_prealloc pa = { 0 };
 	struct extent_buffer *eb;
 	int ret;
 
@@ -4745,7 +4808,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 		check.has_first_key = true;
 	}
 
-	eb = btrfs_find_create_tree_block(fs_info, bytenr, owner_root, level);
+	eb = btrfs_find_create_tree_block(fs_info, &pa, bytenr, owner_root, level);
 	if (IS_ERR(eb))
 		return;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 869925337699..5722864e0411 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -119,6 +119,21 @@ struct extent_buffer {
 #endif
 };
 
+/*
+ * Wrapper struct for managing preallocating an extent_buffer, its folios and a
+ * btrfs_folio_state if needed.
+ *
+ * Only used to mediate allocation, do not refer to the eb directly if not
+ * returned from a successful eb allocating API.
+ *
+ * The eb folios and bfs should generally not be fully attached, except briefly
+ * before they are NULLed in the struct after successful attachment.
+ */
+struct btrfs_eb_prealloc {
+	struct extent_buffer *eb;
+	struct btrfs_folio_state *bfs;
+};
+
 struct btrfs_eb_write_context {
 	struct writeback_control *wbc;
 	struct extent_buffer *eb;
@@ -271,7 +286,11 @@ int set_folio_extent_mapped(struct folio *folio);
 void clear_folio_extent_mapped(struct folio *folio);
 
 struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
+					  struct btrfs_eb_prealloc *pa,
 					  u64 start, u64 owner_root, int level);
+int btrfs_init_eb_prealloc(struct btrfs_fs_info *fs_info,
+			   struct btrfs_eb_prealloc *pa);
+void btrfs_free_eb_prealloc(struct btrfs_eb_prealloc *pa);
 struct extent_buffer *alloc_dummy_extent_buffer(struct btrfs_fs_info *fs_info,
 						u64 start);
 struct extent_buffer *btrfs_clone_extent_buffer(const struct extent_buffer *src);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 875e4ddc68ea..fd5bd593389c 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2986,6 +2986,7 @@ static noinline int walk_down_log_tree(struct btrfs_path *path, int *level,
 {
 	struct btrfs_trans_handle *trans = wc->trans;
 	struct btrfs_fs_info *fs_info = wc->log->fs_info;
+	struct btrfs_eb_prealloc pa = { 0 };
 	u64 bytenr;
 	u64 ptr_gen;
 	struct extent_buffer *next;
@@ -3010,7 +3011,7 @@ static noinline int walk_down_log_tree(struct btrfs_path *path, int *level,
 		check.has_first_key = true;
 		btrfs_node_key_to_cpu(cur, &check.first_key, path->slots[*level]);
 
-		next = btrfs_find_create_tree_block(fs_info, bytenr,
+		next = btrfs_find_create_tree_block(fs_info, &pa, bytenr,
 						    btrfs_header_owner(cur),
 						    *level - 1);
 		if (IS_ERR(next)) {
-- 
2.55.0

