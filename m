Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795657583;
	b=FaeXnt3LdcBvleK5Okxq/NYHI7doxKEzG00rRD5ce23jCR8SLmcyEKD/rogXxn2epk/s
	 cjI9H5j2xSxjIXoJVMz/mw8VA8FOgXliYNGErUuGFF3ZCrJyHAVo55o5vgQwoUxrb0wEF
	 ljmYHEU267DqR/W7zi9kXGpwhBgX518lp9SJlu0AHPjmcuC8yNbY6viIGfP0eQ2cXz/FF
	 k9mEyhtGPXHw76Ho2hxGiJFJ+qkeE2kfkJ8zZLtUByYizX8vyjLuhEFpEdB/xOT6ufX86
	 A0wnPYVPP/6+u/AMFM/GktcaFgnf1PrezgvwIALrColdUEbylxlCNmhaOONO3sDH2AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795657583;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=rTQibs8/o/dW90vH0yd86yddZhse5CdEmpfptRgvpO8=;
	b=vaMDEUbo58SlTv/9N7ZhV6RGaMedADppE/s5q//PfbeCuyUjEGdSX3MphHkTaFXyC6VX
	 76OerckQH+EUMHXaDOsES0VGyp90oJrvj0Ra6VElpNl719pcnqYQaR8G7l4yCen5YzNbQ
	 V3vTmUU29m/Y5FWEEVqmF55NunnLyn6JsmtwxaysiPxbvcmWobv0iVMxi3xdul6IdvEYi
	 F15PeCSxWwpDdcfIR+Lp7HJ/YhCt+0eTRlnGVzlG5OKxilueVu/oAt91OaInLou2r5Vnk
	 hVrLXrh/lXbItptsyGIBBA8glrnHmI6z4FcgaJ4N6PP8R38rGibGpCj2YASnvqCrp6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="RAMmUxy/";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ulSRO3C1;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99713606A31E;
	Thu, 26 Nov 2026 01:46:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99713606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RAMmUxy/;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ulSRO3C1
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 57F9922525;
	Thu, 26 Nov 2026 01:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795657580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rTQibs8/o/dW90vH0yd86yddZhse5CdEmpfptRgvpO8=;
	b=RAMmUxy/fGkphMAGt5Cfazz5Y+mn1+V8WuTovSjbuQmbXyf/W3QjsKM+uBD1ux77HCgCrx
	lIKD+VSV1UIETAeqQWMoGnT872Uslq/W3iZPYAwsXUMYl80aIT0MMCFhw22961crPerWFG
	Em30SFZaEDLMktgtd8W8t8j/gwKC/jE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795657579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rTQibs8/o/dW90vH0yd86yddZhse5CdEmpfptRgvpO8=;
	b=ulSRO3C1sAEtHXo0qcc3jtU4ag1wUSx6v5BOInEqmzVcPUJXxzSUxraStJed8mzt8BOc9q
	wYtNTQG1ABs1zV9EpFMyZVXTLhAgwGXazKygNnDEdKpHNnjCUdNS+UAxU8QlpMm4nXwlG9
	lDKjToKyUMcCMLx5kbYlht5kkSyLiWQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3170C134C1;
	Thu, 26 Nov 2026 01:46:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xuXZA2uPB2uSFAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 26 Nov 2026 01:46:19 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.4-rc7
Date: Thu, 26 Nov 2026 02:46:16 +0100
Message-ID: <cover.1795641319.git.dsterba@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.995];
	MIME_GOOD(-0.10)[text/plain];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80
X-Spam-Level: 
X-Spam-Flag: NO

Hi,

please pull a number of fixes as reported on Bugs page of Sashiko and
usual bag of regular fixes.

Thanks.

- send fixes:
  - fix sending file hole punching command in incremental mode
  - fix invalid memory access for inline extent

- fixes for nowait semantics
  - fix memory allocation in encoding read ioctl
  - don't wait for ordered extents in buffered write

- don't propagate nodatacow from mount option to files with compression
  flag inherited from parent directory

- fix fsync mode in encoded write so the data are fully written

- fix race between reflink and compressed write on the same folio

- fix rchar accounting in io_uring after error

- drop link count for a deleted subvolume early so eventual open file
  does not keep showing the subvolume in the list

- fix livelock during transaction commit on RT kernel

- fix inode locking inode for concurrent sync direct IO writes

- reject subvolume ids that don't fit 32bit long

- error handling and resource management fixes: sysfs objects, block
  group refs, bio control structures, delayed inode refs

----------------------------------------------------------------
The following changes since commit d27d0039bc1334be8a72c769e14c0b0c3efc317d:

  btrfs: fix bio counter and bioc leak when async checksumming fails (2026-11-09 18:50:58 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-rc4-tag

for you to fetch changes up to 3100f46985fd14148e79a0e79912180934ef7231:

  btrfs: fix delayed inode count leak after failure to delete inode ref (2026-11-23 19:53:01 +0100)

----------------------------------------------------------------
Binbin Deng (1):
      btrfs: wait for a grace period before freeing a new device

Boris Burkov (1):
      btrfs: fix block group ref leak when scrub races with unused bg deletion

Cheng Yongkang (1):
      btrfs: remove devid kobject when deleting a missing device

Daniel Vacek (1):
      btrfs: fix a livelock in wait_for_commit() on PREEMPT_RT

Filipe Manana (13):
      btrfs: send: fix missing hole punching during incremental send
      btrfs: send: fix invalid access to inline extents in clone_range()
      btrfs: don't propagate nodatacow mount option on files with inherited compression
      btrfs: drop the link count of a subvolume inode when deleting the subvolume
      btrfs: fix race between concurrent sync direct IO writes
      btrfs: zstd: fix UAF due to race between putting workspace and reclaim
      btrfs: fiemap: deal with inline extent in fiemap_find_last_extent_offset()
      btrfs: fix off-by-one max tree level bound when replaying log trees
      btrfs: fix double release of space when cloning compressed inline extent
      btrfs: abort transaction on failure to update inode after hole punching
      btrfs: fix blocking allocation for nowait encoded reads of inline extents
      btrfs: fix incorrect task accounting on error during io_uring read
      btrfs: fix delayed inode count leak after failure to delete inode ref

Joseph Qi (1):
      btrfs: don't wait for ordered extents in nowait buffered writes

Qu Wenruo (3):
      btrfs: reject subvolume ids that do not fit into unsigned long
      btrfs: skip fast sync for inodes with encoded writes
      btrfs: fix a race between reflink and compressed writes

 fs/btrfs/block-group.c   |  7 +++-
 fs/btrfs/delayed-inode.c |  3 +-
 fs/btrfs/direct-io.c     | 15 +++++++-
 fs/btrfs/disk-io.c       | 31 +++++++++------
 fs/btrfs/disk-io.h       | 18 +++++++++
 fs/btrfs/extent_io.c     |  5 +--
 fs/btrfs/extent_io.h     |  3 +-
 fs/btrfs/fiemap.c        |  2 +
 fs/btrfs/file.c          | 16 +++++++-
 fs/btrfs/inode.c         | 86 ++++++++++++++++++++++++------------------
 fs/btrfs/ioctl.c         |  9 +++--
 fs/btrfs/reflink.c       | 15 +++++++-
 fs/btrfs/send.c          | 98 +++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/transaction.c   | 15 +++-----
 fs/btrfs/tree-log.c      |  2 +-
 fs/btrfs/volumes.c       |  9 +++--
 fs/btrfs/zstd.c          |  8 +++-
 17 files changed, 244 insertions(+), 98 deletions(-)
