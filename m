Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE9734E774
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 04:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775622363; cv=none; b=TLC7yfZdH26zJIaOF4svGBFu2JXb/eqackOP7+mF9Q5hwsk1VCOARum+Znv6sWFdRtWzl78kNuShPQ255UItYNuFlx8WnS6X3plDNVwKvTTt0BnSLG6IjXm1MxDTv7+Od21+X813soUZvV9yvoaKiPqVVj3f+i3hnxajgb4uVSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775622363; c=relaxed/simple;
	bh=WJyfLRMX/OlY4B4LpjFz/jQp+1JV/mnr9GQkQL1CI8A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qFNhugHK3JqHkx/dikCnnG5WuvbtYeMx4IaktGWXKyJ4G8Uw6j/zQt1qN36epmhZ/TIVJCt7KjBFx/aDbgfYbLpdDji2JrLwm/mnwRtGAzpdvqkB/kEFxREPW0na9p4Clnfwqo/cl6zDiQNfpfRhllOGxUYQJWrMAzgWKd8A1lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GedUlcYB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=c+VQAMyO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="GedUlcYB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="c+VQAMyO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 813184E7E6
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 04:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775622356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NSFJj+77cdb+8L04X6hrKVqf+BPAiR12edzVndlxEnU=;
	b=GedUlcYB/ZVt41TgmAoKgx2VI1V6uXET2bY1Ofz2SxBH0TI3ROWodN/lxJjePkUOZkN/UZ
	IVjzyIHzKo8c0EoWBNVYTmODbrmv3odZk7M0RgJ8DkW6A77KP534uzXDoTE/ObGfYpFgp/
	44Vno8gRCqRDCPyZOR5BzSla8ES8H9E=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=c+VQAMyO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775622352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NSFJj+77cdb+8L04X6hrKVqf+BPAiR12edzVndlxEnU=;
	b=c+VQAMyOyDZPWGVfwwmjEN9HJwoPcvhhv/uIeomXnFIPrc/lEQON6gYQTzLRQCb9AsKpRs
	jX79KOABklYeb6H1nwkdS6Me+aGUaam6vXLjSA7gzr41ygxC2yDnF7hUhwnNuPYjsHKxdB
	Bfv/V2YFRW3/7TvvaiPUmNO4ICxpyZg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7620E4A0B3
	for <linux-btrfs@vger.kernel.org>; Wed,  8 Apr 2026 04:25:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MzN7CM/Y1WklUAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2026 04:25:51 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: remove COW fixup and checked folio flag
Date: Wed,  8 Apr 2026 13:55:30 +0930
Message-ID: <cover.1775621833.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 813184E7E6
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

For experimental builds we're already rejecting dirty folios which
don't have ordered flags since v6.15.

Unfortunately we're not yet removing that COW fixup machanism for
non-experimental builds even at v7.0, as there are still some error
corner cases that can lead to dirty folios without ordered flags.

After those years of testing, we're sure we won't need COW fixup for
regular cases. Although I want to remove the COW fixup mechanism after
all known reproducible cases are fixed, I run out of ideas.

Furthermore for the future of huge folios (order 9, 2M page on 4K page
size systems), we can not afford the extra bitmap for a huge folio.
In that case, a huge folio will need 64 bytes per bitmap, which is no
longer a small amount.

I believe it's time to remove the COW fixup mechanism even for
non-experimental builds, along with the checked folio flags.

Qu Wenruo (2):
  btrfs: remove the COW fixup mechanism
  btrfs: remove folio checked subpage bitmap tracking

 fs/btrfs/defrag.c           |   1 -
 fs/btrfs/file.c             |  10 --
 fs/btrfs/free-space-cache.c |   4 -
 fs/btrfs/inode.c            | 204 +++---------------------------------
 fs/btrfs/reflink.c          |   1 -
 fs/btrfs/subpage.c          |  39 +------
 fs/btrfs/subpage.h          |   5 +-
 7 files changed, 17 insertions(+), 247 deletions(-)

-- 
2.53.0

