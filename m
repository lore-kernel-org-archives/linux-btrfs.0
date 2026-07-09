Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40C32701D9
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 04:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783571497; cv=none; b=Y99ZV3KN+Sq+GTSiuFD6ehQT+IWZ51GJTJHBF1SO1URx6IJIc0Ohon+f+pwb6nguQPe1vo9fRIpnT54+3XtzQZyFkDwvHqKETN9kz86pW/ldSvNqyAMVhocHqTJB2MDQDNkwWf2YT1+7I1rUgG/ZEhuD0tN5QYgPystWPGslFu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783571497; c=relaxed/simple;
	bh=e6EagM/+57DsvcarqTLpdH2RvfoHJ2/aMKaVzQffcfo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dg/NfoIGnzsqUIROFWi2rncoZgO0l7Jfn9dQBvmbqlERtlozSbOu55n5K8CU+EkjznIIXeKZUIObSMHi5CE1T+x3HO9y4WXcJbWYYEVpcvSkDdwGt5yJ3vLBkrcQpw01SmbptctnC6BoedxQqzf4dMTLyGFTQL1p7ZXdvBZd63g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=JeoVJUxm; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=QkNIV28a; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="JeoVJUxm";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="QkNIV28a"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id E2E071D00085;
	Thu,  9 Jul 2026 00:31:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 09 Jul 2026 00:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1783571494; x=1783657894; bh=HklfvVqmMn0Gh+9K8dcJV
	z3TlkQ6/SQsmZjmXfyYdmc=; b=JeoVJUxm0MfZgIg+izI3FuMKDsvrxjEtlO6EU
	gzn/msw6BsqWhwo3GSFEBCzbBncYduGa90bm2lwRSxXeUjhDVYQN3fm9LPOi+owb
	eCxHtA0GD12rHbyCvG8vxWKJoyng5uZpyk7yOqA30FDBSN9766JK6JW4B7Tbh0b0
	GJ0X3GP0NchK9okONXrjcRczv5CGy7GppsYiKfNth9XF6vO2LqwwYsw1I3r9Aq2Y
	93cFpkGEIksWoVGk4WeLycQFnsWpPReomLVrd3dGEljQvFea7g/w5ln/RnUTd/9G
	ygAiCCrZiAmlDAq2rpvgF2bvmFL1obRyVhuPfy7THj0yQa9HQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1783571494; x=1783657894; bh=HklfvVqmMn0Gh+9K8dcJVz3TlkQ6/SQsmZj
	mXfyYdmc=; b=QkNIV28ah9Q7TRiMfu3+Vjh/UwF5IfrVnZmgL4ShRQmq+BsQg+t
	oxkSRe4v7G+tsA8yyuWED+UFRg88H9goOxhgY6EKbT+HKXs4PihPwP95/3hYlHPH
	FWRCWge1KO4URETHaO3xpGWv9G96axuADn6LKbJfbDMkuOYEXc0qr6f3wR1jW0MZ
	GvXL4oWeYyRxAmiATd2CIILO+S3zx3iIl0yTqT+T6hQ22ZnejMRmiAnUPAXcxNGg
	7MsS2Mez1VhG8NMzXBot5fewCsjvwI7huy0ve6CQ79qPolnhDOGJAYH6HBbC/Nis
	Ocw6dUH8D/6+lA/2q3/58pOU+uKkxKJfskw==
X-ME-Sender: <xms:JiRPaqVlmk-kYYnaBp8eIJ1R_cm79WFtvXkrcUZhdeCrWcS8ETUKjg>
    <xme:JiRPauB8_ReOoEF-xCLa4z3ufmw63IZUxVbdCC9TalADRRUXeDfeSplJMvWw8eKRK
    rq-SrdQd0SQnolttINQCEwhVxMI7owZvbnC6LkwKSO5sALKwCwc3Us>
