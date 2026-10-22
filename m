Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792688801;
	b=LzUsheFrpe3Vob6urarqJrhQSBDfwICN0OFiGUl1LbSNzhLplDiRmRESxRuBKghla6yX
	 N3t5uqhiak8Quu2JuXk7SA4bYIpcm1qg2QlVInvUTm5Z/JmrDcZDETK3dDa+pivw9Iaup
	 GniMZMVokoahYtPc6IJUpyLTLEas2Cka4/AM4axoy1p+xaeERKrF9+aLGZuFEEMPBnHg7
	 a70mrNJw2wDUI8V/sKbsm65q0iwBCOu7ksc5Lxj6afBiYv7GFigYegs+vUn4p+424gcjw
	 j3Q0z2z9oRGnQsOhVjbw/uLiGILyOZwEWzNs5QXIdDTuuc0KQDmRGFKe9EZgN7r3gPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792688801;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=ttlE8gGvv2J1FdAogmV6Q8hfscCBNZA7amk88+cjcQ0=;
	b=bnXySsk+GuVfD9pUutakuG3wxcGlRNm+F3bZmqYyWyri5eTLS2wi1b35Ev4jMpBdYnPj
	 ke8d7NDdI2DBZo8f0J07mo0t/Gondgc9XarceuGmBgBykoJcJqlvREYXD0NBG1AxQCM3v
	 EBp5ueDIcbCwP/KgJ4VpnM59FBHjLz6BMNhrnTW6F19IFyVA0WCvzQUr+bRA3k/08DtGP
	 /k9GD/kM3gJ8NZ3hgsXxlhF76zZsNcQWVpsmGv9UwM6NW9oyx4CHo/m+GpRetLEHTXsQV
	 +N3R+I5GisGotCe5FHWthx0bjQmreSUiFC2hYcJ6/tTO8sXTFjjtotGRk5wY0e176Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=bur.io;
	spf=pass smtp.mailfrom=bur.io;
	dkim=pass header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=EVIDS6i+;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b="K/3vGuax";
	arc=none smtp.remote-ip=103.168.172.156
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C07606A319
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 17:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02C07606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bur.io header.i=@bur.io header.a=rsa-sha256 header.s=fm3 header.b=EVIDS6i+;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=K/3vGuax
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3B7CF14000C1
	for <linux-btrfs@vger.kernel.org>; Thu, 22 Oct 2026 13:06:40 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 22 Oct 2026 13:06:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792688800; x=
	1792775200; bh=ttlE8gGvv2J1FdAogmV6Q8hfscCBNZA7amk88+cjcQ0=; b=E
	VIDS6i+EVxODStH9x1+H3Kro/ZXbSXeG6VjiYQs0kJK8EiUbEMzcjBHCKgIhGoGN
	j5AaJWe0lRWI0NIa+r5T+B9b+CpIG72/fmh5/MfvJNPTLaW1Ofk+LmpM2WpwTL2x
	bLV2aRuylwLd8NHOeYaoCfUfAWlIadVJGNlgqmuU4ng57KExMPtJ5cD5sU/G77gW
	bsG1aJGtybKl2NInR+EX0zAy/c+9vbk2uWH2PYSbzRiceY909KnJYOzzbTzta6Mu
	05mp9rpdxWkEgKzpAfZ2pbCDnLs76MFF9/NmgjGXCwUjThHbyOe9kwr782W8GYP0
	rsdajPBKbqc0WXepn+srw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1792688800; x=1792775200; bh=ttlE8gGvv2J1FdAogmV6Q8hfscCB
	NZA7amk88+cjcQ0=; b=K/3vGuax/dDgbKwVmZZyLXNIJp5y+JUCHxi9Sl+9x9zV
	SD6uV6IfKOyjtE7ztecH8Ik7VtYHXGRuS/fM8mYMKTXNBC0v43hs9bOrDt4siq4o
	mEPzEUz//oKrrjKFwZJfhIXju2BgVcBtN1gCbEn/EQZiITQctOUwCqGqTcd6IASA
	Pqcl7lDZwgKdiZurjYPL+pVJbSfslg15EUHnlYsXgi0CmfmIWqRfZ0YTRAwWTheT
	N6rCVb3H77xJ1XKxo911lYX5g9leO14TcQNZQtKee4/hTXQGaEEn+SdWVd/wqOjo
	fNPzwHiHU2U1R1hoHRSqPPAd6M41yRti67oHx1NG2w==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=bur.io a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792688800; d=bur.io;
	mf=PGJvcmlzQGJ1ci5pbz4=;
	rt=PGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZz4=;
	s=fm3:rsa-sha256:mxft3RFgR7owInvFbVZp28YFs4Zwsl9YlW+NxVG8nVDJDIh
	Q/3ycN9QepTqIx1PeJ4PEaQzqZ51l3UzEUMzrR0v/rSUdqTrnTALJuuCg9h/jYfT
	EweygG2AeZos98irMLzUamXoc0cf5VPVFw9X2TpsQFQS86kodLcygVYxUxSgZQwi
	7l0kVYZrYtWouZipjWiSa09atrKNrZYJEMFSi34DXyvsn2RlKrLY0WkUf2GsEIG6
	bJbIc9AZWGPxW9Ij/DmzPJXv9uOkKHYMlyggGlHwRQmjrIEGGqnNahDAqEQ8ybjM
	tpJyWHKtUxmoeZcygJizzlYJypWxY9YRzywjC+A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=10;
	hn=content-transfer-encoding,date,feedback-id,from,in-reply-to,
	message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Mfz33bPsXh1CS83HsU2Fg4lrOA3ut1f4S/1YLNPWIPk=:cHK+uKs8VUKUkp65VvZQDeuyT7i0Q1gGkgoGgiejypk=;
