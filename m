Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2B732F766
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772163265; cv=none; b=PbP8OuX7x4hudj3zJ0sln0EVTVuvzsgosJrfyc9mtuuu6YiHipRC8hXQBpg9UAF/H1Uju5JdGMpkIBj/D+m14KqBDHjv7AalB92jB3ZeJw1smtuTStNCF6/Dy/lOvAJ70BGJ0rDRGwjcM9oTGDztL6BX2WEW5UAhfbbkKzlHS3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772163265; c=relaxed/simple;
	bh=ZB0gtVmxZKTun+y+qsPBLdRJfnaxmwYYX7i6hhVPWzE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Loew2BA0IRVRhhK5v5kFMGQMh0cFHXGYB39as7ESycAQpyO1ZFy6BkRMdaadA3MQ3+96bW8Ja/Fctfv/il30b+HEVHHELQQw+DLK2eQHjwqBXb64sVSAr8S4xBH7P7TvAXmrP+PJObPWLZYXfM8PlQx8fqbn3MrwkAsIdOlXcPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZalIgS0J; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZalIgS0J; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZalIgS0J";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZalIgS0J"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6B4755CEAF
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772163258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3gp3QhwTuGC3d/rUIXY1wG68bezpKD0PyB/6p1Lzrcc=;
	b=ZalIgS0J105gFB2BrYeBnUTIism/ks6q3n4oF1HoyQe6pQxZOqAULx7GQ63KuBlaXHQLDI
	myQZNr4ZjY0wKzpzvqABBJOAj6pAwE5VVVfcpuGBlvP1kLyu70c2TDwkgsOwBwpNd7Tiim
	ZeBG5LHyshV46iiUWJO/krGAjL5F9OI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ZalIgS0J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772163258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3gp3QhwTuGC3d/rUIXY1wG68bezpKD0PyB/6p1Lzrcc=;
	b=ZalIgS0J105gFB2BrYeBnUTIism/ks6q3n4oF1HoyQe6pQxZOqAULx7GQ63KuBlaXHQLDI
	myQZNr4ZjY0wKzpzvqABBJOAj6pAwE5VVVfcpuGBlvP1kLyu70c2TDwkgsOwBwpNd7Tiim
	ZeBG5LHyshV46iiUWJO/krGAjL5F9OI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A0B433EA69
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OCMyGLkQoWmcNAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:17 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/4] btrfs: move block size < page size support out of experimental features
Date: Fri, 27 Feb 2026 14:03:46 +1030
Message-ID: <448e4807eee903170d498c049d6e26da026326cf.1772162871.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772162871.git.wqu@suse.com>
References: <cover.1772162871.git.wqu@suse.com>
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid,suse.com:email]
X-Rspamd-Queue-Id: 6B4755CEAF
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Commit 2ccfaf736909 ("btrfs: support all block sizes which is no larger
than page size") has expanded the supported block size to any block size
that is no larger than page size.

But that support is still only for experimental builds, and it has been
two releases without any reported bug.

We can safely move that feature out of experimental features.

Now only bs > ps support is still under experimental features.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/fs.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/fs.c b/fs/btrfs/fs.c
index d7e7011a48c2..ed3bd3cf4524 100644
--- a/fs/btrfs/fs.c
+++ b/fs/btrfs/fs.c
@@ -129,12 +129,10 @@ void btrfs_csum_final(struct btrfs_csum_ctx *ctx, u8 *out)
 /*
  * We support the following block sizes for all systems:
  *
- * - MIN_BLOCKSIZE (4K)
- *   This is the most common block size. For PAGE SIZE > 4K cases the subpage
- *   mode is used.
+ * - [MIN_BLOCKSIZE, PAGE_SIZE]
  *
- * - PAGE_SIZE
- *   The straightforward block size to support.
+ * - (PAGE_SIZE, MAX_BLOCKSIZE]
+ *   For experimental builds and no HIGHMEM.
  */
 bool __attribute_const__ btrfs_supported_blocksize(u32 blocksize)
 {
@@ -142,7 +140,7 @@ bool __attribute_const__ btrfs_supported_blocksize(u32 blocksize)
 	ASSERT(is_power_of_2(blocksize) && blocksize >= BTRFS_MIN_BLOCKSIZE &&
 	       blocksize <= BTRFS_MAX_BLOCKSIZE);
 
-	if (blocksize == PAGE_SIZE || blocksize == BTRFS_MIN_BLOCKSIZE)
+	if (blocksize <= PAGE_SIZE)
 		return true;
 #ifdef CONFIG_BTRFS_EXPERIMENTAL
 	/*
-- 
2.53.0

