Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B6E392C5B
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2026 08:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773734827; cv=none; b=MQsklHP+BHDOUVxhuk231ZoBFishE+HM4/M22OvNLicC24qXWn9uS+ZU0HTdWJav7ADMcbry7aeejpx3Qz3RSm9OWeOyXHAVz5ZDfP9SiVNC925CDmxKZiDrtqmplmg5G20SpznL4kyQEEYKwpNZ9E0NhuVbQEv0+lmbg7iZuUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773734827; c=relaxed/simple;
	bh=fZsWJUbPmEiQjGoupJPmo7dmbljlbIYsM0Mp40acSmg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mh9Wk5N1CSxjDcPpvS0Wf2QJMuwIXr9vSOPyVsnuiBs1cMErQjmm9tttfkWvlcSDS5nzfZpn0/SAz9fxWKwF9UQB+rKyG2eJEVkPoBJobVqDqt0Y0wgyo3NcFRPzObVg5j7rP4D3xqz040zMwwySwfFxgqPoA0RCMi6WGMmjyTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XTWlESlj; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XTWlESlj; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XTWlESlj";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XTWlESlj"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ACCD85BCFD;
	Tue, 17 Mar 2026 08:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773734817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7WbneBgTR6+0lgMtlPXk1kP8Y9ntcRev0lKTMxRKV4E=;
	b=XTWlESlj0+AYX07lZ7aeIpvlRIa26HozJWb0h+hQaCsqLTnjzrWp2yCWnYL3j7zt5HNX1g
	wDHgLNy362w2sZwWtgOXQqyijUuLxe/eOTNXcLtfISgNLkc+hxWEb+LGf9Hj1KCTfBzVO6
	4kFKU54MFuBqqQo0pfWq/vH5+CdbqLk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773734817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=7WbneBgTR6+0lgMtlPXk1kP8Y9ntcRev0lKTMxRKV4E=;
	b=XTWlESlj0+AYX07lZ7aeIpvlRIa26HozJWb0h+hQaCsqLTnjzrWp2yCWnYL3j7zt5HNX1g
	wDHgLNy362w2sZwWtgOXQqyijUuLxe/eOTNXcLtfISgNLkc+hxWEb+LGf9Hj1KCTfBzVO6
	4kFKU54MFuBqqQo0pfWq/vH5+CdbqLk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC6D34273B;
	Tue, 17 Mar 2026 08:06:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fnpwG6ALuWlHUQAAD6G6ig
	(envelope-from <wqu@suse.com>); Tue, 17 Mar 2026 08:06:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2] block: reject zero length in bio_add_page()
Date: Tue, 17 Mar 2026 18:36:34 +1030
Message-ID: <bc2223c080f38d0b63f968f605c918181c840f40.1773734749.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

The function bio_add_page() returns the number of bytes added to the
bio, and if that failed it should return 0.

However there is a special quirk, if a caller is passing a page with
length 0, that function will always return 0 but with different results:

- The page is added to the bio
  If there is enough bvec slot or the folio can be merged with the last
  bvec.

  The return value 0 is just the length passed in, which is also 0.

- The page is not added to the bio
  If the page is not mergeable with the last bvec, or there is no bvec
  slot available.

  The return value 0 means page is not added into the bio.

Unfortunately the caller is not able to distinguish the above two cases,
and will treat the 0 return value as page addition failure.

In that case, this can lead to the double releasing of the last page:

- By the bio cleanup
  Which normally goes through every page of the bio, including the last
  page which is added into the bio.

- By the caller
  Which believes the page is not added into the bio, thus would manually
  release the page.

I do not think anyone should call bio_add_folio()/bio_add_page() with zero
length, but idiots like me can still show up.

So add an extra WARN_ON_ONCE() check for zero length and rejects it
early to avoid double freeing.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Changelog:
- Rewords the commit message
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

