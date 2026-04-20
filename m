Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADCE277029
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Apr 2026 09:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776677521; cv=none; b=O7PJIhrW9D25w6+NB+ccUyWJcsGMA1Dvt5vrE4ZQFmnYN7fAHZdMxmYrJVI/xemNCwZRQTUwyG4sNWfY6c9xmeDhrxySIk9iSZ8WQHgzzDyy0czCX+5iyX+60zGZi8SL9AStWDeVow1w1eLI1e1EWcTYNTtDK5kNWvfcLPTR1wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776677521; c=relaxed/simple;
	bh=2AkVNhAlYnUnK0t8BwWQ9pXKkQWwX62sXumQ4xR6Gsc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BIG2LYIn5a9ObyxUCrAgMb1EiENJLtleSgADuHZDhDrmDLKzQuI8TM3QBdT5g8rxeJIqIb3TI+W4NTIsZ3HgSRg58F/fBGiYFDpnE3MnuTOrt+5C129jmlhLOIquHK0tcnHhJw2Z6AUTf7anWHj02SEzl/27OE7eFaVK+B/FTno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iwfRYolB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iwfRYolB; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iwfRYolB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iwfRYolB"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 41D375BCCF;
	Mon, 20 Apr 2026 09:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776677518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WL9Xl9qWVq0UkQb6b0598cxdO+ebC0xlUrLKis6pAHc=;
	b=iwfRYolBUuioLadP1qNxXeBOkxq3eTi5U77LaspAaRXj+IHOYy1MxNWtGd5wS+/BhLeRDk
	nLsBzRtl4xOTOFAh3guLQUiRvIdb1mqfaflUdQb7uecU7xwoxQFH4Umqs8hY7XmzfpzeQY
	h2KeVOAE69J/hQivDteQHFaqDU20L20=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776677518; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=WL9Xl9qWVq0UkQb6b0598cxdO+ebC0xlUrLKis6pAHc=;
	b=iwfRYolBUuioLadP1qNxXeBOkxq3eTi5U77LaspAaRXj+IHOYy1MxNWtGd5wS+/BhLeRDk
	nLsBzRtl4xOTOFAh3guLQUiRvIdb1mqfaflUdQb7uecU7xwoxQFH4Umqs8hY7XmzfpzeQY
	h2KeVOAE69J/hQivDteQHFaqDU20L20=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 443AE593AE;
	Mon, 20 Apr 2026 09:31:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EQFDAo3y5WnMSwAAD6G6ig
	(envelope-from <wqu@suse.com>); Mon, 20 Apr 2026 09:31:57 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH] btrfs: check and set EXTENT_DELALLOC_NEW before clearing EXTENT_DELALLOC
Date: Mon, 20 Apr 2026 19:01:39 +0930
Message-ID: <b1da8f8c929409e9dc80ab0424fb1554c30a5e7f.1776677493.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	URIBL_BLOCKED(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

[WARNING]
When running test cases with injected errors or shutdown, e.g.
generic/388 or generic/475, there is a chance that the following kernel
warning is triggered:

 BTRFS info (device dm-2): first mount of filesystem d8a19a28-3232-4809-b0df-38df83e71bff
 BTRFS info (device dm-2): using crc32c checksum algorithm
 BTRFS info (device dm-2): checking UUID tree
 BTRFS info (device dm-2): turning on async discard
 BTRFS info (device dm-2): enabling free space tree
 BTRFS critical (device dm-2 state E): emergency shutdown
 ------------[ cut here ]------------
 WARNING: extent_io.c:1742 at extent_writepage_io+0x437/0x520 [btrfs], CPU#2: kworker/u43:2/651591
 CPU: 2 UID: 0 PID: 651591 Comm: kworker/u43:2 Tainted: G        W  OE       7.0.0-rc6-custom+ #365 PREEMPT(full)  5804053f02137e627472d94b5128cc9fcb110e88
 RIP: 0010:extent_writepage_io+0x437/0x520 [btrfs]
 Call Trace:
  <TASK>
  extent_write_cache_pages+0x2a5/0x820 [btrfs 70299925d0856939e93b17d480651713b3cbba58]
  btrfs_writepages+0x74/0x130 [btrfs 70299925d0856939e93b17d480651713b3cbba58]
  do_writepages+0xd0/0x160
  __writeback_single_inode+0x42/0x340
  writeback_sb_inodes+0x22d/0x580
  wb_writeback+0xc6/0x360
  wb_workfn+0xbd/0x470
  process_one_work+0x198/0x3b0
  worker_thread+0x1c8/0x330
  kthread+0xee/0x120
  ret_from_fork+0x2a6/0x330
  ret_from_fork_asm+0x11/0x20
  </TASK>
 ---[ end trace 0000000000000000 ]---
 BTRFS error (device dm-2 state E): root 5 ino 259 folio 1323008 is marked dirty without notifying the fs
 BTRFS error (device dm-2 state E): failed to submit blocks, root=5 inode=259 folio=1323008 submit_bitmap=0: -117
 BTRFS info (device dm-2 state E): last unmount of filesystem d8a19a28-3232-4809-b0df-38df83e71bff

[CAUSE]
Inside btrfs we have the following pattern in several locations, for
example inside btrfs_dirty_folio():

	btrfs_clear_extent_bit(&inode->io_tree, start_pos, end_of_last_block,
			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
			       cached);

	ret = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
					extra_bits, cached);
	if (ret)
		return ret;

