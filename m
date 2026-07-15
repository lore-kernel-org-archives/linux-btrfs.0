Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE0C1A304A
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 00:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784074866; cv=none; b=l2At93HtMvkK4Ksb7iF6VALqvr89DOz2WiR34fIyGkty83CIhQqxNBuGWn3x5mEUByGnn6D5ruOUr7JvV0uOGOjkek/gnn1XMmXylzK+UjOYAnugkzj1P8lnq0HTrdZ4LveLWkmo11D+8N1jAXpOBDZRcaDPn/6Db1iAg1TdNEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784074866; c=relaxed/simple;
	bh=IA5NtyQfsETZEjjrZOLBAynoyCqI7ChrdBmLT/wjU98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LaDoGJU31qtSzd/rUgevYL1yd8Ou8noM2ZLsYbCkQSgUtbMpfIaXsG0bQXHR6iyQgz+/fozrRKI8WuyNOTcXgERgrqu1AGboiu6hMuIYUvhQ+QF2K/6vSRxNCqxAxLufl6tMNm/RpZ8cZ0N9MwuHsmGL4r3dMoJYMl69xWTKY10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=gehMg89V; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=aO8GOvaV; arc=none smtp.client-ip=103.168.172.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="gehMg89V";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="aO8GOvaV"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id E3BD1EC00FB;
	Tue, 14 Jul 2026 20:21:02 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 14 Jul 2026 20:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1784074862; x=1784161262; bh=YsL3EjTb+rs49aHTHRhaS
	2KJspNm4r5nqxGOh+ClHzQ=; b=gehMg89VreGYdig0GpLMAA9XSqA4BGfn84lay
	H6ZY29x3+DDmg1iQ5vp0CnFefNIJhaikC8r3+rjCd3q+TGfm1QY53EvgUOV3kngm
	5XpmmsCvKKbifiR8l+Q5gcXaFZfRHGh2ttQKttY727WprBbVztM+FlYzpF2kATbK
	qktG9ONgdd8yaTk2XRGs9vU1j6tRXCykLWyEdaRWpRU5Cv/jc0wJxGEIGfBZt9sN
	+s9YRZonL5ta4dBLhrsq2XfEwwkRjaqsKsfikGfeiKiVFEANXdj602o3bJHHjp+K
	7lgVaNlDPnZE7WV/8jX/yB5vpvxunIhqrwLp6Pxed/HrQ5ceA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1784074862; x=1784161262; bh=YsL3EjTb+rs49aHTHRhaS2KJspNm4r5nqxG
	Oh+ClHzQ=; b=aO8GOvaVaCaeK129IM2UiMr67a7G5FYcTDc0B3WvrgPh8X2sbMd
	ybTdvTJCWoyjJt46bVG78IDddeSzN3m1A11AhI9tMOdYqNpTdM0cOgHrb97Tw3Pr
	b+pLgzrTUuEf9Du+Bcpj9GKkokz02+nmHXeWqD1zUqK5UpePdPrAYCd/aQEDAmKa
	H0LOEMbzK9pryfiJizhLx2IOkn4/JdhP6WdqHSPV65LDaBpnd+1nezTDmFmoyard
	WJW53dj0pTrUHVvK7/Sjp02viOaF92jQP70YZY6VPw2zwXgsuxm9ktkzW+Lbu+cc
	9Kd+sM0f5FnbLz+UARWmT/7O7tKvPBYKUrg==
X-ME-Sender: <xms:btJWagaP5SM9REf7pYDl3dEHcfKfH4ROgj9crWSb8P27BhLbf7D4WQ>
    <xme:btJWai1Bl0aEVCyGv4WXiONS98DQnkWb_mVFCyg4tj__PRJNO9DqcBv88Szm62LIe
    Tv_Dtmx5Vvd3QnXKFTrBO6MdO8N3vREqNRZVIgIUz6gathRRp3AkWUB>
