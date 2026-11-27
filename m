Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795770586;
	b=LdiGWbMPaXlj8TorATcuTE0pkHxfar7mNK6tscgb0No+r36TPpeC4+lYWXxLXYEE66g5
	 X5MhYU5Wq8/iTpONQrzr/yfwSIUFrUiv9gYXO3CoFDNIFHh3oi3VpOkC2SsiUtXMcEL19
	 pmptqzxieH1cVp8stlQm8Tv8FNVnLu2y57ohC5UXzyXX7WF82eRQRu/XS4Zdc+r3nHO6t
	 atR4xpcHpJXXR/DH9gSByT9XrExbOvlt5YJR6/VEEjdS5D6Nlx6IFPo/SWXjW020f372R
	 AIMq5U+K51bVZjntpB7eddyqisk7BoQLmA/fewa/LrY5wvJ4vHA5yeNTbLGKWZek9Mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795770586;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=cLKF4EcYEjWhoMdWJsYcN7MHJIbXuo2uEvp8+lV+IQ0=;
	b=IJCrt2vohqWJS/i9x/QceggW+sTB/vycSQlt7XtEAfnrvuBgHNtXzi2IsQ1CRxFEeupc
	 ECDFPJ+P/SuG6jOHZlmpxQR1QQMVpvQYFfK3394ydAlgPH/xU1mh/dJbKTtx2mRPGi+Ix
	 OL/4ZAX4laD3LjT5HEMk39uIazI4uieYJQOUFKTQ3PMcVBD6TjgndujObnX7li0uhj4MQ
	 BJrrp/oQX2dAJsbb/RR3KE4BVWKy2wsXHUI3RdXanQqPOvXLmtNNi15i2IUE79l1IoRZe
	 t1QmRvjGFjLYFsFnCvCleUMmy3V0ioNpEerhrfzow1Ntf/Umfu+ko6PZ9zIY5E3vueQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fobCm1kp;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fobCm1kp;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37323606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37323606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fobCm1kp;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fobCm1kp
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 794E52277B
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795770577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cLKF4EcYEjWhoMdWJsYcN7MHJIbXuo2uEvp8+lV+IQ0=;
	b=fobCm1kpI6F12vxSNXTpPUBWRceqKlfNwJwaWXBUBGOI+dfxUhbF1x1a/ibyqEfKcv5+UA
	raQH1458ALd0IPQSewTcWnD4c2J9cSQLE3Xd8cONygnE1n0kBBn7DmOOXWZO1vgWjDBCbo
	Dw1Eu08+ARWcdxwucW5dJTIgk8+dNa0=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=fobCm1kp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795770577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cLKF4EcYEjWhoMdWJsYcN7MHJIbXuo2uEvp8+lV+IQ0=;
	b=fobCm1kpI6F12vxSNXTpPUBWRceqKlfNwJwaWXBUBGOI+dfxUhbF1x1a/ibyqEfKcv5+UA
	raQH1458ALd0IPQSewTcWnD4c2J9cSQLE3Xd8cONygnE1n0kBBn7DmOOXWZO1vgWjDBCbo
	Dw1Eu08+ARWcdxwucW5dJTIgk8+dNa0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 545D5134E8
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KmCXKM9ICWu6BwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2026 09:09:36 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/3] btrfs: prepare and move async csum generation out of experimental feautres
Date: Fri, 27 Nov 2026 19:39:14 +1030
Message-ID: <cover.1795770362.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 794E52277B
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim]
X-Spam-Score: -12.01

[CHANGELOG]
v3:
- Rebased to the latest for-next branch
  Which has all the extra ordered extent IO waiting to address the
  possible race with fast fsync.

- Update the last patch to show more reasons why the existing metadata
  csum offloading is not beneficial

v2:
- Introduce a patch to fix a potential data loss with async direct
  writes
  This is an existing bug, not only affecting the async data csum
  generation. Introduce a dedicated fix for it.

- Introduce a patch to fixx an ASSERT() false alert race
  Again an existing bug.

For the last iteration, the only remaining concern is the fast sync path
race with async data csum generation.

That is already fixed by Josef's fixes that added extra ordered extent
IO wait, so it's no longer a problem.

Now there should be no more blockage for enabling async data csum
generation.

Qu Wenruo (3):
  btrfs: fix an ASSERT() race with async csum generation
  btrfs: make btrfs_fs_info::workers to be a regular workqueue
  btrfs: move async data csum generation out of experimental features

 fs/btrfs/Kconfig     |   2 -
 fs/btrfs/bio.c       | 139 +------------------------------------------
 fs/btrfs/disk-io.c   |  47 ++++++---------
 fs/btrfs/file-item.c |  15 ++---
 fs/btrfs/file-item.h |   2 +-
 fs/btrfs/fs.h        |  17 +-----
 fs/btrfs/super.c     |   2 +-
 7 files changed, 32 insertions(+), 192 deletions(-)

-- 
2.56.1

