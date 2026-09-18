Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FB0357D0A
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 00:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692282; cv=none; b=c1WpsE3yWNQaZK2G9KSyuzjjKGTw3ZL7YgKVcKNjJAq8Le62cmB36h1L9upwxwbad1UTxy9qhKhMJ0CXRuhvQasb+5hcks596DaSg502Uz4vAmg1eWGwfy4IOWt6NB41nWBO1Rw5WkSqJQ9k4zSjn7E6rOR4N+GSnYkTGgkLm6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692282; c=relaxed/simple;
	bh=fkxDK/agN0SSyH2oOIQ6NQ8KDwTae3S4UAgurZ5sASM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Df6sFfaZcftzSTobRIo+Jc50n9e5pPRzSwe8p4w1FDCzp4kKMEJg1Gb9vY80oDZArzOX1iocBggbCtCMRGEnVnwXBkcmqfwIw/1GTstwHq6wiMEIExVArEk7t+jpFmv7tRH5FzLIeebst7QEbpebrtr2ftJzc1xPVfi8xzON2RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=clT2M0AW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iCHFVold; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="clT2M0AW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iCHFVold"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C06EE1FFEA
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 00:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789692274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y3jLt9YwzZpKGh/erBh1Elv42pcaBXfADfuBjKro+ys=;
	b=clT2M0AW+IPN2YZlNwdDd8mng5QffB7VCTo2YUZ6HHyR++RELzosQTRIIvMk6K7dxKnHf6
	UKWhe5B41BFfvMM88h5uRYRKgvQxhEEY8sLKsuutzk9Hk+SJIGbJ0UN4KPBITNP8kb667y
	XN1XoDX4sQJgEgHsSbjoPTq+zWfTZi0=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789692269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y3jLt9YwzZpKGh/erBh1Elv42pcaBXfADfuBjKro+ys=;
	b=iCHFVolda18gEIcodF9phrAZJRJPlY+1wOLJnNDK0VcNGsMrvwwh7kiekVNRyvttfYBhWN
	XHJxgXtD3qgUfumRmNX/d/bzVX3ScFzAXC4QVJw2vVhX/XPn2CpeYRDvhLSWY35XYH5bFG
	ddutp0VH5YnHUFJ7zNytC+0TnXThABw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CD7913888
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 00:44:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8Z0mA2eJrGovEwAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Sep 2026 00:44:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 RESEND 3/6] btrfs: introduce the skeleton of delayed bbio endio function
Date: Fri, 18 Sep 2026 10:14:02 +0930
Message-ID: <1de09905a5581ab755d30f64fb8055aaa1c90b60.1789692182.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789692182.git.wqu@suse.com>
References: <cover.1789692182.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

A delayed bbio will not be directly submitted, but queued into a
workqueue, to perform compression there.

There is also a new workqueue, delayed_write_workers, for this workload.
It will eventually replace the existing delallow_workers.

The compression and uncompressed fallback are not implemented in this
patch.

Only the main endio function and a helper to queue workload into a
workqueue are implemented.

The endio function is mostly the same as end_bbio_data_write(), except
for the extra memory allocation/freeing for the bbio->private.

Another point to note is that, we reuse btrfs_bio::pending_ios to track
the lifespan of the parent delayed bbio.
We can reuse it because the delayed bbio is never submitted for IO, thus
it will never be split by btrfs, so we can reuse that atomic to avoid
extra space inside delayed_bio_private.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c |  8 +++--
 fs/btrfs/fs.h      |  5 +++
 fs/btrfs/inode.c   | 78 +++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 84 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a8535e309b57..64eaa7698be2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1774,6 +1774,8 @@ static void btrfs_stop_all_workers(struct btrfs_fs_info *fs_info)
 	if (fs_info->fixup_workers)
 		destroy_workqueue(fs_info->fixup_workers);
 	btrfs_destroy_workqueue(fs_info->delalloc_workers);
+	if (fs_info->delayed_write_workers)
+		destroy_workqueue(fs_info->delayed_write_workers);
 	btrfs_destroy_workqueue(fs_info->workers);
 	if (fs_info->endio_workers)
 		destroy_workqueue(fs_info->endio_workers);
@@ -1972,7 +1974,8 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	fs_info->delalloc_workers =
 		btrfs_alloc_workqueue(fs_info, "delalloc",
 				      flags, max_active, 2);
-
+	fs_info->delayed_write_workers =
+		alloc_workqueue("btrfs-delayed-write", flags, max_active);
 	fs_info->flush_workers =
 		btrfs_alloc_workqueue(fs_info, "flush_delalloc",
 				      flags, max_active, 0);
@@ -2003,7 +2006,7 @@ static int btrfs_init_workqueues(struct btrfs_fs_info *fs_info)
 	fs_info->discard_ctl.discard_workers =
 		alloc_ordered_workqueue("btrfs-discard", WQ_FREEZABLE);
 
