Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793840903;
	b=ki6KnQCO7AlR+PKJIlk9VNVnujyY9pND7BWBIck26jfqpU/mU5R+pTZlrv+3Zu8XZSg3
	 Nu8fOYEEJopqWgsRF998Jrxofx7pGGyVMBQMokeZycKB01AHFPga/34/AAntrDbNyFS9W
	 SnE/xhKsYtA0BSSbM56X/YeZn+SmnzNuvY5y0sU4j4R6qRTXEKP8v+H0oW7YS5EvKp2xd
	 f1n6q9a29Lx8FmnyFe+G8lLQ4cSxAN8hlq8fuN+HH4AZq5ybJ4e0iIlU29ppZ1Ybw0AOD
	 nglEe6++3BPF74i7EsjLcn04s1fmoJl1U4rXp7SejVRp0gO93X5aXLinnWh9U/iPewA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793840903;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=mTSkPe18QvH7XL+zKIJ/C+Qg3eEW4lZHyf7vtEjqP00=;
	b=USNWIackg+9RwhJIxPSG2LGv0D8cm4YTbNZ1Igsv4BF6A4ypq3ko+PoWfuHoJ92Yn/6k
	 GXgF6MTKDowNraYqUhnYDDY3fR49sw+yUPd3TBrfnlrb18o9q31upDX82AOkXztp3YaqZ
	 9q7A+LnJ3P661N7kW3NAPpWbD83kq0rZ51vw13gz9yt+cCxLVjzoLfc8pqWbo1B4A2VX9
	 UN9btYxKExoNLBOzNvSOA73lwFsSazBtJwkCZqiPu8dbvE7xR5nZIRzKojukvu7zyMrp3
	 ohQv1xmK1abh5Qj/sN3zobctnyy6i1L1sWNcDvLAawdtDcJLhTVod4diryDDo4fNONQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OSHzvTlm;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OSHzvTlm;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E52606A31B
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 01:08:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73E52606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OSHzvTlm;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=OSHzvTlm
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9EDC621F87;
	Thu,  5 Nov 2026 01:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793840900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mTSkPe18QvH7XL+zKIJ/C+Qg3eEW4lZHyf7vtEjqP00=;
	b=OSHzvTlmGjLXnaBoFDS9kpVQRanKh3coKNEkIEcEqwua3m7Fc/mQ3+lGR/pwd1MV35QxXN
	gsIz4DdJPVp+ARkC1FVrCHfaMiKSo5SmzLdCDrlrGjYjf17pCQGPjYLA2AhYmPyjzOBh/e
	SLeD7ax+MUCqBCVhghVqZf4oH0xxbF0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793840900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mTSkPe18QvH7XL+zKIJ/C+Qg3eEW4lZHyf7vtEjqP00=;
	b=OSHzvTlmGjLXnaBoFDS9kpVQRanKh3coKNEkIEcEqwua3m7Fc/mQ3+lGR/pwd1MV35QxXN
	gsIz4DdJPVp+ARkC1FVrCHfaMiKSo5SmzLdCDrlrGjYjf17pCQGPjYLA2AhYmPyjzOBh/e
	SLeD7ax+MUCqBCVhghVqZf4oH0xxbF0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27CC01350A;
	Thu,  5 Nov 2026 01:08:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cNZnHQLX62r/dwAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 05 Nov 2026 01:08:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Breno Leitao <leitao@debian.org>
Subject: [PATCH] btrfs: fix a race between reflink and compressed writes
Date: Thu,  5 Nov 2026 11:38:00 +1030
Message-ID: <38f007be87d8d8889912b9be373460e32741b9b5.1793840873.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

