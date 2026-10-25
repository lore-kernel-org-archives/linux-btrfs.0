Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792917736;
	b=NK0Eloym4lv/+soPpwfCVMRohxrqFJZjqZLQViueh8ud/O1hED1cJzSYhh/OsiMNZAmT
	 shu7UUdNRzo4tAZso1J7bkQYJYK8/RCGmCFFFAlyALXGrk3MC+J9/j+9kA5338Hiypnlc
	 H8EyQSUw19qlKrsLQxsGbFTQLLGPtMGKA3obJM71+MIv1mONqS0bgC6oomwZDOatFxFrQ
	 M27cNsbH2QqtI1zk8QuxremN0eEhzcJqWntS9L1Loo+00lDFdYqovPx8SiMyycw36L41X
	 pPUQUxVswHZRiQV1lbPU6438cdf2fjOvF2zkQZiuKrLk2+A80DKYK2xcdDfX7V8fh4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792917736;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding:X-Rspamd-Queue-Id:
	 X-Spam-Level:X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:
	 X-Spamd-Result:X-Spam-Score;
	bh=/8fESpy/ye1h00OIre3+PgdDEn0TfYVFh8Df88MsLhU=;
	b=3jats+OmsKUPYdMIr0FUVB/qs1GEfTBV0pd2nw8lhdZFWeIAGsUOjfVM+7eMQ2BNnfJx
	 oA9sp5lS0XnJ9UlwgfXS/EpPJmopT/6E6m0kLGivdtsAwmHiGNivjjr9+H9uiG3EqWIfn
	 Z4Hf/i7C1Msn7jH4k1b27pnWZ624gqrjXq14V9qwVdfRwXUJbLlglh4+NzJfVfGOBqmo7
	 XEnYjis8J551aCarP48viOINErF4A4nhZTswabtyvlcpfxtLvuSvlt0y+4X/+rz8ZPD8+
	 pwQZqbALQtwarNEfkzI1/+r6Y7gzltVftTnY7Cweatznr1aNplXy6pebFmXsgiiAm+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RB6QtyTt;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RB6QtyTt;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1758C606A322
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1758C606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RB6QtyTt;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RB6QtyTt
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 71DB91F390
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/8fESpy/ye1h00OIre3+PgdDEn0TfYVFh8Df88MsLhU=;
	b=RB6QtyTtXDaHqNtitcjkxfd/fKTEbsQ+w2ZhaDiIJnxuhEN7bFRm9FQRKnNnnrtQK1UiA3
	SLwyuu2vgpjH+oOtr9jiaYky649VwYKUbXLI01XWv980ofdmDk4VxCYvMvIFMQ5opz8vjq
	xrXNgehojqNgEBZ4Qq6jvMgpy3QhbTk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=RB6QtyTt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792917734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/8fESpy/ye1h00OIre3+PgdDEn0TfYVFh8Df88MsLhU=;
	b=RB6QtyTtXDaHqNtitcjkxfd/fKTEbsQ+w2ZhaDiIJnxuhEN7bFRm9FQRKnNnnrtQK1UiA3
	SLwyuu2vgpjH+oOtr9jiaYky649VwYKUbXLI01XWv980ofdmDk4VxCYvMvIFMQ5opz8vjq
	xrXNgehojqNgEBZ4Qq6jvMgpy3QhbTk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A84B13314
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mglvH9zA3Wq5HgAAD6G6ig:T6
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 25 Oct 2026 08:42:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 05/12] btrfs-progs: image: free the buffer if output allocation failed
Date: Sun, 25 Oct 2026 19:11:39 +1030
Message-ID: <63427a7f600d79f76460ed7b91ea88c381675b93.1792914402.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1792914402.git.wqu@suse.com>
References: <cover.1792914402.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 71DB91F390
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.01

Inside dump_worker(), if the compression output buffer allocation
failed, since async->buffer is reused, no one can reach the old original
buffer.

This leads to leaked memory on the error path. Release the original
buffer in that case.

Assisted-by: LLM (exposing the bug)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/image-create.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/image/image-create.c b/image/image-create.c
index 75f450520059..97348f37acaa 100644
--- a/image/image-create.c
+++ b/image/image-create.c
@@ -68,6 +68,7 @@ static void *dump_worker(void *data)
 			async->bufsize = compressBound(async->size);
 			async->buffer = malloc(async->bufsize);
 			if (!async->buffer) {
+				free(orig);
 				error_mem("async buffer");
 				pthread_mutex_lock(&md->mutex);
 				if (!md->error)
-- 
2.56.0