X-ME-Received: <xmr:btJWaoU270J0gdYF_XReSuJAWYSNuBr3Yw-W691kpV5TyXmsJvfKAfcmdAcYid_F-zXZjIjSVKmGISHDoYZc4WMmBPI>
X-ME-Proxy-Cause: dmFkZTEbgWsSNCsC9UP27Ruw2rWhj6hAFzz4ntRx241V75Q7QVpDK4/BNN4tWtaj4hlyNe
    nh93rCIeJCCrI2qQ5hQ6ld7lYkKh4TOPhQbR8yO2P8UbVIq/LeAwG30INr8TbHIrZrGLnH
    zhIYflzgY5AMgUj34QHhDIBC4leOD/E7hEMCkpnX3pDHfsKjGm0w0T1UTVrI+wlc3BPtDA
    kNyLuIvExXGtksycrrSV2Cz3ckF+S/f0mBsymb9tC/3cb9BGkDY504GlYpyefg0LX6M42Q
    yhzpuxvcWupabPVceGKYpjgV/o58qzVvteZqi7urFf7/1hZ5MAQsvzdQsEVw3Sq2jz4AiK
    dP3mEYGR6aCqO2upvKatl1Smk3AjgggVfj9X0X4vhiKNSmL7BlLXB0K9EDaA8WNw6GOtQs
    dIfKfT8HOxHBwGPokQuyPX+r6Ls6ajCJpaOVscWNv+6BoIcX2/nIQzQVavJic4ba/sD3v1
    y1O8HesWFcyFD9/PoxP83N8CxtS5V+xDgb6Hi1Pq23aRegMlSCL4wtnRALTSQUWtX6jvrf
    QccsqHPOzwISZrstdU7lLG/Ev1mlER1b8jzI76T0+5303EHRHoUq3Tp6lHGh2mWEOb8KQF
    ZzEIFL9pC8EYs6/Uym5pls43fZJ/Vjkd37qrFYYjiR+Qo03tOgbRtDX97xcQ
X-ME-Proxy: <xmx:btJWakU4POwxVQs6bW5t49b1_9bUNichFg7zy2rDPKg-LEVoaH7tAA>
    <xmx:btJWavduL9CYQlXdoMahoNM4NO0tGtAm9pGrgr7V0tVIRWlVWWF9zw>
    <xmx:btJWalWqKcqmJUBi0cWlm9okv6uq8hKP8MbXO6vTrR7SkPJGHOCKWA>
    <xmx:btJWagfu9KxNavTDG4f5ZWbH66mUAER4Q4npu4zwSEJGyHeQ1dJU6Q>
    <xmx:btJWap2pvhTJb0sn_aCAHlKIvexDzf8Ao_pvs6a2XQiE7UKXKOnVNGeU>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 20:21:02 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: willy@infradead.org
Subject: [PATCH v2] btrfs: write-protect folios during data writeback
Date: Tue, 14 Jul 2026 17:21:02 -0700
Message-ID: <e4721e5fdeec2f5a448c6bf25d896d58d35406bb.1784074799.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 095be159f3eb ("btrfs: unify folio dirty flag clearing") replaced
the folio_clear_dirty_for_io() call in extent_write_cache_pages() with a
plain folio_test_dirty() check. Besides clearing the dirty flag,
folio_clear_dirty_for_io() also calls folio_mkclean(), which write-protects
the shared mmap PTEs mapping the folio. Note that we still do call
folio_clear_dirty_for_io() later in submit_one_sector() when we clear
dirty on the last sector of the folio (the only sector for non-subpage
cases). But we lost this early call in extent_write_cache_pages().

Without the extra write-protection, a process with the file mmap-ed can
modify a sector while it is being used by writeback in a way that
expects a stable folio (checksumming, compressing, copying, etc...)
without faulting, which manifests as a handful of concrete bugs.

1. For large folios or subpage sectorsize, it is possible to submit a bio
which does not cover the whole folio. When this happens, we will have a
bio in flight for a folio that we have *not* called
folio_clear_dirty_for_io() on. If a task with an existing mmap-ed PTE
writes (without faulting..) in this window, it can result in
corruptions. If the write arrives while the checksumming or writing itself
is underway, this can result in an invalid checksum and later corruption
reports on read. If the write arrives after checksumming/writing is done
but before the last sector dirty is cleared, then the write is present
in page cache but doesn't affect the dirty tracking and will be lost
when the the folio is fully finished being submitted and the dirty bit
is cleared. This results in losing the write even if fsync() is called.

