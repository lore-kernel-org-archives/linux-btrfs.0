Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5D719D07A
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 23:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782516765; cv=none; b=CW6bBd5cASIFkaWB3UAFotkDxDuQ3/GeSHxh70TCYUY0VYWScwgNS6JcyzhMBth2chMLC4XL1C7JTVADiw7Olw6ElfWRMAJCAsR6C0+0Of/SvSer6/oTDr5x4Pv8u/eJoXkQeUnoD4xrdv4+vEDIc6fi7seJqtRAG2sl5aFXDRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782516765; c=relaxed/simple;
	bh=++piRGKeS0ns7U5gTQY8UqwfWIvjXpJwKgYuQqO9cLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NHLlPwWEQcvFRUmgVEVveZMFvQCjITv87pxXU1V8f3QTYVD7XQpf9MkJOKbqeYn9/9w9yykl4nSK7QluASKVdnk5PIy666xnEdgnRley39J7VZZvI0lq64K6xQ2dxzrsgShx+h/6lnHB886e/2UAu2lwofVhH/w8zgXn6BFMhZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DDAqQ43M; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=X/FlVhF+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DDAqQ43M";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="X/FlVhF+"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C2E1F72438;
	Fri, 26 Jun 2026 23:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782516762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mGDZj4eAweyn0IbqKZctFHwEHtCmziF+v1Iqa1dduWo=;
	b=DDAqQ43MV9qjq/DpP+s5ALLdjZ1cgt2yK5zhsWl3xGJQ0Ux16bIcebWeGMoxS5ce2UyUh2
	lzqllpauobinP1lOxZyXExtm2Z1aFTT1++RRfdQjvstmt4O/V4bftvIOQgenhz3UeRWCzC
	umip2Ffgl9rbWJkAA+ibziUQ6TRYzL8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="X/FlVhF+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782516761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mGDZj4eAweyn0IbqKZctFHwEHtCmziF+v1Iqa1dduWo=;
	b=X/FlVhF+VEcL0kqi1kKHxGTxEVHuKm2lpf1m5RS8k9QQ4uMEhq5nZCtoP/PX5uloavQS4O
	kFGFRPggSdslhZ0JmAY4xW0lfjY/IWA+ndOmMRaP7G3dKHdoAqgyum3MZQEFDw3tN1KHVV
	ZUZX9+ydnE7IEeS/oxwxpdeX4roEhU0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B474779A8;
	Fri, 26 Jun 2026 23:32:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YH8fCxgMP2pRZQAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 26 Jun 2026 23:32:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
Subject: [PATCH v2] btrfs: always wait for ordered extents to avoid OE races
Date: Sat, 27 Jun 2026 09:02:21 +0930
Message-ID: <9c7c44767a2f1b94dc46626e81e2efd9cbd67824.1782516739.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TAGGED_RCPT(0.00)[ba2afde329fc27e3f22e];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C2E1F72438
X-Spam-Score: -3.01

