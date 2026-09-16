Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3804545FFCD
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 07:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789545278; cv=none; b=hxU6fH5VNtlbGAgfG6RBFwZupQ3prkMS9PgSOO+vJcVVVykM5YkN2bpcpBSgBRbqAGWkBzNiW+l74Vb721RdDekTtIJq6XE60tauFs6Bjlrv0VK2F/e6fZGjhq4Cg2pOSmBDk0m8qOw7bQdpdcVEdq6M8VOM2C0NfWE+WKhL1vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789545278; c=relaxed/simple;
	bh=pRVQlJdE1Lzy1f9FOX8Ewi7VUHj/mDNZBt42ejFONcQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSMI7dr0QscJkc0FuVfaLlHVurAYbRrUmtA5mrwr6zM0iv6JNvMupqGaiVFd9pBNis2Ksc5/GtcKFptiGzVdRnVuap1JHlvauvdLVkWN+rn+zYeyWZSLjId4kFZVu5DQz/3acie47wSableLrvhcvGFsailwirYRifRDvPDmf2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tOadcfQC; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=duHYOZ45; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tOadcfQC";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="duHYOZ45"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E037121BF6
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 07:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789545257; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3fqqVc6BB1hG/p1xc90SlmNDNK3n3+Ci5RhxzacYUtk=;
	b=tOadcfQCDlkvQr076pf4p+P1N1R1frRWVJDVAk+OVcc8QgU2aH/GV7BSI/oho104Jn9fM5
	8He1RdMJJpqgU0apb1CXR7Z1QP457ANaNnkBVfTRAz2d1XupKMAprtcBqrS3tcKWVj35xH
	dnscT6eVYsLwCY0eiTmAezaD6zM+QXg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789545252; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3fqqVc6BB1hG/p1xc90SlmNDNK3n3+Ci5RhxzacYUtk=;
	b=duHYOZ45e/8Yuhy8FTMACHBbJxEGPrGTEd549hhQGeBwwbQelBPe5Z2jX+ym3CZhvwqoO9
	DJiVMfljmL4y0mxh0QitsSQ08+CfAuYEhWIu7GqGnT5S1ISS3mBTpLGaYiBNwy4umSurgD
	NPzaS6BG1IuiMEbEfhej5devxfJEqxs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A2A6A1373A
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 07:54:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 31W+Dh5LqmqMKgAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 07:54:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/6] btrfs: introduce the skeleton of delayed bbio endio function
Date: Wed, 16 Sep 2026 17:23:45 +0930
Message-ID: <bd4c6b7b2f65957a5d8473c4c9b5710a1093cd90.1789545179.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789545179.git.wqu@suse.com>
References: <cover.1789545179.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

A delayed bbio will not be directly submitted, but queued into a
workqueue, to perform compression there.

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
 fs/btrfs/inode.c | 77 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 72 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 69e12cb2d7b5..10b9a7fcfadf 100644
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
@@ -7691,18 +7696,80 @@ struct extent_map *btrfs_create_delayed_em(struct btrfs_inode *inode,
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
+	struct delayed_bio_private *dbp;
+
+	ASSERT(bbio->is_delayed);
+
+	bbio->end_io = end_bbio_delayed;
+	dbp = kzalloc_obj(*dbp);
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
+	schedule_work(&dbp->work);
+}
+
 /*
  * For release_folio() and invalidate_folio() we have a race window where
  * folio_end_writeback() is called but the subpage spinlock is not yet released.
-- 
2.55.0

