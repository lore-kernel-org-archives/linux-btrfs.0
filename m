Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18D8248166
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 02:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773368778; cv=none; b=EXGJxRMolW845HlkaGv0WEon2HIzJ/mfRzC2LoqYWcjMlg0fp452wyEW+K1a/RU2oQrE1mUtU6ENCklOYi6lKG01lX+Q/v8pwnQ7/TTq7veW6FO5sRxQ2AO0NHJavQVOhaAVtw8twAmARsHM3ztvD15OG0JQFtSsu4yWvuLJrBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773368778; c=relaxed/simple;
	bh=Hm5jpoPT9BrYcpXJ0gxIk4hBg6IkiZnU/bFMPU1r8b8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=i/J931l+Vs7k3+3cAgNTM/5HoKHUvL5eymwwZNh0bajRHQX2RfzBnAVNG1sPuXr2nLWmpereDqrOKIzCOEUekH+3YH4sBzaIjzQv8x3M9VgL0HXyyAJ9W8hhZLxQcdp+s1H6sMnFNgl7vWpd88/bLcLmSa0nbDsrEFnI4E/06oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=vNl1cdMR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jDTvSneP; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="vNl1cdMR";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jDTvSneP"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 179424E074;
	Fri, 13 Mar 2026 02:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773368775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PWlCkTT4olomkKZRyvwvUxLdDzvznCdm856iBmHiu/c=;
	b=vNl1cdMR3azhio4GFei/d6pY350Zl4t4YgK2CjMoh6NifDNL3XGCdBbbxPnRJmpfL2WydK
	DiwvGEQb8ASfk3Suy+RoOAYFj7WpKjMuQ6eD1Op81y+WoW8kql9YAW3zDe7Bdhxob9RAO+
	NPXhbGWm5girM8/UBKcps648d9RETso=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jDTvSneP
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773368774; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PWlCkTT4olomkKZRyvwvUxLdDzvznCdm856iBmHiu/c=;
	b=jDTvSnePuSdEd7bvwHdlUcqBhAyA+ek1yIQ4Bv6ZUkpjSj0Edfc2bm9xizc+x295RdYqh0
	a9dqZx+J4RMB65e1OfWYso0Jy9OAVXRSjmn0QYqXjqB/wtqnim4gTIuVrNdw4/tvC7C8Yg
	zj/FtvvQ0oZWfASgvFRu03KNuELyncU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 172C1402B4;
	Fri, 13 Mar 2026 02:26:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x6WzMsR1s2lXVQAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 13 Mar 2026 02:26:12 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH] block: reject zero length in bio_add_page()
Date: Fri, 13 Mar 2026 12:55:55 +1030
Message-ID: <f3db373bad065ae6251892acd15993f5dd56dfe1.1773368732.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
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
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 179424E074

[BUG]
I caused a regression in btrfs where an incorrect check leads to
a bio_add_folio() call with a zero length.

Then btrfs goes through the error handling, including:
- Freeing the folio
- Freeing every folio inside that bio

But that can lead VM_BUG_ON() on the last folio.

[CAUSE]
When calling bio_add_folio()/bio_add_page() with zero length, the folio
can still be added to the bio as long as there is a free bvec slot or
can be merged with previous folio/page.

Then bio_add_page() return @len, which is 0.

Normally this means an addition failure, but this time the folio is
already queued into the folio.

This can easily confuse the caller, as for normal failure cases both the
folio and bio should be cleaned up.
But since the bio has the last folio queued in already, this leads to
double folio freeing.

[FIX]
I do not think anyone should call bio_add_folio()/bio_add_page() with zero
length, but idiots like me can still show up.

So add an extra WARN_ON_ONCE() check for zero length and rejects it
early to avoid double freeing.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 block/bio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index d80d5d26804e..6048d9382fec 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1064,6 +1064,8 @@ int bio_add_page(struct bio *bio, struct page *page,
 {
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return 0;
+	if (WARN_ON_ONCE(len == 0))
+		return 0;
 	if (bio->bi_iter.bi_size > BIO_MAX_SIZE - len)
 		return 0;
 
-- 
2.53.0

