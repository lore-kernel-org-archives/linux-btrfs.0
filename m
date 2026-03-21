Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5F937472F
	for <linux-btrfs@vger.kernel.org>; Sat, 21 Mar 2026 13:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774098464; cv=none; b=gmNeanvoOVp5NJZsT0kfvRlWY1HC0A/W/U/n2d2SevxmMlRBO7+vgf/bU+Rle32rPgnjNIeTBqWeKEeGmqe4+QIDd18ezZknVK8c7U9Xu+hhcEn7JJnOPIJW9+06/5lFw769x6dx25Znd50J0RyDpr+JOrcu0Z/4IQRA1v5ycsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774098464; c=relaxed/simple;
	bh=vGnjHifbLTmZl3gNJlEQtM0viBNttthj2q0nZsVotyU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KvtdjhzFRYsZ8Dcj43PoaaZ9qa2tm4ZcBIsCeIkwZMqLSCnZEkP7gci9oo9aQvDET54DWwOVenPGMPTDjpXS4noZRwJpD2SASudySPeKKeOPk1tfD+OO3U+GOdsN9p2/Il610AT+r5RSSqFBUIHldG4kZp15p4t7+UbvYpA5eo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rJd0UZns; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rJd0UZns; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rJd0UZns";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rJd0UZns"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 81D544D2DD;
	Sat, 21 Mar 2026 13:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774098054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wq9b1mhLGvCckbh9kKBfElZccw5iPKNnM/PVb8uGy1w=;
	b=rJd0UZnsJCeUsJjHAb19CAC8n0oCUfvTk2uK2usUDmdlTkaTnawBdARW4aQytM/hGgEbTO
	RofBpFrzHJWhLtNnyaiTcw+hJJ2SvkX0hNtpbWozgETa/SRtEH9GuvjGjBMNZhzNpkpc/n
	3OblELmBsZz5PzP2oXoBCxPn2CkrUzI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=rJd0UZns
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1774098054; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wq9b1mhLGvCckbh9kKBfElZccw5iPKNnM/PVb8uGy1w=;
	b=rJd0UZnsJCeUsJjHAb19CAC8n0oCUfvTk2uK2usUDmdlTkaTnawBdARW4aQytM/hGgEbTO
	RofBpFrzHJWhLtNnyaiTcw+hJJ2SvkX0hNtpbWozgETa/SRtEH9GuvjGjBMNZhzNpkpc/n
	3OblELmBsZz5PzP2oXoBCxPn2CkrUzI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7AE0E42D93;
	Sat, 21 Mar 2026 13:00:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d3v6HYaWvmltCwAAD6G6ig
	(envelope-from <dsterba@suse.com>); Sat, 21 Mar 2026 13:00:54 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.0-rc5, part 2
Date: Sat, 21 Mar 2026 14:00:50 +0100
Message-ID: <cover.1774096729.git.dsterba@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 81D544D2DD

Hi,

another batch of fixes for problems that have been identified by tools
analyzing code or by fuzzing. Most of them are short, two patches fix
the same thing in many places so the diffs are bigger.

- handle potential NULL pointer errors after attempting to read extent
  and checksum trees

- prevent ENOSPC when creating many qgroups by ioctls in the same
  transaction

- encoded write ioctl fixes (on setups with 64K page and 4K block size)
  - fix unexpected bio length
  - do not let compressed bios and pages interfere with page cache

- compression fixes on setups with 64K page and 4K block size: fix folio
  length assertions (zstd and lzo)

- remap tree fixes
  - make sure to hold block group reference while moving it
  - handle early exit when moving block group to unused list

- handle deleted subvolumes with inconsistent state of deletion progress

----------------------------------------------------------------
The following changes since commit fc1cd1f18c34f91e78362f9629ab9fd43b9dcab9:

  btrfs: tree-checker: fix misleading root drop_level error message (2026-03-13 12:49:25 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.0-rc4-tag

for you to fetch changes up to b17b79ff896305fd74980a5f72afec370ee88ca4:

  btrfs: reject root items with drop_progress and zero drop_level (2026-03-17 11:43:08 +0100)

----------------------------------------------------------------
Filipe Manana (3):
      btrfs: check for NULL root after calls to btrfs_extent_root()
      btrfs: check for NULL root after calls to btrfs_csum_root()
      btrfs: reserve enough transaction items for qgroup ioctls

Mark Harmstone (2):
      btrfs: hold block group reference during entire move_existing_remap()
      btrfs: check block group before marking it unused in balance_remap_chunks()

Qu Wenruo (4):
      btrfs: fix a bug that makes encoded write bio larger than expected
      btrfs: do not touch page cache for encoded writes
      btrfs: fix an incorrect ASSERT() condition inside zstd_decompress_bio()
      btrfs: fix an incorrect ASSERT() condition inside lzo_decompress_bio()

ZhengYuan Huang (1):
      btrfs: reject root items with drop_progress and zero drop_level

 fs/btrfs/backref.c         | 28 +++++++++++++
 fs/btrfs/block-group.c     | 36 +++++++++++++++++
 fs/btrfs/compression.c     | 11 ++++--
 fs/btrfs/disk-io.c         | 20 ++++++++--
 fs/btrfs/extent-tree.c     | 98 +++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/file-item.c       |  7 ++++
 fs/btrfs/free-space-tree.c |  9 ++++-
 fs/btrfs/inode.c           | 25 +++++++++---
 fs/btrfs/ioctl.c           | 12 ++++--
 fs/btrfs/lzo.c             |  4 +-
 fs/btrfs/qgroup.c          |  8 ++++
 fs/btrfs/raid56.c          | 12 +++++-
 fs/btrfs/relocation.c      | 39 ++++++++++++++----
 fs/btrfs/tree-checker.c    | 17 ++++++++
 fs/btrfs/tree-log.c        | 21 ++++++++++
 fs/btrfs/volumes.c         | 25 ++++++++----
 fs/btrfs/zoned.c           |  7 ++++
 fs/btrfs/zstd.c            |  2 +-
 18 files changed, 341 insertions(+), 40 deletions(-)
