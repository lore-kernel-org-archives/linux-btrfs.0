Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794304314;
	b=BjWiB+z4rEF9pNGUPcdCl4d20Zesr5MoEWlUG4gzzaETWekpReufOdbhILNHP3ZJ0/IZ
	 A8qd05hv5wpGDTuCICHfiUe+AEgQoZzOfMs9KbtfA5v6nsqY4oFF2cb8wzvZ4htfCR79j
	 jrenUFHXWlGl4om2/52x0I66KPgWdzJbYKduTLjcC9XfulPi2Yq2Cw84//9uGcNLORmg2
	 pkcO1GW08mbc/+2QeCwEzbl+rENbAnjcIm7WXfc1wo9SduQ39eRsxQNlKchhyCCzXOAOr
	 oVjCKsGdok48uAfNMxz3WDG2KoGBAEdPqsUl5KDrRlxajw+mqhcucwd172/K2W2dZlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794304314;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=qkriYlT4Bg2pIZnrQYpxHKmYGGwcce2gCkaRbIwv6pE=;
	b=U/YYJn2J7e4QIf89YFD5W2amnKoG9Jy0Irr75TvmgcYR1dcxm+VDEhBgea+UmGzDcQta
	 yvs/ZXpRpX4cIo+dvs5fRGDBRDWAc0qdtja5snhqOejULEV3X1N7JHg0ps8waMJp46iCj
	 W2xh65IS6U+xHkBkvmXBIXvvxrHrbWjEgQmYAkqWPvNkkQseK0fMBVYJzopiOSiozIeEv
	 uB8iycByG3pBAdKKxlpVowdkyjaJKzqkoTALmzEGm4nH0Vc6XAFfI/OWGmQOZtDpirTr9
	 nWsbTAJX0pQIHSayfxh8h9w5VZmrP8KrNQa6nURxr96IZZWTx87I/O+5qWooXZ+WsSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=t0ZIMCBk;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=VhvcGKMo;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937CE606A31C
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 09:51:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 937CE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=t0ZIMCBk;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=VhvcGKMo
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0FE0821F19
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 09:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794304306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qkriYlT4Bg2pIZnrQYpxHKmYGGwcce2gCkaRbIwv6pE=;
	b=t0ZIMCBkTNtmTATFS9em+Ne/2w3PG+Qc3P/wRaS5zFc9gfJGkuld5TVTpP6so5O+B/BbGI
	XsKTR5+BGTAmeW++eWRK2WUugiWUiGsXQx2OJK8CpMVouv+vk7Qv9+HNsKaRBZ5hFSsF00
	dQUJZbQqUVZB6H34a19xJK7ZLzJi/Xs=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=VhvcGKMo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794304305; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qkriYlT4Bg2pIZnrQYpxHKmYGGwcce2gCkaRbIwv6pE=;
	b=VhvcGKMoNkR1YYkXsL7RoIXAmg6/FLJdsvInnRGutPA+tBfJyq1ko96JMYJREdhh8P5i/5
	SSX1npDKNH/tJShvF43Gko5cyoiSBC+b4ODZpFtrsC8DMfIjLvX9m5uia/mhjVnp+j3FTs
	CZ4jBwQd9Eps3jVpvdjfeOhIkvu7QE8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB0D31339F
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 09:51:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bnvvDC/p8mo6BgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 10 Nov 2026 09:51:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: set write error flags before clearing writeback on failed buffered writes
Date: Tue, 10 Nov 2026 20:21:21 +1030
Message-ID: <d562d8a0c43abbd8cc1414d80f7cd4b2acf9610f.1794304279.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 0FE0821F19

