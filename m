Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794300137;
	b=Zk9VY6esEt7YZFELnzAUQohmrZPmqgCnwsyxyUR6mfhdFMvPeOASZDIpyqXrQdZmptYM
	 OQweNdf/o1l529VBajgMIjgjSjq0NIi9os73v+VFVHGbAFP1ePHBFhedRvtryMhqIDFlR
	 H6lO5TO2GfuzubVuuZHnsPTPWNW6nLEDRBqrFbapuQ1jus6pStDmnQe7+2GPjLyoOltwx
	 dbDnoGC4oXg1uqft1jSKZwbLqu0YEL5L96ABgjTRNUXhbx6fDL2Qj2tKv8ohx5woh2BrQ
	 oL+hPB0YX2IVlyU+6pHxitiCtVWVFNngIpkbniu0Yr7+SlZhG0OoNPQx7sqJoIkx/FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794300137;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=taShu/fHcVI0vHZKByzl7kgth2lhnSLlY1j56cP1WAs=;
	b=YxvWaErKDKXqXcVb8xMa+w00HOyPRaT4H+sGOQlMf3+NrHZucEkHu7db9L1ctxVNZhn6
	 7zWLoRdKMd35BEvuAbxRMkcVv5vu92TvPdotz1G/7yzNjZ1T+TumF00meyuyu/93Mtca6
	 IHQ3Y1m5XkzOieEG5QiTBdL1hRhcutVxzDgTy/pP3FjZHQpfVG238FZUgFuF3o6UrSpxT
	 PaJdzBkYknBzVKG2G59oqhlTxiQGpwOB1ZjrbkLba9A79ZeS6kxm2aO2aVVGzEfpM7GGM
	 7Xin7BXVTgMxzB9KosmIPRJZNvYihafNUpn/MsXov6qBB2dpr9xGdl4oOgO7fC5VnbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=qR7yRsM6;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=qR7yRsM6;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505C4606A332
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 08:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 505C4606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=qR7yRsM6;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=qR7yRsM6
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AF44520127
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 08:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794300133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=taShu/fHcVI0vHZKByzl7kgth2lhnSLlY1j56cP1WAs=;
	b=qR7yRsM6Fk20gur2gTvAzGAz8IQreKMyZCwWJHi220qP+z0qPmWJ222mU+TcPpx7OV3mqp
	zbFBVrNXAB3HjhTOlSrFzLW9D1X0XB74eswVwqBuKVFR3lJjrzx2ki/op4FulJnVMRwN0c
	vUFmzaJ7pR5nn8ox+3Bbyb3foa3VJxA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=qR7yRsM6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794300133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=taShu/fHcVI0vHZKByzl7kgth2lhnSLlY1j56cP1WAs=;
	b=qR7yRsM6Fk20gur2gTvAzGAz8IQreKMyZCwWJHi220qP+z0qPmWJ222mU+TcPpx7OV3mqp
	zbFBVrNXAB3HjhTOlSrFzLW9D1X0XB74eswVwqBuKVFR3lJjrzx2ki/op4FulJnVMRwN0c
	vUFmzaJ7pR5nn8ox+3Bbyb3foa3VJxA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8B6E513479
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 08:42:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6b/+NeLY8mr/PQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 08:42:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: set write error flags before clearing writeback on failed buffered writes
Date: Tue, 10 Nov 2026 19:11:44 +1030
Message-ID: <93ad6002c98614b7a35c87b2792bce8dadb1e6b2.1794300081.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: AF44520127
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