X-ME-Sender: <xms:oELaalgAI7vN2BjEls1X1CWVmY0PKTPyKLweAqPLs_Ql_Y-Ttdg1ng>
    <xme:oELaagDV6ZkafdjII7HZMjiO2x-PrgfP5d--VD8dph2IAam7gotLMYLCcJ_F7Rh79
    37NQEaHIYdfEg5TnbflIfCkpYQCFNYz9dsbIMyJi4rc6Qfjs3Q4_GVC>
X-ME-Received: <xmr:oELaaiunNi4pCETJ-H6UpA_VVTxFhB7R-yH3JqDBUsBwUWFuhkDwCDxw>
X-ME-Proxy-Cause: dmFkZTFHrlJj//L4HW0gMRAa88v6yP0BBBjriifSGvQW6YuUs7WmmNMltev/ozjNjBJR+y
    zShKOHjKVRgl5nWEkdfsqVKPwvgQqQv4CsdxUxHonBZ3gp7XhVekftJPfRu+WaquMttbaf
    KRtU/ZAxUqPe1hHEB8VYY8Ny9XbhTnqWbqbqBvsJjByTUPGtMepuCHmZmm72N3aWxUsJ+1
    qj3t9OYhNQwEwupacm/dmidrUI2p6iYAKdqbX4ujn5SlvAx5WvIOT3UkK5PjbaK2feL6Gd
    +LegYth04+J2OuinTEoQq6/KbF0FHOPyQ38gpGfzmR18g22hGolplw1UgWyHEXv04wkSdC
    FbT2jfYvq9jWMqnnEzTGD1PDOL45mcb+Z/suxtGKIis+7lT4It/YYO3YRFqVMew+KmODIU
    OiGVd2vr1UzrJdZG6t8ltTW+uV0bBbZ0OoAkHoDDxR3Zg21LGviiP2ixktKTbRdk/a/RGl
    V6XZAAI95EeRIvjVf1Yw2cg8OA/+d7ReBW/C996pklBNW/taWV227xOEh3BiTNsxiDFdWC
    0HXX9db410gZ1ouTrn4iABwsPP2GQFkWUmJUwF58CUlFiEu4GRdLhnSa432XXvbNZMdHJm
    hKou8NvnlpqtB7xbGtvQnpdIdO9Bd/zqPkYnp8bO2vawDdkR6WUlhIlWoKQA
X-ME-Proxy: <xmx:oELaalYY9FRale7D_y--2jkKjG5Ty6fDIMYHOCGV8xwyRBozcO-lRA>
    <xmx:oELaalUe2mbl0uuJwC1ewFfstJvjwHLnyuMC5v4zz_-tIFNJFk9iVQ>
    <xmx:oELaap4zEwyOWINZbATF0KKG4JAiSGtJvGKK0YTcTa4UFBwP_JSEoA>
    <xmx:oELaagihydnLESG95DjjZmldMNraBeiHDoaVFtUq2L27t--mVAPnvw>
    <xmx:oELaangXvsxdnFZqKmZbK8xFAddKfshG2SlQNsP2wkhG2W7WwYV4fXr4>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Oct 2026 13:06:39 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 7/7] btrfs: remove block_group data_rwsem and delalloc_bytes
