Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620942C11DB
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775150402; cv=none; b=CTm/hFYUhpIKfif5DfI3wfLtliFsNZg63p3xpueI5pRLym/cJVf1IHXN+vRGx5jlXjLtor+KCoJ+ytF99wLULiU5nsRDnsDok9OEQWht+7UkZTlJAdQfENt8s7zpbPE98Z8SN9BQn3LwTZKVlxycGginS/bnPt03SIApq5g0umo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775150402; c=relaxed/simple;
	bh=POInJvqKz7RwucNAPx5JUnzUXkkuIaivYJucdXdWN3A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QvsaEIr1YEg+8ocDzb/zTGV1cdYZ12jvWehUK+btYMcxIDGzW76ptsqh7qUZnQU8ulNMy/cN+SF4wjXMkq4ch/k90BOgjh9h2NqWwAvShPmpdsK5qVNghizsmDAToUJlBlYmfifgDzztO6bTdGL8G2ThOXGLwKZhGVamqyU1HtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V9ezaDKp; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V9ezaDKp; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V9ezaDKp";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V9ezaDKp"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C22BC4D2E5;
	Thu,  2 Apr 2026 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775150396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rdtP2C/g7jf8P/M1mCDfTlhVuM1isdmq0/bcFgIfgnU=;
	b=V9ezaDKpkwid2MAuIlztvOccETFiJiQQf5Wn251v/fmkIH6hlOKOrnt6O6X+gsKcS5Btob
	tRaa/m0VRxcUZptb9jqAeSREPJMWfChriq7Elab2NBCtKkeVNOAqpFpR0FrgmD7Uwmhk4L
	r7TQXJuhYChboXVZE8USwjFm6WDAIdQ=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=V9ezaDKp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775150396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rdtP2C/g7jf8P/M1mCDfTlhVuM1isdmq0/bcFgIfgnU=;
	b=V9ezaDKpkwid2MAuIlztvOccETFiJiQQf5Wn251v/fmkIH6hlOKOrnt6O6X+gsKcS5Btob
	tRaa/m0VRxcUZptb9jqAeSREPJMWfChriq7Elab2NBCtKkeVNOAqpFpR0FrgmD7Uwmhk4L
	r7TQXJuhYChboXVZE8USwjFm6WDAIdQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BAA914A0B0;
	Thu,  2 Apr 2026 17:19:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ODSHLTylzmm9RQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 02 Apr 2026 17:19:56 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fix for 7.0-rc7
Date: Thu,  2 Apr 2026 19:19:45 +0200
Message-ID: <cover.1775149839.git.dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C22BC4D2E5

Hi,

please pull one more fix for a potential extent tree corruption due to
unexpected error value. When search for extent item under some
circumstances fails it appears as success to the caller. Thanks.

----------------------------------------------------------------
The following changes since commit 1c37d896b12dfd0d4c96e310b0033c6676933917:

  btrfs: fix lost error when running device stats on multiple devices fs (2026-03-23 20:12:12 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc6-tag

for you to fetch changes up to 316fb1b3169efb081d2db910cbbfef445afa03b9:

  btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref() (2026-03-31 06:00:45 +0200)

----------------------------------------------------------------
robbieko (1):
      btrfs: fix incorrect return value after changing leaf in lookup_extent_data_ref()

 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
