Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF1218FDBD
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859321; cv=none; b=jGLmS3PZg0fOKa9WjWtCY0oEcTey2nZU2dgs3j6LoGKu2R1mZxfkq4VunhfeUYLsNd4urCCAkdWZS2aOhxlvkhRPkCrm7Dw96ITlVnd9Zy1RCQi7PoYWklKfpuX8jZGJ0QGsuyqRLtYxUEQiCtpQu+anC+OD944MLyWePXt2RtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859321; c=relaxed/simple;
	bh=duZ3QEvBnZ967jX2YhaXfT3mznsqzULHHw8w0G7y+t4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ec5HkdoToYDutwJ04knY2VmX03cuMoHgfnAOP13t+8siC9kmdaJVuNrZBz3wTlGhhcjGiZ5xC1J7xmUDGuX8jBFHcck/h/5FqohnbeNXkc3iycYnJP1befv9QgI9+DOyWRei/I/iVP/2ZMWj3SiwZ+p6GtTBiTXgi8gFA5k+SqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RVQn0k/E; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RVQn0k/E; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RVQn0k/E";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RVQn0k/E"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1549C75BED
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781859314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=meR3rDnPXmPWdy/QdF3dkrdotWOBFbLqeqDSl/CSJ34=;
	b=RVQn0k/Eev3LE8MZLRiBBiFRui2fw0cX36GcakjDqXTPDYxcQ+BvdZ6mXhKerqIaUHjiwg
	lGjQ/wzFXHhH/1p5faiNhwVGUdEtF6Y7nu6+damS4vjKzJPVzC85n3ToUPrk4IxqiZozgC
	xiY7Ym/kcaA+pMLgJj36nWFgmYVjHRU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="RVQn0k/E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781859314; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=meR3rDnPXmPWdy/QdF3dkrdotWOBFbLqeqDSl/CSJ34=;
	b=RVQn0k/Eev3LE8MZLRiBBiFRui2fw0cX36GcakjDqXTPDYxcQ+BvdZ6mXhKerqIaUHjiwg
	lGjQ/wzFXHhH/1p5faiNhwVGUdEtF6Y7nu6+damS4vjKzJPVzC85n3ToUPrk4IxqiZozgC
	xiY7Ym/kcaA+pMLgJj36nWFgmYVjHRU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 150DB779A8
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YGorLfADNWrBTwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: allow any block size that is no larger than page size
Date: Fri, 19 Jun 2026 18:24:47 +0930
Message-ID: <501cf54f07025b6fa11a74baf0f7156684902391.1781859111.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1781859111.git.wqu@suse.com>
References: <cover.1781859111.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1549C75BED
X-Spam-Score: -3.01

Since v5.15 btrfs has support for block size < page size, but we still
only support 4K block size, meanwhile there is no special reason that we
can not support 8K/16K/32K block sizes for 64K page size.

That 4K limit is completely artificial, and mostly to reduce test
runtime so we do not need to test all the extra block size combinations.

However that also limits the user choices, some users may understand
what they are doing, and want larger block sizes.
In that case, fixed 4K block size for subpage routine is blocking our
way.

Just remove that fixed 4K requirement for block size < page size.

This should not affect regular end users, since mkfs is already using 4K
block size as default for quite a while, and the existing bs == ps support is
always there.

But for power users, this allows extra block size support, and may
provide extra test coverage.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/fs.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/fs.c b/fs/btrfs/fs.c
index 907c8837a639..5015d0148841 100644
--- a/fs/btrfs/fs.c
+++ b/fs/btrfs/fs.c
@@ -127,14 +127,9 @@ void btrfs_csum_final(struct btrfs_csum_ctx *ctx, u8 *out)
 }
 
 /*
- * We support the following block sizes for all systems:
- *
- * - 4K
- *   This is the most common block size. For PAGE SIZE > 4K cases the subpage
- *   mode is used.
- *
- * - PAGE_SIZE
- *   The straightforward block size to support.
+ * For regular builds, any block size <= page size is supported.
+ * For experimental builds, any block size between BTRFS_MIN_BLOCKSIZE
+ * and BTRFS_MAX_BLOCKSIZE (inclusive) is supported.
  */
 bool __attribute_const__ btrfs_supported_blocksize(u32 blocksize)
 {
@@ -142,7 +137,7 @@ bool __attribute_const__ btrfs_supported_blocksize(u32 blocksize)
 	ASSERT(is_power_of_2(blocksize) && blocksize >= BTRFS_MIN_BLOCKSIZE &&
 	       blocksize <= BTRFS_MAX_BLOCKSIZE);
 
-	if (blocksize == PAGE_SIZE || blocksize == SZ_4K || blocksize == BTRFS_MIN_BLOCKSIZE)
+	if (blocksize <= PAGE_SIZE)
 		return true;
 #ifdef CONFIG_BTRFS_EXPERIMENTAL
 	/*
-- 
2.54.0

