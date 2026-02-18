Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046CA2F3C26
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2026 10:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771409186; cv=none; b=KDYU8YKUtusMVrF+UCbs27L3w8QNea95ivrFKJCNSa1r55Hr23rard0Hn1NVIRMA5ktT3d5zk8MZxjYVHxyH8bFEGBftYwdADNCp7NvhSMoZhIf5S7+rbF1oVhxUA2b+fqFts8LPnorGa1I/0tcF3Q+jeptDstoMTlWSj5WulNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771409186; c=relaxed/simple;
	bh=izoFz5EhTPH/Ek+LW0auL1w41eXty1M4ehFi69ctgFA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ctzp6bOSZgJPm9k9xjbH7u9boZVUwo2PEHZL7ACfvGuED4WGVQUXpbdqrEHi7iYEQNVd26aGUQFokPL1sG8JM/ZU751SXDGlnMmWWYMLgMd3RuCAdIStA91jwcKVfeWqhqiCluJOZweMiA/UWuONtFfldK7gD02NEnrol1UN4nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dIlx/M51; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dIlx/M51; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dIlx/M51";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dIlx/M51"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 303A03E6D2
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2026 10:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771409183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1ZRElEJT+IcDKW4iSLjeu7O8/LRBj2Mas6R91wVQx5A=;
	b=dIlx/M51rDRd5ht+Qtzj4ibpNSohm+xeeMuqQ3hRyW5xSXqus/TS/yUsKDyz/7sJ8RS5Bi
	SvYDv83HQA/NHDGviuXXDnfpeg24whhgZ4/Nwff5+vBG8wduNrBVMFRIIRG+J7FUcKtpRO
	SvDXGAmgvRCkCtNwJIZ3MkHpCu5+HwY=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="dIlx/M51"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771409183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=1ZRElEJT+IcDKW4iSLjeu7O8/LRBj2Mas6R91wVQx5A=;
	b=dIlx/M51rDRd5ht+Qtzj4ibpNSohm+xeeMuqQ3hRyW5xSXqus/TS/yUsKDyz/7sJ8RS5Bi
	SvYDv83HQA/NHDGviuXXDnfpeg24whhgZ4/Nwff5+vBG8wduNrBVMFRIIRG+J7FUcKtpRO
	SvDXGAmgvRCkCtNwJIZ3MkHpCu5+HwY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 648183EA65
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2026 10:06:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id atNACh6PlWluDQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Feb 2026 10:06:22 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs: fix all bugs introduced in the compressed_folios[] removal
Date: Wed, 18 Feb 2026 20:36:00 +1030
Message-ID: <cover.1771409004.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
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
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 303A03E6D2

I'm a total idiot, that my usual 64K page sized arm64 VM is configured
back to use 4K page size for bs > ps runs, but forgot to revert the
config back.

This makes all recent arm64 runs use 4K page size, making it almost
no different than x86_64 runs.

This means the recent compressed_folios[] cleanup is not really properly
tested for bs < ps cases at all.
Thus all the regressions are not properly detected during the
development.

In fact commit e1bc83f8b157 ("btrfs: get rid of compressed_folios[] usage
for encoded writes") introduced two bugs in just one go, one can even
lead to data corruption for bs < ps cases.

All bugs are caught by dded ASSERT()s, but some ASSERT()s are just
incorrect in the first place, like patch 2~4.

Meanwhile the first one can lead to data corruption if
CONFIG_BTRFS_ASSERT is not selected, thus it will need higher priority.

Again, very sorry for my super stupid arm64 kernel config error.

Will no longer run 4K page sized kernel on that VM any more, and deploy
a new VM for 4K page sized tests, with proper kernel string suffix to
indicate the page size in the future.

Qu Wenruo (4):
  btrfs: fix a bug that makes encoded write bio larger than expected
  btrfs: do not touch page cache for encoded writes
  btrfs: fix an incorrect ASSERT() condition inside
    zstd_decompress_bio()
  btrfs: fix an incorrect ASSERT() condition inside lzo_decompress_bio()

 fs/btrfs/compression.c | 11 ++++++++---
 fs/btrfs/inode.c       |  4 +---
 fs/btrfs/lzo.c         |  4 ++--
 fs/btrfs/zstd.c        |  2 +-
 4 files changed, 12 insertions(+), 9 deletions(-)

-- 
2.52.0