[BUG]
There is a bug report with a reproduce that can lead to transaction
abort. The reproducer requires either large folios or page size larger
than block size and compression:

 BTRFS info (device dm-2): use zstd compression, level 3
 ------------[ cut here ]------------
 WARNING: fs/btrfs/extent_map.c:443 at btrfs_unpin_extent_cache+0x12a/0x1a0 [btrfs], CPU#0: kworker/u41:1/1073
 CPU: 0 UID: 0 PID: 1073 Comm: kworker/u41:1 Tainted: G        W   E       7.3.0-rc7-custom+ #111 PREEMPT(full)  181cfbec4e757bdd6c595e90a917484279074a92
 Workqueue: btrfs-endio-write btrfs_work_helper [btrfs]
 RIP: 0010:btrfs_unpin_extent_cache+0x12a/0x1a0 [btrfs]
 Call Trace:
  <TASK>
  btrfs_finish_one_ordered+0x8f9/0xce0 [btrfs 78b39de6ff5f8aabf4d2477512804f86456deeca]
  btrfs_work_helper+0xc5/0x3a0 [btrfs 78b39de6ff5f8aabf4d2477512804f86456deeca]
  process_scheduled_works+0x20b/0x480
  worker_thread+0x1f7/0x2f0
  kthread+0x101/0x130
  ret_from_fork+0xd9/0x250
  ret_from_fork_asm+0x11/0x20
  </TASK>
 ---[ end trace 0000000000000000 ]---
 BTRFS warning (device dm-2): found extent map for inode 257 (root 5) with unexpected start offset 8192 when unpinning extent range [4096, 12288), generation 12
 ------------[ cut here ]------------
 WARNING: fs/btrfs/inode.c:3321 at btrfs_finish_one_ordered+0xc4b/0xce0 [btrfs], CPU#0: kworker/u41:1/1073
 CPU: 0 UID: 0 PID: 1073 Comm: kworker/u41:1 Tainted: G        W   E       7.3.0-rc7-custom+ #111 PREEMPT(full)  181cfbec4e757bdd6c595e90a917484279074a92
 Workqueue: btrfs-endio-write btrfs_work_helper [btrfs]
 RIP: 0010:btrfs_finish_one_ordered+0xc4b/0xce0 [btrfs]
 Call Trace:
  <TASK>
  btrfs_work_helper+0xc5/0x3a0 [btrfs 78b39de6ff5f8aabf4d2477512804f86456deeca]
  process_scheduled_works+0x20b/0x480
  worker_thread+0x1f7/0x2f0
  kthread+0x101/0x130
  ret_from_fork+0xd9/0x250
  ret_from_fork_asm+0x11/0x20
  </TASK>
 ---[ end trace 0000000000000000 ]---
 BTRFS error (device dm-2 state A): Transaction 12 aborted (-EUCLEAN)
 BTRFS: error (device dm-2 state A) in btrfs_finish_one_ordered:3321: errno=-117 Filesystem corrupted

[CAUSE]

There is a race between compressed write and regular write inside the
same folio, that can lead to incorrect PAGECACHE_TAG_DIRTY tag to be
cleared too early.

In this example, we have a large folio containing 8 pages (4K page size,
4K block size), with the following layout:

  0        8K        16K        24K        32K
      |//////////|          |///|

Where [4K, 12K) is dirty, and [20K, 24K) is also dirty.

        Writeback                 |        Compression worker
----------------------------------+------------------------------------
writepage_delalloc()              |
|- run_delalloc_compressed()      |
|  |  Queueing [4K, 12K) for      |
|  |  compression.                |
|  \- btrfs_queue_work()          |
|                                 | compress_file_range()
|                                 | |- extent_range_clear_dirty_for_io()
|                                 |    \- btrfs_folio_clamp_clear_dirty()
|                                 |       Now range [4K, 12K) is no longer
|                                 |       dirty, but also without an OE.
\- run_delalloc_cow()             |
   |  For the [20K, 24K)          |
   \- submit_one_sector()         |
      |- btrfs_folio_clear_dirty()|
      |  Since [20K, 24K) is the  |
      |  last dirty block, the    |
      |  folio is no longer dirty |
      |                           |
      |- btrfs_folio_set_writeback()
         Since the folio is no    |
	 longer dirty, the        |
	 PAGECACHE_TAG_DIRTY tag  |
	 is also cleared.         |

The above race will lead to a 32K folio that contains [4K, 12K) range
that is still under compression (and should still be counted dirty), but
without an OE.

Then later in the reflink:

        Reflink                   |        Compression worker
