Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201F13AF652
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 15:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773330140; cv=none; b=hdutIMg2ZZSOCHVoeBZHKFE0SssNfXUBBnHsv5qPJBAdmbx+T0HPDS1JVKDVie+KyUUnPy6n7kl11T+eyqb2Hz2KgF8PUukXAh4p0ZgnwsdZvCP9x1T2ezYQowmvybTEEnmXcS7hiQXnRW00PYPwK5O6kkgGDLznJOiN5TIO0j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773330140; c=relaxed/simple;
	bh=BC14mZMWnqVAIzfkSlRKJyYcJPi/ih6edQbPGtbXUb8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W2IQ8mlXJQ5/Ocsg741Nksj/XVIy3dYULA7s04rrssSj2k3YAoqx88f9vZYY4VhLaJq3/gz1+vr/nV/RWh7082KvAGQ7H46Zfru+wXVgbHLfVHFiOqOPofHhLbjz2fKUSMke5y+SNmqd2aDSZ8Wsb5X46Q3LahJ6lYLxA5nQVbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pDa/crwb; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pDa/crwb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pDa/crwb";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pDa/crwb"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 606C64D3B7;
	Thu, 12 Mar 2026 15:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773330136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d54Z0aaNQtE1wotqT4KogCOLNuJRsfdFCT2Db8Ek+hM=;
	b=pDa/crwb0ezkt2HoBoITTrE4TOFYYHiqrkr9JKXGqt6XjRGhWr31pQk/R07kMVSsTCLy0E
	AETHo83U82/CG0Po+T5/htrxYwxrSNHJTz4SGw6hICNFpSbG1QQGAB2H5PPdKBKg2jXrpr
	OAm0AVTrSYdc6E1/poF4IDARP/vvfSI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773330136; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=d54Z0aaNQtE1wotqT4KogCOLNuJRsfdFCT2Db8Ek+hM=;
	b=pDa/crwb0ezkt2HoBoITTrE4TOFYYHiqrkr9JKXGqt6XjRGhWr31pQk/R07kMVSsTCLy0E
	AETHo83U82/CG0Po+T5/htrxYwxrSNHJTz4SGw6hICNFpSbG1QQGAB2H5PPdKBKg2jXrpr
	OAm0AVTrSYdc6E1/poF4IDARP/vvfSI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A6CC40040;
	Thu, 12 Mar 2026 15:42:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LxMOFtjesmmUQwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 12 Mar 2026 15:42:16 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.0-rc4
Date: Thu, 12 Mar 2026 16:42:09 +0100
Message-ID: <cover.1773328799.git.dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Hi,

please pull the following fixes. Some of them are for user actions that
can lead to transaction abort and turn the filesystem read-only. Thanks.

- detect possible file name hash collision earlier so it does not lead
  to transaction abort

- handle b-tree leaf overflows when snapshotting a subvolume with set
  received UUID, leading to transaction abort

- in zoned mode, reorder relocation block group initialization after the
  transaction kthread start

- fix orphan cleanup state tracking of subvolume, this could lead to
  invalid dentries under some conditions

- add locking around updates of dynamic reclain state update

- in subpage mode, add missing RCU unlock when trying to releae extent
  buffer

- remap tree fixes:
  - add missing description strings for the newly added remap tree
  - properly update search key when iterating backrefs

----------------------------------------------------------------
The following changes since commit f8db8009ea65297dba7786668d4561f6dbd99678:

  btrfs: check block group lookup in remove_range_from_remap_tree() (2026-02-26 15:03:29 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc3-tag

for you to fetch changes up to 0749cab6174dc035b1628fb6db03abf758cfda6f:

  btrfs: remove duplicated definition of btrfs_printk_in_rcu() (2026-03-03 17:20:51 +0100)

----------------------------------------------------------------
Bart Van Assche (1):
      btrfs: add missing RCU unlock in error path in try_release_subpage_extent_buffer()

Boris Burkov (1):
      btrfs: set BTRFS_ROOT_ORPHAN_CLEANUP during subvol create

Filipe Manana (6):
      btrfs: fix transaction abort on file creation due to name hash collision
      btrfs: fix transaction abort when snapshotting received subvolumes
      btrfs: fix transaction abort on set received ioctl due to item overflow
      btrfs: abort transaction on failure to update root in the received subvol ioctl
      btrfs: remove unnecessary transaction abort in the received subvol ioctl
      btrfs: remove duplicated definition of btrfs_printk_in_rcu()

Johannes Thumshirn (1):
      btrfs: zoned: move btrfs_zoned_reserve_data_reloc_bg() after kthread start

Mark Harmstone (2):
      btrfs: print-tree: add remap tree definitions
      btrfs: read key again after incrementing slot in move_existing_remaps()

Sun YangKai (1):
      btrfs: hold space_info->lock when clearing periodic reclaim ready

 fs/btrfs/disk-io.c     |  7 ++++++-
 fs/btrfs/extent_io.c   |  1 +
 fs/btrfs/inode.c       | 19 +++++++++++++++++++
 fs/btrfs/ioctl.c       | 32 ++++++++++++++++++++++++++++----
 fs/btrfs/messages.h    |  3 ---
 fs/btrfs/print-tree.c  | 10 ++++++++++
 fs/btrfs/relocation.c  |  2 ++
 fs/btrfs/space-info.c  |  5 ++++-
 fs/btrfs/transaction.c | 16 ++++++++++++++++
 fs/btrfs/uuid-tree.c   | 38 ++++++++++++++++++++++++++++++++++++++
 fs/btrfs/uuid-tree.h   |  2 ++
 11 files changed, 126 insertions(+), 9 deletions(-)