Date: Thu, 22 Oct 2026 10:07:05 -0700
Message-ID: <ffe3e4bab04b3eeae4bcc70f56f0ec3422adea4f.1792688736.git.boris@bur.io>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792688736.git.boris@bur.io>
References: <cover.1792688736.git.boris@bur.io>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The v1 space cache was the only real user of the two fields.

994a93e11f49 ("btrfs: remove the v1 space cache write path") removed the
v1 space cache so now data_rwsem has no code path that write locks it
and delalloc_bytes is only printed, so both can be removed.

Luckily, this also removes a bunch of confusing indirection machinery
dedicated to separating delalloc calls to btrfs_reserve_extent() from
non-delalloc calls.

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/block-group.c | 12 +-----
 fs/btrfs/block-group.h | 13 +-----
 fs/btrfs/direct-io.c   |  4 +-
 fs/btrfs/extent-tree.c | 94 +++++++-----------------------------------
 fs/btrfs/extent-tree.h |  6 +--
 fs/btrfs/inode.c       | 36 ++++------------
 fs/btrfs/relocation.c  | 16 +++----
 fs/btrfs/space-info.c  |  5 +--
 8 files changed, 43 insertions(+), 143 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 477c14fbcb4c..8c41ec5ce570 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -2435,7 +2435,6 @@ static struct btrfs_block_group *btrfs_create_block_group(
 
 	refcount_set(&cache->refs, 1);
 	spin_lock_init(&cache->lock);
-	init_rwsem(&cache->data_rwsem);
 	INIT_LIST_HEAD(&cache->list);
 	INIT_LIST_HEAD(&cache->cluster_list);
 	INIT_LIST_HEAD(&cache->bg_list);
@@ -3643,14 +3642,13 @@ int btrfs_update_block_group(struct btrfs_trans_handle *trans,
  * @ram_bytes:  The number of bytes of file content, and will be same to
  *              @num_bytes except for the compress path.
  * @num_bytes:	The number of bytes in question
- * @delalloc:   The blocks are allocated for the delalloc write
  *
  * This is called by the allocator when it reserves space. If this is a
  * reservation and the block group has become read only we cannot make the
  * reservation and return -EAGAIN, otherwise this function always succeeds.
  */
 int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
-			     u64 ram_bytes, u64 num_bytes, bool delalloc,
+			     u64 ram_bytes, u64 num_bytes,
 			     bool force_wrong_size_class)
 {
 	struct btrfs_space_info *space_info = cache->space_info;
@@ -3672,8 +3670,6 @@ int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
 	}
 
 	cache->reserved += num_bytes;
-	if (delalloc)
-		cache->delalloc_bytes += num_bytes;
 
 	trace_btrfs_space_reservation(cache->fs_info, "space_info",
 				      space_info->flags, num_bytes, 1);
@@ -3703,15 +3699,13 @@ int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
  *
  * @cache:       The cache we are manipulating.
  * @num_bytes:   The number of bytes in question.
- * @is_delalloc: Whether the blocks are allocated for a delalloc write.
  *
  * This is called by somebody who is freeing space that was never actually used
  * on disk.  For example if you reserve some space for a new leaf in transaction
  * A and before transaction A commits you free that leaf, you call this with
  * reserve set to 0 in order to clear the reservation.
  */
-void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
-			       bool is_delalloc)
+void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes)
 {
 	struct btrfs_space_info *space_info = cache->space_info;
 	bool bg_ro;
@@ -3721,8 +3715,6 @@ void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
 	bg_ro = cache->ro;
 	cache->reserved -= num_bytes;
 	btrfs_maybe_reset_size_class(cache);
-	if (is_delalloc)
-		cache->delalloc_bytes -= num_bytes;
 	spin_unlock(&cache->lock);
 
 	if (bg_ro)
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index d567ed822e55..b33705dc088c 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -121,7 +121,6 @@ struct btrfs_block_group {
 	u64 pinned;
 	u64 reserved;
 	u64 used;
-	u64 delalloc_bytes;
 	u64 bytes_super;
 	u64 flags;
 	u64 global_root_id;
@@ -152,13 +151,6 @@ struct btrfs_block_group {
 	 */
 	u32 bitmap_low_thresh;
 
-	/*
-	 * It is just used for the delayed data space allocation because
-	 * only the data space allocation and the relative metadata update
-	 * can be done cross the transaction.
-	 */
-	struct rw_semaphore data_rwsem;
-
 	/* For raid56, this is a full stripe, without parity */
 	unsigned long full_stripe_len;
 	unsigned long runtime_flags;
@@ -358,10 +350,9 @@ int btrfs_write_dirty_block_groups(struct btrfs_trans_handle *trans);
 int btrfs_update_block_group(struct btrfs_trans_handle *trans,
 			     u64 bytenr, u64 num_bytes, bool alloc);
 int btrfs_add_reserved_bytes(struct btrfs_block_group *cache,
-			     u64 ram_bytes, u64 num_bytes, bool delalloc,
+			     u64 ram_bytes, u64 num_bytes,
 			     bool force_wrong_size_class);
-void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes,
-			       bool is_delalloc);
+void btrfs_free_reserved_bytes(struct btrfs_block_group *cache, u64 num_bytes);
 int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
 		      struct btrfs_space_info *space_info, u64 flags,
 		      enum btrfs_chunk_alloc_enum force);
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index ed3914257d39..96c0c9ccc179 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -186,7 +186,7 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
 	alloc_hint = btrfs_get_extent_allocation_hint(inode, start, len);
 again:
 	ret = btrfs_reserve_extent(root, len, len, fs_info->sectorsize,
-				   0, alloc_hint, &ins, true, true);
+				   0, alloc_hint, &ins, true);
 	if (ret == -EAGAIN) {
 		ASSERT(btrfs_is_zoned(fs_info));
 		wait_on_bit_io(&inode->root->fs_info->flags, BTRFS_FS_NEED_ZONE_FINISH,
@@ -206,7 +206,7 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
 				     BTRFS_ORDERED_REGULAR);
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 	if (IS_ERR(em))
-		btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, true);
+		btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset);
 
 	return em;
 }
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 80f2c735f432..cce2d314a000 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3695,7 +3695,7 @@ int btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
 
 	btrfs_add_free_space(bg, buf->start, buf->len);
