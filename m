Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C773A6B99
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Jun 2026 22:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782254213; cv=none; b=UvML1cs7N2XPdbk/BhHot7AkHZV8Rt6vcicGIqknGCHdVNMamoHKk+/fZTEhM6CJDlVg/SWu+ZDWWqkCPHV2K+l/wonjmd1/MwAyEP1oajvGhpWF2R+YH/3aUzZdVtMSxgENC8jaYwkVs6qGqTz722zNdUcTrm8hwrUHtv/OzlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782254213; c=relaxed/simple;
	bh=X6wWpKL2yPMjHJaT1fdRXbKuiDGSnAJ7yf1k2IVhFek=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJks6g5fb/5G0x2U+AuWB811/2xlWODuqJvUAaE51E5k/i2sOiC3mUkYycGFSvgdII2DxocdnT5+Fz+aTWTqGwKR++DquomUML/vDHZM/rRyjhEhlaCsvBwm2j3Rdqlq0sWCRaet/3D+hVqMnIvtyPQ1exu6IcRuVPwx9gF8gx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=bnHY1TJQ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OYp+mrD1; arc=none smtp.client-ip=103.168.172.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="bnHY1TJQ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OYp+mrD1"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfout.phl.internal (Postfix) with ESMTP id 24D7EEC01B8;
	Tue, 23 Jun 2026 18:36:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 23 Jun 2026 18:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1782254211; x=
	1782340611; bh=GlMm9QT4nu7XpYtifphTAQIRgCpkfs3fKlkhM5AsXKY=; b=b
	nHY1TJQwfrjtSLYhihlF6WYZqwufSPoVkh0dYnG3GRLZc5XZZ768Qs4uA2YOEqw5
	eKX7cdnKx92IoYhXFmt8e5TX5dv76jmOIlt9lvDVwEpcTy3BkvikNNFgZ2W5wu2b
	VZLI7QAmGTGUBCfcqmwtVL0EG21oeS4CXbp9nj8LMkvyEu69OVb2HST0/pUnV/Pt
	tSVMlOYw3W9pcXXTvB1ygj55rynBmkj/s4bgul8v4p2RWdAELiEd0Up52UHMngL4
	s9d/K7Y3oLZoRv6YFQyrOTuF494uc07p52ColGV93hDoLcj9BsUyXNnAk/2o7Zj/
	PNjXU+cHo7aqH0fvt8pgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1782254211; x=1782340611; bh=GlMm9QT4nu7XpYtifphTAQIRgCpk
	fs3fKlkhM5AsXKY=; b=OYp+mrD17+fxW/h5jwletZ2sNxbuQA2IlYJrUf2XhEh/
	Q2fsNmrDoO6axrksG2k2n+ev1phnLIi25so2qW4etWD6wo9l/gtSyF/C9Pp8o5zS
	l2DfmabjJ+YnAxjm+6DdYvNDDKsFlwDSjb0mg7fWleJmnvR4zZiOaqrMB06Obq4H
	WYKjOKV+CTLOBfRI/mlIGXX9RUKq3ZTMOM46Xh95E91PqKeB2NcJ3mZ6TSuc6W4F
	xjeVQQ1W0HoB4n8t9sM+N5a5sXBfzsH/K6wRY3xXTFUpVP4TdIkhEsxq202znEZc
	Fttbyx6IdHpxVEgMrlnwkxypAc9CowgbkkTC5hYVXw==
X-ME-Sender: <xms:gwo7aom03W4KFxKOTtn2tnDjomavMJ65xdxbu9sS9iixd6U7srMfCw>
    <xme:gwo7at2TeHnRgno_nT-1cxs29XHziHsOF4lokT4v4CM7FbsegXlVmwh9uGeH_NrDC
    TIwadr0E2sNQlaGjwX_Z5l6zPE6xn-QJaPBe7OTwgPdfAbyOXYB-h9x>
