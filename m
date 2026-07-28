Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A64A355814
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785220780; cv=none; b=tiLk/1ulY7++CsGjfEQVqiyTlPCTluuyOKhIxf1c8KulzSo5TpqVbIHbIzbAOwjlWD61k5LHPRwSxxfwNBpaH98EJTBlNDhoOy1+3NNDM9y5gqzX/kOtaBmHpDGmdAojDqaSHdKgjZX5Zmb+jXVdXDoih/PSaosHZ/doqX9HK/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785220780; c=relaxed/simple;
	bh=AvWQal/df6YNfWK1WNKXRWB4Iuraj8hsoGl142UVbDo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qS3079aADI0U7ziK0pMBCQtOfA7Ji5qlV56tgUQP8ioO+S7b6RnpA5HgaNCXOTejVek8eIJrpArOQSQWNgUKfD5MQUBw4T8X/PR/J9lhnj/XzGnflR/v5RsV1aAR8RXLHr3tV74owrGS03Pk+tMDGkHRIJtPQepMmNEY85DLQKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=cNqQr3GI; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Fmem+PeZ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="cNqQr3GI";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Fmem+PeZ"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5D9657BDB3
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785220773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ik4Y+xJi9iKdbwNAjQvJ5ZwJ0WpUsgZwiG2jONb1nRM=;
	b=cNqQr3GIc+TfOoEFWvUB1xXHT/gJcbgFlOCAwBvLKFh7ZtBMBxIO3n4P7z2djn2ZSGg+40
	gxknuOZXGFE+uzSZpju0h/OhBaz122Nh90D4O3t4vV2ERRO668NObtYeQpjPrh2cyKmczI
	xfcjBSrtZ2vkqelmpur6zFNER9Fs9Io=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Fmem+PeZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785220769; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ik4Y+xJi9iKdbwNAjQvJ5ZwJ0WpUsgZwiG2jONb1nRM=;
	b=Fmem+PeZmjM9LcI2O9yc+ah8ICs46iEW6XzCgD3PhDrHFl/Kknvb0YBMbVP00c1Cw4rwTD
	iY0xaq3vNhPY3g1Q8VBY0BLVJZGDZ/jgowSV5an4mUvqP4ULtv3VA+sMgpcCsyuQlvqAXf
	RmlNN0A9yVgtu6NSVvNmVeZQnpOZSGY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A1C9779B3
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +CGxAqBOaGrkSAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 06:39:28 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: use proper inclusive end in extent_fiemap()
Date: Tue, 28 Jul 2026 16:09:03 +0930
Message-ID: <44822c23fc6764aa93a855648a1533a5faf4925c.1785220613.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785220613.git.wqu@suse.com>
References: <cover.1785220613.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 5D9657BDB3
X-Spamd-Result: default: False [-3.01 / 50.00];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

The @end parameter for all extent io tree helpers is inclusive, but
the call site in extent_fiemap() is passing exclusive end.

Fix it to follow the common pattern.

Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate reporting extent sharedness")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/fiemap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
index ba6a360074c0..2f2ae0b76799 100644
--- a/fs/btrfs/fiemap.c
+++ b/fs/btrfs/fiemap.c
@@ -657,7 +657,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
 
 restart:
 	range_start = round_down(start, sectorsize);
-	range_end = round_up(start + len, sectorsize);
+	range_end = round_up(start + len, sectorsize) - 1;
 	prev_extent_end = range_start;
 
 	btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cached_state);
@@ -710,7 +710,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
 
 		/* We have in implicit hole (NO_HOLES feature enabled). */
 		if (prev_extent_end < key.offset) {
-			const u64 hole_end = min(key.offset, range_end) - 1;
+			const u64 hole_end = min(key.offset - 1, range_end);
 
 			ret = fiemap_process_hole(inode, fieinfo, &cache,
 						  &delalloc_cached_state,
@@ -812,10 +812,10 @@ static int extent_fiemap(struct btrfs_inode *inode,
 	if (!stopped && prev_extent_end < range_end) {
 		ret = fiemap_process_hole(inode, fieinfo, &cache,
 					  &delalloc_cached_state, backref_ctx,
-					  0, 0, 0, prev_extent_end, range_end - 1);
+					  0, 0, 0, prev_extent_end, range_end);
 		if (ret < 0)
 			goto out_unlock;
-		prev_extent_end = range_end;
+		prev_extent_end = range_end + 1;
 	}
 
 	if (cache.cached && cache.offset + cache.len >= last_extent_end) {
-- 
2.54.0

