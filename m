Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E8E34FF40
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 04:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775622367; cv=none; b=cQpdjWZBeUJ408TE/zUK3YsJOBSYhQryKKWAnInAmCaeqPnpTWlF45OiZ98pv8XdH/zCNGUpunSd6mrwCoPxGIW4a2wrdIsJdEZLpbU4UQct/2kjq1baoQduC96LsFMXAFVa9aN2mc60OyP773BE5FNxzycd7ruoY8hGAlT1c44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775622367; c=relaxed/simple;
	bh=Zk4GSclIs/9lavlMJ41o7maNmg2S7Q+J2NMsnO6SDLI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYoklgM839wS57Qt3gl4IzqOYy94TSMzBqkaWtK4D2Fr9Zs5gOpVgCw2rtywqjtE9NpmlFBmvihF93uwqJvctXZZwmnAXwXsFTl6FOL6mAH0A7n6NcvmgXbfC8Qc7gOc22kj6Ss7DR3V+6HIQn3SpovDnYQF+t3C9/EZOs1uxao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dpHyn2mr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dpHyn2mr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dpHyn2mr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dpHyn2mr"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 413ED5BD46
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 04:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775622354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gJtVv02YbexbidUMAdI5yq4LQoj5veuBFhcrW33+gaU=;
	b=dpHyn2mrdIKaGtAE/uRLIw1zy7hC8oVvw52knoGN6kxxKhcqOd4COR7rwSk5QrHbbQokVs
	QERLyOnCMrTo6GI8YFbAeTbTFCPlRRocd1HaSiMPdTt1D++WU15sRAvjBbFr4X8S3GW3dG
	fnIiAJL6XR5b8mmS1dgiOTlA8eBTCCg=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775622354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gJtVv02YbexbidUMAdI5yq4LQoj5veuBFhcrW33+gaU=;
	b=dpHyn2mrdIKaGtAE/uRLIw1zy7hC8oVvw52knoGN6kxxKhcqOd4COR7rwSk5QrHbbQokVs
	QERLyOnCMrTo6GI8YFbAeTbTFCPlRRocd1HaSiMPdTt1D++WU15sRAvjBbFr4X8S3GW3dG
	fnIiAJL6XR5b8mmS1dgiOTlA8eBTCCg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2FD1A4A0B4
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 04:25:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WNLoMtDY1WklUAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2026 04:25:52 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: remove the COW fixup mechanism
Date: Wed,  8 Apr 2026 13:55:31 +0930
Message-ID: <c3f440e920f5a82ed5f4dbd839c9a8843d971043.1775621833.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775621833.git.wqu@suse.com>
References: <cover.1775621833.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

[BACKGROUND]
Btrfs has a special mechanism called COW fixup, which detects dirty
pages without an ordered extent (folio ordered flag).

Normally a dirty folio must go through delayed allocation (delalloc)
before it can be submitted, and delalloc will create an ordered extent
for it and mark the range with ordered flag.

However in older kernels, there are bugs related to get_user_pages()
which can lead to some page marked dirty but without notifying the fs to
properly prepare them for writeback.

In that case without an ordered extent btrfs is unable to properly
submit such dirty folios, thus the COW fixup mechanism is introduced,
which do the extra space reservation so that they can be written back
properly.

[MODERN SOLUTIONS]
The MM layer has solved it properly now with the introduction of
pin_user_pages*(), so we're handling cases that are no longer valid.

So commit 7ca3e84980ef ("btrfs: reject out-of-band dirty folios during
writeback") is introduced to change the behavior from going through
COW fixup to rejecting them directly for experimental builds.

So far it works fine, but when errors are injected into the IO path, we
have random failures triggering the new warnings.

It looks like we have error path that cleared the ordered flag but
leaves the folio dirty flag, which later triggers the warning.

[REMOVAL OF COW FIXUP]
Although I hope to fix all those known warnings cases, I just can not
figure out the root cause yet.

But on the other hand, if we remove the ordered and checked flags in the
future, and purely rely on the dirty flags and ordered extent search, we
can get a much cleaner handling.

Considering it's no longer hitting the COW fixup for normal IO paths, I
think it's finally the time to remove the COW fixup completely.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 201 ++++-------------------------------------------
 1 file changed, 14 insertions(+), 187 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 808e52aa6ef2..2119c957aa47 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2833,206 +2833,33 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
 				    EXTENT_DELALLOC | extra_bits, cached_state);
 }
 
