Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2173254BB
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 15:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779897088; cv=none; b=uQgO27+gFD4lgPgc5gkZYJCuFov8sUsVS9Pxa0lolmhBuvrgXKo0gK6wNGxkZTROjp9inNvLm+4GY7hJtXwSFqTYIK0QYdvzjJ4XwzcKuRhbaXSjkBA7f8+qLA/SkMZQ7raDZXxfNzgZCStoy5rcg/HHGdrOAAbbbeVzPm4SzuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779897088; c=relaxed/simple;
	bh=2KdqAkzdHleLyBg502Y3ggHbzfkzQtEi6E1PT9hcSXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LC1CXO1rtpSgON7SJTqojUQYpxJEz+AlSZzNJWvZHO9CVk3lpIFXu+3+ZOzP1WpXrUrwUjmD5aUfIXJ3feNU28FcwL5qpKOmAIlJ4THOO3vxMV/O7wiNjH6U6ZwgZuPyCSu4uGlc4LbELM7G1MBLt9K89sTXY6PtjW5Bnog+FMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k+47OdRj; arc=none smtp.client-ip=209.85.128.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k+47OdRj"
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-7b4ee3a88e1so113836347b3.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 08:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779897086; x=1780501886; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lCUyR7f5kpHOM76Lh2WrZfehiekzfV3WqrZEO9NdlLw=;
        b=k+47OdRjN9bYfm/PTMWKx/2uggxF7s5EIhoe5m5cFJxR31JAGSa73UzeN6ldDdMHWb
         aWjknt2HCwuj+jdGW1+K8s/hfOcEKJ4hiCnxKVmNtcBwjX8itDp6VYbocWi68N87r4aF
         k0l8dsZdLYs3dylYfhY56tFmYyu2B9+XCJjV0/GM7ot4cNIZj6qBp7AIYidvf8+pedE4
         8ttFA66ysJvQumWe2ih9SWfZsqMgHnbQgtdVOGyDCjPiDHnbw1yp7hxKNdYBuTYeGzHu
         Lrbrjw8uDqDxhHd+eb4DVVGNNpfiXvYhx/9Xld9XhrEcTywbfF7cOap4konWD5cjm367
         GQaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779897086; x=1780501886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lCUyR7f5kpHOM76Lh2WrZfehiekzfV3WqrZEO9NdlLw=;
        b=sI8lNQ+c12+59PotIh7Nli7MFnIPJDzKHbpPfAYDcIB4kNasmrqtbi0l59lLw6aiRD
         fykEeEJr0ByvOvbOIdogUHPEinxWyIM2SdDBOy8bRhEkttVRN0UGNSE+/O1vsJr8w6/x
         SoeKK1Il+5ywIXe7cO93ejXUh1Fl4NJy4K2TGSn+Ss+SiWb92kSOZm8pbHG7vOlbtlSS
         Lr8wvI5QiSMp/R04kc0a504LKpGODmleaiHfdB2US++VHzlC4e/5jJ1XpSOZV6L9XHlg
         D4N4mZxoCIPRSHv+6Ngr5JrNnN79jM1rPrkNqvs/CzOCSZo2+CGdCnv0/pUEyKXFRlSJ
         D2sw==
X-Gm-Message-State: AOJu0YyGNLMMpA/cA5eobxqz/fb9vYZJxcoKR/In+TzhzlRqDpn0Y/8L
	9Na1Epg+pF6Y3bV5o+gftJVyoMke4gjZRGEiu5TQEjAoRpckkiPY2pqlO7h1pMoC
