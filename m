Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169EE4EDCB6
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 09:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792054825; cv=none; b=O9ImMannkmsQfCRRFRB36PQTme76xEhAaVfrtKMrBTT6MiWKXL9+6Fg/YG+6qUHNDprS9mpmjQron/VnH95g8xRE8Iu3e/na5aCc1AXAm9gpbpmKl/hKWHDcOwLr7QpXKtceVe6r5jimo6LcaMG9ANpZf8mXUkoACUpctHmuIVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792054825; c=relaxed/simple;
	bh=AfznUyVdySKlcMpDV6egOkj64/DVv7blNs1zFbANA5Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=i8JQOy6VNH/OUtGgGdJfpd7AxO6Z5p2q17gLkkX7XOtrLPjrIbB/JA/AK6b6AEIpzuZLqXHDLJ8sO42iUakOxsTLK/3HfBByqNkjcYP2x/nUQcik+pNykdz5wZrlgys6AO70pAv1tAVLI+wGcpG9f/nkN9s+pxMYwG6REdqISK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fKdvn1Rj; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fKdvn1Rj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fKdvn1Rj";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fKdvn1Rj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C750D1F7F8
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 09:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792054811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d9hPxFyeI+A/ZI+p60U0MIzZpXGLvnWIyK97HA8aVNk=;
	b=fKdvn1RjugfvGTUu7bfz+sON3laVWgSe4aw3XiHFlMe8upf+hSsEfjKrvsg0kNkPSCUqsT
	pM9gSj/Efdw4ntNFp0wywfb7ryQSRC/B3qwMH6Ys1GXrYhIyxOQHMSnZDlGXoQCSA41Px7
	FTQatHazbwAutbk9I4kubFpfOFHYg+c=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792054811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d9hPxFyeI+A/ZI+p60U0MIzZpXGLvnWIyK97HA8aVNk=;
	b=fKdvn1RjugfvGTUu7bfz+sON3laVWgSe4aw3XiHFlMe8upf+hSsEfjKrvsg0kNkPSCUqsT
	pM9gSj/Efdw4ntNFp0wywfb7ryQSRC/B3qwMH6Ys1GXrYhIyxOQHMSnZDlGXoQCSA41Px7
	FTQatHazbwAutbk9I4kubFpfOFHYg+c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E7E4132C9
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 09:00:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LEeeMxiW0GrOMAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2026 09:00:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: lzo: remove the special handling inside one fs block
Date: Thu, 15 Oct 2026 19:29:50 +1030
Message-ID: <9fbafebb95a3b9bbe4d6adf98c1ad3c65eb29aca.1792054757.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

Since commit 3eaf5f082c4c ("btrfs: extract inlined creation into a
dedicated delalloc helper"), even for inlined compressed extents the cb
range will be exact one block, aka [0, sector).

And several attempts to bring back the old compression range [0, i_size]
all failed with extra races against i_size.

So I think the behavior will stay. With that said, we can further
simplify the lzo compression path.
Since the range is always aligned to block size, and lzo compression is
already done block by block, there is no reason to handle sub-block
sized range.

We can safely remove the @sectorsize_mask, @sector_off and @in_len
variables, and always use @sectorsize as input length for each
compression iteration.

Finally add two ASSERT()s to make sure the range passed into
btrfs_compress_bio() is always block aligned.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c |  3 +++
 fs/btrfs/lzo.c         | 11 +++--------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ad90e14032db..b12b7f1b31fd 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1010,6 +1010,9 @@ struct compressed_bio *btrfs_compress_bio(struct btrfs_inode *inode,
 	struct compressed_bio *cb;
 	int ret;
 
+	ASSERT(IS_ALIGNED(start, fs_info->sectorsize));
+	ASSERT(IS_ALIGNED(len, fs_info->sectorsize));
+
 	cb = alloc_compressed_bio(inode, start, REQ_OP_WRITE | write_flags,
 				  end_bbio_compressed_write);
 	cb->start = start;
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 2f0996692da0..0b2d9a825543 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -291,9 +291,6 @@ int lzo_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 
 	while (cur_in < start + len) {
 		char *data_in;
-		const u32 sectorsize_mask = sectorsize - 1;
-		u32 sector_off = (cur_in - start) & sectorsize_mask;
-		u32 in_len;
 		size_t out_len;
 
 		/* Get the input page first. */
@@ -303,11 +300,9 @@ int lzo_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 				goto out;
 		}
 
-		/* Compress at most one sector of data each time. */
-		in_len = min_t(u32, start + len - cur_in, sectorsize - sector_off);
-		ASSERT(in_len);
+		/* Compress one sector of data each time. */
 		data_in = kmap_local_folio(folio_in, offset_in_folio(folio_in, cur_in));
-		ret = lzo1x_1_compress(data_in, in_len, workspace->cbuf, &out_len,
+		ret = lzo1x_1_compress(data_in, sectorsize, workspace->cbuf, &out_len,
 				       workspace->mem);
 		kunmap_local(data_in);
 		if (unlikely(ret < 0)) {
@@ -321,7 +316,7 @@ int lzo_compress_bio(struct list_head *ws, struct compressed_bio *cb)
 		if (ret < 0)
 			goto out;
 
-		cur_in += in_len;
+		cur_in += sectorsize;
 
 		/*
 		 * Check if we're making it bigger after two sectors.  And if
-- 
2.56.0

