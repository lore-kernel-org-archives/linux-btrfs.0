Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 718E4393DDD
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773954314; cv=none; b=KwmNVvqiHiouGvhkdnhPnsXD4byXRkUgJZw647CMBQ9oigUwzrPrBiU+Gw9UfD85u9kewMoifNt5UCd+oUCuJsa+Pdkxc2657IXLjxq+bpXzmaGG4NhskZl7qO43AktPh6VPkLG6W/2xIRLzbQxYkQHq059A2AFUzMc7bsuAeVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773954314; c=relaxed/simple;
	bh=X36yW+6BFtNr5gss7XlANIaMaVr1lH1i5948X//crig=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ihgT7UMjx1a8FU9aBkdkASB6fBSgQysckvkvr3kkDIqZtBohVfwOb+nMW0x2FYwXB0YmRI8qz/uS1H4DCUkMhCPAI/hKybMkerDL1Onrs4UItXqCvXwtoh+6bVmz+DZwJOM7yQKJQwhY9bS1e3tNeIUQ0F24dwujgUom9/mRLBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ErTnizwz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IY4LNFvH; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ErTnizwz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IY4LNFvH"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A71424D414
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773954310; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/uv/qlWiz9sZY8WUXMNhvVScfK1o7H9jtrvT9nAW1B4=;
	b=ErTnizwzS295shlLjo4hrQRuYDssAPpT2zdRUl63Qhbzuf5MXL6NJyjztpnNcAi1knErp6
	YIKPOurrydT+nCGbL2PYOXo3qgmD9FTOD8obBORhY0Lg4U8/NxygNvTBGF2iipAxVFgzcd
	FP/tlHiYwuFi3D5T+mCHsKwCu5BAD40=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=IY4LNFvH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773954309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/uv/qlWiz9sZY8WUXMNhvVScfK1o7H9jtrvT9nAW1B4=;
	b=IY4LNFvHdS2h+qdWvW4b7K+rON2piEI14NvXDL9mu/R1O+RyF/orRTevggiu6buncjI0pg
	JOiZeGgs1qpJWkxHbSzRPI5JZKlRaODP5+fr4ELZqtswDGMpohs7c5AI7oq45+LHyY3xqG
	C36/7MW2NTCtLECNdrI5efxWLhr2pAs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7E194273B
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cD2MFQRlvGk5FAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2026 21:05:08 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] btrfs: delay compression to bbio submission time
Date: Fri, 20 Mar 2026 07:34:44 +1030
Message-ID: <cover.1773953307.git.wqu@suse.com>
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: A71424D414
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[CHANGELOG]
PoC->v1:
- Fix the ordered extent leak caused by incorrect ref count of child OEs
- Fix the reserved space leakage in ranges without a real OE
- Fix the hang caused by incorrect extent lock/unlock pair
  All exposed by fsstress runs

- Fix the OE range check in btrfs_wait_ordered_extents() that affects
  snapshot creation
  All exposed by fstests runs

[BACKGROUND]
Btrfs currently goes with async submission for compressed write, I'll go
the following example to explain the async submission:

The page and fs block sizes are all 4K, no large folio involved.
The dirty range is [0, 4K), [8K, 128K).

    0  4K  8K                                        128K
    |//|   |/////////////////////////////////////////|

- Write back folio 0
  * Delalloc
    writepage_delalloc() will find the delalloc range [0, 4K), and since
    it can not be inlined and too small for compression, it will be go
    through COW path, thus a new data extent is allocated, with
    corresponding EM/OE created.

  * Submission
    That folio 0 will be added into a bbio, and since we reached the OE
    end, the bbio will be submitted immediately.

- Write back folio 8K
  * Delalloc
    writepage_delalloc() find the delalloc range [8K, 128K) and go
    compression.
    Instead of allocating an extent immediately, it queues the work into
    delalloc_workers.

    Please note that the range [8K, 128K) is completely locked during
    compression.

  * Skip submission
    As the whole folio 8K went through async submission, we skip bbio
    submission.

- Write back folio 12K
  We wait for the folio to be unlocked (after compression is done and
  compressed bio is submitted).
  When the folio is unlocked, the folio will have writeback flag set and
  its dirty flag cleared. Thus we either wait for the writeback or skip
  the folio completely.

  This step repeats for the range [8K, 128K).

AFAIK the async submission is required as we can not submit two
different bbios for a single compressed range.
Which is different from the uncompressed write path, where we can have
several different bbios for a single ordered extent.

[PROBLEMS]
The async submission has the following problems:

- Non-sequential writeback
  Especially when large folios are involved, we can have some blocks
  submitted immediately (uncompressed), and some submitted later
  (compressed).

  That breaks the assumption of iomap and DONTCACHE writes, which
  requires all blocks inside a folio to be submitted in one go.

- Not really async
  As the example given above, we keep the whole range locked during
  compression.
  This means if we want to read a cached folio in that range, we still
  need to wait for the compression.

[DELAYED COMPRESSION]
The new idea is to delay the compression at bbio submission time.
Now the workflow will be:

- Write back folio 0
  The same, submitting it immediately

- Write back folio 8K
  * Delalloc
    writepage_delalloc() find the delalloc range [8K, 128K) and go
    compression, but this time we allocated delayed EM and OE for the
    range [8K, 128K).

  * Submission
    That folio 8K will be added into a bbio, with its dirty flag removed
    and writeback flag set.

- Writeback folio 12K ~ 124K
  * Delalloc
    No new delalloc range.
 
  * Submission
    Those folios will be added to the same bbio above.
    And after the last folio 124K is queued, we reached the OE end, and
    will submit the delayed bbio.

- Delayed bbio submission
  As the bbio has a special @is_delayed flag set, it will not be
  submitted directly, but queued into a workqueue for compression.

  * Compression in the workqueue
  * Real delalloc
    Now an on-disk extent is reserved. The real EM will replace the
    delayed one.
    And the real OE will be added as a child of the original delayed
    one.
  * Compressed data submission
  * Delayed bbio finish
    When all child compressed/uncompressed writes finished, the delayed
    bbio will finish.

    The full delayed OE is also finished, which will insert all of its
    child OEs into the subvolume tree.

This solves both the problems mentioned above, but is definitely way
more complex than the current async submission:

- Layered OEs
  And we need to manage the child/parent OEs properly
  But still it brings the minimal amount of changes to the existing OE
  users, and keep the scheme that every block going through
  extent_writepage_io() has a corresponding OE.

- Possible extra split
  Since the delayed OE is allocated first, we can still submit two
  different delayed bbio for the same OE.

  This means we can have two smaller compressed extents compared to one,
  which may reduce the compression ratio.

- More complex error handling
  We need to handle cases where some part of the delayed OE has no child
  one. In that case we need to manually release the reserved data/meta
  space.

Qu Wenruo (6):
  btrfs: add skeleton for delayed btrfs bio
  btrfs: add delayed ordered extent support
  btrfs: introduce the skeleton of delayed bbio endio function
  btrfs: introduce compression for delayed bbio
  btrfs: implement uncompressed fallback for delayed bbio
  btrfs: enable experimental delayed compression support

 fs/btrfs/bio.c          |   1 +
 fs/btrfs/bio.h          |   3 +
 fs/btrfs/btrfs_inode.h  |   3 +
 fs/btrfs/extent_io.c    |  29 ++-
 fs/btrfs/extent_map.h   |   9 +-
 fs/btrfs/inode.c        | 492 +++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ordered-data.c | 181 +++++++++++----
 fs/btrfs/ordered-data.h |  14 ++
 8 files changed, 678 insertions(+), 54 deletions(-)

-- 
2.53.0

