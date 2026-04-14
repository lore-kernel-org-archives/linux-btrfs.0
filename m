Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F8D1F92E
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776129430; cv=none; b=LIsxwZa57arASKs7zvLvnL/PbrKAQAhz2CrvzZsd+vG6oT4P49vPiAbyttUpr3hEOnqCBMJW0HZ5DfKjCiPp7eQl1ZoOTPxgpl3r9y9O6IT3ClPQ4zYdTUCU69NxBlC93nJSSM/5+Y09GC/fTD/a0BdhEDWV0jRCqHe0JV16Z7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776129430; c=relaxed/simple;
	bh=lFRzHtU5lHeqbbSaUTVZayCgKVeKP9hHlKj7kfvc+YI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNKxOaGP7PTAVcRpJi4PgaHZ1kmRwZDUD0VfVFgVxNWVS0BCQzbHHZwGZKoP090bk1SXcOVvuVjmECWMq9MjnhAlf7R8hWonzqSZeYVUh3SH2AmeXzsYthCKZVHB/d2f20iGk9BF4spzdAQpIzhxBwwaqD3IMG8SUJA68XzFVko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r+id8v4D; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=r+id8v4D; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r+id8v4D";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="r+id8v4D"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CCCFF5BE00
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776129421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=07TGWHiBZMlWHOaQYc+IbGIz41TKImcnDJm7MEo2fO4=;
	b=r+id8v4DZeBtqkE8hD/GjCE31w4RYv/lz15XhKEoEHYzdYRMn9OljQbFhya/Qxe9dDZuKR
	4cnJxioA0OJqF/LVPmfQhj7bxagSS4S71h8kFnmKkXT+M4CrY7UyujJCdaiyk5o7Dc6XgB
	qYkv4xUrYY184wMUSevzjG/2zh++hik=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=r+id8v4D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1776129421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=07TGWHiBZMlWHOaQYc+IbGIz41TKImcnDJm7MEo2fO4=;
	b=r+id8v4DZeBtqkE8hD/GjCE31w4RYv/lz15XhKEoEHYzdYRMn9OljQbFhya/Qxe9dDZuKR
	4cnJxioA0OJqF/LVPmfQhj7bxagSS4S71h8kFnmKkXT+M4CrY7UyujJCdaiyk5o7Dc6XgB
	qYkv4xUrYY184wMUSevzjG/2zh++hik=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 169FA4B1A3
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:17:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cEbVMoyV3WmEbgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 01:17:00 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/2] btrfs: remove the COW fixup mechanism
Date: Tue, 14 Apr 2026 10:46:41 +0930
Message-ID: <5f9c367ba3f2c32972d0bc2844858bfb1fd47061.1776129347.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776129347.git.wqu@suse.com>
References: <cover.1776129347.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Rspamd-Queue-Id: CCCFF5BE00
X-Spam-Flag: NO
X-Spam-Score: -3.01
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
 fs/btrfs/Kconfig     |   4 -
 fs/btrfs/disk-io.c   |  16 +---
 fs/btrfs/extent_io.c |  12 +--
 fs/btrfs/fs.h        |   7 --
 fs/btrfs/inode.c     | 202 ++++---------------------------------------
 5 files changed, 17 insertions(+), 224 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 5e75438e0b73..5d785d010971 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -93,10 +93,6 @@ config BTRFS_EXPERIMENTAL
 
 	  Current list:
 