2. For zoned submissions which are done in batch separate from the main
extent_writepage() loop, we also risk csum violations for those
submissions. Zoned writes are clamped to max_zone_append_size and are
not aligned with folios, so a submission can span two folios. The first
folio being processed in extent_write_cache_pages() will call
extent_write_locked_range() which will submit the partial range of the
next folio, while the rest of that folio could still be dirty. So
clearing dirty on the submitted sectors doesn't call
folio_clear_dirty_for_io() and we have the same issue. Since
extent_write_cache_pages() skips these batch submitted folios (they are
already marked for writeback from submission by the preceding folio), we
must add the extra write protection in lock_delalloc_folios().

3. For inline extents this will subtly risk losing writes that happen
after/while we copy the inline extent but before we clear dirty on
the folio.

4. For folios spanning EOF, mmap could tamper with the zeroed bytes past
EOF and cause them to be persisted where future faults would improperly
see them instead of zeros.

5. Finally, for compressed extents, we risk modifying the folios while we
work on compressing them which will result in corrupted compressed data.
Specifically, in run_delalloc_compressed() we queue up work to do
compress_file_range() in BTRFS_COMPRESSION_CHUNK_SIZE (512K) chunks which
will call btrfs_folio_clamp_clear_dirty() on the range. For non-subpage,
this will always clear the whole folio, safely. For subpage, we risk a
partial clear here as well. In particular, imagine a 2M folio broken up
into 512K chunks of work which might start compression work on one chunk
before all the chunks compress_file_range() workers have gotten far
enough to finish clearing all the dirty bitmaps of the folio and getting
to folio_clear_dirty_for_io(). Large folios on the edges of submission
ranges are similarly at risk to be only partly cleared.
This particular gap was introduced by a second patch in the same series:
commit a4ef54dbb576 ("btrfs: make extent_range_clear_dirty_for_io() to handle sector size < page size cases")

We cannot simply restore the call to folio_clear_dirty_for_io() because
that also drops the dirty flag off the folio which violates invariants
introduced for large folios by
commit 334509ce9d07 ("btrfs: use dirty flag to check if an ordered extent needs to be truncated")
and results in failing to invalidate clean folios past i_size, resulting
in deadlocks.

Therefore, to fix it, leave the existing semantics w.r.t. the folio's
dirty flag (to preserve the correct invalidate behavior) but ensure that
the other aspect of folio_clear_dirty_for_io(), folio_mkclean(), is run
on the folio when we lock it for writeback.

Finally, to help prevent similar regressions in the future, add a debug
warning that triggers at the known corruption sites if we have failed to
write protect the folio.

Assisted-by: LLM (debug, reproduce, research fix, review patch)
Fixes: 095be159f3eb ("btrfs: unify folio dirty flag clearing")
Fixes: a4ef54dbb576 ("btrfs: make extent_range_clear_dirty_for_io() to handle sector size < page size cases")
Signed-off-by: Boris Burkov <boris@bur.io>
---
Changelog:
v2:
- improved changelog to cover more details of the conditions needed to
  cause the bugs.

 fs/btrfs/extent_io.c | 31 +++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |  5 +++++
 fs/btrfs/inode.c     | 23 +++++++++++++++++------
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8fbb798767ca..647b109ef61b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -6,6 +6,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/page-flags.h>
+#include <linux/rmap.h>
 #include <linux/sched/mm.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
@@ -299,6 +300,25 @@ static noinline void unlock_delalloc_folio(const struct inode *inode,
 				PAGE_UNLOCK);
 }
 
+#ifdef CONFIG_BTRFS_DEBUG
+/*
+ * Writeback must write-protect a folio when locking it for IO, before
+ * anything consumes its data (zeroing, inline copy, compression,
+ * checksumming). If this fails, then an mmap writer would be able to
+ * modify the data concurrently while we need it to be stable.
+ */
+void btrfs_check_folio_write_protected(struct folio *folio)
+{
+	if (folio_mkclean(folio)) {
+		const struct btrfs_inode *inode = BTRFS_I(folio->mapping->host);
+
+		DEBUG_WARN("writable mmap PTEs, root %llu ino %llu pos %llu order %u",
+			   btrfs_root_id(inode->root), btrfs_ino(inode), folio_pos(folio),
+			   folio_order(folio));
+	}
+}
+#endif
+
 static noinline int lock_delalloc_folios(struct inode *inode,
 					 struct folio *locked_folio,
 					 u64 start, u64 end)
@@ -332,6 +352,8 @@ static noinline int lock_delalloc_folios(struct inode *inode,
 				folio_unlock(folio);
 				goto out;
 			}
