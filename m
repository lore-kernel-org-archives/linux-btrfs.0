Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475476;
	b=DJ+Guos3m8mwTuGurAqUIV071zdmIUbUkYRzrJM3UN8NhaQYejZVlOAQkkfPXCezV37r
	 WRvrfgJsGP4xQYWuJI3oF+/e8ZH4Sz8DzimpA/0FHlng/ec+orgS/PMiNIBG16cVYdgC7
	 Lx4wx3NRNz+nDBDQHrNKUkpP/gFxWsfvJ8NGPLh8xuHoXNHfBT8U7lA8/JCgtarrDor8d
	 kDrCfKb8eXZ6XGDQL58PFdYA5CZzYvVNuFusWvJPvsQHbnUa6mGtYGrqFG+WzVKJfdjdv
	 xl8J2n4gQWMbf1ft7gXVIyXciJu1+aJX4fTAX7Qu2WGcah+2Suna+WAxWaGagaowYQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475476;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=8myXmSaWQNRpalQvMr/6/3RD7WKOGizXNA3/wowyLR4=;
	b=maTtUkSbkxQ+J/3ZBKHwZLnuj8mbilsTh0P0EmUqYpphT3MF3tlub9TT/KcSX2WX9y/h
	 IGbOKxvvbgYKBOmjsMaD08OxKWZLJ+3XF6JuyqxKgrpfilUFk6Zzcf4GsOT7SZ44ZscdF
	 dSl0fi0YcQJDqMd/JYcMjJ7dRat0QHKM+5ZoICKfU4Y+1el+xLmYuufmr1t0wXbs6Z8uM
	 n1l7++Qm+oSFtUsSLKdTjRofYRQRGRFit+HPTtAuuJ31hiRGBs7jpe0ngLvCW+othwuUs
	 5UOXAuudXe+9oZRRlPAHGkKS3c31ibApA0gBSya0APt/yAdA0lJmCFWx411y8601AbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ICqZwKCL;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ICqZwKCL;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA8D606A693
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7AA8D606A693
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ICqZwKCL;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ICqZwKCL
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B90D81F88F
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795475470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8myXmSaWQNRpalQvMr/6/3RD7WKOGizXNA3/wowyLR4=;
	b=ICqZwKCLwVNEKH+GvcF+j2BEpkADNubwohO/eFen3XEwrpf41BzRjqbttSXe0FNCsAQ7nH
	ttmVZFyblf6lR0SDYQ3QNg7N/TJePfjK9I1KAA7mxR5iVNfHIjDiRtqb9bqaa4NyNVwJM+
	5hL39e3q9HWDKxjeFDXWW+8y0tzpJRQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795475470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=8myXmSaWQNRpalQvMr/6/3RD7WKOGizXNA3/wowyLR4=;
	b=ICqZwKCLwVNEKH+GvcF+j2BEpkADNubwohO/eFen3XEwrpf41BzRjqbttSXe0FNCsAQ7nH
	ttmVZFyblf6lR0SDYQ3QNg7N/TJePfjK9I1KAA7mxR5iVNfHIjDiRtqb9bqaa4NyNVwJM+
	5hL39e3q9HWDKxjeFDXWW+8y0tzpJRQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 86CC813505
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PLMLMwzIBGtlZQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 23:11:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: error handling improvement to btrfs_backref_error_cleanup()
Date: Tue, 24 Nov 2026 09:40:44 +1030
Message-ID: <cover.1795475376.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.1
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

The first one is a case where erroring out halfway can be problematic,
change it to validate before anything else.

The second one is reported by Sashiko.

Qu Wenruo (2):
  btrfs: make btrfs_backref_finish_upper_links() fail before touching
    the cache
  btrfs: fix leaked backref nodes in btrfs_backref_error_cleanup()

 fs/btrfs/backref.c | 92 ++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 49 deletions(-)

-- 
2.56.1

