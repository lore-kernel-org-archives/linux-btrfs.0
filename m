Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD75255F28
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 06:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790316993; cv=none; b=f8jM3u/P29C/68r4ifEbpGgZneH63EYi/S1ndAAOLwtTOJg8tpqNf7bHTb0NwCqJ8Js2RFsM1g3/jiC/5bPLHkqsmElinjRXfwtEydqxGzItHWBI5JggjdPEXzOIGqhQFG4COp2pImSDmnusT16d6KUoJx0Yl0izSmw2CMfGcPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790316993; c=relaxed/simple;
	bh=GWJ1l62EcrnyQyLW/qD1zi+6wGPMA0hYyOTVnL+78xU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=OsxNbt99khEnxKpqIOaKG5+R5afCOn73CGc/+2ZAxYubY4LX0Q7dEQSMS061K5ok/L8i9A0AYrHrd4l8A2OAPFFRJ8zkkrop+e2viL10W/7OF+LOKJeWoXRvGrYALlzOPzi4f+lH/DmWbES+Wo0do1lkeZ1O+AbdTnNCNnxeklw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YepebT1I; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V7h7RBxC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YepebT1I";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V7h7RBxC"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 50D4B21D5F
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 06:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790316984; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eqY+N83UT0Uyr2qxrQD6TLoa1jADEZPSuP77j81DqJs=;
	b=YepebT1IcNghZdsu99viJv9sf5Bldm0Y6UrFUfTrzZAZ92cufLa3pUSnVy5N7IyeJirnJ9
	4vVUiC3jMZfnnCTK6UTz+nkGqx3EmCdpg5PjCKcVB7viCBfIg5EZ3BMOLPB1PPyqiOtE1X
	xbVcXmeC51rfYp5LQiWD6NRGMxahPmk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790316980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=eqY+N83UT0Uyr2qxrQD6TLoa1jADEZPSuP77j81DqJs=;
	b=V7h7RBxCG7ZXFbUnGDQOLS7wWtKh2tTWd+77MD35aMqUPTAfGeC7miA43p1Ys1xOiIQ7m4
	gnlgcwaF7roiRnGDd5SY2gvh37dn2qJSeHxImnrxHLxbYJPtKWInqlD3DHqQve+i175g6+
	Of6FDg+J+X3/svYHaTsNd40c0OxGExw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE30413432
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 06:16:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HeJfCbIRtmpdQwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2026 06:16:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v6 0/6] btrfs: delay compression to bbio submission time
Date: Fri, 25 Sep 2026 15:45:53 +0930
Message-ID: <cover.1790316897.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

[CHANGELOG]
v6:
- Fix a bitmap race which is not protected
  This is reported by Sashiko and looks correct.

  There can be multiple bios submitted for the same delayed OE.
  Thus the child_cleanup_bitmap needs to be protected from races.

  Re-use btrfs_inode::ordered_tree_lock to prevent race.

- Release qgroup reserved space on error path

- Release EXTENT_DELALLOC_NEW and EXTENT_DEFRAG flags on error path

- Call btrfs_drop_extent_map_range() during error handling
  The point here is even if we failed to create the real child EM, there
  is still a delayed EM created at run_delalloc_delayed().

  Since the parent OE cleanup will not cover the error range, we also
  need to drop the delayed EM.

- Drop a duplicated xmpchg() call
  btrfs_bio_end_io() is already doing it for us.

The remaining comments from Sashiko are incorrect:

- Double metadata delalloc releaseing
  The out_free_reserve tag of try_submit_compressed() is only reached
  when an error happens before an OE created.
  So there is no child OE to do the cleanup. Furthermore
  btrfs_removed_ordered_extent() won't release metadata on delayed
  parent OE.

  Thus the situation mentioned in the review is incorrect.

- Data space leak
  The data space is already converted from bytes_may_use to
  bytes_reserved at a succesful btrfs_reserve_extent().

  And later on error path btrfs_free_reserved_extent() will decrease
  bytes_reserved.
  Furthermore no parent OE will cleanup the range, so there is no
  leak on data reserved space.

  Although the io tree bits (EXTENT_DELALLOC_NEW and EXTENT_DEFRAG) is
  still leaking.

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
 fs/btrfs/inode.c        | 595 +++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/ordered-data.c | 185 ++++++++++---
 fs/btrfs/ordered-data.h |  20 ++
 11 files changed, 830 insertions(+), 66 deletions(-)

-- 
2.55.0