+			/* Locked for writeback; revoke writable mmap PTEs before using the data. */
+			folio_mkclean(folio);
 			range_start = max_t(u64, folio_pos(folio), start);
 			range_len = min_t(u64, folio_next_pos(folio), end + 1) - range_start;
 			btrfs_folio_set_lock(fs_info, folio, range_start, range_len);
@@ -1780,6 +1802,13 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	ASSERT(end <= folio_end, "start=%llu len=%u folio_start=%llu folio_size=%zu",
 	       start, len, folio_start, folio_size(folio));
 
+	/*
+	 * We are about to checksum and write out the data, so it must not be
+	 * mmap writeable, or we could corrupt the data and end up with invalid
+	 * checksums.
+	 */
+	btrfs_check_folio_write_protected(folio);
+
 	/* Truncate the submit bitmap to the current range. */
 	if (start > folio_start)
 		bitmap_clear(bio_ctrl->submit_bitmap, 0,
@@ -2590,6 +2619,8 @@ static int extent_write_cache_pages(struct address_space *mapping,
 				continue;
 			}
 
+			/* Locked for writeback; revoke writable mmap PTEs before using the data. */
+			folio_mkclean(folio);
 			ret = extent_writepage(folio, bio_ctrl);
 			if (ret < 0) {
 				done = true;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 9896e15ddc40..869925337699 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -255,6 +255,11 @@ bool try_release_extent_mapping(struct folio *folio, gfp_t mask);
 int try_release_extent_buffer(struct folio *folio);
 
 int btrfs_read_folio(struct file *file, struct folio *folio);
+#ifdef CONFIG_BTRFS_DEBUG
+void btrfs_check_folio_write_protected(struct folio *folio);
+#else
+static inline void btrfs_check_folio_write_protected(struct folio *folio) { }
+#endif
 void extent_write_locked_range(struct inode *inode, const struct folio *locked_folio,
 			       u64 start, u64 end, struct writeback_control *wbc,
 			       bool pages_dirty);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b47e2aa5071d..636196705fa3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -775,19 +775,28 @@ static inline void inode_should_defrag(struct btrfs_inode *inode,
 
 static int extent_range_clear_dirty_for_io(struct btrfs_inode *inode, u64 start, u64 end)
 {
+	pgoff_t index = start >> PAGE_SHIFT;
 	const pgoff_t end_index = end >> PAGE_SHIFT;
 	struct folio *folio;
 	int ret = 0;
 
-	for (pgoff_t index = start >> PAGE_SHIFT; index <= end_index; index++) {
+	while (index <= end_index) {
 		folio = filemap_get_folio(inode->vfs_inode.i_mapping, index);
 		if (IS_ERR(folio)) {
 			if (!ret)
 				ret = PTR_ERR(folio);
+			index++;
 			continue;
 		}
+		/*
+		 * We are about to compress the folio, so it must not be mmap
+		 * writeable or we could corrupt the data as we attempt to
+		 * compress it.
+		 */
+		btrfs_check_folio_write_protected(folio);
 		btrfs_folio_clamp_clear_dirty(inode->root->fs_info, folio, start,
 					      end + 1 - start);
+		index = folio_next_index(folio);
 		folio_put(folio);
 	}
 	return ret;
@@ -877,11 +886,6 @@ static void compress_file_range(struct btrfs_work *work)
 
 	inode_should_defrag(inode, start, end, end - start + 1, SZ_16K);
 
-	/*
-	 * We need to call clear_page_dirty_for_io on each page in the range.
-	 * Otherwise applications with the file mmap'd can wander in and change
-	 * the page contents while we are compressing them.
-	 */
 	ret = extent_range_clear_dirty_for_io(inode, start, end);
 
 	/*
@@ -2317,6 +2321,13 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
 	int ret;
 
 	ASSERT(folio_pos(locked_folio) == 0);
+	/*
+	 * If an mmap writer could modify the folio while we copy it into an
+	 * inline extent we might see only part of their modification then
+	 * wrongly mark it clean again after copying, losing that write. So the
+	 * folio must be write protected here.
+	 */
+	btrfs_check_folio_write_protected(locked_folio);
 
 	if (btrfs_inode_can_compress(inode) &&
 	    inode_need_compress(inode, 0, blocksize, true)) {
-- 
2.55.0