X-ME-Received: <xmr:JiRParxzHYhePZYweIAYC5h-eUcVmfUxE2IF9epD346grzknGqcqvt34Og17TtaoPm5sRgqHc6CtGIZeaH8s3b-YOzg>
X-ME-Proxy-Cause: dmFkZTEoH5iWRPSVy2F9gMjNp4XsXHAy5+VQ7GbFKfkmEP1hob5dwgg1oGzUPYM5NZfawE
    84iZIfrwZFxApzLd6rWEe+dQ+zPWljytiIvZAkKxpKZUlyOvTk32ShSHP1lZhW0kW+tOnb
    Kf6D8vNvL8+WhPyIXExXyDWOZq0ebaKssZFw0umJA0nD6UUViJvX3foElmZM4cgubcT3qm
    WY+UbMBikBIo+h/NJphJTLtH6y+omOKL7USIJgoiqFZTtGdModgk/63uK1/6Iz34U1P1TS
    71rsqZD0Vwb5PMoJ5LSh8D/fnRbf43cj2Wg2/A5plryzujlqEd0gf9h0TmR6jKsi+rxRhz
    3KsLYVL00am4rkjeHNv5qWf/l7jmtur0/U8NA5QxYDi8AiqM6NGyNerxSTHaOgD9kzDX5P
    AHMKIplgQmDZvkG44+pFZWBjUxwxQKqpEOJJL8iD6m1s7C0WRkl/ij8ki3zVqKsDezG1zz
    jbrtXsF8uz2HLo7qGaI0ddknBop88Q89CSF9sz9p+7JW1CSJHjFQVLMLTf3ALE7i3ebHv8
    S8DUWJ7ub384rrldIC4YNVfdrA73D3jVtgUbPzZzoWTMGoFf8pKNCGfo+yQ2lGQGcXa2A3
    q2UQnN+wwK/4g7kaSq/MgzvnAsVHfFvauBJE7szy7SVUx45HPLqc6phF1DfA
X-ME-Proxy: <xmx:JiRParCynwzaWZRzFQ-1dsn-wwGnkayk_-0nC9fyT1OCBkYUb2OQkA>
    <xmx:JiRPaoawKp9AT1exTkYz9LX82PRI41bOijRq0sranz-IoZM0_NMQDw>
    <xmx:JiRPajgO3xnJ7ZmGzpjSMrYl3CbNYXi_zSpAfIA3AvGsHFweBz_Cfg>
    <xmx:JiRPaq5nMoQaVPdfvcqKlfnWcIVi-qicX4uB5TZHtUqSWi62jcq3fw>
    <xmx:JiRPavjFymHv41MHBpmbUdF4M4P9uvB2HQjHq9_Gv73p5c8zwykndVnP>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 00:31:33 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Cc: willy@infradead.org
Subject: [PATCH] btrfs: write-protect folios during data writeback
Date: Wed,  8 Jul 2026 21:31:48 -0700
Message-ID: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 095be159f3eb ("btrfs: unify folio dirty flag clearing") replaced
the folio_clear_dirty_for_io() call in extent_write_cache_pages() with a
plain folio_test_dirty() check. Besides clearing the dirty flag,
folio_clear_dirty_for_io() also calls folio_mkclean(), which write-protects
the shared mmap PTEs mapping the folio.

Without the write-protection, a process with the file mmap'd can modify
a sector while it is being used by writeback in a way that expects a
stable folio (checksumming, compressing, copying, etc...) which
manifests as a handful of concrete bugs.

For large folios or subpage sectorsize, this will result in an invalid
checksum and later corruption reports on read (if sectorsize ==
folio_size() then we will always be in the case where we call
folio_mkclean() when we clear the dirty on the sector, which is the
whole folio).

For zoned submissions which are done in batch separate from the main
extent_writepage() loop, we also risk csum violations for those
submissions.

For inline extents this will subtly risk losing writes that happen
after/while we copy the inline extent but before we clear dirty on
the folio.

For folios spanning EOF, mmap could tamper with the zeroed bytes past
EOF and cause them to be persisted where future faults would impoperly
see them instead of zeros.

Finally, for compressed extents, we risk modifying the folios while we
work on compressing them which will result in corrupted compressed data.
This particular gap was introduced by a second patch in the same series:
Commit a4ef54dbb576 ("btrfs: make extent_range_clear_dirty_for_io() to handle sector size < page size cases")

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