X-Gm-Gg: Acq92OGztPvr9pJJFe3eizB3VNyRh7SMoSpwaMaTR/eGtcnT0QKejafDC0kiehlVT3P
	tgOpgK34KBa3PUVRvI6vrVNaptkxZgRjKi2V31uSrrT1tJAxlC9HPKgfuPbcUEVkeWIP5nx++Xu
	AhtulE+ClQXHWkQbQJu+7/g5/aYIPgYDnuQeYmE7uYAve2B9qGcg3gfqhKMcNPsXIWpXpEybyJ0
	zSwqYlTDvOjw4LFpSxpLyJ47vy/lpQIkMbhVyT07pa1hQXGpVhBWYSoWXVeDksR9c77MoDcr+MH
	9lfyleXgHNRHkAg9VKdRiD9RiaCr0JWto6tTmjXj2qY+7MBxLhZ6N9eWskGKzO2ZAMOAqiH2Uxf
	ayZkuJOXedWaiFwG91Dofv+JeMRenRlbGK+UBBWqvDokR20/WsCz8dzpqQo5QeK951G/B+TTiKk
	XA688m8/618JCiCWzknO8Jzmlf
X-Received: by 2002:a05:690c:a78e:b0:7db:e20c:2b24 with SMTP id 00721157ae682-7dbe20c4519mr9772127b3.45.1779897085634;
        Wed, 27 May 2026 08:51:25 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7d38c8396basm77036267b3.44.2026.05.27.08.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 08:51:25 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: Filipe Manana <fdmanana@suse.com>,
	Sun YangKai <sunk67188@gmail.com>
Subject: [PATCH v2 2/2] btrfs: skip COW for written extent buffers allocated in current transaction
Date: Wed, 27 May 2026 08:51:09 -0700
Message-ID: <d15772cee7ff1bad9d66cde0bb199ce372ebace7.1779895842.git.loemra.dev@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779895842.git.loemra.dev@gmail.com>
References: <cover.1779895842.git.loemra.dev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When memory pressure causes writeback of a recently COW'd buffer,
btrfs sets BTRFS_HEADER_FLAG_WRITTEN on it. Subsequent
btrfs_search_slot() restarts then see the WRITTEN flag and re-COW
the buffer unnecessarily, causing COW amplification that can exhaust
block reservations and degrade throughput.

Overwriting in place is crash-safe because the committed superblock
does not reference buffers allocated in the current (uncommitted)
transaction, so no on-disk tree points to this block yet.

When should_cow_block() encounters a WRITTEN buffer whose generation
matches the current transaction, instead of requesting a COW, re-dirty
the buffer and re-register its range in the transaction's dirty_pages.

Both are necessary because btrfs tracks dirty metadata through two
independent mechanisms. set_extent_buffer_dirty() sets the
EXTENT_BUFFER_DIRTY flag and the buffer_tree xarray PAGECACHE_TAG_DIRTY
mark, which is what background writeback (btree_write_cache_pages) uses
to find and write dirty buffers. The transaction's dirty_pages io tree
is a separate structure used by btrfs_write_and_wait_transaction() at
commit time to ensure all buffers allocated during the transaction are
persisted. The dirty_pages range was originally registered in
btrfs_init_new_buffer() when the block was first allocated. Normally
dirty_pages is only cleared at commit time by
btrfs_write_and_wait_transaction(), but if qgroups are enabled and
snapshots are being created, qgroup_account_snapshot() may have already
called btrfs_write_and_wait_transaction() and released the range before
the final commit-time call.

Keep BTRFS_HEADER_FLAG_WRITTEN set so that btrfs_free_tree_block()
correctly pins the block if it is freed later.

Relax the lockdep assertion in btrfs_mark_buffer_dirty() from
btrfs_assert_tree_write_locked() to lockdep_assert_held() so that it
accepts either a read or write lock. should_cow_block() may be called
from btrfs_search_slot() when only a read lock is held (nodes above
write_lock_level are read-locked). The write lock assertion previously
documented the caller convention that buffer content was being modified
under exclusive access, but btrfs_mark_buffer_dirty() and
set_extent_buffer_dirty() themselves only perform independently
synchronized operations: atomic bit ops on bflags, folio_mark_dirty()
(kernel-internal folio locking), xarray mark updates (xarray spinlock),
and percpu counter updates. The read lock is sufficient because it
prevents lock_extent_buffer_for_io() from acquiring the write lock and
racing on the dirty state. Since rw_semaphore permits concurrent
readers, multiple threads can enter btrfs_mark_buffer_dirty()
simultaneously for the same buffer; this is safe because
test_and_set_bit(EXTENT_BUFFER_DIRTY) ensures only one thread performs
the full dirty state transition.