[BUG]
Syzbot reported a bug that there can be conflicting OEs for the same
range:

 BTRFS critical (device loop4): panic in insert_ordered_extent:264: overlapping ordered extents, existing oe file_offset 16384 num_bytes 430080 flags 0x1089, new oe file_offset 16384 num_bytes 430080 flags 0x80 (errno=-17 Object alrea[  179.162726][ T6897] BTRFS critical (device loop4): panic in insert_ordered_extent:264: overlapping ordered extents, existing oe file_offset 16384 num_bytes 430080 flags 0x1089, new oe file_offset 16384 num_bytes 430080 flags 0x80 (errno=-17 Object already exists)
 ------------[ cut here ]------------
 kernel BUG at fs/btrfs/ordered-data.c:264!
 Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/09/2026
 RIP: 0010:btrfs_alloc_ordered_extent+0x943/0xad0
 Call Trace:
  <TASK>
  cow_file_range+0x744/0x12a0
  fallback_to_cow+0x5ea/0xa00
  run_delalloc_nocow+0x110c/0x17a0
  btrfs_run_delalloc_range+0xbe4/0x1c20
  writepage_delalloc+0x104d/0x1ba0
  btrfs_writepages+0x1667/0x28b0
  do_writepages+0x338/0x560
  filemap_fdatawrite_range+0x1f2/0x300
  btrfs_fdatawrite_range+0x54/0xf0
  btrfs_direct_write+0x6a0/0xc30
  btrfs_do_write_iter+0x329/0x790
  do_iter_readv_writev+0x624/0x8d0
  vfs_writev+0x34c/0x990
  __se_sys_pwritev2+0x17a/0x2a0
  do_syscall_64+0x174/0x580
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  </TASK>
 ---[ end trace 0000000000000000 ]---

[CAUSE]
Since commit ff66fe666233 ("btrfs: fix incorrect buffered IO fallback
for append direct writes"), if the direct IO finished short, we will
revert the isize back to the original one, so that append writes can be
respected during the buffered fallback.

Normally we rely on lock_and_cleanup_extent_if_need() function during
buffered writeback to wait for any existing ordered extents.

But that ordered extent waiting only happens if the start_pos is inside
the isize.
Since we have reverted the isize during failed direct IO, we will not
wait for any ordered extents.

This means we can have a race where the direct IO OE is still in the
tree, finished but not yet removed, then we're inserting the OE for the
buffered write, causing the above crash.

[FIX]
Make the OE wait to be unconditional, to handle the reverted isize
situation.

And since lock_and_cleanup_extent_if_need() now either lock the
extents or return -EAGAIN, also remove the branches that handles
no-extent-locked cases, and rename it to remove the "_if_need" suffix.

The following micro benchmark shows the runtime difference for
btrfs_buffered_write(), doing `xfs_io -f -c "pwrite 0 1m"` workload,
all values are the average runtime in nano seconds.

      function runtime              |   before    |     after
 -----------------------------------+-------------+---------------
 lock_and_cleanup_extent_if_need()  |     58.2    |    183.0
 btrfs_buffered_write()             |   2115.6    |   2973.3

The overall runtime of btrfs_buffered_write() is still pretty
tiny (still less than 3 micro seconds), I'd say the extra cost is still
acceptable.

An alternative to fix this problem is to wait ordered extents during
iomap_end() where the isize revert is done.

But that solution will break nowait requirement, as if a nowait direct
IO finished short, we have to wait for the OEs unconditionally or the
next append buffered IO can still hit the same problem.

So here we have to move the wait cost to buffered write, but at least
the code is slightly more streamline.

Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
Fixes: ff66fe666233 ("btrfs: fix incorrect buffered IO fallback for append direct writes")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Further cleanup the handling of lock_and_cleanup_extent_if_need()
  As it no longer return without locking extents, cleanup the caller
  furthermore to remove unnecessary local variables.

- Add a micro bench mark for the performance impact

- Explain why we have to do the wait inside buffered write not
  in direct write path
---
 fs/btrfs/file.c | 104 +++++++++++++++++++-----------------------------
 1 file changed, 41 insertions(+), 63 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index df8f6f565070..62f41314df04 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -875,70 +875,64 @@ static noinline int prepare_one_folio(struct inode *inode, struct folio **folio_
 
 /*
  * Locks the extent and properly waits for data=ordered extents to finish
- * before allowing the folios to be modified if need.
+ * before allowing the folios to be modified.
  *
  * Return:
- * 1 - the extent is locked
- * 0 - the extent is not locked, and everything is OK
+ * 0 - the extent is locked
  * -EAGAIN - need to prepare the folios again
  */
 static noinline int
-lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct folio *folio,
-				loff_t pos, size_t write_bytes,
-				u64 *lockstart, u64 *lockend, bool nowait,
-				struct extent_state **cached_state)
+lock_and_cleanup_extent(struct btrfs_inode *inode, struct folio *folio,
+			loff_t pos, size_t write_bytes,
+			u64 *lockstart, u64 *lockend, bool nowait,
+			struct extent_state **cached_state)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct btrfs_ordered_extent *ordered;
 	u64 start_pos;
 	u64 last_pos;
-	int ret = 0;
 
 	start_pos = round_down(pos, fs_info->sectorsize);
 	last_pos = round_up(pos + write_bytes, fs_info->sectorsize) - 1;
 
-	if (start_pos < inode->vfs_inode.i_size) {
-		struct btrfs_ordered_extent *ordered;
-
-		if (nowait) {
-			if (!btrfs_try_lock_extent(&inode->io_tree, start_pos,
-						   last_pos, cached_state)) {
-				folio_unlock(folio);
-				folio_put(folio);
-				return -EAGAIN;
-			}
-		} else {
-			btrfs_lock_extent(&inode->io_tree, start_pos, last_pos,
-					  cached_state);
-		}
-
-		ordered = btrfs_lookup_ordered_range(inode, start_pos,
-						     last_pos - start_pos + 1);
-		if (ordered &&
-		    ordered->file_offset + ordered->num_bytes > start_pos &&
-		    ordered->file_offset <= last_pos) {
-			btrfs_unlock_extent(&inode->io_tree, start_pos, last_pos,
-					    cached_state);
+	if (nowait) {
+		if (!btrfs_try_lock_extent(&inode->io_tree, start_pos,
+					   last_pos, cached_state)) {
 			folio_unlock(folio);
 			folio_put(folio);
-			btrfs_start_ordered_extent(ordered);
-			btrfs_put_ordered_extent(ordered);
 			return -EAGAIN;
 		}
-		if (ordered)
-			btrfs_put_ordered_extent(ordered);
-
-		*lockstart = start_pos;
-		*lockend = last_pos;
-		ret = 1;
+	} else {
+		btrfs_lock_extent(&inode->io_tree, start_pos, last_pos,
+				  cached_state);
 	}
 
+	ordered = btrfs_lookup_ordered_range(inode, start_pos,
+					     last_pos - start_pos + 1);
+	if (ordered &&
+	    ordered->file_offset + ordered->num_bytes > start_pos &&
+	    ordered->file_offset <= last_pos) {
+		btrfs_unlock_extent(&inode->io_tree, start_pos, last_pos,
+				    cached_state);
+		folio_unlock(folio);
+		folio_put(folio);
+		btrfs_start_ordered_extent(ordered);
+		btrfs_put_ordered_extent(ordered);
+		return -EAGAIN;
+	}
+	if (ordered)
+		btrfs_put_ordered_extent(ordered);
+
+	*lockstart = start_pos;
+	*lockend = last_pos;
+
 	/*
 	 * We should be called after prepare_one_folio() which should have locked
 	 * all pages in the range.
 	 */
 	WARN_ON(!folio_test_locked(folio));
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -1195,7 +1189,6 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
 	const u64 reserved_start = round_down(start, fs_info->sectorsize);
 	u64 reserved_len;
 	struct folio *folio = NULL;
-	int extents_locked;
 	u64 lockstart;
 	u64 lockend;
 	bool only_release_metadata = false;
@@ -1253,18 +1246,16 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
 		reserved_len = last_block - reserved_start;
 	}
 
-	extents_locked = lock_and_cleanup_extent_if_need(inode, folio, start,
-							 write_bytes, &lockstart,
-							 &lockend, nowait,
-							 &cached_state);
-	if (extents_locked < 0) {
-		if (!nowait && extents_locked == -EAGAIN)
+	ret = lock_and_cleanup_extent(inode, folio, start, write_bytes,
+				      &lockstart, &lockend, nowait, &cached_state);
+	if (ret < 0) {
+		if (!nowait)
 			goto again;
 
 		btrfs_delalloc_release_extents(inode, reserved_len);
 		release_space(inode, *data_reserved, reserved_start, reserved_len,
 			      only_release_metadata);
-		return extents_locked;
+		return ret;
 	}
 
 	copied = copy_folio_from_iter_atomic(folio, offset_in_folio(folio, start),
@@ -1288,11 +1279,8 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
 
 		/* No copied bytes, unlock, release reserved space and exit. */
 		if (copied == 0) {
-			if (extents_locked)
-				btrfs_unlock_extent(&inode->io_tree, lockstart, lockend,
-						    &cached_state);
-			else
-				btrfs_free_extent_state(cached_state);
+			btrfs_unlock_extent(&inode->io_tree, lockstart, lockend,
+					    &cached_state);
 			btrfs_delalloc_release_extents(inode, reserved_len);
 			release_space(inode, *data_reserved, reserved_start, reserved_len,
 				      only_release_metadata);
@@ -1311,17 +1299,7 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
 
 	ret = btrfs_dirty_folio(inode, folio, start, copied, &cached_state,
 				only_release_metadata);
-	/*
-	 * If we have not locked the extent range, because the range's start
-	 * offset is >= i_size, we might still have a non-NULL cached extent
-	 * state, acquired while marking the extent range as delalloc through
-	 * btrfs_dirty_page(). Therefore free any possible cached extent state
-	 * to avoid a memory leak.
-	 */
-	if (extents_locked)
-		btrfs_unlock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
-	else
-		btrfs_free_extent_state(cached_state);
+	btrfs_unlock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
 
 	btrfs_delalloc_release_extents(inode, reserved_len);
 	if (ret) {
-- 
2.54.0