However btrfs_set_extent_delalloc() can return IO errors other than -ENOMEM
through the following callchain:

 btrfs_set_extent_delalloc()
 \- btrfs_find_new_delalloc_bytes()
    \- btrfs_get_extent()
       \- btrfs_lookup_file_extent()
          \- btrfs_search_slot()

When such IO error happened, the previous btrfs_clear_extent_bit() has
cleared the EXTENT_DELALLOC for the range, and we're expecting
btrfs_set_extent_delalloc() to re-set EXTENT_DELALLOC.

But since btrfs_set_extent_delalloc() failed before
btrfs_set_extent_bit(), EXTENT_DELALLOC flag is no longere present.

And if the folio range is dirty before entering
btrfs_set_extent_delalloc(), we got a dirty folio but no EXTENT_DELALLOC
flag now.

Then we hit the folio writeback:

 extent_writepage()
 |- writepage_delalloc()
 |  No ordered extent is created, as there is no EXTENT_DELALLOC set
 |  for the folio range.
 |  This also means the folio has no ordered flag set.
 |
 |- extent_writepage_io()
    \- if (unlikely(!folio_test_ordered(folio))
       Now we hit the warning.

[FIX]
Introduce a new helper, btrfs_reset_extent_delalloc() to replace the
currently open-coded btrfs_clear_extent_bit() +
btrfs_set_extent_delalloc() combination.

Instead of calling btrfs_clear_extent_bit() first, update
EXTENT_DELALLOC_NEW first, as that part can fail due to metadata IO,
meanwhile btrfs_clear_extent_bit() and btrfs_set_extent_bit() can really
only fail with -ENOMEM.

This allows us to fail early without clearing EXTENT_DELALLOC bit, so
even if that new btrfs_reset_extent_delalloc() failed before touching
EXTENT_DELALLOC, the existing dirty range will still have their old
EXTENT_DELALLOC flag present, thus avoid the warning.

Cc: stable@vger.kernel.org # 6.1+
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/btrfs_inode.h |  3 +++
 fs/btrfs/file.c        | 25 +++---------------
 fs/btrfs/inode.c       | 59 +++++++++++++++++++++++++++++++++++++-----
 fs/btrfs/reflink.c     |  4 +--
 4 files changed, 59 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 6e696b350dc5..ad523549d8b4 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -569,6 +569,9 @@ int btrfs_start_delalloc_roots(struct btrfs_fs_info *fs_info, long nr,
 int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
 			      struct extent_state **cached_state);
+int btrfs_reset_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
+				unsigned int extra_bits,
+				struct extent_state **cached_state);
 
 struct btrfs_new_inode_args {
 	/* Input */
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a6f641a41d99..ab536a304500 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -85,16 +85,8 @@ int btrfs_dirty_folio(struct btrfs_inode *inode, struct folio *folio, loff_t pos
 
 	end_of_last_block = start_pos + num_bytes - 1;
 
-	/*
-	 * The pages may have already been dirty, clear out old accounting so
-	 * we can set things up properly
-	 */
-	btrfs_clear_extent_bit(&inode->io_tree, start_pos, end_of_last_block,
-			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-			       cached);
-
-	ret = btrfs_set_extent_delalloc(inode, start_pos, end_of_last_block,
-					extra_bits, cached);
+	ret = btrfs_reset_extent_delalloc(inode, start_pos, end_of_last_block,
+					  extra_bits, cached);
 	if (ret)
 		return ret;
 
@@ -1952,18 +1944,7 @@ static vm_fault_t btrfs_page_mkwrite(struct vm_fault *vmf)
 		}
 	}
 