-	btrfs_free_reserved_bytes(bg, buf->len, false);
+	btrfs_free_reserved_bytes(bg, buf->len);
 	btrfs_put_block_group(bg);
 	trace_btrfs_reserved_extent_free(fs_info, buf->start, buf->len);
 
@@ -3766,65 +3766,18 @@ enum btrfs_loop_type {
 	LOOP_NO_EMPTY_SIZE,
 };
 
-static inline void
-btrfs_lock_block_group(struct btrfs_block_group *cache, bool delalloc)
-{
-	if (delalloc)
-		down_read(&cache->data_rwsem);
-}
-
-static inline void
-btrfs_unlock_block_group(struct btrfs_block_group *cache, bool delalloc)
-{
-	if (delalloc)
-		up_read(&cache->data_rwsem);
-}
-
 static struct btrfs_block_group *btrfs_lock_cluster(
 		   struct btrfs_block_group *block_group,
-		   struct btrfs_free_cluster *cluster,
-		   bool delalloc)
+		   struct btrfs_free_cluster *cluster)
 	__acquires(&cluster->refill_lock)
 {
-	struct btrfs_block_group *used_bg = NULL;
+	struct btrfs_block_group *used_bg;
 
 	spin_lock(&cluster->refill_lock);
-	while (1) {
-		used_bg = cluster->block_group;
-		if (!used_bg)
-			return NULL;
-
-		if (used_bg == block_group)
-			return used_bg;
-
+	used_bg = cluster->block_group;
+	if (used_bg && used_bg != block_group)
 		btrfs_get_block_group(used_bg);
-
-		if (!delalloc)
-			return used_bg;
-
-		if (down_read_trylock(&used_bg->data_rwsem))
-			return used_bg;
-
-		spin_unlock(&cluster->refill_lock);
-
-		/* We should only have one-level nested. */
-		down_read_nested(&used_bg->data_rwsem, SINGLE_DEPTH_NESTING);
-
-		spin_lock(&cluster->refill_lock);
-		if (used_bg == cluster->block_group)
-			return used_bg;
-
-		up_read(&used_bg->data_rwsem);
-		btrfs_put_block_group(used_bg);
-	}
-}
-
-static inline void
-btrfs_release_block_group(struct btrfs_block_group *cache, bool delalloc)
-{
-	if (delalloc)
-		up_read(&cache->data_rwsem);
-	btrfs_put_block_group(cache);
+	return used_bg;
 }
 
 static bool find_free_extent_check_size_class(const struct find_free_extent_ctl *ffe_ctl,
@@ -3859,7 +3812,7 @@ static int find_free_extent_clustered(struct btrfs_block_group *bg,
 	u64 offset;
 	int ret;
 
-	cluster_bg = btrfs_lock_cluster(bg, last_ptr, ffe_ctl->delalloc);
+	cluster_bg = btrfs_lock_cluster(bg, last_ptr);
 	if (!cluster_bg)
 		goto refill_cluster;
 	if (cluster_bg != bg && (cluster_bg->ro ||
@@ -3894,7 +3847,7 @@ static int find_free_extent_clustered(struct btrfs_block_group *bg,
 	 */
 	if (ffe_ctl->loop >= LOOP_NO_EMPTY_SIZE && cluster_bg != bg) {
 		spin_unlock(&last_ptr->refill_lock);
-		btrfs_release_block_group(cluster_bg, ffe_ctl->delalloc);
+		btrfs_put_block_group(cluster_bg);
 		return -ENOENT;
 	}
 
@@ -3902,7 +3855,7 @@ static int find_free_extent_clustered(struct btrfs_block_group *bg,
 	btrfs_return_cluster_to_free_space(NULL, last_ptr);
 
 	if (cluster_bg != bg)
-		btrfs_release_block_group(cluster_bg, ffe_ctl->delalloc);
+		btrfs_put_block_group(cluster_bg);
 
 refill_cluster:
 	if (ffe_ctl->loop >= LOOP_NO_EMPTY_SIZE) {
@@ -4205,8 +4158,7 @@ static int do_allocation(struct btrfs_block_group *block_group,
 }
 
 static void release_block_group(struct btrfs_block_group *block_group,
-				struct find_free_extent_ctl *ffe_ctl,
-				bool delalloc)
+				struct find_free_extent_ctl *ffe_ctl)
 {
 	switch (ffe_ctl->policy) {
 	case BTRFS_EXTENT_ALLOC_CLUSTERED:
@@ -4221,7 +4173,6 @@ static void release_block_group(struct btrfs_block_group *block_group,
 
 	BUG_ON(btrfs_bg_flags_to_raid_index(block_group->flags) !=
 	       ffe_ctl->index);
-	btrfs_unlock_block_group(block_group, delalloc);
 }
 
 static void found_extent_clustered(struct find_free_extent_ctl *ffe_ctl,
@@ -4708,8 +4659,6 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		if (find_free_extent_skip_block_group(block_group, ffe_ctl))
 			continue;
 
-		btrfs_lock_block_group(block_group, ffe_ctl->delalloc);
-
 		/*
 		 * this can happen if we end up cycling through all the
 		 * raid types, but we want to make sure we only allocate
@@ -4734,7 +4683,6 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			 * It's possible that we have MIXED_GROUP flag but no
 			 * block group is mixed.  Just skip such block group.
 			 */
-			btrfs_unlock_block_group(block_group, ffe_ctl->delalloc);
 			continue;
 		}
 
@@ -4778,7 +4726,6 @@ static noinline int find_free_extent(struct btrfs_root *root,
 			goto loop;
 
 		if (bg_ret && bg_ret != block_group) {
-			btrfs_unlock_block_group(block_group, ffe_ctl->delalloc);
 			/*
 			 * bg_ret is still on the list: btrfs_remove_block_group()
 			 * detaches it from the cluster before list_del_init().
@@ -4807,7 +4754,6 @@ static noinline int find_free_extent(struct btrfs_root *root,
 
 		ret = btrfs_add_reserved_bytes(block_group, ffe_ctl->ram_bytes,
 					       ffe_ctl->num_bytes,
-					       ffe_ctl->delalloc,
 					       ffe_ctl->loop >= LOOP_WRONG_SIZE_CLASS);
 		if (ret == -EAGAIN) {
 			btrfs_add_free_space_unused(block_group,
@@ -4822,7 +4768,6 @@ static noinline int find_free_extent(struct btrfs_root *root,
 		ins->offset = ffe_ctl->num_bytes;
 
 		trace_btrfs_reserve_extent(block_group, ffe_ctl);
-		btrfs_unlock_block_group(block_group, ffe_ctl->delalloc);
 		break;
 loop:
 		if (!ffe_ctl->cached && ffe_ctl->loop > LOOP_CACHING_NOWAIT &&
@@ -4834,7 +4779,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 						ffe_ctl->empty_size);
 			goto have_block_group;
 		}
-		release_block_group(block_group, ffe_ctl, ffe_ctl->delalloc);
+		release_block_group(block_group, ffe_ctl);
 		cond_resched();
 	}
 	up_read(&space_info->groups_sem);
@@ -4897,11 +4842,6 @@ static noinline int find_free_extent(struct btrfs_root *root,
  * @is_data        -	Boolean flag indicating whether an extent is
  *			allocated for data (true) or metadata (false)
  *
- * @delalloc       -	Boolean flag indicating whether this allocation is for
- *			delalloc or not. If 'true' data_rwsem of block groups
- *			is going to be acquired.
- *
- *
  * Returns 0 when an allocation succeeded or < 0 when an error occurred. In
  * case -ENOSPC is returned then @ins->offset will contain the size of the
  * largest available hole the allocator managed to find.
@@ -4909,7 +4849,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 			 u64 num_bytes, u64 min_alloc_size,
 			 u64 empty_size, u64 hint_byte,
-			 struct btrfs_key *ins, bool is_data, bool delalloc)
+			 struct btrfs_key *ins, bool is_data)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct find_free_extent_ctl ffe_ctl = {};
@@ -4928,7 +4868,6 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 	ffe_ctl.min_alloc_size = min_alloc_size;
 	ffe_ctl.empty_size = empty_size;
 	ffe_ctl.flags = flags;
-	ffe_ctl.delalloc = delalloc;
 	ffe_ctl.hint_byte = hint_byte;
 	ffe_ctl.for_treelog = for_treelog;
 	ffe_ctl.for_data_reloc = for_data_reloc;
@@ -4961,8 +4900,7 @@ int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes,
 	return ret;
 }
 
-int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info, u64 start, u64 len,
-			       bool is_delalloc)
+int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info, u64 start, u64 len)
 {
 	struct btrfs_block_group *cache;
 
@@ -4974,7 +4912,7 @@ int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info, u64 start, u64 len
 	}
 
 	btrfs_add_free_space(cache, start, len);
-	btrfs_free_reserved_bytes(cache, len, is_delalloc);
+	btrfs_free_reserved_bytes(cache, len);
 	trace_btrfs_reserved_extent_free(fs_info, start, len);
 
 	btrfs_put_block_group(cache);
@@ -5406,7 +5344,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		return ERR_CAST(block_rsv);
 
 	ret = btrfs_reserve_extent(root, blocksize, blocksize, blocksize,
-				   empty_size, hint, &ins, false, false);
+				   empty_size, hint, &ins, false);
 	if (ret)
 		goto out_unuse;
 
@@ -5468,7 +5406,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_tree_unlock(buf);
 	free_extent_buffer(buf);
 out_free_reserved:
-	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, false);
+	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset);
 out_unuse:
 	btrfs_unuse_block_rsv(fs_info, block_rsv, blocksize);
 	return ERR_PTR(ret);
diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
index ecb2a1bf2435..b2895bad41dd 100644
--- a/fs/btrfs/extent-tree.h
+++ b/fs/btrfs/extent-tree.h
@@ -39,7 +39,6 @@ struct find_free_extent_ctl {
 	struct btrfs_free_cluster *last_ptr;
 	bool use_cluster;
 
-	bool delalloc;
 	bool have_caching_bg;
 	bool orig_have_caching_bg;
 
@@ -140,7 +139,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 				   struct btrfs_key *ins);
 int btrfs_reserve_extent(struct btrfs_root *root, u64 ram_bytes, u64 num_bytes,
 			 u64 min_alloc_size, u64 empty_size, u64 hint_byte,
-			 struct btrfs_key *ins, bool is_data, bool delalloc);
+			 struct btrfs_key *ins, bool is_data);
 int btrfs_inc_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		  struct extent_buffer *buf, bool full_backref);
 int btrfs_dec_ref(struct btrfs_trans_handle *trans, struct btrfs_root *root,
@@ -151,8 +150,7 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans, struct btrfs_ref *ref);
 
 u64 btrfs_get_extent_owner_root(struct btrfs_fs_info *fs_info,
 				struct extent_buffer *leaf, int slot);
-int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info, u64 start, u64 len,
-			       bool is_delalloc);
+int btrfs_free_reserved_extent(struct btrfs_fs_info *fs_info, u64 start, u64 len);
 int btrfs_pin_reserved_extent(struct btrfs_trans_handle *trans,
 			      const struct extent_buffer *eb);
 int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b071ed59a583..f66d3034b555 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1072,7 +1072,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 	compressed_size = async_extent->cb->bbio.bio.bi_iter.bi_size;
 	ret = btrfs_reserve_extent(root, async_extent->ram_size,
 				   compressed_size, compressed_size,
-				   0, *alloc_hint, &ins, true, true);
+				   0, *alloc_hint, &ins, true);
 	if (ret) {
 		/*
 		 * We can't reserve contiguous space for the compressed size.
@@ -1131,7 +1131,7 @@ static void submit_one_async_extent(struct async_chunk *async_chunk,
 
 out_free_reserve:
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
-	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, true);
+	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset);
 	mapping_set_error(inode->vfs_inode.i_mapping, -EIO);
 	extent_clear_unlock_delalloc(inode, start, end,
 				     NULL, &cached,
@@ -1217,7 +1217,7 @@ static int cow_one_range(struct btrfs_inode *inode, struct folio *locked_folio,
 	int ret;
 
 	ret = btrfs_reserve_extent(root, num_bytes, num_bytes, min_alloc_size,
-				   0, alloc_hint, ins, true, true);
+				   0, alloc_hint, ins, true);
 	if (ret < 0) {
 		*ret_alloc_size = cur_len;
 		return ret;
@@ -1314,7 +1314,7 @@ static int cow_one_range(struct btrfs_inode *inode, struct folio *locked_folio,
 				     PAGE_END_WRITEBACK);
 	btrfs_qgroup_free_data(inode, NULL, file_offset, cur_len, NULL);
 	btrfs_dec_block_group_reservations(fs_info, ins->objectid);
-	btrfs_free_reserved_extent(fs_info, ins->objectid, ins->offset, true);
+	btrfs_free_reserved_extent(fs_info, ins->objectid, ins->offset);
 	mapping_set_error(inode->vfs_inode.i_mapping, -EIO);
 	*ret_alloc_size = cur_len;
 	/*
@@ -3135,21 +3135,6 @@ static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 						qgroup_reserved, &ins);
 }
 
-static void btrfs_release_delalloc_bytes(struct btrfs_fs_info *fs_info,
-					 u64 start, u64 len)
-{
-	struct btrfs_block_group *cache;
-
-	cache = btrfs_lookup_block_group(fs_info, start);
-	ASSERT(cache);
-
-	spin_lock(&cache->lock);
-	cache->delalloc_bytes -= len;
-	spin_unlock(&cache->lock);
-
-	btrfs_put_block_group(cache);
-}
-
 static int insert_ordered_extent_file_extent(struct btrfs_trans_handle *trans,
 					     struct btrfs_ordered_extent *oe)
 {
@@ -3310,9 +3295,6 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 			goto out;
 		}
 		clear_reserved_extent = false;
-		btrfs_release_delalloc_bytes(fs_info,
-					     ordered_extent->disk_bytenr,
-					     ordered_extent->disk_num_bytes);
 	}
 
 	ret = btrfs_unpin_extent_cache(inode, ordered_extent->file_offset,
@@ -3400,7 +3382,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 						NULL, true);
 			btrfs_free_reserved_extent(fs_info,
 					ordered_extent->disk_bytenr,
-					ordered_extent->disk_num_bytes, true);
+					ordered_extent->disk_num_bytes);
 			/*
 			 * Actually free the qgroup rsv which was released when
 			 * the ordered extent was created.
@@ -9195,7 +9177,7 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 		 */
 		cur_bytes = min(cur_bytes, last_alloc);
 		ret = btrfs_reserve_extent(root, cur_bytes, cur_bytes,
-				min_size, 0, *alloc_hint, &ins, true, false);
+				min_size, 0, *alloc_hint, &ins, true);
 		if (ret)
 			break;
 
@@ -9221,7 +9203,7 @@ int btrfs_prealloc_file_range(struct inode *inode, int mode,
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
 			btrfs_free_reserved_extent(fs_info, ins.objectid,
-						   ins.offset, false);
+						   ins.offset);
 			break;
 		}
 
@@ -10021,7 +10003,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 	}
 
 	ret = btrfs_reserve_extent(root, disk_num_bytes, disk_num_bytes,
-				   disk_num_bytes, 0, 0, &ins, true, true);
+				   disk_num_bytes, 0, 0, &ins, true);
 	if (ret)
 		goto out_delalloc_release;
 	extent_reserved = true;
@@ -10062,7 +10044,7 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 
 out_free_reserved:
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
-	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, true);
+	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset);
 out_delalloc_release:
 	btrfs_delalloc_release_extents(inode, num_bytes);
 	btrfs_delalloc_release_metadata(inode, disk_num_bytes, ret < 0);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index b2ac5b836b21..8575ee0a2de9 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4286,7 +4286,7 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
 		min_size = fs_info->nodesize;
 
 	ret = btrfs_reserve_extent(fs_info->fs_root, length, length, min_size,
-				   0, 0, &ins, is_data, false);
+				   0, 0, &ins, is_data);
 	if (unlikely(ret)) {
 		spin_lock(&sinfo->lock);
 		btrfs_space_info_update_bytes_may_use(sinfo, -length);
@@ -4309,7 +4309,7 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
 		u64 new_length = ALIGN_DOWN(dest_length, fs_info->nodesize);
 
 		btrfs_free_reserved_extent(fs_info, dest_addr + new_length,
-					   dest_length - new_length, 0);
+					   dest_length - new_length);
 
 		dest_length = new_length;
 	}
@@ -4443,14 +4443,14 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
 	btrfs_dec_block_group_reservations(fs_info, dest_addr);
 
 	if (unlikely(ret)) {
-		btrfs_free_reserved_extent(fs_info, dest_addr, dest_length, 0);
+		btrfs_free_reserved_extent(fs_info, dest_addr, dest_length);
 
 		if (trans) {
 			btrfs_abort_transaction(trans, ret);
 			btrfs_end_transaction(trans);
 		}
 	} else {
-		btrfs_free_reserved_bytes(dest_bg, dest_length, 0);
+		btrfs_free_reserved_bytes(dest_bg, dest_length);
 
 		ret = btrfs_commit_transaction(trans);
 	}
@@ -5115,7 +5115,7 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 	 * rest of it the next time round.
 	 */
 	ret = btrfs_reserve_extent(fs_info->fs_root, remap_length, remap_length,
-				   min_size, 0, 0, &ins, is_data, false);
+				   min_size, 0, 0, &ins, is_data);
 	if (ret) {
 		spin_lock(&sinfo->lock);
 		btrfs_space_info_update_bytes_may_use(sinfo, -remap_length);
@@ -5141,7 +5141,7 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 		u64 new_length = ALIGN_DOWN(length, fs_info->nodesize);
 
 		btrfs_free_reserved_extent(fs_info, new_addr + new_length,
-					   length - new_length, 0);
+					   length - new_length);
 
 		length = new_length;
 	}