-/* see btrfs_writepage_start_hook for details on why this is required */
-struct btrfs_writepage_fixup {
-	struct folio *folio;
-	struct btrfs_inode *inode;
-	struct btrfs_work work;
-};
-
-static void btrfs_writepage_fixup_worker(struct btrfs_work *work)
-{
-	struct btrfs_writepage_fixup *fixup =
-		container_of(work, struct btrfs_writepage_fixup, work);
-	struct btrfs_ordered_extent *ordered;
-	struct extent_state *cached_state = NULL;
-	struct extent_changeset *data_reserved = NULL;
-	struct folio *folio = fixup->folio;
-	struct btrfs_inode *inode = fixup->inode;
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	u64 page_start = folio_pos(folio);
-	u64 page_end = folio_next_pos(folio) - 1;
-	int ret = 0;
-	bool free_delalloc_space = true;
-
-	/*
-	 * This is similar to page_mkwrite, we need to reserve the space before
-	 * we take the folio lock.
-	 */
-	ret = btrfs_delalloc_reserve_space(inode, &data_reserved, page_start,
-					   folio_size(folio));
-again:
-	folio_lock(folio);
-
-	/*
-	 * Before we queued this fixup, we took a reference on the folio.
-	 * folio->mapping may go NULL, but it shouldn't be moved to a different
-	 * address space.
-	 */
-	if (!folio->mapping || !folio_test_dirty(folio) ||
-	    !folio_test_checked(folio)) {
-		/*
-		 * Unfortunately this is a little tricky, either
-		 *
-		 * 1) We got here and our folio had already been dealt with and
-		 *    we reserved our space, thus ret == 0, so we need to just
-		 *    drop our space reservation and bail.  This can happen the
-		 *    first time we come into the fixup worker, or could happen
-		 *    while waiting for the ordered extent.
-		 * 2) Our folio was already dealt with, but we happened to get an
-		 *    ENOSPC above from the btrfs_delalloc_reserve_space.  In
-		 *    this case we obviously don't have anything to release, but
-		 *    because the folio was already dealt with we don't want to
-		 *    mark the folio with an error, so make sure we're resetting
-		 *    ret to 0.  This is why we have this check _before_ the ret
-		 *    check, because we do not want to have a surprise ENOSPC
-		 *    when the folio was already properly dealt with.
-		 */
-		if (!ret) {
-			btrfs_delalloc_release_extents(inode, folio_size(folio));
-			btrfs_delalloc_release_space(inode, data_reserved,
-						     page_start, folio_size(folio),
-						     true);
-		}
-		ret = 0;
-		goto out_page;
-	}
-
-	/*
-	 * We can't mess with the folio state unless it is locked, so now that
-	 * it is locked bail if we failed to make our space reservation.
-	 */
-	if (ret)
-		goto out_page;
-
-	btrfs_lock_extent(&inode->io_tree, page_start, page_end, &cached_state);
-
-	/* already ordered? We're done */
-	if (folio_test_ordered(folio))
-		goto out_reserved;
-
-	ordered = btrfs_lookup_ordered_range(inode, page_start, PAGE_SIZE);
-	if (ordered) {
-		btrfs_unlock_extent(&inode->io_tree, page_start, page_end,
-				    &cached_state);
-		folio_unlock(folio);
-		btrfs_start_ordered_extent(ordered);
-		btrfs_put_ordered_extent(ordered);
-		goto again;
-	}
-
-	ret = btrfs_set_extent_delalloc(inode, page_start, page_end, 0,
-					&cached_state);
-	if (ret)
-		goto out_reserved;
-
-	/*
-	 * Everything went as planned, we're now the owner of a dirty page with
-	 * delayed allocation bits set and space reserved for our COW
-	 * destination.
-	 *
-	 * The page was dirty when we started, nothing should have cleaned it.
-	 */
-	BUG_ON(!folio_test_dirty(folio));
-	free_delalloc_space = false;
-out_reserved:
-	btrfs_delalloc_release_extents(inode, PAGE_SIZE);
-	if (free_delalloc_space)
-		btrfs_delalloc_release_space(inode, data_reserved, page_start,
-					     PAGE_SIZE, true);
-	btrfs_unlock_extent(&inode->io_tree, page_start, page_end, &cached_state);
-out_page:
-	if (ret) {
-		/*
-		 * We hit ENOSPC or other errors.  Update the mapping and page
-		 * to reflect the errors and clean the page.
-		 */
-		mapping_set_error(folio->mapping, ret);
-		btrfs_folio_clear_ordered(fs_info, folio, page_start,
-					  folio_size(folio));
-		btrfs_mark_ordered_io_finished(inode, page_start,
-					       folio_size(folio), !ret);
-		folio_clear_dirty_for_io(folio);
-	}
-	btrfs_folio_clear_checked(fs_info, folio, page_start, PAGE_SIZE);
-	folio_unlock(folio);
-	folio_put(folio);
-	kfree(fixup);
-	extent_changeset_free(data_reserved);
-	/*
-	 * As a precaution, do a delayed iput in case it would be the last iput
-	 * that could need flushing space. Recursing back to fixup worker would
-	 * deadlock.
-	 */
-	btrfs_add_delayed_iput(inode);
-}
-
 /*
- * There are a few paths in the higher layers of the kernel that directly
- * set the folio dirty bit without asking the filesystem if it is a
- * good idea.  This causes problems because we want to make sure COW
- * properly happens and the data=ordered rules are followed.
+ * There used to be a bug related get user space where a page can be dirtied
+ * without notifying the filesystem.
  *
- * In our case any range that doesn't have the ORDERED bit set
- * hasn't been properly setup for IO.  We kick off an async process
- * to fix it up.  The async helper will wait for ordered extents, set
- * the delalloc bit and make it safe to write the folio.
+ * Btrfs used to handle such corner case by manually re-setup the needed flags
+ * so we can later submit them for writeback.
+ *
+ * But nowadays this can only happen at some error paths that we cleared the
+ * ordered flag without clearing the dirty flag.
+ * In that case we just error out.
  */
 int btrfs_writepage_cow_fixup(struct folio *folio)
 {
 	struct inode *inode = folio->mapping->host;
 	struct btrfs_fs_info *fs_info = inode_to_fs_info(inode);
-	struct btrfs_writepage_fixup *fixup;
 
 	/* This folio has ordered extent covering it already */
 	if (folio_test_ordered(folio))
 		return 0;
 
-	/*
-	 * For experimental build, we error out instead of EAGAIN.
-	 *
-	 * We should not hit such out-of-band dirty folios anymore.
-	 */
-	if (IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL)) {
-		DEBUG_WARN();
-		btrfs_err_rl(fs_info,
+	DEBUG_WARN();
+	btrfs_err_rl(fs_info,
 	"root %lld ino %llu folio %llu is marked dirty without notifying the fs",
-			     btrfs_root_id(BTRFS_I(inode)->root),
-			     btrfs_ino(BTRFS_I(inode)),
-			     folio_pos(folio));
-		return -EUCLEAN;
-	}
-
-	/*
-	 * folio_checked is set below when we create a fixup worker for this
-	 * folio, don't try to create another one if we're already
-	 * folio_test_checked.
-	 *
-	 * The extent_io writepage code will redirty the foio if we send back
-	 * EAGAIN.
-	 */
-	if (folio_test_checked(folio))
-		return -EAGAIN;
-
-	fixup = kzalloc_obj(*fixup, GFP_NOFS);
-	if (!fixup)
-		return -EAGAIN;
-
-	/*
-	 * We are already holding a reference to this inode from
-	 * write_cache_pages.  We need to hold it because the space reservation
-	 * takes place outside of the folio lock, and we can't trust
-	 * folio->mapping outside of the folio lock.
-	 */
-	ihold(inode);
-	btrfs_folio_set_checked(fs_info, folio, folio_pos(folio), folio_size(folio));
-	folio_get(folio);
-	btrfs_init_work(&fixup->work, btrfs_writepage_fixup_worker, NULL);
-	fixup->folio = folio;
-	fixup->inode = BTRFS_I(inode);
-	btrfs_queue_work(fs_info->fixup_workers, &fixup->work);
-
-	return -EAGAIN;
+		     btrfs_root_id(BTRFS_I(inode)->root),
+		     btrfs_ino(BTRFS_I(inode)),
+		     folio_pos(folio));
+	return -EUCLEAN;
 }
 
 static int insert_reserved_file_extent(struct btrfs_trans_handle *trans,
-- 
2.53.0