Remove the CONFIG_BTRFS_DEBUG assertion in set_extent_buffer_dirty()
that checked folio_test_dirty() after marking the buffer dirty. This
assertion assumed exclusive access (only one thread in
set_extent_buffer_dirty() at a time), which held when the only caller
was btrfs_mark_buffer_dirty() under write lock. With concurrent readers
calling through should_cow_block(), a thread that loses the
test_and_set_bit race sees was_dirty=true and skips the folio dirty
marking, but the winning thread may not have called
btrfs_meta_folio_set_dirty() yet, causing the assertion to fire. This
is a benign race: the winning thread will complete the folio dirty
marking, and no writeback can clear it while readers hold their locks.

Hoist the EXTENT_BUFFER_WRITEBACK, BTRFS_HEADER_FLAG_RELOC, and
BTRFS_ROOT_FORCE_COW checks before the WRITTEN block since they apply
regardless of whether the buffer has been written back. This
consolidates the exclusion logic and simplifies the WRITTEN path to
only handle log trees and zoned devices. Moving the RELOC checks
before the smp_mb__before_atomic() barrier is safe because both
btrfs_root_id() (immutable) and BTRFS_HEADER_FLAG_RELOC (set at COW
time under tree lock) are stable values not subject to concurrent
modification; the barrier is only needed for BTRFS_ROOT_FORCE_COW
which is set concurrently by create_pending_snapshot().

Exclude cases where in-place overwrite is not safe:
 - EXTENT_BUFFER_WRITEBACK: buffer is mid-I/O
 - Zoned devices: require sequential writes
 - Log trees: log blocks are immediately referenced by a committed
   superblock via btrfs_sync_log(), so overwriting could corrupt the
   committed log
 - BTRFS_ROOT_FORCE_COW: snapshot in progress
 - BTRFS_HEADER_FLAG_RELOC: block being relocated

Signed-off-by: Leo Martins <loemra.dev@gmail.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Sun YangKai <sunk67188@gmail.com>
---
 fs/btrfs/ctree.c     | 83 +++++++++++++++++++++++++++++++++++---------
 fs/btrfs/disk-io.c   |  2 +-
 fs/btrfs/extent_io.c |  4 ---
 3 files changed, 67 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 829d8be7f423..3f2e9e3145c2 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -603,6 +603,25 @@ int btrfs_force_cow_block(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
+/*
+ * Check if @buf needs to be COW'd.
+ *
+ * Returns true if COW is required, false if the block can be reused
+ * in place.
+ *
+ * We do not need to COW a block if:
+ * 1) the block was created or changed in this transaction;
+ * 2) the block does not belong to TREE_RELOC tree;
+ * 3) the root is not forced COW.
+ *
+ * Forced COW happens when we create a snapshot during transaction commit:
+ * after copying the src root, we must COW the shared block to ensure
+ * metadata consistency.
+ *
+ * When returning false for a WRITTEN buffer allocated in the current
+ * transaction, re-dirties the buffer for in-place overwrite instead
+ * of requesting a new COW.
+ */
 static inline bool should_cow_block(struct btrfs_trans_handle *trans,
 				    const struct btrfs_root *root,
 				    struct extent_buffer *buf)
@@ -610,22 +629,14 @@ static inline bool should_cow_block(struct btrfs_trans_handle *trans,
 	if (btrfs_is_testing(root->fs_info))
 		return false;
 
-	/*
-	 * We do not need to cow a block if
-	 * 1) this block is not created or changed in this transaction;
-	 * 2) this block does not belong to TREE_RELOC tree;
-	 * 3) the root is not forced COW.
-	 *
-	 * What is forced COW:
-	 *    when we create snapshot during committing the transaction,
-	 *    after we've finished copying src root, we must COW the shared
-	 *    block to ensure the metadata consistency.
-	 */
-
 	if (btrfs_header_generation(buf) != trans->transid)
 		return true;
 
-	if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN))
+	if (test_bit(EXTENT_BUFFER_WRITEBACK, &buf->bflags))
+		return true;
+
+	if (btrfs_root_id(root) != BTRFS_TREE_RELOC_OBJECTID &&
+	    btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC))
 		return true;
 
 	/* Ensure we can see the FORCE_COW bit. */