----------------------------------+------------------------------------
btrfs_clone_files()               |
|  Which is to replace [4K, 8K)   |
|                                 |
|- btrfs_wait_ordered_range()     |
|  |- btrfs_fdatawrite_range()    |
|  |  Nothing to do, since no     |
|  |  DIRTY tag for the folio     |
|  |                              |
|  |- filemap_fdatawait_range()   |
|  |  The [20K, 24K) finished,    |
|  |  So no WRITEBACK tag         |
|  |                              |
|  \- lookup OE                   |
|     No OE is created for range  |
|     [4K, 12K)                   |
|                                 |
|                                 | submit_compressed_extents
|                                 | \- submit_one_async_extent
|                                 |    \- btrfs_alloc_ordered_extent()
|                                 |       OE for [4K, 12K) created, but
|                                 |       it's too late.
\- btrfs_clone()                  |
   Replace file extents for range |
   [4K, 8K), which will conflict  |
   with the new compressed range  |
   [4K, 12K)                      |
                                  | end_bbio_data_write([4k, 12K))
				  | \- btrfs_finish_ordered()
				  |
				  |
				  | finish_ordered_fn()
				  | \- btrfs_finish_one_ordered()
                                  |    \- btrfs_unpin_extent_cache()
                                  |       em start 8K != 4K
                                          return -EUCLEAN, transaction aborted

[FIX]
Do not clear the folio dirty early during compress_file_range().

The early clearing is done through extent_range_clear_dirty_for_io(), so
remove the folio dirty clearing completely from it.

And since what's left is only checking the folio write protection,
rename the function to extent_range_check_write_protected() instead, and
slightly clean it up, so it doesn't need to return an int.

Finally since the range is still dirty now, all run_delalloc_cow()
callers pass @pages_dirty = true, we can remove that parameter along other
involved functions.

Fixes: 1d2fbb7f1f9e ("btrfs: allow compression even if the range is not page aligned")
Reported-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/linux-btrfs/ause7k_HjzUWT3D-@gmail.com/
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c |  5 ++---
 fs/btrfs/extent_io.h |  3 +--
 fs/btrfs/inode.c     | 42 ++++++++++++------------------------------
 3 files changed, 15 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a221b63bdb20..a143592c20d4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2904,8 +2904,7 @@ static int extent_write_cache_pages(struct address_space *mapping,
  * locked.
  */
 void extent_write_locked_range(struct inode *inode, const struct folio *locked_folio,
-			       u64 start, u64 end, struct writeback_control *wbc,
-			       bool pages_dirty)
+			       u64 start, u64 end, struct writeback_control *wbc)
 {
 	bool found_error = false;
 	int ret = 0;
@@ -2948,7 +2947,7 @@ void extent_write_locked_range(struct inode *inode, const struct folio *locked_f
 		cur_len = cur_end + 1 - cur;
 
 		ASSERT(folio_test_locked(folio));
-		if (pages_dirty && folio != locked_folio)
+		if (folio != locked_folio)
 			ASSERT(folio_test_dirty(folio));
 
 		/*
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d8dd2ae9ff9a..c55b37cb24b7 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -280,8 +280,7 @@ void btrfs_check_folio_write_protected(struct folio *folio);
 static inline void btrfs_check_folio_write_protected(struct folio *folio) { }
 #endif
 void extent_write_locked_range(struct inode *inode, const struct folio *locked_folio,
-			       u64 start, u64 end, struct writeback_control *wbc,
-			       bool pages_dirty);
+			       u64 start, u64 end, struct writeback_control *wbc);
 int btrfs_writepages(struct address_space *mapping, struct writeback_control *wbc);
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc);
 void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start, u64 end);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b6ea1f713b7e..91186c0cd6af 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -120,8 +120,7 @@ static int btrfs_truncate(struct btrfs_inode *inode, bool skip_writeback);
 
 static noinline int run_delalloc_cow(struct btrfs_inode *inode,
 				     struct folio *locked_folio, u64 start,
-				     u64 end, struct writeback_control *wbc,
-				     bool pages_dirty);
+				     u64 end, struct writeback_control *wbc);
 
 static int data_reloc_print_warning_inode(u64 inum, u64 offset, u64 num_bytes,
 					  u64 root, void *warn_ctx)
@@ -773,33 +772,27 @@ static inline void inode_should_defrag(struct btrfs_inode *inode,
 		btrfs_add_inode_defrag(inode, small_write);
 }
 
-static int extent_range_clear_dirty_for_io(struct btrfs_inode *inode, u64 start, u64 end)
+static void extent_range_check_write_protected(struct btrfs_inode *inode, u64 start, u64 end)
 {
 	pgoff_t index = start >> PAGE_SHIFT;
 	const pgoff_t end_index = end >> PAGE_SHIFT;
 	struct folio *folio;
-	int ret = 0;
+
+	if (!IS_ENABLED(CONFIG_BTRFS_DEBUG))
+		return;
 
 	while (index <= end_index) {
 		folio = filemap_get_folio(inode->vfs_inode.i_mapping, index);
+		/* Compression should have all involved folios still locked. */
 		if (IS_ERR(folio)) {
-			if (!ret)
-				ret = PTR_ERR(folio);
+			ASSERT(0, "missing a folio inside the compression range");
 			index++;
 			continue;
 		}
-		/*
-		 * We are about to compress the folio, so it must not be mmap
-		 * writeable or we could corrupt the data as we attempt to
-		 * compress it.
-		 */
 		btrfs_check_folio_write_protected(folio);
-		btrfs_folio_clamp_clear_dirty(inode->root->fs_info, folio, start,
-					      end + 1 - start);
 		index = folio_next_index(folio);
 		folio_put(folio);
 	}
-	return ret;
 }
 
 static struct folio *compressed_bio_last_folio(struct compressed_bio *cb)