-	if (!(fs_info->workers &&
+	if (!(fs_info->workers && fs_info->delayed_write_workers &&
 	      fs_info->delalloc_workers && fs_info->flush_workers &&
 	      fs_info->endio_workers && fs_info->endio_meta_workers &&
 	      fs_info->endio_write_workers &&
@@ -4436,6 +4439,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	 * when we call kthread_stop().
 	 */
 	btrfs_flush_workqueue(fs_info->delalloc_workers);
+	flush_workqueue(fs_info->delayed_write_workers);
 
 	/*
 	 * We can have ordered extents getting their last reference dropped from
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 3eba8438593c..72e3ef1de423 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -707,6 +707,11 @@ struct btrfs_fs_info {
 	 */
 	struct btrfs_workqueue *workers;
 	struct btrfs_workqueue *delalloc_workers;
+	/*
+	 * This is for delayed writes, for now only compressed writes
+	 * on non-zoned experimental builds utilize this.
+	 */
+	struct workqueue_struct *delayed_write_workers;
 	struct btrfs_workqueue *flush_workers;
 	struct workqueue_struct *endio_workers;
 	struct workqueue_struct *endio_meta_workers;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9d20af32eb2e..9568118e65b4 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -97,6 +97,11 @@ struct data_reloc_warn {
 	int mirror_num;
 };
 
+struct delayed_bio_private {
+	struct work_struct work;
+	struct btrfs_bio *delayed_bbio;
+};
+
 /*
  * For the file_extent_tree, we want to hold the inode lock when we lookup and
  * update the disk_i_size, but lockdep will complain because our io_tree we hold
@@ -7707,18 +7712,81 @@ struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
 	return em;
 }
 
-void btrfs_submit_delayed_write(struct btrfs_bio *bbio)
+static void run_delayed_bbio(struct work_struct *work)
 {
-	ASSERT(bbio->is_delayed);
+	struct delayed_bio_private *dbp = container_of(work, struct delayed_bio_private, work);
+	struct btrfs_bio *parent = dbp->delayed_bbio;
+
+	/* Compressed and uncompressed fallback is not yet implemented. */
+	ASSERT(0);
 
 	/*
-	 * Not yet implemented, and should not hit this path as we have no
-	 * caller to create delayed extent map.
+	 * Any real compressed/uncompressed bios have increased
+	 * parent->pending_ios, the last caller of btrfs_bio_end_io()
+	 * will execute the real endio function.
 	 */
-	ASSERT(0);
+	btrfs_bio_end_io(parent, BLK_STS_OK);
+}
+
+static void end_bbio_delayed(struct btrfs_bio *bbio)
+{
+	struct delayed_bio_private *dbp = bbio->private;
+	struct btrfs_inode *inode = bbio->inode;
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct folio_iter fi;
+	const u32 bio_size = bio_get_size(&bbio->bio);
+	const bool uptodate = bbio->status == BLK_STS_OK;
+
+	ASSERT(bbio->is_delayed);
+
+	bio_for_each_folio_all(fi, &bbio->bio) {
+		u64 start = folio_pos(fi.folio) + fi.offset;
+		u32 len = fi.length;
+
+		btrfs_folio_clear_writeback(fs_info, fi.folio, start, len);
+	}
+	btrfs_mark_ordered_io_finished(inode, bbio->file_offset, bio_size, uptodate);
+	kfree(dbp);
 	bio_put(&bbio->bio);
 }
 
+void btrfs_submit_delayed_write(struct btrfs_bio *bbio)
+{
+	const struct btrfs_fs_info *fs_info = bbio->inode->root->fs_info;
+	struct delayed_bio_private *dbp;
+
+	ASSERT(bbio->is_delayed);
+
+	bbio->end_io = end_bbio_delayed;
+	dbp = kzalloc_obj(*dbp, GFP_NOFS);
+	if (!dbp) {
+		btrfs_bio_end_io(bbio, errno_to_blk_status(-ENOMEM));
+		return;
+	}
+	dbp->delayed_bbio = bbio;
+	bbio->private = dbp;
+	/*
+	 * TODO: find a way to properly allow sequential extent allocation.
+	 *
+	 * Currently compression and submission happen in the same workload.
+	 * We want to run compression in parallel but run allocation sequentially.
+	 *
+	 * The existing btrfs workqueue will execute the sequential workload
+	 * twice, the second one to free the structure, thus the btrfs_work
+	 * structure can have a lifespan longer than the delayed bbio.
+	 *
+	 * But the current structure's lifespan is bounded to the original
+	 * bbio, if using btrfs workqueue, we need extra lifespan management
+	 * to ensure the work structure doesn't disappear when the original
+	 * bbio is finished.
+	 *
+	 * This means we have to either delay the original bbio's finish,
+	 * or have a very complex synchronization.
+	 */
+	INIT_WORK(&dbp->work, run_delayed_bbio);
+	queue_work(fs_info->delayed_write_workers, &dbp->work);
+}
+
 /*
  * For release_folio() and invalidate_folio() we have a race window where
  * folio_end_writeback() is called but the subpage spinlock is not yet released.
-- 
2.55.0

