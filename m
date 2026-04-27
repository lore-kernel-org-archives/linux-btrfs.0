Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23DD3242D8
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 15:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777302283; cv=none; b=oD05STF98IuuDvpxIMxHlKJUe/eRKTMPd5c2J1TKBANHSHfvmF0uU18qtxrMrpwIxqysGaSvhXpuhtxKPANBFKuwTjECyUJqP1WcVtrDtBIu9h46mXKx1Rl8htnt3c8xwvXdS2gdJECNAMCQF+Ao1Fqsc7f2zytgD7WPKtPT1SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777302283; c=relaxed/simple;
	bh=fECCU0fEelPZx+Gg6N+Dz/dAow+g9nTAakocFYup8Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uhhYhDC2TAJiq0UfZ1QYKFlIuM/y0shh72MPnZ5J220GeiWwhc/aNLZbnmNiO9Vio3/pe6ir42GRlOhwtSCUpN4tuoder8ZjFp2znpVwXOkrpJk3RynCs3SbD/+ManPTGtZ8VPo5iiTY7KDDKWJA69ltQS5LBF86OdpBCKvpk/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=a9ylJVa9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=a9ylJVa9; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="a9ylJVa9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="a9ylJVa9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2FF876A923;
	Mon, 27 Apr 2026 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777302280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tbNJ2IUFV6qgeDXkc/5OKgkupBInIErB7jP4IoAi1Ng=;
	b=a9ylJVa91qaOu77dj9YrqCXxoNc4y9uEUQIw0b6M4GxS5JGWovmB3hx3Fiyg+lSguXMz/g
	Tn73PYMWRN5D9Lfg1qPd9ccuSvuVSpJ8abbHYeUEv9WkKLViw58uP4OG5PTb3j6yD7UO2k
	7UaPZHwhmAIe30IrB3/I+HaoCKsYRDw=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777302280; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=tbNJ2IUFV6qgeDXkc/5OKgkupBInIErB7jP4IoAi1Ng=;
	b=a9ylJVa91qaOu77dj9YrqCXxoNc4y9uEUQIw0b6M4GxS5JGWovmB3hx3Fiyg+lSguXMz/g
	Tn73PYMWRN5D9Lfg1qPd9ccuSvuVSpJ8abbHYeUEv9WkKLViw58uP4OG5PTb3j6yD7UO2k
	7UaPZHwhmAIe30IrB3/I+HaoCKsYRDw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29D58593B0;
	Mon, 27 Apr 2026 15:04:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DecvCgh772kEOwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Mon, 27 Apr 2026 15:04:40 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.1-rc2
Date: Mon, 27 Apr 2026 17:04:29 +0200
Message-ID: <cover.1777300791.git.dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Hi,

please pull the following batch of fixes that arrived shortly before or
during the merge window.

Thanks.

- space reservation fixes
  - correctly undo 'may_use' accounting for remap tree
  - avoid double decrement of 'may_use' when submitting async io

- actually enable the shutdown ioctl callback (not just the superblock ops)

- raid stripe tree fixes when deleting extents
  - add missing error handling
  - fix various incorrect values set

- fix transaction state when removing a directory, possibly leading to
  EIO during log replay

- additional b-tree node key checks during metadata readahead

- error handling and transaction abort updates

----------------------------------------------------------------
The following changes since commit fc3d53288158d68444eed059adb734709b855bbf:

  btrfs: btrfs_log_dev_io_error() on all bio errors (2026-04-07 20:00:29 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-rc1-tag

for you to fetch changes up to 82323b1a7088b7a5c3e528a5d634bff447fa286f:

  btrfs: fix double-decrement of bytes_may_use in submit_one_async_extent() (2026-04-21 04:03:08 +0200)

----------------------------------------------------------------
David Sterba (1):
      btrfs: handle unexpected free-space-tree key types

Filipe Manana (1):
      btrfs: fix missing last_unlink_trans update when removing a directory

Mark Harmstone (5):
      btrfs: fix bytes_may_use leak in move_existing_remap()
      btrfs: fix bytes_may_use leak in do_remap_reloc_trans()
      btrfs: abort transaction in do_remap_reloc_trans() on failure
      btrfs: don't clobber errors in add_remap_tree_entries()
      btrfs: fix double-decrement of bytes_may_use in submit_one_async_extent()

Qu Wenruo (2):
      btrfs: apply first key check for readahead when possible
      btrfs: enable shutdown ioctl for non-experimental builds

robbieko (6):
      btrfs: copy devid in btrfs_partially_delete_raid_extent()
      btrfs: fix raid stripe search missing entries at leaf boundaries
      btrfs: fix wrong min_objectid in btrfs_previous_item() call
      btrfs: replace ASSERT with proper error handling in stripe lookup fallback
      btrfs: handle -EAGAIN from btrfs_duplicate_item and refresh stale leaf pointer
      btrfs: check return value of btrfs_partially_delete_raid_extent()

 fs/btrfs/extent_io.c        | 14 +++++++++--
 fs/btrfs/extent_io.h        |  3 ++-
 fs/btrfs/free-space-tree.c  | 18 +++++++++++---
 fs/btrfs/inode.c            |  4 +++-
 fs/btrfs/ioctl.c            |  7 +++---
 fs/btrfs/raid-stripe-tree.c | 57 +++++++++++++++++++++++++++++++++++----------
 fs/btrfs/relocation.c       | 30 +++++++++++++++++++-----
 7 files changed, 104 insertions(+), 29 deletions(-)
