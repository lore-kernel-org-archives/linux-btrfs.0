Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFD73B8D70
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230727; cv=none; b=abK2472Vdu8K6VdXRB6wyzmVmXNIKXvXp6JHeRgwiPa+Gqzbd8W+di1TJ8f0HseTyh5Iw64UpAB5+99qmJPmXGleA6HHAhOd1t2qpRSKr3LQF60SsaLXHMwS6Xm0Zd7Il4kD8UFfe0sIggai1NAKPojh5khR1LJLNMKsHCp5p/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230727; c=relaxed/simple;
	bh=2NMaRQUrKz93sVvc37yzMt+12UpdUtpKVdCJG3cv61U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WEdoBKro/S4ShibUXee3EyYrn6NZgfOfnKB80hMd8zS1IErVaxlu1S749W9yOW3QVQB8I3apY36kOuJBrAFZdJTZ6zjfCYABZa2MOb0mdg3Em7SMlQt4+fVDCUQo7rcojohmmWjwF5iDgoROOzS5qTJgyCGCizwjkcarfC5t/5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ncjm3g5e; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=cuq8GE3B; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ncjm3g5e";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="cuq8GE3B"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 202BD7C03A;
	Tue, 28 Jul 2026 09:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785230720; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aVpi+4JMQkIel3WFLvEEJVOeBtmj3UWBlLNlfy4s0RI=;
	b=Ncjm3g5erz56fLAQ8ksZMZv/CtqIEObUj5dq5RgD6kdgFYH+C30uLOFEVc1dnvSSqtDURf
	06af26H6tGhgSIG2d9oCn0+y/pLZE3Q0GH2zmKBsa1B3k8GTUjI/A+XAnKtuKhkbyFmVP6
	MVdRnLr/7tHzuw1uAuxBnraWVFd6CsY=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785230716; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aVpi+4JMQkIel3WFLvEEJVOeBtmj3UWBlLNlfy4s0RI=;
	b=cuq8GE3BnEkPuNPrgbklxe0fiZhiZAe/2MvPHpvu5pdNajDiqsnrCAOPq/SX/cN9WiR/1B
	HFTX5iCjr4OM/OJ4NhKv3fubND6dnfJzlZsGByqLhXE+FyeVdIB4Jw6KqXt4vlY3xhv+nX
	ucp3banUhdmCdzGlD/CrHmRCdlb0NFY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19D4C779B1;
	Tue, 28 Jul 2026 09:25:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b6RIBnx1aGpwagAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 28 Jul 2026 09:25:16 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.2-rc6
Date: Tue, 28 Jul 2026 11:25:14 +0200
Message-ID: <cover.1785171953.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo]

Hi,

please pull the following btrfs fixes. They're one-liners or short
focused fixes (I've removed other less serious ones).

A heads up for one more fix, for a problem that resurfaced last week. In
short we have to bring back the "fixup worker", detect and handle pages
set dirty without filesystem notification. There's a reliable reproducer
for at least one such case. The fix heavily builds on the removed code
so we have a solid base, the new changes are wrt folios and subpage mode.

The v3 [1] seems to be the final one, we'll give it a test, estimated
time of the pull request is next week.

[1] https://lore.kernel.org/linux-btrfs/69d0043e0f6a3d17048dfde857127ab0bf331154.1785190866.git.boris@bur.io/

This was not expected and we hoped to leave the fixup worker in the
past, but it's hard to argue with a reproducer. The remaining time
before release should be sufficient to get the fix finalized.

Thanks.


- zoned mode:
  - fix assertion and handle case of finished zone and truncated extent
  - fix zone metadata write pointer on actual zone reset
  - fix deadlock caused metadata writeback and transaction commit
  - fix return value reuse leading to confusion about chunk reservations

- raid56 scrub
  - fix tracking of sector checksums when there are not checksums found
  - fix inverted logic when submitting parity read bio

- mount/remount fixes
  - fix leaking 'remount in progress' state which can break other
    operations to work (qgroup rescan, autodefrag, reclaim)
  - adjust using global block reserve after read-only mount when using
    rescue= option
  - handle missing raid stripe tree when mounted with 'ignorebadroots'

- fix -Wmaybe-uninitialized warning in GET_CSUMS ioctl

----------------------------------------------------------------
The following changes since commit 75a41e3e51eb0d6f7a4969c5056298c2aa3e85f2:

  btrfs: fix GET_SUBVOL_INFO after compat refactor (2026-07-14 07:05:10 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc5-tag

for you to fetch changes up to c4c0673e4cb15b0c127e6d00732a2427bdd12c11:

  btrfs: raid56: fix scrub read assembly submitting no reads (2026-07-21 06:44:08 +0200)

----------------------------------------------------------------
Dongjiang Zhu (2):
      btrfs: skip global block reserve accounting for rescue mounts
      btrfs: report missing raid stripe tree root during lookup

Guanghui Yang (1):
      btrfs: zoned: fix missing chunk metadata reservation

Johannes Thumshirn (3):
      btrfs: zoned: fix deadlock between metadata writeback and transaction commit
      btrfs: zoned: reset meta_write_pointer on zone reset
      btrfs: zoned: skip fully truncated ordered extents at zone finish

Mykola Lysenko (1):
      btrfs: raid56: fix scrub read assembly submitting no reads

Paul E. McKenney (1):
      btrfs: initialize 'args' to avoid compiler warning in btrfs_ioctl_get_csums()

Qu Wenruo (2):
      btrfs: fix leaking BTRFS_FS_STATE_REMOUNTING flag
      btrfs: raid56: fix an incorrect csum skip during scrub

 fs/btrfs/block-group.c      | 34 +++++++++++++++++++---------------
 fs/btrfs/block-rsv.c        | 19 +++++++++++++++++--
 fs/btrfs/disk-io.c          | 11 +----------
 fs/btrfs/fs.h               |  9 +++++++++
 fs/btrfs/ioctl.c            |  2 +-
 fs/btrfs/raid-stripe-tree.c |  6 ++++++
 fs/btrfs/raid56.c           | 15 ++++++++-------
 fs/btrfs/super.c            |  8 +++++---
 fs/btrfs/zoned.c            | 27 ++++++++++++++++++++++++++-
 9 files changed, 92 insertions(+), 39 deletions(-)