@@ -5180,7 +5180,7 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 	}
 
 	adjust_block_group_remap_bytes(trans, dest_bg, length);
-	btrfs_free_reserved_bytes(dest_bg, length, 0);
+	btrfs_free_reserved_bytes(dest_bg, length);
 
 	spin_lock(&sinfo->lock);
 	sinfo->bytes_readonly += length;
@@ -5224,7 +5224,7 @@ static int do_remap_reloc_trans(struct btrfs_fs_info *fs_info,
 	if (dest_bg)
 		btrfs_put_block_group(dest_bg);
 
-	btrfs_free_reserved_extent(fs_info, new_addr, length, 0);
+	btrfs_free_reserved_extent(fs_info, new_addr, length);
 
 	mutex_unlock(&fs_info->remap_mutex);
 	btrfs_end_transaction(trans);
diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
index 82d4ac418a2d..e2355c844a50 100644
--- a/fs/btrfs/space-info.c
+++ b/fs/btrfs/space-info.c
@@ -685,10 +685,9 @@ void btrfs_dump_space_info(struct btrfs_space_info *info, u64 bytes,
 		spin_lock(&cache->lock);
 		avail = btrfs_block_group_available_space(cache);
 		btrfs_info(fs_info,
-"block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %llu delalloc %llu super %llu zone_unusable (%llu bytes available) %s",
+"block group %llu has %llu bytes, %llu used %llu pinned %llu reserved %llu super %llu zone_unusable (%llu bytes available) %s",
 			   cache->start, cache->length, cache->used, cache->pinned,
-			   cache->reserved, cache->delalloc_bytes,
-			   cache->bytes_super, cache->zone_unusable,
+			   cache->reserved, cache->bytes_super, cache->zone_unusable,
 			   avail, cache->ro ? "[readonly]" : "");
 		spin_unlock(&cache->lock);
 		btrfs_dump_free_space(cache, bytes);
-- 
2.56.0