-	/*
-	 * page_mkwrite gets called when the page is firstly dirtied after it's
-	 * faulted in, but write(2) could also dirty a page and set delalloc
-	 * bits, thus in this case for space account reason, we still need to
-	 * clear any delalloc bits within this page range since we have to
-	 * reserve data&meta space before lock_page() (see above comments).
-	 */
-	btrfs_clear_extent_bit(io_tree, page_start, end,
-			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
-			       EXTENT_DEFRAG, &cached_state);
-
-	ret = btrfs_set_extent_delalloc(inode, page_start, end, 0, &cached_state);
+	ret = btrfs_reset_extent_delalloc(inode, page_start, end, 0, &cached_state);
 	if (ret < 0) {
 		btrfs_unlock_extent(io_tree, page_start, page_end, &cached_state);
 		goto out_unlock;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 71129502333a..0dc5fe7f7705 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2810,7 +2810,10 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 			      unsigned int extra_bits,
 			      struct extent_state **cached_state)
 {
-	WARN_ON(PAGE_ALIGNED(end));
+	const u32 blocksize = inode->root->fs_info->sectorsize;
+
+	ASSERT(IS_ALIGNED(start, blocksize), "start=%llu", start);
+	ASSERT(IS_ALIGNED(end + 1, blocksize), "end=%llu", end);
 
 	if (start >= i_size_read(&inode->vfs_inode) &&
 	    !(inode->flags & BTRFS_INODE_PREALLOC)) {
@@ -2833,6 +2836,53 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 				    EXTENT_DELALLOC | extra_bits, cached_state);
 }
 
+/*
+ * Clear the old accounting flags and set EXTENT_DELALLOC for the range.
+ *
+ * Return <0 for error, in that case no range has EXTENT_DELALLOC bit cleared or set.
+ */
+int btrfs_reset_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
+				unsigned int extra_bits,
+				struct extent_state **cached_state)
+{
+	const u32 blocksize = inode->root->fs_info->sectorsize;
+
+	/* The @extra_bits can only be EXTENT_NORESERVE for now. */
+	ASSERT(!(extra_bits & ~EXTENT_NORESERVE));
+
+	/* Basic alignment check. */
+	ASSERT(IS_ALIGNED(start, blocksize), "start=%llu", start);
+	ASSERT(IS_ALIGNED(end + 1, blocksize), "end=%llu", end);
+
+	/*
+	 * Check and set DELALLOC_NEW flags, this needs to search tree thus
+	 * can fail early.
+	 * Thus we want to do this before clearing DELALLOC_EXTENT.
+	 */
+	if (start >= i_size_read(&inode->vfs_inode) &&
+	    !(inode->flags & BTRFS_INODE_PREALLOC)) {
+		/*
+		 * There can't be any extents following eof in this case so just
+		 * set the delalloc new bit for the range directly.
+		 */
+		extra_bits |= EXTENT_DELALLOC_NEW;
+	} else {
+		int ret;
+
+		ret = btrfs_find_new_delalloc_bytes(inode, start,
+						    end + 1 - start,
+						    cached_state);
+		if (unlikely(ret))
+			return ret;
+	}
+	/* Clear the old accounting as the range may already be dirty. */
+	btrfs_clear_extent_bit(&inode->io_tree, start, end,
+			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING |
+			       EXTENT_DEFRAG, cached_state);
+	return btrfs_set_extent_bit(&inode->io_tree, start, end,
+				    EXTENT_DELALLOC | extra_bits, cached_state);
+}
+
 static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
 				       struct btrfs_inode *inode, u64 file_pos,
 				       struct btrfs_file_extent_item *stack_fi,
@@ -4973,12 +5023,7 @@ int btrfs_truncate_block(struct btrfs_inode *inode, u64 offset, u64 start, u64 e
 		goto again;
 	}
 
-	btrfs_clear_extent_bit(&inode->io_tree, block_start, block_end,
-			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG,
-			       &cached_state);
-
-	ret = btrfs_set_extent_delalloc(inode, block_start, block_end, 0,
-					&cached_state);
+	ret = btrfs_reset_extent_delalloc(inode, block_start, block_end, 0, &cached_state);
 	if (ret) {
 		btrfs_unlock_extent(io_tree, block_start, block_end, &cached_state);
 		goto out_unlock;
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 14742abe0f92..fb34598a77ff 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -94,9 +94,7 @@ static int copy_inline_to_page(struct btrfs_inode *inode,
 	if (ret < 0)
 		goto out_unlock;
 
-	btrfs_clear_extent_bit(&inode->io_tree, file_offset, range_end,
-			       EXTENT_DELALLOC | EXTENT_DO_ACCOUNTING | EXTENT_DEFRAG, NULL);
-	ret = btrfs_set_extent_delalloc(inode, file_offset, range_end, 0, NULL);
+	ret = btrfs_reset_extent_delalloc(inode, file_offset, range_end, 0, NULL);
 	if (ret)
 		goto out_unlock;
 
-- 
2.53.0

