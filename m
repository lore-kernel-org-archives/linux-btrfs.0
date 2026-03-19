Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246A43ACEFE
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773954327; cv=none; b=FkZg3E+qjiDcxIsiALw6zhi29WPhLkap72QObyrBzWDfBYyvjdPNvGY/GGEGj4VjCUJFBjKzjBxe2EJIAvhDTYlZYsBn4ernAXWQzv4KokWEIPQmJP8vi/Vv70cXJ2IQjuwKM5hmRfQGqf78FqzMQ1Zza5fNq4h9c6809zWuksk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773954327; c=relaxed/simple;
	bh=U19du3KLIJYCjRIU4AN9cEwTI2ib9aydEB/J3WYnFNM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7FdoPpA36HrMEjuDbjv3aorKFTz750U5mP2PfF1ssbnnXYi2u0XlMDcqV1LNcwIRSHCOjTAr3JemlWQn3mQUMqVRR6Mli7zn84xqn+ugdh4FWrTwtng5aHK987wZwl2YpdBgUojyqMo1gdzMVxfX9wBsHcydwKwAYRSVmLTFL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tAPtEvW2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tAPtEvW2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tAPtEvW2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tAPtEvW2"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8C7975BDE3
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773954314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iajAs+S2QAEE04L5KqYQJQJxj54koJhu//es3Dp66uk=;
	b=tAPtEvW2piNdyTJhS9Bf87CjR4VTlgsAS9Npv7Jr5zLuBCJyGo7oK+rrZ+1Vq/S/9Uaa5t
	Eqe9Pub4sqBkiosjosTpO5kI3omSVqpRlTFyD0LbQMUOz/KYNy778w2Mj+EsGaZ+0Qkhba
	oCI3R33pZRQ9m5fMvw3gprhqLRp59n4=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=tAPtEvW2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773954314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iajAs+S2QAEE04L5KqYQJQJxj54koJhu//es3Dp66uk=;
	b=tAPtEvW2piNdyTJhS9Bf87CjR4VTlgsAS9Npv7Jr5zLuBCJyGo7oK+rrZ+1Vq/S/9Uaa5t
	Eqe9Pub4sqBkiosjosTpO5kI3omSVqpRlTFyD0LbQMUOz/KYNy778w2Mj+EsGaZ+0Qkhba
	oCI3R33pZRQ9m5fMvw3gprhqLRp59n4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8CEBB4273B
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4N3xDgllvGk5FAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/6] btrfs: introduce the skeleton of delayed bbio endio function
Date: Fri, 20 Mar 2026 07:34:47 +1030
Message-ID: <f3db5c18b252400fda6f0af95c64cce7e25c0c11.1773953307.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773953307.git.wqu@suse.com>
References: <cover.1773953307.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Queue-Id: 8C7975BDE3
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

A delayed bbio will not be directly submitted, but queued into a
workqueue, doing the heavy lifting compression there.

The compression and uncompressed fallback are not implemented in this
patch.

Only the main endio function and helper to queue workload into a
workqueue is implemented.

The endio function is mostly the same as end_bbio_data_write(), except
the extra memory allocation/freeing for the bbio->private.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/inode.c | 68 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 64 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 799e3d5c80f3..03018cc3bd25 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -97,6 +97,12 @@ struct data_reloc_warn {
 	int mirror_num;
 };
 
+struct delayed_bio_private {
+	struct work_struct work;
+	struct btrfs_bio *delayed_bbio;
+	atomic_t pending_ios;
+};
+
 /*
  * For the file_extent_tree, we want to hold the inode lock when we lookup and
  * update the disk_i_size, but lockdep will complain because our io_tree we hold
@@ -7657,18 +7663,72 @@ struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
 	return em;
 }
 
-void btrfs_submit_delayed_write(struct btrfs_bio *bbio)
+static void run_delayed_bbio(struct work_struct *work)
 {
-	ASSERT(bbio->is_delayed);
+	struct delayed_bio_private *dbp = container_of(work, struct delayed_bio_private, work);
+	struct btrfs_bio *parent = dbp->delayed_bbio;
 
 	/*
-	 * Not yet implemented, and should not hit this path as we have no
-	 * caller to create delayed extent map.
+	 * Increase the pending_ios so that parent bbio won't end
+	 * until all child ones are submitted.
 	 */
+	atomic_inc(&dbp->pending_ios);
+	/* Compressed and uncompressed fallback is not yet implemented. */
 	ASSERT(0);
+	if (atomic_dec_and_test(&dbp->pending_ios))
+		btrfs_bio_end_io(parent, parent->status);
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
+		btrfs_folio_clear_ordered(fs_info, fi.folio, start, len);
+		btrfs_folio_clear_writeback(fs_info, fi.folio, start, len);
+	}
+	btrfs_mark_ordered_io_finished(inode, bbio->file_offset, bio_size, uptodate);
+	kfree(dbp);
 	bio_put(&bbio->bio);
 }
 
+void btrfs_submit_delayed_write(struct btrfs_bio *bbio)
+{
+	struct delayed_bio_private *dbp;
+
+	ASSERT(bbio->is_delayed);
+
+	bbio->end_io = end_bbio_delayed;
+	dbp = kzalloc(sizeof(struct delayed_bio_private), GFP_NOFS);
+	if (!dbp) {
+		btrfs_bio_end_io(bbio, errno_to_blk_status(-ENOMEM));
+		return;
+	}
+	atomic_set(&dbp->pending_ios, 0);
+	dbp->delayed_bbio = bbio;
+	bbio->private = dbp;
+	/*
+	 * TODO: find a way to properly allow sequential extent allocation.
+	 *
+	 * The existing btrfs async workqueue will execute the sequential workload
+	 * twice, the second one to free the structure.
+	 * But our current submission path can only be called once, after that
+	 * the bbio will be gone thus can not afford to use btrfs async workqueue.
+	 */
+	INIT_WORK(&dbp->work, run_delayed_bbio);
+	schedule_work(&dbp->work);
+}
+
 /*
  * For release_folio() and invalidate_folio() we have a race window where
  * folio_end_writeback() is called but the subpage spinlock is not yet released.
-- 
2.53.0

