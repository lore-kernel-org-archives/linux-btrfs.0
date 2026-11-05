Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793852507;
	b=W2NjsjzmEEIAa0Edjec9u0IyjsLdx72gp1tYVkRfr46XVy3OwN2iQJLd6XBP3VWQq9at
	 Mh3pYoj+bUK2N2ezbJliSdaK45wV4rMTLtmdUsS6sQX7Tv0jrgjvxiKE3HK9zrBjZ01ze
	 ixfG56qienjge6F1gdv2g5SuA+EdnwyNmFkacEi/pGdPZwZW55u/n20JRNJZaSJJrRJY/
	 iStZ2q9cisQOc2ZSaTksi5cOCU5SFApCJKU/ZHHO2NcOn1g6CyetEo8uGK0QVW0HrWHrO
	 9NzoqmY20RurWOEizp4KFq9qL+wPP6j8wHEiua9KKEvUEDkj2due3PmrHMI4vHLuk5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793852507;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=rsrb/kDwr1n5JVcBT8EMffd2eikce8QtgXmfDGDR410=;
	b=2bQKie0pUgnEAhhwdZZCSmow5HmQ265DnWhJlgMZriQTY6S8MHfShMIv52v5+ryxPoDF
	 SvNBdqwCAwHl11Fc/ZgUUm5T910E/7FwqMesTahoIVwtWzbEG/uqi03stDKDlj/psI4oi
	 b+DtmG8zLzo4n8HLzIknBSN0j/V0DQ7zHRvTBH+nx8XzUxnXa18+aVY3DlNYKKaHL7fr5
	 mEl/uVRNYVkNCnG1nzCdPEO7ykzheAwg+1a9ZTKCiYTvSlJ3WmTbSI3DtnKY0lz4AEWMl
	 58MPssigL1lP2+MsBC0TfZuTIAmZaFuEJSM8LPzINVuHYKXqHsdQpwkKBH6Jh2GDvfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=U2lCLpfZ;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=U2lCLpfZ;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657D2606A326
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 04:21:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 657D2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=U2lCLpfZ;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=U2lCLpfZ
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 834571F7E1
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 04:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793852504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rsrb/kDwr1n5JVcBT8EMffd2eikce8QtgXmfDGDR410=;
	b=U2lCLpfZ5MRcgg9Lg2SrL4zws0m8MvTCbNjAHvNZtwJkxnFBs6FgNAT2irWzwL7HXF8kxg
	9Gnrrz0tIA6Wa01UYz+Xp776HT50jCeuxosskomTOsAmPqmScF+PtXX/52Dku1GF/X7Px0
	uwouXXPoaMG4vl/1Jl4ZTPiUw+Gils8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=U2lCLpfZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793852504; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rsrb/kDwr1n5JVcBT8EMffd2eikce8QtgXmfDGDR410=;
	b=U2lCLpfZ5MRcgg9Lg2SrL4zws0m8MvTCbNjAHvNZtwJkxnFBs6FgNAT2irWzwL7HXF8kxg
	9Gnrrz0tIA6Wa01UYz+Xp776HT50jCeuxosskomTOsAmPqmScF+PtXX/52Dku1GF/X7Px0
	uwouXXPoaMG4vl/1Jl4ZTPiUw+Gils8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 52EE2133F6
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Nov 2026 04:21:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ICoyJlYE7GrhOQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 05 Nov 2026 04:21:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: skip fast sync for inodes with encoded writes
Date: Thu,  5 Nov 2026 14:51:16 +1030
Message-ID: <14e0d19262452be0d9e08478f47be08ec6fa6d6f.1793852473.git.wqu@suse.com>
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sashiko.dev:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 834571F7E1

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
Fix it by requiring full sync for the inode which went through encoded
writes.

Encoded writes are mostly utilized by btrfs-recevice, so it's never on
the hot path.
And receveied subvolumes are set read-only, so normally no one should
even call fsync() on those inodes. Thus the cost of full fsync on encoded
writes should be very acceptable.

Link: https://sashiko.dev/#/patchset/8eb322321cac98013cc46dfe8d89fa58c1ad3dee.1793766229.git.wqu%40suse.com
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog
RFC->v1: (RFC at https://lore.kernel.org/linux-btrfs/c284dccd8c27a6434e56ed067b0ef4ea67935d8c.1793776224.git.wqu@suse.com/)
- Require full fsync instead of waiting for encoded writes
  The common usage of encoded writes are btrfs receive, so we shouldn't
  need to bother fsync on those files in the first place.

  And this makes the fix much simpler.

- Drop the REASON for RFC part
  Which contains quite some incorrect assumptions on fsync() and direct
  IOs
---
 fs/btrfs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ab60b7d4f389..65714380a935 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10035,6 +10035,12 @@ ssize_t btrfs_do_encoded_write(struct kiocb *iocb, struct iov_iter *from,
 		ret = PTR_ERR(ordered);
 		goto out_free_reserved;
 	}
+	/*
+	 * fsync() of the inode can not go through fast path, as there is no
+	 * dirty/writeback folio in the page cache for fsync() to wait.
+	 * So fast sync can return without waiting for the data to reach disks.
+	 */
+	btrfs_set_inode_full_sync(inode);
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
 
 	if (start + encoded->len > inode->vfs_inode.i_size)
-- 
2.56.0