@@ -633,11 +644,49 @@ static inline bool should_cow_block(struct btrfs_trans_handle *trans,
 	if (test_bit(BTRFS_ROOT_FORCE_COW, &root->state))
 		return true;
 
-	if (btrfs_root_id(root) == BTRFS_TREE_RELOC_OBJECTID)
-		return false;
+	if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_WRITTEN)) {
+		/*
+		 * The buffer was allocated in this transaction and has been
+		 * written back to disk (WRITTEN is set). Normally we'd COW
+		 * it again, but since the committed superblock doesn't
+		 * reference this buffer (it was allocated in this transaction),
+		 * we can safely overwrite it in place.
+		 *
+		 * We keep BTRFS_HEADER_FLAG_WRITTEN set. The block has been
+		 * persisted at this bytenr and will be again after the
+		 * in-place update. This is important so that
+		 * btrfs_free_tree_block() correctly pins the block if it is
+		 * freed later (e.g., during tree rebalancing or FORCE_COW).
+		 *
+		 * Log trees and zoned devices cannot use this optimization:
+		 * - Log trees: log blocks are written and immediately
+		 *   referenced by a committed superblock via
+		 *   btrfs_sync_log(), bypassing the normal transaction
+		 *   commit. Overwriting in place could corrupt the
+		 *   committed log.
+		 * - Zoned devices: require sequential writes.
+		 */
+		if (btrfs_root_id(root) == BTRFS_TREE_LOG_OBJECTID ||
+		    btrfs_is_zoned(root->fs_info))
+			return true;
 
-	if (btrfs_header_flag(buf, BTRFS_HEADER_FLAG_RELOC))
-		return true;
+		/*
+		 * Re-register this block's range in the current transaction's
+		 * dirty_pages so that btrfs_write_and_wait_transaction()
+		 * writes it. The range was originally registered when the
+		 * block was allocated. Normally dirty_pages is only cleared
+		 * at commit time by btrfs_write_and_wait_transaction(), but
+		 * if qgroups are enabled and snapshots are being created,
+		 * qgroup_account_snapshot() may have already called
+		 * btrfs_write_and_wait_transaction() and released the range
+		 * before the final commit-time call.
+		 */
+		btrfs_set_extent_bit(&trans->transaction->dirty_pages,
+				     buf->start,
+				     buf->start + buf->len - 1,
+				     EXTENT_DIRTY, NULL);
+		btrfs_mark_buffer_dirty(trans, buf);
+	}
 
 	btrfs_inhibit_eb_writeback(trans, buf);
 	return false;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8a11be02eeb9..cc6893f9892e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4479,7 +4479,7 @@ void btrfs_mark_buffer_dirty(struct btrfs_trans_handle *trans,
 #endif
 	/* This is an active transaction (its state < TRANS_STATE_UNBLOCKED). */
 	ASSERT(trans->transid == fs_info->generation);
-	btrfs_assert_tree_write_locked(buf);
+	lockdep_assert_held(&buf->lock);
 	if (unlikely(transid != fs_info->generation)) {
 		btrfs_abort_transaction(trans, -EUCLEAN);
 		btrfs_crit(fs_info,
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3411c4199347..dd6304795ace 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3833,10 +3833,6 @@ void set_extent_buffer_dirty(struct extent_buffer *eb)
 					 eb->len,
 					 eb->fs_info->dirty_metadata_batch);
 	}
-#ifdef CONFIG_BTRFS_DEBUG
-	for (int i = 0; i < num_extent_folios(eb); i++)
-		ASSERT(folio_test_dirty(eb->folios[i]));
-#endif
 }
 
 void clear_extent_buffer_uptodate(struct extent_buffer *eb)
-- 
2.53.0-Meta

