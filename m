Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B6F1FBEA6
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 00:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780533013; cv=none; b=fQugaMGjoDnnRB030QyL0qqbilSno0j8tpZUkusVDgMFztDZMcgqIrE9F5C2C4CcU+cjtad9lkWlFn1tm1YxPeqjIGWg/I5xbp3ZdDog79PVptJoPdanR8za8JehTqNPPfPuPr7Qj4MXFQ/38HxukRZprsszz6rvpZKB6+AqgOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780533013; c=relaxed/simple;
	bh=fOFnl47Wg9rKtOgY1nPUYBCqb1LydW7DjFpv6R4x4Cs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=geVY6CsA5kmFbzTdaxb7uaEsGgqG6PgA9eSIvaMN37Jplcg0iTvVNKigrlJ2eFUZkX6zwvLfMeoRVuL88AXzhB13W6+E+s7xgzziV33VY0D1WJ2O6TO7p5zaCQSzInLmShDfaRir0npK92dIl8UhqK607I1HrDXxAFuSCKqBKFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oT1s511y; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=oX94b5ez; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oT1s511y";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="oX94b5ez"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8DEEA6AABB
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 00:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780533009; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CxfOp62KfErLG4kEBAcqpQ13m2RHh3eXQ9W8PUNOu20=;
	b=oT1s511y/E/nr1Otybb4jC0R07gnqOfqOqy9ih4NqdHtnybR6Vf4NDuz/+raY1cYNVBZxM
	V4TeJA0ehfMZYrXd2UdMS/heW9n2zf6M2KoZfGmsoddSrFaprHVaWdec8TKGUoN+QShQya
	4W5tj2bZEt4J2DByJkw0LL0zJpQrWcc=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=oX94b5ez
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780533008; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=CxfOp62KfErLG4kEBAcqpQ13m2RHh3eXQ9W8PUNOu20=;
	b=oX94b5ezQa6qZCfQcImVZbAzkAEohFJN66UNRNyoTJA15G1SYLc++raMIjqTlI4ej1QP0J
	sbV8n3FKpfL5fqLJJVZA7Q7xyoB9V8GBTnwCYWNHknKsE39bORxXlEYoOc48Px6Hg5a6m1
	R9jczjVp6ZS+1+JQzN3zQ9TtQL4Z4B0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 88191779A8
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Jun 2026 00:30:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YoaNDQ/HIGqsVgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 04 Jun 2026 00:30:07 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/3] btrfs: fix generic/362 failures with nodatasum
Date: Thu,  4 Jun 2026 09:59:45 +0930
Message-ID: <cover.1780528155.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 8DEEA6AABB
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim];
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
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Changelog
v3:
- Change the timing of isize revert to avoid race with buffered read
  Normally we need to take extent lock to update isize, but in this
  particular case, the ordered extent we're holding acts like an extent
  lock, thus we are safe to modify the isize as long as the OE is not
  finished.

- Add a comment on why it's safe to revert the isize

- Explain that the isize revert is not perfect
  We should hold the extent lock until endio/iomap_end, and only update
  the isize for a successful submission.

  But that will require quite a lot of extra work, and should be done
  later by a dedicated series other than a short fix.

v2:
- Add a new patch to allow retry after no byte is submitted for direct
  write

- Add a more clean callchain to explain why __iomap_dio_rw() doesn't
  return -EFAULT/-ENOTBLK directly.

- Add a code comment explaining the OE split sitation and why we can
  truncate all the remaining OE after a short write

- Fix the isize revert when part of the direct write succeeded

- Dig deeper into the original cause
  Which is very old, dates back to v5.15 LTS at least, and add a reason
  why no specific fixes tag is provided.

The test case generic/362 is pretty well hidden by several factors:

- "nodatasum" will not take effect due to the bad design of the test
  case
  If the target file already exists, the test case will reuse it,
  meanwhile "nodatasum" mount option only affects new files, meaning
  if the test case is executed before with data checksum, it will never
  go through the nodatasum path.

  There is already an update on the test case to make the failure
  reliably reproducible:
  https://lore.kernel.org/linux-btrfs/20260528111659.87113-1-wqu@suse.com/

- Btrfs always falls back to buffered IO if the inode has csum
  Thus we do not exercise the zero-copy path, hide the failure for the
  default mount option.

With that said, the test case failure needs to be fixed, and there are
several bugs in the direct write path:

- Treat any short write as an error
  This is especially common as we have disabled page faulting for
  reading from the @from iov_iter.

  This is fixed by the first patch.

- No isize rollback after a short write
  The isize is increased at btrfs_get_blocks_direct_write() but when a
  short write happened, the isize is not propoerly rolledback, causing
  later buffered fallback to write at the new isize.

  This is fixed by the second patch.

- No page fault-in retry after a zero-submitted short write
  Unlike the previous two, this is only a minor problem which reduces
  the chance to do zero-copy direct IO.

  This is fixed by the third patch.


Qu Wenruo (3):
  btrfs: fix false IO failure after falling back to buffered write
  btrfs: fix incorrect buffered IO fallback for append direct writes
  btrfs: retry faulting in the pages after a zero sized short direct
    write

 fs/btrfs/direct-io.c    | 62 +++++++++++++++++++++++++++++++++++++----
 fs/btrfs/inode.c        |  6 +---
 fs/btrfs/ordered-data.c | 12 ++++++++
 fs/btrfs/ordered-data.h |  2 ++
 4 files changed, 72 insertions(+), 10 deletions(-)

-- 
2.54.0