X-ME-Received: <xmr:gwo7akR5NDc2Cswwn_Y69m1_tGTtB8XHFPlPpdyPFEuWLbpMxB19d0MQ3DtgdBT51bDlu8xj2UU3ua6Cy7_jq7DVX_U>
X-ME-Proxy-Cause: dmFkZTFM0Wp6sPpJEkK9bsyZ6YA6pQQcGXcfVMo4LIrpl/vE+Yh8DM6caFGBxxRGtS3Stn
    xYgxFiBgxns8eaaAUvVS7iRn5Gi5QnRO3iWhoiIDAsm10q//73fvsXO+rADefuA7Gqhbrx
    vjIio6OLwdHUEJoK4JyAA+dS9g6z+j5E9JeVRu9TU8mQN/a0t43WDCDjSzKH8Q8Jd70YQh
    YXFZRiZWtCZe/AgrYmt6Yzf6FJUG2jxv+LnTt1iksDgfXV/HmRrGIBUDUh1kEef3r5X6sR
    8v7CJIUK8W5eOshC6IfmD0GDbKS4pwhq9P5oURR0uZWzafqsY7J41BglfGtsyOYvVn7nsQ
    sjpBG8Jvefb7xym2CBgNxo3rLMyWLI50Y7YPDSDcOYd3ULjoQ7FXLbOHrkYfdIQPGHL1p+
    edrmTNx0Acr/zK+BYMxxGKCK0YceQri/pNwm53/u0quEO2UZDbYKrQHxLBfx7hvcx+hztt
    MNCSYPkhQKFzbcWE92sUj9+1Z2fn7yZnc3sgnGI7NQRvImkFRIxD7+2oz4oWj6dBoNdqx+
    jiCnqkxpsoyFA7Nvuh9t0S2kzesKD0JPA997vT8RghWiyciCaJYiCcinC0z8I0Qljg5aVF
    RxrrxSl5HarMnUs3IbgbMwpCDrKAzYcsftE0Mx8CJQhnnb9EV/YicjKz0OvQ
X-ME-Proxy: <xmx:gwo7avsC1ZABaIR16exEfO7sOnm1k38s5FVM_jNnrHjyak-8DEtvog>
    <xmx:gwo7apZEil6jhlAD7kts2odN5X9CNODLcMVZhC4YVuujZzkzNhzUxQ>
    <xmx:gwo7akvjXWZleXWSTGp1uxM2u5--aIUAe_wSB1tkIJViXBlO-Dz7Nw>
    <xmx:gwo7arHb514qSZcBPNsb-sqgjD-4bgGINoXpcEhOrAvVI8n6NGwuGw>
    <xmx:gwo7auKP_GwKmM0oo7dUNkzaXkg5hEYM7OcrDlQweYXFlf5-aGhMd-jI>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Jun 2026 18:36:50 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH 2/5] btrfs: add struct btrfs_eb_prealloc
Date: Tue, 23 Jun 2026 15:35:37 -0700
Message-ID: <6f82fa916cd0d6a5c7c343edf7e0a9a667972873.1782249000.git.boris@bur.io>
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
index 0a7d80da9c94..60307fe6a685 100644
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
index 624d76e0ca01..9f7e50f53f92 100644
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
index fa4cc8bcd1af..4d6bd7535a65 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3374,7 +3374,7 @@ static bool check_eb_alignment(struct btrfs_fs_info *fs_info, u64 start)
  * The caller needs to free the existing folios and retry using the same order.
  */
 static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
-				      struct btrfs_folio_state *prealloc,
+				      struct btrfs_eb_prealloc *pa,
 				      struct extent_buffer **found_eb_ret)
 {
 
@@ -3396,6 +3396,7 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
 	if (!ret)
 		goto finish;
 
+	/* ret == -EEXIST: a folio already lives at this index. */
 	existing_folio = filemap_lock_folio(mapping, index + i);
 	/* The page cache only exists for a very short time, just retry. */
 	if (IS_ERR(existing_folio))
@@ -3404,7 +3405,27 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
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
@@ -3435,8 +3456,10 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
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
@@ -3451,17 +3474,94 @@ static int attach_eb_folio_to_filemap(struct extent_buffer *eb, int i,
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
@@ -3481,7 +3581,13 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
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
@@ -3493,66 +3599,18 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 
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
@@ -3629,6 +3687,10 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
 out:
 	WARN_ON(!refcount_dec_and_test(&eb->refs));
 
+	/* attach hands off pa->bfs; free it if we bailed first. */
+	btrfs_free_folio_state(pa->bfs);
+	pa->bfs = NULL;
+
 	/*
 	 * Any attached folios need to be detached before we unlock them.  This
 	 * is because when we're inserting our new folios into the mapping, and
@@ -4660,6 +4722,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 		.level = level,
 		.transid = gen
 	};
+	struct btrfs_eb_prealloc pa = { 0 };
 	struct extent_buffer *eb;
 	int ret;
 
@@ -4668,7 +4731,7 @@ void btrfs_readahead_tree_block(struct btrfs_fs_info *fs_info,
 		check.has_first_key = true;
 	}
 
-	eb = btrfs_find_create_tree_block(fs_info, bytenr, owner_root, level);
+	eb = btrfs_find_create_tree_block(fs_info, &pa, bytenr, owner_root, level);
 	if (IS_ERR(eb))
 		return;
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9896e15ddc40..26d941504ae1 100644
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
@@ -266,7 +281,11 @@ int set_folio_extent_mapped(struct folio *folio);
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
2.54.0

