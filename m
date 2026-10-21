Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792622953;
	b=Aoq1zJ7AruvUJ/ssT2PtDuLX3c1J0Y76EOracuNKjMn2DJixWyPLmEknGm3Kba1a+5Uf
	 mJ4sYeg+bkooxFch8sa680cFAC1kdc5y/D5nz0MQVwHPdQd10X1ZlfjVCXm8dUmQ98JIj
	 Rtw5cGLbqvczJbqGVcxKgCTBEjZVvzOD+WS4JtjxWFQhDCVbTlx9lsV1waJqlfjClRx/h
	 ItbFMh/+3MEvdmotuoQ5Z6rrWefeB7Z5Rho7+NylOSk+dR3eGYLCGxllb4+JGrTWgHKNR
	 T/iYNW0dWJ3P4z4U2MS0dymX6zX3whFaySJ0B0Zk7y+KCcpnsDEyzbwB2ASvafwlJOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792622953;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=Rt+IO2SSqg4UjxudtRnbglAGk3uMDolm7AeTyjKmU38=;
	b=W4LK6GwGWUa5HA0hvwPiMo/7gPaWRtuWp8r5Z+EcVs8ip1AcQWZ1mGYF7B/RJxTr0l3+
	 ITgdzMJIC0tk4xO8xPheXubxH3bJ3lw8qqKUUd+orZhRrSXZ0W9IxVUCiatbgUH7uBfJa
	 YxJIXcMABovwxFUHxZAfGlUhnZb6W6T9h7IgSQE5bsO08mrnpcEiANJ7PSg5HLEr2EuSr
	 4THEgLANpcO+XTN+NBhlHOVqQ8O9YqA4D+iiTufxvLr1zDguJ3zWl2zAqKBWsze4rDhSb
	 S7HmdHU5Hxzq7iuBhNAU/Cyzb2cPiBhH7LF1yEQjgcLzntry47tHN+rZx0drT2gm5pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hvoZASVn;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=szYDru4Y;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8C4606A31A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 22:49:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D8C4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=hvoZASVn;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=szYDru4Y
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DA53F21F5A
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 22:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792622951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Rt+IO2SSqg4UjxudtRnbglAGk3uMDolm7AeTyjKmU38=;
	b=hvoZASVnV3MulP1IIhCW1KToFvJxduco+pM50Rv/1QO0EwhcpopTLBfyfWcSFphWTtbGPv
	wbJeFmyixw6u81EYHF7fQKRkBDQVqBCpdS0xY3O/MG+y8lR3b52hk/pLXjpo/QoiAPv1w8
	/3b3+AVjq59fpyJJzTVIyJhyViB0Y4A=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=szYDru4Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792622950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Rt+IO2SSqg4UjxudtRnbglAGk3uMDolm7AeTyjKmU38=;
	b=szYDru4YP4NNpBjUUKhuEmd2U+oU8JM6pB+S/a2ipw8JY76jCWDqDXRGoCz8ZLqfZ4lgJ5
	vqOgI+QEyoh71WsygZltn83mdfUFoYGeS6euew45aLDIPu/gtCkvKxC80wgCW652w+jtQy
	S0Vq0nk6lHdCuFQe8EL4P6Z4w7ApMNQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD9AA134FD
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 22:49:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rDjXB2VB2WpmVwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2026 22:49:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove BUG*() from raid56.c
Date: Thu, 22 Oct 2026 09:18:47 +1030
Message-ID: <9ecefaae0a4bcb001d1fd8ed3c73b3fb2f5a7062.1792622924.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
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
X-Rspamd-Queue-Id: DA53F21F5A

There are several BUG()/BUG_ON() inside raid56.c, which cause
checkpatch warning if code is touching them. This is especially annoying
if using b4, with btrfs-workflow git hooks applied, which makes b4 to
wait for user input but without any output.

Address them by removing one very impossible BUG(), and using ASSERT() for
the remaining ones:

- __remove_rbio_from_cache()
- rbio_is_full()
- unlock_stripe()
  Replace the BUG_ON() with ASSERT().

- finish_parity_scrub()
  Remove the BUG(), as alloc_rbio() has already properly calculated
  real_stripes and nr_data using the number of parity.

  Furthermore, initialize @has_qstripe at the beginning of the function
  using the bioc->map_type directly.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/raid56.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 080be467c6fc..59aad807f98a 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -510,7 +510,7 @@ static void __remove_rbio_from_cache(struct btrfs_raid_bio *rbio)
 			if (!list_empty(&rbio->hash_list)) {
 				list_del_init(&rbio->hash_list);
 				refcount_dec(&rbio->refs);
-				BUG_ON(!list_empty(&rbio->plug_list));
+				ASSERT(list_empty(&rbio->plug_list));
 			}
 		}
 	}
@@ -634,7 +634,7 @@ static int rbio_is_full(struct btrfs_raid_bio *rbio)
 	spin_lock(&rbio->bio_list_lock);
 	if (size != rbio->nr_data * stripe_len)
 		ret = 0;
-	BUG_ON(size > rbio->nr_data * stripe_len);
+	ASSERT(size <= rbio->nr_data * stripe_len);
 	spin_unlock(&rbio->bio_list_lock);
 
 	return ret;
@@ -881,7 +881,7 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 		    test_bit(RBIO_CACHE_BIT, &rbio->flags)) {
 			keep_cache = true;
 			clear_bit(RBIO_RMW_LOCKED_BIT, &rbio->flags);
-			BUG_ON(!bio_list_empty(&rbio->bio_list));
+			ASSERT(bio_list_empty(&rbio->bio_list));
 			goto done;
 		}
 
@@ -2719,7 +2719,7 @@ static int finish_parity_scrub(struct btrfs_raid_bio *rbio)
 	unsigned long *pbitmap = &rbio->finish_pbitmap;
 	int nr_data = rbio->nr_data;
 	int sectornr;
-	bool has_qstripe;
+	const bool has_qstripe = rbio->bioc->map_type & BTRFS_BLOCK_GROUP_RAID6;
 	struct page *page;
 	phys_addr_t p_paddr = INVALID_PADDR;
 	phys_addr_t q_paddr = INVALID_PADDR;
@@ -2729,13 +2729,6 @@ static int finish_parity_scrub(struct btrfs_raid_bio *rbio)
 
 	bio_list_init(&bio_list);
 
-	if (rbio->real_stripes - rbio->nr_data == 1)
-		has_qstripe = false;
-	else if (rbio->real_stripes - rbio->nr_data == 2)
-		has_qstripe = true;
-	else
-		BUG();
-
 	/*
 	 * Replace is running and our P/Q stripe is being replaced, then we
 	 * need to duplicate the final write to replace target.
-- 
2.56.0

