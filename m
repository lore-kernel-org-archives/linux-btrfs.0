Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B551BC8EB
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778903143; cv=none; b=NwgRq7zH3s8L9SmbBHlxigST1kHI5x0rrYrCRv7zCIxriRQJFJuW8ymMbjAjwAYpLSTNnMU00EgDiIMk2xAhiE0SweygxrLSeqGxFFnCHPEolAlWXlX9M2Nh34zzaYB3S4eCXud+lYnplUMtBwOBfI6X56bb7ghBPsbGUkvQDPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778903143; c=relaxed/simple;
	bh=do82HZBgh2PEzMJEs+izGx664JQWqxVfzffB14UsQdA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=TThoDsL/P5dzOgqtZnZfiNZiG9ncm6z1bekDVzr2R9BFHffNSTRhjQCVng2/fBwJqb+yjWnDcjtMZpauSrnpHKz62SbNMI43Fe7LF6+YVLzbGbxblP2+7CXKGA5DzoyVR/B8bG8sk8hTvorX4t43rHXD7oP8oLPSDuIk3l9k8XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EptORGol; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EptORGol; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EptORGol";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EptORGol"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 700846AA2C
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778903138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nhmSVUBWWJnm3oQiXgO26ow9o2mxLYqH85LYnwXZj6k=;
	b=EptORGol7g0li/p8JzaSsU3yPwvVUunk3FkTZ1Ie5x0juxv6CxDes6tNK/wRrVbdCsgTpI
	hFIKzpMVhlqywYh2P2je1BgrsfuObiA40Jh0w8EkpYjnolXg/AyumgcvxOO3U/QtSsKHYK
	t7NyqpPe7l4FJqo1aNBN7xTXXEfrUQA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=EptORGol
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778903138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nhmSVUBWWJnm3oQiXgO26ow9o2mxLYqH85LYnwXZj6k=;
	b=EptORGol7g0li/p8JzaSsU3yPwvVUunk3FkTZ1Ie5x0juxv6CxDes6tNK/wRrVbdCsgTpI
	hFIKzpMVhlqywYh2P2je1BgrsfuObiA40Jh0w8EkpYjnolXg/AyumgcvxOO3U/QtSsKHYK
	t7NyqpPe7l4FJqo1aNBN7xTXXEfrUQA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8D4A593A8
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EFtmGmHoB2qdMQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 16 May 2026 03:45:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/6] btrfs: delay compression to bbio submission time
Date: Sat, 16 May 2026 13:15:13 +0930
Message-ID: <cover.1778902677.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 700846AA2C
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.01

[CHANGELOG]
v2:
- Rebased to the latest for-next branch
  Several minor conflicts:
  * The removal of folio ordered flag
  * The refactor of btrfs_mod_oustanding_extents()

- Fix a random failure in btrfs/260
  It turns out that the original filemap_flush() only triggers writeback
  of dirty pages, but since our new compression happens after the bios
  are submitted, there can be a race between inode->defrag_compression
  clearing and compression path reading inode->defrag_compression.

  This can cause btrfs to use the mount option other than the specified
  defrag compression algo to do the compression.

  Fix it by using filemap_write_and_wait_range(), which also avoids the
  quirky double flush behavior.
  
- Fix a use-after-free bug where bio->bi_status is accessed after
  bio_put()

- Remove a mapping_set_error() call when try_submit_compressed() failed
  As we still have uncompressed fallback, we should not set the mapping
  as error.

- Drop all allocated OEs along with the extent maps when
  run_delalloc_delayed() failed
  
- Slightly reword the cover letter

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
  No compression.
  * New OE for [0, 4K)
  * Submit bbio for [0, 4K)

- Write back folio 8K
  * Delayed compression/OE creation into a workqueue
    All folios in range [8K, 128K) is still locked.
  * Skip submission

- Write back folios at range [12K, 128K)
  * Wait for the folio to be unlocked.
    As the folio is only unlocked after the compression is done.
  * Skip submission
    As the folio is no longer dirty.

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
  No compression, the same as the old code.
  * New OE for [0, 4K)
  * Submit bbio for [0, 4K)

- Write back folio 8K
  * New OE for [8K, 128K)
    This new OE has a delayed flag, without a real data extent backing
    it.
    Then the folio range [12K, 128K) is unlocked, just like the the
    uncompressed writes.
    
  * Queue the folio into a bbio

- Writeback folio 12K ~ 124K
  * No new OE
    The existing delayed OE [8K, 128K) is already there.
 
  * Queue the folio into a bbio.

  * Submit the bbio
    As we have reached the OE end.

- Delayed bbio submission
  As the bbio has a special @is_delayed flag set, it will not be
  submitted directly, but queued into a workqueue for compression.

  * Compression in the workqueue
    As we do not want to delay the writeback of the remaining folios.
    Thus the compression should be done inside a workqueue.

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

This solves both the problems mentioned above, but is definitely more
complex than the current async submission:

- An OE no longer represents an allocated extent
  As we will have delayed OEs, which have no allocated space backing it.

  Thankfully this is not a huge deal. At ordered extent finish time, we
  just need to skip any reserved space handling for an delayed OE range
  that doesn't have a real OE covering it.

- Layered OEs
  And we need to manage the child/parent OEs properly
  But still it brings the minimal amount of changes to the existing OE
  users, and keep the scheme that every block going through
  extent_writepage_io() has a corresponding OE.

  The other solution to layered OEs is, to split OE at the real OE
  allocation time.

  But that has more corner cases than I thought:

  * The new real OE is exactly the same size as the delayed OE
    We need to either completely replace the delayed OE with the new
    real one, or copy the members from the real OE into the existing
    one.

    Either way, there will be a OE that needs to be put, and skip all
    the per-root OE tracking.
    Also need to properly handling the OE waiting behavior for the
    remaining one in the ordered tree.

  * The new real OE is at the middle of a delayed OE
    This is a corner case but can happen.

    In that case we need to allocate a new OE to fill the tailing part,
    and that new OE will also need to be added to the per-root OE list,
    with proper flags inherited from the old OE.

  All my local attempts to go that path, not only leads to more code
  but more error handling and very tricky OE splits.

  So I'm afraid the layered OE solution is complex, but less complex
  than the alternavive OE splitting method.

  At least for now, when only compressed writes are delayed, the layer
  solution still seems to be simpler.
  It may change in the future if we also want to go delayed writes for
  non-compressed writes.
  But I hope we can simplify the code before that future.

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
 fs/btrfs/defrag.c       |  26 ++-
 fs/btrfs/extent_io.c    |  34 ++-
 fs/btrfs/extent_map.h   |   9 +-
 fs/btrfs/inode.c        | 493 +++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ordered-data.c | 178 +++++++++++----
 fs/btrfs/ordered-data.h |  14 ++
 9 files changed, 703 insertions(+), 58 deletions(-)

-- 
2.54.0

