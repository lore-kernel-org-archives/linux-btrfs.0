Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD8F29BD8C
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 05:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782366105; cv=none; b=Gnk6JUN6Zwd0z+EVSx31peX3qgp8R0FJJI8XNqVVQpbsYII8CpISjvQmGr/FmlZmwzSybs1kqfGuJIWUY5etfyTrDOq92t3bpxuVNO0OM311ajLL8v7Vbvsu0bYJFhlQge4dNGMaVao6tuTEcnhuZFdPcNr9dX+Bo58bz6yHdAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782366105; c=relaxed/simple;
	bh=D2uGgZkujgjqZ/ZO6ypSRDpOdYfAA9BdQjiSG17mLR8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q7Gw15k07e6wYDARRyU/o51gROEagl09t7Em8cZm+ojZCBFhutiJ+UpboGXGwHKZwOYG+vk1lAqDc8HwiliXm+CF5r2l+RnBhizFMScYm/fu1He25GNVsKUrPw6EozGs/rBniFvXL4ugQJwbdM/HMEms0yZeWII6JLt/dY80H6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=banBTA+M; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=banBTA+M; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="banBTA+M";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="banBTA+M"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B664B75E74;
	Thu, 25 Jun 2026 05:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782366101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=51eKUkR4CfwpsRYfb18HG6SbBAsux8zKXHyGp3bD83w=;
	b=banBTA+MInWz6u7o1Dduk+esue0FxnAwpo+MBwr7Lh8hsWdckbCcK7eFfkYSqKLpeLyB0U
	fURSguqtm2BwyF0bUdEj80si3xX6IxbQ9yipCFktKDxOciQxLi+KVhU45ENDthT4fFffEG
	7dQnOmOX1wvG8l+rchj5B7p3GLHg6Gw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782366101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=51eKUkR4CfwpsRYfb18HG6SbBAsux8zKXHyGp3bD83w=;
	b=banBTA+MInWz6u7o1Dduk+esue0FxnAwpo+MBwr7Lh8hsWdckbCcK7eFfkYSqKLpeLyB0U
	fURSguqtm2BwyF0bUdEj80si3xX6IxbQ9yipCFktKDxOciQxLi+KVhU45ENDthT4fFffEG
	7dQnOmOX1wvG8l+rchj5B7p3GLHg6Gw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6AFD5779A8;
	Thu, 25 Jun 2026 05:41:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id icneBpS/PGr/GwAAD6G6ig
	(envelope-from <wqu@suse.com>); Thu, 25 Jun 2026 05:41:40 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
Subject: [PATCH] btrfs: always wait for ordered extents to avoid OE races
Date: Thu, 25 Jun 2026 15:11:21 +0930
Message-ID: <aaabe0f2bee07800fb0490d24fab5cd162e5241d.1782366056.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TAGGED_RCPT(0.00)[ba2afde329fc27e3f22e];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[syzkaller.appspot.com:url,appspotmail.com:email,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:mid]
X-Spam-Level: 
X-Spam-Score: -2.80

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

Normally we rely on lock_and_cleanup_extent_if_needed() function during
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

And since lock_and_cleanup_extent_if_needed() can no longer turn 0, we
can also remove the branches that handles no-extent-locked cases.

Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
Fixes: ff66fe666233 ("btrfs: fix incorrect buffered IO fallback for append direct writes")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/file.c | 77 +++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 47 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index df8f6f565070..ef31140e0942 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -879,7 +879,6 @@ static noinline int prepare_one_folio(struct inode *inode, struct folio **folio_
  *
  * Return:
  * 1 - the extent is locked
- * 0 - the extent is not locked, and everything is OK
  * -EAGAIN - need to prepare the folios again
  */
 static noinline int
@@ -889,6 +888,7 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct folio *folio,
 				struct extent_state **cached_state)
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct btrfs_ordered_extent *ordered;
 	u64 start_pos;
 	u64 last_pos;
 	int ret = 0;
@@ -896,42 +896,38 @@ lock_and_cleanup_extent_if_need(struct btrfs_inode *inode, struct folio *folio,
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
+	ret = 1;
+
 	/*
 	 * We should be called after prepare_one_folio() which should have locked
 	 * all pages in the range.
@@ -1288,11 +1284,8 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
 
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
@@ -1311,17 +1304,7 @@ static int copy_one_range(struct btrfs_inode *inode, struct iov_iter *iter,
 
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

