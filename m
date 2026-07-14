Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448133A5431
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 06:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784011780; cv=none; b=EvPFlcllrz+vMx9HfjCYd73eaW3vOINDpqoF3kicpYOvtMa5YpRrEvo9uXKxrh3rjzsnUl9LQgXTq8nUbaMl8o3g9Frdas9ZAFo6n5EsurIYT4PkNReq4Cbcii1/1Pew6xfCjIvExo56vWG8bu4+b7hPwnnCJ10ihTFutp4g1Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784011780; c=relaxed/simple;
	bh=2VrQT/eKZoZblO2/6szFh1Z5D+Y4+nmeeox4pcFhVN4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=s+ZxwwoeQ6CoeUuUch1UXgnWY3c0TglMNHmxzKJ3BPbbexkH0WM8jqUoSkdJdY0sscQMBH2Sex103QFySc8LZGpqCyGopd11RFJmgWzBs8/vBHOshlPwNPMfVMjXiZmLab7P4wVoBoeaXEG4GbmGG3UL8OTt0oTlWK2jwLExyaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=t/NZpGmt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=t/NZpGmt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="t/NZpGmt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="t/NZpGmt"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C953377D11
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 06:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784011775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IwdnZkLklKo/hu0fcM+NEmgaW9QUNII5Rn5I1WVM2/I=;
	b=t/NZpGmtGmKPzxxrS/76rd6HPLKdkc37jqaJ7w6/SwBNAE7fAChV0IaPmAiwds+WyWuCUD
	zw0NMhGQyFqD354QDeF+9TdYfLSO0R3WqbKA46mTAaqxgqDtuzxWPuMKLp0wg+/bv4H/3L
	Ox5Nl+vBvLixhP1QqIhF3ZM0KDB003A=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="t/NZpGmt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784011775; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=IwdnZkLklKo/hu0fcM+NEmgaW9QUNII5Rn5I1WVM2/I=;
	b=t/NZpGmtGmKPzxxrS/76rd6HPLKdkc37jqaJ7w6/SwBNAE7fAChV0IaPmAiwds+WyWuCUD
	zw0NMhGQyFqD354QDeF+9TdYfLSO0R3WqbKA46mTAaqxgqDtuzxWPuMKLp0wg+/bv4H/3L
	Ox5Nl+vBvLixhP1QqIhF3ZM0KDB003A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 145B0779AE
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 06:49:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jg4UMv7bVWp+TAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2026 06:49:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/4] btrfs: removal of on-stack paddrs[], final part
Date: Tue, 14 Jul 2026 16:19:13 +0930
Message-ID: <cover.1784011485.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C953377D11
X-Spam-Score: -3.01

[CHANGELOG]
v3:
- Rebased to the latest for-next
  There is a fix in RAID56, which can cause conflicts with the last
  patch

- Remove all remaining on-stack paddrs[] usage
  There are two last ones in RAID56, one can be converted to use bio
  interface, the other is not using on-stack paddrs[] array.

  So we can finally remove all on-stack paddrs[] usage.

v2:
- Fix a missing assignment for metadata repair
  The logical should be assigned before passing it to
  btrfs_repair_bbio_failure().

- Move the commit message of error message change to the correct patch
  It's changed in the first patch not the last one.

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

Qu Wenruo (4):
  btrfs: replace btrfs_repair_io_failure() to use bio for page iteration
  btrfs: enhance btrfs_data_csum_ok() to use bio for page iteration
  btrfs: use a shared helper to calculate data checksum for a bio
  btrfs: remove on-stack paddrs[] array usage

 fs/btrfs/bio.c         | 140 +++++++++++++++++++----------------------
 fs/btrfs/bio.h         |   5 +-
 fs/btrfs/btrfs_inode.h |  12 ++--
 fs/btrfs/disk-io.c     |  25 +++++---
 fs/btrfs/file-item.c   |  20 ++----
 fs/btrfs/inode.c       | 114 +++++++++++----------------------
 fs/btrfs/raid56.c      |  47 ++++++++------
 7 files changed, 159 insertions(+), 204 deletions(-)

-- 
2.54.0