-	  - COW fixup worker warning - last warning before removing the
-				       functionality catching out-of-band page
-				       dirtying, not necessary since 5.8
-
 	  - RAID mirror read policy - additional read policies for balancing
 				      reading from redundant block group
 				      profiles (currently: pid, round-robin,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d450bfc6d89b..761362f4ab9f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1736,7 +1736,6 @@ static int read_backup_root(struct btrfs_fs_info *fs_info, u8 priority)
 /* helper to cleanup workers */
 static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 {
-	btrfs_destroy_workqueue(fs_info->fixup_workers);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
 	btrfs_destroy_workqueue(fs_info->workers);
 	if (fs_info->endio_workers)
@@ -1944,9 +1943,6 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	fs_info->caching_workers =
 		btrfs_alloc_workqueue(fs_info, "cache", flags, max_active, 0);
 
-	fs_info->fixup_workers =
-		btrfs_alloc_ordered_workqueue(fs_info, "fixup", ordered_flags);
-
 	fs_info->endio_workers =
 		alloc_workqueue("btrfs-endio", flags, max_active);
 	fs_info->endio_meta_workers =
@@ -1972,7 +1968,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	      fs_info->endio_workers && fs_info->endio_meta_workers &&
 	      fs_info->endio_write_workers &&
 	      fs_info->endio_freespace_worker && fs_info->rmw_workers &&
-	      fs_info->caching_workers && fs_info->fixup_workers &&
+	      fs_info->caching_workers &&
 	      fs_info->delayed_workers && fs_info->qgroup_rescan_workers &&
 	      fs_info->discard_ctl.discard_workers)) {
 		return -ENOMEM;
@@ -4327,16 +4323,6 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	if (unlikely(BTRFS_FS_ERROR(fs_info)))
 		btrfs_error_commit_super(fs_info);
 
-	/*
-	 * Wait for any fixup workers to complete.
-	 * If we don't wait for them here and they are still running by the time
-	 * we call kthread_stop() against the cleaner kthread further below, we
-	 * get an use-after-free on the cleaner because the fixup worker adds an
-	 * inode to the list of delayed iputs and then attempts to wakeup the
-	 * cleaner kthread, which was already stopped and destroyed. We parked
-	 * already the cleaner, but below we run all pending delayed iputs.
-	 */
-	btrfs_flush_workqueue(fs_info->fixup_workers);
 	/*
 	 * Similar case here, we have to wait for delalloc workers before we
 	 * proceed below and stop the cleaner kthread, otherwise we trigger a
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a8887285deda..862ef3c8886e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1739,12 +1739,6 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	       start, len, folio_start, folio_size(folio));
 
 	ret = btrfs_writepage_cow_fixup(folio);
-	if (ret == -EAGAIN) {
-		/* Fixup worker will requeue */
-		folio_redirty_for_writepage(bio_ctrl->wbc, folio);
-		folio_unlock(folio);
-		return 1;
-	}
 	if (ret < 0) {
 		btrfs_folio_clear_dirty(fs_info, folio, start, len);
 		btrfs_folio_set_writeback(fs_info, folio, start, len);
@@ -1867,12 +1861,8 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 	 *
 	 * So here we check if the page has private set to rule out such
 	 * case.
-	 * But we also have a long history of relying on the COW fixup,
-	 * so here we only enable this check for experimental builds until
-	 * we're sure it's safe.
 	 */
-	if (IS_ENABLED(CONFIG_BTRFS_EXPERIMENTAL) &&
-	    unlikely(!folio_test_private(folio))) {
+	if (unlikely(!folio_test_private(folio))) {
 		WARN_ON(IS_ENABLED(CONFIG_BTRFS_DEBUG));
 		btrfs_err_rl(fs_info,
 	"root %lld ino %llu folio %llu is marked dirty without notifying the fs",
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index a4758d94b32e..5ccc907327a8 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -697,13 +697,6 @@ struct btrfs_fs_info {
 	struct btrfs_workqueue *endio_write_workers;
 	struct btrfs_workqueue *endio_freespace_worker;
 	struct btrfs_workqueue *caching_workers;
-
-	/*
-	 * Fixup workers take dirty pages that didn't properly go through the
-	 * cow mechanism and make them safe to write.  It happens for the
-	 * sys_munmap function call path.
-	 */
-	struct btrfs_workqueue *fixup_workers;
 	struct btrfs_workqueue *delayed_workers;
 
 	struct task_struct *transaction_kthread;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 808e52aa6ef2..29a624a2c611 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -2833,206 +2833,34 @@ int btrfs_set_extent_delalloc(struct btrfs_inode *inode, u64 start, u64 end,
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
+ * There used to be a bug related to get_user_page*() where a page can be
+ * dirtied without notifying the filesystem.
  *
- * In our case any range that doesn't have the ORDERED bit set
- * hasn't been properly setup for IO.  We kick off an async process
- * to fix it up.  The async helper will wait for ordered extents, set
- * the delalloc bit and make it safe to write the folio.
+ * Btrfs used to handle such cases by manually re-setup the needed flags/states
+ * so we can later submit them for writeback.
+ *
+ * But nowadays MM layer has address that problem, and we can only hit dirty
+ * folios without the ordered flag when some error handling is done incorrectly,
+ * e.g. cleared the ordered flag but didn't clear the dirty flag.
+ * In that case we just error out and treat it as an write error.
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

