Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9E215746F
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790306191; cv=none; b=L1GZsdSz6GVN2Eb3T42by2Vm7isxtSRwsKYDbAkwwu6Aotum8PBajK2kA7KlfH0yEszObTOr2akaxN6lCQEP3hHYMUNTsBI+Q2MvJ17vm84W5w+7HCxPR1v1It7EZxs2dD02JFnj+AnVerjPaoYBmOOb4iMhfBXBp2VTGaTXEc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790306191; c=relaxed/simple;
	bh=TMspvbyesP2oAFOYIKOgK7WnaZc34bz58psnRljYo1I=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=SYbGwfIGvXSzQnR5tAWRIXAQs1soKMUhgEasxGGMFacB93YqDr7KpHZf2EVxr28WHS2sOxHE/0/IvugWH8+GDSGng5rM7kaBPgzRhRRNlEURbCvcNwTP5ZOyEMuDFSCfPrOLQ39Hp+AWzD/EQnpBONJ8H6eVLCKVxn1GvnWkYV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=kK1hwSgt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ua0VsQDx; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="kK1hwSgt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ua0VsQDx"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ADA41200CE
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790306183; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=T8wGJcDxCoOsZz5w3W2GygFRdeHtn9NRjCrKyHIoqzo=;
	b=kK1hwSgtSVXfqRVKQgn2DDIc0R+4jAHBW2KRNVrN7OwfW+k5lH7zyeSj+Ay/KR8DvCwekM
	3vlyjw/TLHOIVv1xt83JGtt6NagyB+VvMMBDGPdVQ5RBOBkuF1TUh8OA07h3dBDmnVueB2
	DQNuhF1OSAzELijBwRd4Ch+BKcz0TLw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ua0VsQDx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790306179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=T8wGJcDxCoOsZz5w3W2GygFRdeHtn9NRjCrKyHIoqzo=;
	b=ua0VsQDxwJe2UMjeSG5offsFJNnUipy6W4emAPvDYdWTTmcfeNaoQcS3udHBhl1XNwomUQ
	EvmxalZ9Y50om3P0O5zgLtQqVTW2jeTgcHKsA6aIIxIjowpAuvGT0yYyaUT/oiCPbbY4C0
	8xPQbH4iuBzj2ABSyGWC+WMjRvmALZk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FA11136F7
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Fd3cN4HntWpbDQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 03:16:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v5 0/6] btrfs: delay compression to bbio submission time
Date: Fri, 25 Sep 2026 12:45:49 +0930
Message-ID: <cover.1790306139.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: ADA41200CE
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

[CHANGELOG]
v5:
- Fix an error handling path when compression writes failed after reserved
  data extents
  The current fallback behavior is different than the old async path,
  and can lead to reserved space inbalance.

  Follow the old async behavior that if an error is hit after reserved
  a data extent, error out without falling back to uncompressed writes.

- Fix an error handling path that both parent and failed child OEs are
  doing the same cleanup twice
  If a delayed child OE range hits some critical error without creating
  an OE, e.g. failed to allocate the child OE itself, the child OE range
  will be cleaned up.

  But later parent OE will also cleanup any range that has no child OE,
  it will clean the range again.

  Fix it by changing the btrfs_ordered_extent::child_bitmap to
  child_cleanup bitmap, which is initialized to all 1 when allocating
  the OE, then cleared when:
  * A new child OE is added
  * A child OE range is already cleaned up
    In either try_submit_compressed() or
    submit_one_uncompressed_range().

  So that the parent OE cleanup will skip any range that is covered by
  an child OE or already cleaned up.

- Fix reserved metadata space leak in child OE error path
  If the child OE range failed to allocate an OE, the reserved metadata
  space is not released, thus will require manual cleanup.

- Fix a lockdep warning where the aquire and release is not paired

- Mark the mapping as error when end_bbio_delayed() hit an error
  To follow end_bbio_data_write().

v4 RESEND:
- Fix a conflict due to some rewording in for-next
  Which prevents Sashiko to review the series.

v4:
- Fix a possible write path deadlock during reclaim
  The delayed_bio_private structure is allocated during writeback, it
  needs GFP_NOFS to avoid deadlock.

- Use a dedicated workqueue for WQ_MEM_RECLAIM ability

v3:
- Various fixes to error handling
  Mostly reported by LLM.

- Use delayed bbios' pending_io to tracking child bbios
  Which reduces the structure size of delayed_bio_private.

- Extra full sync requirement for delayed writes
  To avoid fast sync path to grab a delayed OE, which has no reliable
  on-disk bytenr.

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


Qu Wenruo (6):
  btrfs: add delayed ordered extent support
  btrfs: add skeleton for delayed btrfs bio
  btrfs: introduce the skeleton of delayed bbio endio function
  btrfs: introduce compression for delayed bbio
  btrfs: implement uncompressed fallback for delayed bbio
  btrfs: enable experimental delayed compression support

 fs/btrfs/bio.c          |   1 +
 fs/btrfs/bio.h          |   7 +
 fs/btrfs/btrfs_inode.h  |   3 +
 fs/btrfs/defrag.c       |  27 +-
 fs/btrfs/disk-io.c      |   8 +-
 fs/btrfs/extent_io.c    |  36 ++-
 fs/btrfs/extent_map.h   |   9 +-
 fs/btrfs/fs.h           |   5 +
 fs/btrfs/inode.c        | 575 +++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ordered-data.c | 185 ++++++++++---
 fs/btrfs/ordered-data.h |  20 ++
 11 files changed, 810 insertions(+), 66 deletions(-)

-- 
2.55.0

