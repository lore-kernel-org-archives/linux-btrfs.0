Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B116327AC45;
	Sat,  5 Sep 2026 16:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788625517; cv=none; b=dq2ii/xsXAnA1+5cua7x9ABbb7AkCgygdUX0yK/Ucjz/zyqexNdF9vLVt+ffEbhshvN8qDKv7fB7mi/uOdr6wPWtg4kAmAD/X1KpvwTngcARLblsMklg8ITgkCsxsll/RrQTNOeMeSPyKRjnyMidX6DJVNYsMm0RtA8K7kXo5as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788625517; c=relaxed/simple;
	bh=bibvW/OI2KKpB1OFUFwCpu1LHqDAkTxOtirPg+HkdN8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r+ydUdKcpB/cmsw2jH6p+pJTEWTid9qNnNjORE5+spRsghtkCarFD8IM0SiflZs/k8d5lVrDOw7rwZnCAFtbgxO9eDDpoBsVJj+WCWy+lU63DFJAUyO2Hde1XG5Ke1HIE5r0gQBVVfxdsgPNPJRAmNipoV9Wjf+YxM7U/oYCiW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tYYZIjFf; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=U6DSmOoO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tYYZIjFf";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="U6DSmOoO"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 639A721C90;
	Sat,  5 Sep 2026 16:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788625509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uRc3XZyYCapTXZ7/lREVkVyHENJuGfY4NrdU71AjO0E=;
	b=tYYZIjFftWZFaLkmzgPlU7LPLdPdfWxOTSy6SfebfskESX6dNfEZAyX4dc4T/mDv7/oZYN
	LwKbJu2qXI5TWeJMXExkYWa8yM4iUa8PRlqJnzpgcxIS0XRNiv9v9nXE4b89AJP/vajAI7
	bsw8CaBc+CpGrNK3V3v5ScYfkqC1CM8=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=U6DSmOoO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788625505; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=uRc3XZyYCapTXZ7/lREVkVyHENJuGfY4NrdU71AjO0E=;
	b=U6DSmOoOwo3cYGdcNYejBfCsoaur+vX9+JSY5gtNL9F5xVR95d3mYUvcGi5MnpqbdF35t2
	Z7IJZrdgBz6LqdboA8XuViyOmZmKSKMiAOA+2QH8PoTTpsxvhh35v65mYMnpuH/88kIaIa
	Tg6m/e6jao3R3g4NMiNEdYdW8cujBAI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1E39B13341;
	Sat,  5 Sep 2026 16:25:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2mn6BmFCnGrpTgAAD6G6ig
	(envelope-from <dsterba@suse.com>); Sat, 05 Sep 2026 16:25:05 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.3-rc2
Date: Sat,  5 Sep 2026 18:25:01 +0200
Message-ID: <cover.1788623834.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 639A721C90
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
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
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

Hi,

please pull the following fixes and updates. Thanks.

- preserve inode compression level when changing attributes

- fix lost wakeup when waiting for a zstd workspace

- fix bio context leaks after ordered extent processing errors

- in send, handle unexpected extents for non-regular inodes

- handle edge case in creation of reloc tree with enabled quotas

- in scrub report the exact failing offset, not the stripe base

- error handling fixes
  - error code propagation in send, zoned mode and raid-stripe-tree
  - restore active device pointer after seeding device addition error
  - transaction abort fixups

- update Chris' email address

----------------------------------------------------------------
The following changes since commit 4096e2a06f43fae209d6472d395f3219e02ab2e6:

  btrfs: skip hole detection during full fsync for files without holes (2026-08-07 19:17:19 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc1-tag

for you to fetch changes up to 6a7a45b1d94799a5eb8e6d26e65cf31a3fcda9e5:

  MAINTAINERS: update Chris Mason's email address (2026-09-02 22:19:30 +0200)

----------------------------------------------------------------
Avi Weiss (1):
      btrfs: send: fix lost error return value in will_overwrite_ref()

Chris Mason (1):
      MAINTAINERS: update Chris Mason's email address

FAN YE (1):
      btrfs: zstd: fix lost wakeup when waiting for a workspace

Guanghui Yang (3):
      btrfs: clean up target device if block group marking fails
      btrfs: detach failed sprout device from transaction update list
      btrfs: restore active device pointers after failed sprout

James C. Owens (1):
      btrfs: scrub: report the failing sector's address, not the stripe base

Johannes Thumshirn (2):
      btrfs: zoned: finish active block group cleanup if call_zone_finish() fails
      btrfs: zoned: propagate do_zone_finish() error in btrfs_zone_finish_endio()

Leo Martins (1):
      btrfs: abort transaction before releasing tree_log_mutex on commit failure

Qu Wenruo (4):
      btrfs: fix the possible bioc_list memory leak during error
      btrfs: return proper negative error code for update_raid_extent_item()
      btrfs: do not force reloc root creation during qgroup_account_snapshot()
      btrfs: tests: do not touch page cache if root/inode allocation failed

Sam Ho (1):
      btrfs: preserve the compression property when other inode flags change

Shuangpeng Bai (1):
      btrfs: fix transaction use-after-free in raid stripe insertion

ZhengYuan Huang (1):
      btrfs: send: reject extents for non-regular inodes

 MAINTAINERS                      |  2 +-
 fs/btrfs/dev-replace.c           |  2 +-
 fs/btrfs/inode.c                 |  3 +++
 fs/btrfs/ioctl.c                 | 21 ++++++++++++++++++---
 fs/btrfs/raid-stripe-tree.c      | 25 ++++++++++++++++---------
 fs/btrfs/raid-stripe-tree.h      |  1 +
 fs/btrfs/scrub.c                 | 24 ++++++++++++++----------
 fs/btrfs/send.c                  |  9 ++++++++-
 fs/btrfs/tests/extent-io-tests.c |  5 +++--
 fs/btrfs/transaction.c           | 19 ++++++++++++++++++-
 fs/btrfs/volumes.c               |  4 ++++
 fs/btrfs/zoned.c                 | 16 +++++++---------
 fs/btrfs/zstd.c                  | 11 ++++++++++-
 13 files changed, 104 insertions(+), 38 deletions(-)