[BUG]
After commit f13e01b89daf ("btrfs: ensure fast fsync waits for ordered
extents after a write failure"), a failed COW write sets the inode's
BTRFS_INODE_COW_WRITE_ERROR flag.

That flag makes the next fast fsync wait for ordered extents to complete,
so that it never logs the failed extents.

However for buffered writes the flag can be set too late, and a fast
fsync can still log file extent items for the failed write.

[CAUSE]
In end_bbio_data_write() the folios' writeback is cleared before the error
is recorded:

 CPU0 (endio, failed buffered bio)  CPU1 (fast fsync)
 end_bbio_data_write()
 |-btrfs_folio_clear_writeback()
 | ^^^ wakes up the fsync           btrfs_sync_file()
 |                                  |-filemap_fdatawait_range()
 |                                  | ^^^ Returns after the writeback
 |                                  | finished
 |                                  |
 |                                  |-test_and_clear_bit(COW_WRITE_ERROR)
 |                                  | ^^^ Still 0, skips
 |                                  |     btrfs_wait_ordered_range()
 |                                  |
 |                                  \-btrfs_log_changed_extents()
 |                                    ^^^ logs the extent maps of the
 |                                        failed ordered extent
 |-mapping_set_error()
 \-btrfs_finish_ordered_extent()
   \-set_bit(COW_WRITE_ERROR)
     ^^^ Too late.

A power loss after the log tree is persisted makes log replay point the
file to blocks that didn't receive its data.

The mapping error is recorded late too, so the fsync can miss it as well.

[FIX]
Record the error before anything a fast fsync can wait for.

Introduce btrfs_ordered_extent_io_failed(), which marks the ordered
extent with BTRFS_ORDERED_IOERR, sets the mapping error and sets
BTRFS_INODE_COW_WRITE_ERROR for COW ordered extents.

Call it from end_bbio_data_write() before clearing writeback, along with
mapping_set_error() with the real error code.

Also call it from btrfs_finish_ordered_extent() before
can_finish_ordered_extent(), which sets BTRFS_ORDERED_IO_DONE, so that the
flag is also visible to anyone woken up by IO_DONE.
Compressed writes already finish the ordered extent before clearing
writeback and are not affected.

Assisted-by: LLM (exposing the bug and coding)
Fixes: f13e01b89daf ("btrfs: ensure fast fsync waits for ordered extents after a write failure")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent_io.c    | 13 ++++++++++---
 fs/btrfs/ordered-data.c | 40 +++++++++++++++++++++++++++++-----------
 fs/btrfs/ordered-data.h |  1 +
 3 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b2739838c646..53fced2756b5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -545,6 +545,16 @@ static void end_bbio_data_write(struct btrfs_bio *bbio)
 	u32 bio_size = 0;
 
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
+
+	/*
+	 * Record the error before clearing writeback, as a fast fsync waiting
+	 * for writeback checks the error right after being woken up.
+	 */
+	if (error) {
+		mapping_set_error(bbio->inode->vfs_inode.i_mapping, error);
+		btrfs_ordered_extent_io_failed(bbio->ordered);
+	}
+
 	bio_for_each_folio_all(fi, bio) {
 		struct folio *folio = fi.folio;
 		u64 start = folio_pos(folio) + fi.offset;
@@ -554,9 +564,6 @@ static void end_bbio_data_write(struct btrfs_bio *bbio)
 		btrfs_folio_clear_writeback(fs_info, folio, start, len);
 	}
 
-	if (error)
-		mapping_set_error(bbio->inode->vfs_inode.i_mapping, error);
-
 	btrfs_finish_ordered_extent(bbio->ordered, bbio->file_offset, bio_size, !error);
 	bio_put(bio);
 }
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index df74c75d6c29..0a851203e589 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -423,18 +423,18 @@ static void btrfs_queue_ordered_fn(struct btrfs_ordered_extent *ordered)
 	btrfs_queue_work(fs_info->endio_write_workers, &ordered->work);
 }
 
-void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
-				 u64 file_offset, u64 len, bool uptodate)
+/*
+ * Record that the IO of @ordered failed.
+ *
+ * Must be called before anything a fast fsync can wait on is signaled: the
+ * writeback bit of the folios for buffered IO, or BTRFS_ORDERED_IO_DONE for
+ * direct IO. Otherwise the fast fsync can miss the error.
+ */
+void btrfs_ordered_extent_io_failed(struct btrfs_ordered_extent *ordered)
 {
 	struct btrfs_inode *inode = ordered->inode;
-	bool ret;
 
-	trace_btrfs_finish_ordered_extent(inode, file_offset, len, uptodate);
-
-	spin_lock(&inode->ordered_tree_lock);
-	ret = can_finish_ordered_extent(ordered, file_offset, len,
-					uptodate);
-	spin_unlock(&inode->ordered_tree_lock);
+	btrfs_mark_ordered_extent_error(ordered);
 
 	/*
 	 * If this is a COW write it means we created new extent maps for the
@@ -442,7 +442,7 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 	 * before submitting a bio or during IO.
 	 *
 	 * We have marked the ordered extent with BTRFS_ORDERED_IOERR, and we
-	 * are queuing its completion below. During completion, at
+	 * will queue its completion. During completion, at
 	 * btrfs_finish_one_ordered(), we will drop the extent maps for the
 	 * unwritten extents.
 	 *
@@ -464,8 +464,26 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 	 * Set a flag in the inode so that the next fast fsync will wait for
 	 * ordered extents to complete before starting to log.
 	 */
-	if (!uptodate && !test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
+	if (!test_bit(BTRFS_ORDERED_NOCOW, &ordered->flags))
 		set_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
+}
+
+void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
+				 u64 file_offset, u64 len, bool uptodate)
+{
+	struct btrfs_inode *inode = ordered->inode;
+	bool ret;
+
+	trace_btrfs_finish_ordered_extent(inode, file_offset, len, uptodate);
+
+	/* Must be done before BTRFS_ORDERED_IO_DONE can be set below. */
+	if (!uptodate)
+		btrfs_ordered_extent_io_failed(ordered);
+
+	spin_lock(&inode->ordered_tree_lock);
+	ret = can_finish_ordered_extent(ordered, file_offset, len,
+					uptodate);
+	spin_unlock(&inode->ordered_tree_lock);
 
 	if (ret)
 		btrfs_queue_ordered_fn(ordered);
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 8d5d5ba1e02f..1bb8f9c8c472 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -226,6 +226,7 @@ bool btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, u64 end,
 struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 			struct btrfs_ordered_extent *ordered, u64 len);
 void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered);
+void btrfs_ordered_extent_io_failed(struct btrfs_ordered_extent *ordered);
 void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
 					 u64 truncate_len);
 int __init ordered_data_init(void);
-- 
2.56.0