@@ -886,16 +879,7 @@ static void compress_file_range(struct btrfs_work *work)
 
 	inode_should_defrag(inode, start, end, end - start + 1, SZ_16K);
 
-	ret = extent_range_clear_dirty_for_io(inode, start, end);
-
-	/*
-	 * All the folios should have been locked thus no failure.
-	 *
-	 * And even if some folios are missing, btrfs_compress_bio()
-	 * would handle them correctly, so here just do an ASSERT() check for
-	 * early logic errors.
-	 */
-	ASSERT(ret == 0);
+	extent_range_check_write_protected(inode, start, end);
 
 	/*
 	 * We need to save i_size before now because it could change in between
@@ -1011,8 +995,7 @@ static void submit_uncompressed_range(struct btrfs_inode *inode,
 	};
 
 	wbc_attach_fdatawrite_inode(&wbc, &inode->vfs_inode);
-	ret = run_delalloc_cow(inode, locked_folio, start, end,
-			       &wbc, false);
+	ret = run_delalloc_cow(inode, locked_folio, start, end, &wbc);
 	wbc_detach_inode(&wbc);
 	if (ret < 0) {
 		if (locked_folio)
@@ -1657,8 +1640,7 @@ static bool run_delalloc_compressed(struct btrfs_inode *inode,
  */
 static noinline int run_delalloc_cow(struct btrfs_inode *inode,
 				     struct folio *locked_folio, u64 start,
-				     u64 end, struct writeback_control *wbc,
-				     bool pages_dirty)
+				     u64 end, struct writeback_control *wbc)
 {
 	u64 done_offset = end;
 	int ret;
@@ -1669,7 +1651,7 @@ static noinline int run_delalloc_cow(struct btrfs_inode *inode,
 		if (ret)
 			return ret;
 		extent_write_locked_range(&inode->vfs_inode, locked_folio,
-					  start, done_offset, wbc, pages_dirty);
+					  start, done_offset, wbc);
 		start = done_offset + 1;
 	}
 
@@ -2436,7 +2418,7 @@ int btrfs_run_delalloc_range(struct btrfs_inode *inode, struct folio *locked_fol
 		return 1;
 
 	if (zoned)
-		return run_delalloc_cow(inode, locked_folio, start, end, wbc, true);
+		return run_delalloc_cow(inode, locked_folio, start, end, wbc);
 	else
 		return cow_file_range(inode, locked_folio, start, end, NULL, 0);
 }
-- 
2.56.0

