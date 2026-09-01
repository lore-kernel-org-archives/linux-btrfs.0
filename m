Received: from mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00591425879
	for <linux-btrfs@vger.kernel.org>; Tue,  1 Sep 2026 03:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788232231; cv=none; b=Cen2BNIfwEhHwuZ0hUNy6kdUPV/2J1d88SEvGT2WcznNS7CAV7Ra2kYz8nA08psf+zhn4QDbEj2uulOJSCD86ACr6rLp3N8Fy+wewc2W4f+ctrP5wqDLcpA3zW2PmBWwqBBQyPEufmjv8zMDtkDYBtur9bIV6C8Uyq4EhiU+I3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788232231; c=relaxed/simple;
	bh=AA9zs4peXKVsBDlnJCWp7g3Xl/pc0+W71XBIrCNsNw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ctrmoB2Nm3OJUuMGkv8nJv5MdANku37FDWhpGdDe7ljVGa6ERIAb79ICp8QUTl1D7YwQIMBtesHx2hLaGeGqF1iruGEPzQ/CpCKfUzPP1l0sm7Zbw+mHfSaWnfxnaygwH9EUAfqt2SXLX72Z/AsG2zHI7Ixtun+cbutr0k6jW00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sLEjvszu; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sLEjvszu"
X-Envelope-To: linux-btrfs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=AA9zs4peXKVsBDlnJCWp7g3Xl/pc0+W71XBIrCNsNw0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788232223; v=1; x=1788837023;
 b=sLEjvszue7o/mdWMk0+khmxzH7QOTI3mzf92O487svLi9+F75rafr6/GzX8U8+1iCIlyY14G
 y3xWr8lKNOemyyHUdJiYpzl41MRo1VlzBgKtidGqBXEq7WPlToEPKeiaolxxTLxbp1A7Sp87h5Z
 HTx5N2XYxNkHnQtoL+8cZ9LY=
X-Envelope-To: linux-btrfs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 8ff52d866e859521;
	Tue, 01 Sep 2026 03:10:23 +0000
X-Mizu-Trace-ID: 8ff52d866e859521
X-Migadu-Flow: FLOW_OUT
From: Matthew Schwartz <matthew.schwartz@linux.dev>
To: stable@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Chris Mason <clm@fb.com>,
	Matthew Schwartz <matthew.schwartz@linux.dev>
Subject: [PATCH 7.2.y] btrfs: write-protect folios during data writeback
Date: Mon, 31 Aug 2026 20:09:45 -0700
Message-ID: <20260901030945.738683-1-matthew.schwartz@linux.dev>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Boris Burkov <boris@bur.io>

commit 5376c9db45368eb210b4d71104ac00a59dc8b6e0 upstream.

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
when the folio is fully finished being submitted and the dirty bit
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
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
---
Please apply to 7.2.y. Only 7.2 needs it, as 095be159f3eb landed there
together with the restored COW fixup code in 0680cbbf39ca. Older series
still write-protect the folio through folio_clear_dirty_for_io() in
extent_write_cache_pages() and do not need a backport.

Without it, linking a kernel with ld.lld on a compress=zstd btrfs
floods "is fixup with an empty fixup bitmap" errors and objtool then
hangs unkillable in btrfs_start_ordered_extent_nowriteback(), which
also hangs sync(2) and shutdown.

 fs/btrfs/extent_io.c | 31 +++++++++++++++++++++++++++++++
 fs/btrfs/extent_io.h |  5 +++++
 fs/btrfs/inode.c     | 23 +++++++++++++++++------
 3 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index f032f0858f40..45c4d4a3b29b 100644
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
@@ -1893,6 +1915,13 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
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
@@ -2703,6 +2732,8 @@ static int extent_write_cache_pages(struct address_space *mapping,
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
index 2534cd9284d5..39a01f9cf6b5 100644
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

