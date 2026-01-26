Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C6328726D
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 03:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769397917; cv=none; b=Ml+LS5WsiHgJvdv2NRlZJQHZa39FVbjuKp6AUmPsGuKSjVIG4KhQwaLTw9QczJE9sEiD7LnVfLhRf9Xp9wpSbJ8aDjNn0pkHCb5zEfXyREfhKtIHw1z5aUmz3umvkPQyK6OcYhiU0thmqWiFwEJXz6TAvuYWj+qNTtEeSNEreqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769397917; c=relaxed/simple;
	bh=fcKl/9Puu5V5Qk5m893F/MFHYWxHO8Ppb+gYVWZrNAA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmOBaoLkaJrpZShqCEG0yPzQCvl5osEdEQczxIDvLUQ+tmUzUV+3ImwsVrrU9PJJhcyo5ggyB8A2OgIkbCI6WoVgcwm7dacbTyfP0xE48c4q8oDse4yoJ1nZYixC5MEQkXv6tB5nueEybWRisgmYSToe3w8IXgZzSCK70D0qcH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Fdf9WwiP; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Fdf9WwiP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Fdf9WwiP";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Fdf9WwiP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 073E93368A
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 03:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769397895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GTJffkD/e1lc+BNaEZQ8W6fnG8GefnGfMRM9olA8Alg=;
	b=Fdf9WwiP86oi0cLaL6HXEWHNULi6TuJpcAbotMeBjgcnyT/xLBNpXG0uqnPjwR9j7+oqvS
	hylTCQ4ZiuXf3N87Qgk8mtnp69hPnVug+dOQCrUfTpTppS+hXUdInCfrmYYT1yPcBIJjov
	Gj2zNo+tcHbv/ySjKI8rcsFmmPh9MtE=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Fdf9WwiP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1769397895; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GTJffkD/e1lc+BNaEZQ8W6fnG8GefnGfMRM9olA8Alg=;
	b=Fdf9WwiP86oi0cLaL6HXEWHNULi6TuJpcAbotMeBjgcnyT/xLBNpXG0uqnPjwR9j7+oqvS
	hylTCQ4ZiuXf3N87Qgk8mtnp69hPnVug+dOQCrUfTpTppS+hXUdInCfrmYYT1yPcBIJjov
	Gj2zNo+tcHbv/ySjKI8rcsFmmPh9MtE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F401E139E9
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 03:24:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kBRWKIXedmneXgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2026 03:24:53 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] btrfs: get rid of compressed_bio::compressed_folios[]
Date: Mon, 26 Jan 2026 13:54:16 +1030
Message-ID: <d2c928a93990b361e9e11c758fa7dc42a19fc630.1769397502.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769397502.git.wqu@suse.com>
References: <cover.1769397502.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 073E93368A
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Level: 

Now there is no one utilizing that member, we can safely remove it along
with compressed_bio::nr_folios member.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/compression.c | 2 --
 fs/btrfs/compression.h | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index c7e2a1fcf5f8..67db96629210 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -240,7 +240,6 @@ static void end_bbio_compressed_read(struct btrfs_bio *bbio)
 	btrfs_bio_end_io(cb->orig_bbio, status);
 	bio_for_each_folio_all(fi, &bbio->bio)
 		btrfs_free_compr_folio(fi.folio);
-	kfree(cb->compressed_folios);
 	bio_put(&bbio->bio);
 }
 
@@ -301,7 +300,6 @@ static void end_bbio_compressed_write(struct btrfs_bio *bbio)
 	/* Note, our inode could be gone now. */
 	bio_for_each_folio_all(fi, &bbio->bio)
 		btrfs_free_compr_folio(fi.folio);
-	kfree(cb->compressed_folios);
 	bio_put(&cb->bbio.bio);
 }
 
diff --git a/fs/btrfs/compression.h b/fs/btrfs/compression.h
index ecbcd0a8364a..4dcb75c78ade 100644
--- a/fs/btrfs/compression.h
+++ b/fs/btrfs/compression.h
@@ -42,12 +42,6 @@ static_assert((BTRFS_MAX_COMPRESSED % PAGE_SIZE) == 0);
 #define	BTRFS_ZLIB_DEFAULT_LEVEL		3
 
 struct compressed_bio {
-	/* Number of compressed folios in the array. */
-	unsigned int nr_folios;
-
-	/* The folios with the compressed data on them. */
-	struct folio **compressed_folios;
-
 	/* starting offset in the inode for our pages */
 	u64 start;
 
-- 
2.52.0

