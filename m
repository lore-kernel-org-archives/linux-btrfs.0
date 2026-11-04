Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776277;
	b=WZvf/umtb9/HvTeu0YGSaM8SF07E7SJP5ytdNmChDwblxazRn3vN130bQhpcgAR1aYr2
	 jY+s9LOQZ/yVNcI+1dQXrDxg95Oe1kTiQzO3c/iDQ/biXgiiZbDaFUIRVWmt6hB+uQTjU
	 oXdMNNjdmbey3iv3a6os2ACB8fR1/U5cOTvXjXa/bjlj5XDbTOx7nZgZ1avETVf0lTrFx
	 RhEuUIg1hHyAFViQR7Ovn/qiiitrZV+r9J22gzVdK4Spdv3MM3chcvUnDNYEz1mYj9mcT
	 zlgm4YdZF9bW16wauw49O5YPVamomrmG/m3tCZ297jkTAHJhMEMhWOM3DVd+bBCQACw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776277;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=z4FYX9MESJyKh2ZLRALRMZWR1o+SIg95Guf77ANqBTI=;
	b=a2B8lQc+Cd5WVOGAOuCO9QNtAQnANXNbkR0oyNxew1guhJKKm4JmtMkQCjLmBClqQweV
	 W+6bS6dx+FpDhZBxapYdBh9jQcqRdvTY240Jrh8gwbkFXPVKLLoiFgkpam+LdEMcAopBt
	 /HtY46b1ngqWQTgFK6sr5DLer6bahyPsLSM6TesVXQHGxM6hqO/5j2EjSH+BA960afZ54
	 XOWu3jsk+35RThJv8H/29mATlwaYjW3FhZmMyPXpruQEF6ASl1njpSFggAZsvsDBhVzvT
	 RlL7o+IV+QxIels5/7E4HUXfCaRcgE+ShFavDo/ApgKLiJt/Ej0ARt4bSCmPN1z4y0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UNt6U9gz;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UNt6U9gz;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F82F606A31B
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 07:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9F82F606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UNt6U9gz;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=UNt6U9gz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE22E1F79F
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 07:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793776274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=z4FYX9MESJyKh2ZLRALRMZWR1o+SIg95Guf77ANqBTI=;
	b=UNt6U9gzxqWsXKn2W3ECBwxszNq2YsotNMKS6vIMNyq0/U5HLQ4KngumICcTD/yU71Uo4M
	z7ybMoLBvwhwUd0QYG1XXWKmJ7pzj7V9rHq3QaMpV2yBPzpPTsEu0F/Y9U/0DfU2XZ6m9k
	ZIr4xKPXa8Jui6XH8EK9iVVkWD5eQlI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=UNt6U9gz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793776274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=z4FYX9MESJyKh2ZLRALRMZWR1o+SIg95Guf77ANqBTI=;
	b=UNt6U9gzxqWsXKn2W3ECBwxszNq2YsotNMKS6vIMNyq0/U5HLQ4KngumICcTD/yU71Uo4M
	z7ybMoLBvwhwUd0QYG1XXWKmJ7pzj7V9rHq3QaMpV2yBPzpPTsEu0F/Y9U/0DfU2XZ6m9k
	ZIr4xKPXa8Jui6XH8EK9iVVkWD5eQlI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6067E134A5
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Nov 2026 07:11:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q1+GKZDa6mrXJwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 04 Nov 2026 07:11:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs: wait for encoded writes in fast fsync
Date: Wed,  4 Nov 2026 17:40:46 +1030
Message-ID: <c284dccd8c27a6434e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com>
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
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,suse.com:email,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: AE22E1F79F

[BUG REPORT]
Sashiko reported a bug that encoded writes can have its file extents
recorded before their data reaches disks.

[CAUSE]
An encoded write returns to the caller as soon as its bio is submitted,
and its folios are not in the inode's page cache:

  btrfs_ioctl_encoded_write()
   \- btrfs_do_encoded_write()
       |- btrfs_alloc_ordered_extent()
       \- btrfs_submit_compressed_write()   <- returns before the bio ends

A fast fsync only waits for writeback of the folios in the page cache,
so it has nothing to wait for on such an ordered extent:

  btrfs_sync_file()
   |- btrfs_get_ordered_extents_for_logging()
   |- filemap_fdatawait_range()             <- no folio under writeback
   \- btrfs_log_dentry_safe()
       \- ...
           \- log_extent_csums()
               \- log_csums()               <- csum_list may be in flight

This has two problems:

- fsync can return before the data of the encoded write is on disk, while
  the log tree describing it is already persisted.

- With async data checksum generation, the sums are attached to
  ordered->csum_list by btrfs_csum_one_bio() before the checksums are
  calculated.  log_extent_csums() can then log zeroed or partially
  calculated checksums.

For buffered writes this is not a problem, as writeback of a folio ends
after the bio endio, which in turn runs after the checksums are
generated.

[FIX]
Fix it by waiting for the encoded ordered extents in the fast fsync path
before waiting for writeback.

And if the encoded OE failed, also fail the whole fsync early.

Such an ordered extent can only complete after its bio is finished,
meaning the data is on disk and the checksums are fully generated.

Link: https://sashiko.dev/#/patchset/8eb322321cac98013cc46dfe8d89fa58c1ad3dee.1793766229.git.wqu%40suse.com
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Reason for RFC:

This is only covering encoded IO, not direct IO.

As we should not mix direct and buffered IO in the first place, fsync()
definitely counts as a function in the buffered IO family.

The problem is whether we should treat encoded IOs as buffered or direct?

The encoded write itself doesn't wait for write to finish, so it looks
like buffered, but on the other hand it doesn't touch page cache at all,
which is similar to direct IO.

Personally speaking, I tend to treat encoded IO more like buffered, thus
that's why I sent the patch out, other than rejecting the Sashiko review
result.
---
 fs/btrfs/file.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 20e15dc30bfb..474bbb0adfef 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1629,12 +1629,31 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		ret = btrfs_wait_ordered_range(inode, start, len);
 		clear_bit(BTRFS_INODE_COW_WRITE_ERROR, &inode->runtime_flags);
 	} else {
+		struct btrfs_ordered_extent *ordered;
+
 		/*
 		 * Get our ordered extents as soon as possible to avoid doing
 		 * checksum lookups in the csum tree, and use instead the
 		 * checksums attached to the ordered extents.
 		 */
 		btrfs_get_ordered_extents_for_logging(inode, &ctx.ordered_extents);
+
+		/*
+		 * Encoded writes don't mark any folio of the inode as writeback,
+		 * thus the fdatawait below can't wait for them.  Wait for them
+		 * explicitly, so that their data is on disk and their checksums
+		 * are fully generated before we log them.
+		 */
+		list_for_each_entry(ordered, &ctx.ordered_extents, log_list) {
+			if (test_bit(BTRFS_ORDERED_ENCODED, &ordered->flags)) {
+				btrfs_start_ordered_extent(ordered);
+				if (test_bit(BTRFS_ORDERED_IOERR, &ordered->flags)) {
+					ret = -EIO;
+					goto out_release_extents;
+				}
+			}
+		}
+
 		ret = filemap_fdatawait_range(inode->vfs_inode.i_mapping, start, end);
 		if (ret)
 			goto out_release_extents;
-- 
2.56.0