[BUG]
After commit a11d6912fdd9 ("btrfs: remove folio parameter from ordered
io related functions") and 9d7db4100057 ("btrfs: move the
mapping_set_error() out of the loop in end_bbio_data_write()"), a failed
COW write sets the inode's BTRFS_INODE_COW_WRITE_ERROR flag.

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
extent with BTRFS_ORDERED_IOERR, sets the mapping error with specified
error code, and sets BTRFS_INODE_COW_WRITE_ERROR for COW ordered extents.

This means btrfs_mark_ordered_extent_error() also needs a new @error
parameter.
For existings callers if an error code can be easily grabbed, pass that
real error code, otherwise pass an -EIO to follow the old behavior.

Call it from end_bbio_data_write() before clearing writeback.

Also call it from btrfs_finish_ordered_extent() before
can_finish_ordered_extent(), which sets BTRFS_ORDERED_IO_DONE, so that the
flag is also visible to anyone woken up by IO_DONE.
Compressed writes already finish the ordered extent before clearing
writeback and are not affected.

Assisted-by: LLM (exposing the bug and coding)
Fixes: a11d6912fdd9 ("btrfs: remove folio parameter from ordered io related functions")
Fixes: 9d7db4100057 ("btrfs: move the mapping_set_error() out of the loop in end_bbio_data_write()")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
v2:
- Update the fixes tag to the ones that moves the error handling after
  writeback flag clearing

- Introduce a new @error parameter to btrfs_mark_ordered_extent_error()
  to avoid overwriting the error with -EIO
---
 fs/btrfs/extent_io.c    | 13 ++++++++---
 fs/btrfs/inode.c        |  2 +-
 fs/btrfs/ordered-data.c | 48 +++++++++++++++++++++++++++++------------
 fs/btrfs/ordered-data.h |  5 ++++-
 fs/btrfs/relocation.c   |  4 ++--
 fs/btrfs/zoned.c        |  2 +-
 6 files changed, 52 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index b2739838c646..05a33ef27fcc 100644
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
+		btrfs_ordered_extent_io_failed(bbio->ordered, error);
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
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 19b1eba2dd84..3e450ab77532 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3347,7 +3347,7 @@ int btrfs_finish_one_ordered(struct btrfs_ordered_extent *ordered_extent)
 		 * marking this ordered extent as failed.
 		 */
 		if (ret)
-			btrfs_mark_ordered_extent_error(ordered_extent);
+			btrfs_mark_ordered_extent_error(ordered_extent, ret);
 
 		/*
 		 * Drop extent maps for the part of the extent we didn't write.
diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index df74c75d6c29..72696913a781 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -352,10 +352,11 @@ void btrfs_add_ordered_sum(struct btrfs_ordered_extent *entry,
 	spin_unlock(&inode->ordered_tree_lock);
 }
 
-void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered)
+void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered,
+				     int error)
 {
 	if (!test_and_set_bit(BTRFS_ORDERED_IOERR, &ordered->flags))
-		mapping_set_error(ordered->inode->vfs_inode.i_mapping, -EIO);
+		mapping_set_error(ordered->inode->vfs_inode.i_mapping, error);
 }
 
 void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
@@ -399,7 +400,7 @@ static bool can_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 	}
 
 	if (!uptodate)
-		btrfs_mark_ordered_extent_error(ordered);
+		btrfs_mark_ordered_extent_error(ordered, -EIO);
 
 	if (ordered->bytes_left)
 		return false;
@@ -423,18 +424,19 @@ static void btrfs_queue_ordered_fn(struct btrfs_ordered_extent *ordered)
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
+void btrfs_ordered_extent_io_failed(struct btrfs_ordered_extent *ordered,
+				    int error)
 {
 	struct btrfs_inode *inode = ordered->inode;
-	bool ret;
 
-	trace_btrfs_finish_ordered_extent(inode, file_offset, len, uptodate);
-
-	spin_lock(&inode->ordered_tree_lock);
-	ret = can_finish_ordered_extent(ordered, file_offset, len,
-					uptodate);
-	spin_unlock(&inode->ordered_tree_lock);
+	btrfs_mark_ordered_extent_error(ordered, error);
 
 	/*
 	 * If this is a COW write it means we created new extent maps for the
@@ -442,7 +444,7 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
 	 * before submitting a bio or during IO.
 	 *
 	 * We have marked the ordered extent with BTRFS_ORDERED_IOERR, and we
-	 * are queuing its completion below. During completion, at
+	 * will queue its completion. During completion, at
 	 * btrfs_finish_one_ordered(), we will drop the extent maps for the
 	 * unwritten extents.
 	 *
@@ -464,8 +466,26 @@ void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
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
+		btrfs_ordered_extent_io_failed(ordered, -EIO);
+
+	spin_lock(&inode->ordered_tree_lock);
+	ret = can_finish_ordered_extent(ordered, file_offset, len,
+					uptodate);
+	spin_unlock(&inode->ordered_tree_lock);
 
 	if (ret)
 		btrfs_queue_ordered_fn(ordered);
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 8d5d5ba1e02f..a4e4705111a2 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -225,7 +225,10 @@ bool btrfs_try_lock_ordered_range(struct btrfs_inode *inode, u64 start, u64 end,
 				  struct extent_state **cached_state);
 struct btrfs_ordered_extent *btrfs_split_ordered_extent(
 			struct btrfs_ordered_extent *ordered, u64 len);
-void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered);
+void btrfs_mark_ordered_extent_error(struct btrfs_ordered_extent *ordered,
+				     int error);
+void btrfs_ordered_extent_io_failed(struct btrfs_ordered_extent *ordered,
+				    int error);
 void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
 					 u64 truncate_len);
 int __init ordered_data_init(void);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 9af207446848..3f55aeb76917 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5809,7 +5809,7 @@ int btrfs_reloc_clone_csums(struct btrfs_ordered_extent *ordered)
 	int ret;
 
 	if (unlikely(!csum_root)) {
-		btrfs_mark_ordered_extent_error(ordered);
+		btrfs_mark_ordered_extent_error(ordered, -EIO);
 		btrfs_err(fs_info,
 			  "missing csum root for extent at bytenr %llu",
 			  disk_bytenr);
@@ -5820,7 +5820,7 @@ int btrfs_reloc_clone_csums(struct btrfs_ordered_extent *ordered)
 				      disk_bytenr + ordered->num_bytes - 1,
 				      &list, false);
 	if (ret < 0) {
-		btrfs_mark_ordered_extent_error(ordered);
+		btrfs_mark_ordered_extent_error(ordered, ret);
 		return ret;
 	}
 
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 3192b86669b9..6decf4633c94 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -2173,7 +2173,7 @@ void btrfs_finish_ordered_zoned(struct btrfs_ordered_extent *ordered)
 			continue;
 		}
 		if (!btrfs_zoned_split_ordered(ordered, logical, len)) {
-			btrfs_mark_ordered_extent_error(ordered);
+			btrfs_mark_ordered_extent_error(ordered, -EIO);
 			btrfs_err(fs_info, "failed to split ordered extent");
 			goto out;
 		}
-- 
2.56.0

