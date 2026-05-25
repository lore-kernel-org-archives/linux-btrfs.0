Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2241933EF
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 05:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779685557; cv=none; b=T9t3/uqh8njlP8XkKywKkXdbpZgsAgAOaBfO8eBR+nWVwezETQhiXLZ6dfkdacdtYHyNm1kqZtoaWuZJc9JK6ulHxpL2aCzo2pja6GDr3QP/XXO9rDosRxWxLVX/fx/HvIgXixCU1IDwg2UmkCgl/Jy2oW89ixnT58jgcdpX66M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779685557; c=relaxed/simple;
	bh=XxHQh9TJuHtpE3sxCNQFzL7HOC/Lxj5MhYCqfyu0b9I=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ucPPq3OmfC9bosqLY9Rn/gtpaD5JDDKZli+3jwQhRsUiANjEEjMpe7F+P+usXoUPiPw+HWZBgcKwaG/6Sbbn+NgEK79xNnBhe1DFFNENOTWpk3KFzVvo4ns6KwH5whvPeQVL8vnxaLXT2Z6u8Nk4tQeQrlsQIU2guCXcXuvpUg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=R8i5KHGW; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=eG9wvC2f; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="R8i5KHGW";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="eG9wvC2f"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 18B776891E
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 05:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779685554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gVXKAp1bgMqjtfR+eslI/SYpSykUTeq6rKgMlNYyFEo=;
	b=R8i5KHGWaxeWntK5jpS518BjoqbV/nJiHq8js3dUQe45SE1i3UZ8VhppPnyBwQlNESb+2+
	2Dd8QthX4gxOZxE5Ehb8W9KJwm6sGPgcSFjU83/an/3hIJm9VfAHXvFxcPA9r3xnyn080t
	LOHFrn/oRaskNjIeuJwRZa+kuaXLBjE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=eG9wvC2f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779685552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=gVXKAp1bgMqjtfR+eslI/SYpSykUTeq6rKgMlNYyFEo=;
	b=eG9wvC2fsNnS+tIprQ3PvJAqWLCtz2p+vQovPxViLmO9U5gwdAPy7/saerw02ZrGuYMTZV
	44PwItooXLJHDSMrA9BYOpRY32wJp9d507ui8fRuJbrzUJqL9P2NAHxxhizmEVOUHUqEHa
	Rw+1uwXqGhgaAUcum/UiyWFYIZK4hwI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 55E6C59A85
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 05:05:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uh96Bq/YE2r6EQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 05:05:51 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling back to buffered IO
Date: Mon, 25 May 2026 14:35:33 +0930
Message-ID: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 18B776891E
X-Rspamd-Action: no action
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	internal_greylist_whitelist(0.00)[2a07:de40:b281:104:10:150:64:97];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

Previously btrfs forces direct writes to fall back to buffered ones if the
inode has data checksum or the profile has duplication.

That fallback is to avoid the content being modified that the final
content may mismatch with the checksum or the other mirrors.

That brings a pretty huge performance cost, which already caused some
concern at that time.

But later upstream commit c9d114846b38 ("iomap: add a flag to bounce
buffer direct I/O") introduced a new method by copying the content into
new pages, and do all the operations based on the newly allocated pages.

So let btrfs to utilize the new flag for direct writes if we require
stable folios.

There is a quick benchmark, using the following fio setup:

 fio --name=randwrite --filename $mnt/foobar --ioengine=libaio --size=4G \
     --rw=randwrite --iodepth=64 --runtime=60 --time_based --direct=1 \
     --bs=$blocksize

Unit is MiB/s.

 Blocksize | Zero-copy (*) | Buffered |   Bounce
-----------+---------------+----------+-----------
        4K |          35.1 |     17.1 |      33.8
       64K |           522 |      251 |       492

*: This is done by reverting the commit 968f19c5b1b7 ("btrfs: always
   fallback to buffered write if the inode requires checksum")

Although with page bouncing the performance is only around 95% of
true-zero copy, it's still almost double the performance of buffered
fallback.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Rework the comment in btrfs_dio_write()
---
 fs/btrfs/direct-io.c | 45 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 29 deletions(-)

diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 57167d56dc72..173fe065fc38 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -768,10 +768,25 @@ static ssize_t btrfs_dio_read(struct kiocb *iocb, struct iov_iter *iter,
 static struct iomap_dio *btrfs_dio_write(struct kiocb *iocb, struct iov_iter *iter,
 					 size_t done_before)
 {
+	struct btrfs_inode *inode = BTRFS_I(file_inode(iocb->ki_filp));
 	struct btrfs_dio_data data = { 0 };
+	const u64 data_profile = btrfs_data_alloc_profile(inode->root->fs_info) &
+				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
+	unsigned int dio_flags = IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED;
+
+	/*
+	 * Userspace may modify the buffer while DIO is in flight. With
+	 * data checksumming this would produce a checksum that doesn't
+	 * match the persisted data; with duplicated profiles the mirrors
+	 * would diverge. Bounce in those cases so writeback sees stable
+	 * content.
+	 */
+	if (!(inode->flags & BTRFS_INODE_NODATASUM) ||
+	    (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0))
+		dio_flags |= IOMAP_DIO_BOUNCE;
 
 	return __iomap_dio_rw(iocb, iter, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			    IOMAP_DIO_PARTIAL | IOMAP_DIO_FSBLOCK_ALIGNED, &data, done_before);
+			      dio_flags, &data, done_before);
 }
 
 static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
@@ -800,8 +815,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t ret;
 	unsigned int ilock_flags = 0;
 	struct iomap_dio *dio;
-	const u64 data_profile = btrfs_data_alloc_profile(fs_info) &
-				 BTRFS_BLOCK_GROUP_PROFILE_MASK;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
@@ -815,16 +828,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	if (iocb->ki_pos + iov_iter_count(from) <= i_size_read(inode) && IS_NOSEC(inode))
 		ilock_flags |= BTRFS_ILOCK_SHARED;
 
-	/*
-	 * If our data profile has duplication (either extra mirrors or RAID56),
-	 * we can not trust the direct IO buffer, the content may change during
-	 * writeback and cause different contents written to different mirrors.
-	 *
-	 * Thus only RAID0 and SINGLE can go true zero-copy direct IO.
-	 */
-	if (data_profile != BTRFS_BLOCK_GROUP_RAID0 && data_profile != 0)
-		goto buffered;
-
 relock:
 	ret = btrfs_inode_lock(BTRFS_I(inode), ilock_flags);
 	if (ret < 0)
@@ -865,22 +868,6 @@ ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
 		goto buffered;
 	}
-	/*
-	 * We can't control the folios being passed in, applications can write
-	 * to them while a direct IO write is in progress.  This means the
-	 * content might change after we calculated the data checksum.
-	 * Therefore we can end up storing a checksum that doesn't match the
-	 * persisted data.
-	 *
-	 * To be extra safe and avoid false data checksum mismatch, if the
-	 * inode requires data checksum, just fallback to buffered IO.
-	 * For buffered IO we have full control of page cache and can ensure
-	 * no one is modifying the content during writeback.
-	 */
-	if (!(BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)) {
-		btrfs_inode_unlock(BTRFS_I(inode), ilock_flags);
-		goto buffered;
-	}
 
 	/*
 	 * The iov_iter can be mapped to the same file range we are writing to.
-- 
2.54.0

