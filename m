Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A10395DAC
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 07:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782977839; cv=none; b=XDDuWEDgVE2M4wyi4JM2Efl4k8CDkG4TwOirNgZ6ezgLZMrFz5Q4jbfz816IM3DMNjQc4V48yGEAPxJBcqrAh6EkLdFpV8IaszNo9CBQ3ZTGTuon7+CIpFJtbSO3WLWsFQX5xkGFkrqvxLoVEXTI+OV+O6tEXoa/HpwWvO20QSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782977839; c=relaxed/simple;
	bh=3hzOQHikDL5YdNnL8qe7rbt/Pu50KFcIZZFqFFveGUE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qaMBsgRVBH0s3zHcH1TkLQoZX0U562yFebebco0rM8PwnHzr7ctOu2zKPujRUndUEWe2OlqhtPz/1pr2H9MC3hnW9uw/DAhDDPZA6xPcZarlzmNRdemD5VBGe++GpjHJAl1EvMY6ZT+GSbwkYZbjyv/xtvEvHzZKmTcZRDDOwmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ClWbNy/W; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ClWbNy/W; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ClWbNy/W";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ClWbNy/W"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9F85C73708
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 07:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782977832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d/j2QPQV2v/Ykr7qOmGsBgZq7Jgf0VNRu0Cpj6zQnQM=;
	b=ClWbNy/WYEL8h4xvz2FgsYuKIcbuW5WTl4pZBv0nDm2Y3NpVm3unhsVPVCt+UX3OsU8fQq
	L1qtx9xt/6gDqFw9VFlYCzRW3J+HZt7KRyk3wJtRtvv6egqNtcSN4SDUL8KVZbY+ha9w4T
	07m1PrzKgXvf9nMbjTlZMDJL0FSkozw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782977832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d/j2QPQV2v/Ykr7qOmGsBgZq7Jgf0VNRu0Cpj6zQnQM=;
	b=ClWbNy/WYEL8h4xvz2FgsYuKIcbuW5WTl4pZBv0nDm2Y3NpVm3unhsVPVCt+UX3OsU8fQq
	L1qtx9xt/6gDqFw9VFlYCzRW3J+HZt7KRyk3wJtRtvv6egqNtcSN4SDUL8KVZbY+ha9w4T
	07m1PrzKgXvf9nMbjTlZMDJL0FSkozw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A780F779AA
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 07:37:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yC8AFicVRmrOCQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2026 07:37:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: removal of on-stack paddrs[], part 1
Date: Thu,  2 Jul 2026 17:06:46 +0930
Message-ID: <cover.1782977445.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 
X-Spam-Score: -2.80

Since the experimental bs > ps support, several on-stack fixed paddrs[]
arrays are introduced, for assemble mutli-page sized fs blocks.

However that on-stack memory usage is always there for 4K page sized
systems, no matter if the block size of the filesystem.

This series is part 1 of such on-stack paddrs[] cleanup.

The idea is to use bio interface for page iterations, the core idea is
to use a const bvec_iter as the pointer to where the block is.

Then we save a local bevc_iter, and use the local iter to check the next
few pages until we fill a full block.

Furthermore, with the help of bvec_iter, we can remove a lot of
parameters:

- file_offset
- logical
- bio_offset
  All can be generated by using the @iter passed in and the
  bbio->saved_iter to calculate the old @bio_offset.

  @bio_offset is the (iter.bi_sector - saved_iter.bi_sector) <<
  SECTOR_SHIFT.
  As when bvec_iter is advanced, its bi_sector is also increased.

  @logical is simpler, just iter.bi_sector << SECTOR_SHIFT.

  @file_offset is the bbio->file_offset + bio_offset.

This means we no longer need to use on-stack paddrs[] to csum
generation.

With bio interfaces, the iteration of an fs block is as simple as the
following: (I tried to change the page/pg_off/cur_len into a macro just
like btrfs_bio_for_each_block(), but failed)

	u32 cur = 0;

	btrfs_csum_init(&cctx, fs_info->csum_type);
	while (cur < blocksize) {
		struct page *page = bio_iter_page(&bbio->bio, iter);
		const u32 pg_off = bio_iter_offset(&bbio->bio, iter);
		const u32 cur_len = min(bio_iter_len(&bbio->bio, iter), blocksize - cur);
		void *kaddr;

		kaddr = kmap_local_page(page) + pg_off;
		btrfs_csum_update(&cctx, kaddr, cur_len);
		kunmap_local(kaddr);

		bio_advance_iter_single(&bbio->bio, &iter, cur_len);
		cur += cur_len;
	}
	btrfs_csum_final(&cctx, csum);

However there are still some callers left:

- Scrub
  That's already addressed in another series accidentially
  (https://lore.kernel.org/linux-btrfs/cover.1782795330.git.wqu@suse.com/)

  That will be last user of btrfs_check_block_csum().

- RAID56
  That will be only location left without a bio.
  In that case we can easily craft a local helper to do csum generation
  without using on-stack paddrs[].

Qu Wenruo (3):
  btrfs: replace btrfs_repair_io_failure() to use bio for page iteration
  btrfs: enhance btrfs_data_csum_ok() to use bio for page iteration
  btrfs: use a shared helper to calculate data checksum for a bio

 fs/btrfs/bio.c         | 140 +++++++++++++++++++----------------------
 fs/btrfs/bio.h         |   5 +-
 fs/btrfs/btrfs_inode.h |   6 +-
 fs/btrfs/disk-io.c     |  24 ++++---
 fs/btrfs/file-item.c   |  19 ++----
 fs/btrfs/inode.c       |  59 ++++++++++++++---
 6 files changed, 140 insertions(+), 113 deletions(-)

-- 
2.54.0

