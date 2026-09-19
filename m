Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4933815E3;
	Sat, 19 Sep 2026 19:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789847091; cv=none; b=pFF/Np0i1vKrZdkWD7ZGvdz1JHnLsTEJiTzZgfqtmMi/Dg+G/gVwNqciz6a/gpsS4B73pVPXKpsUWUZlZ57QgGF/9Srgg6x4EvcstyaohDdaXJiMiO27F8/Tsdk9q1MNndQw5IVUs3JadFEQyLWfdv4avVIncentUUA37DD15VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789847091; c=relaxed/simple;
	bh=Ixu3UO9lZvjmGvkxIbVOSuDtQAsLTQwkWpcCBbb2pKg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RpPPvUczn5tVRR0HPeYtrtCTHLja2G3HyTDdrCWC6Yo9IUEs6yQ8FDqHDxYo+5PynDm8q48oCV7Wf2LNzYo+1EVtsyF3o9UQR4qsp5qywaCnLDOn5oeTocj585bTwFLx43vi2cjmXo3NhLNqj1Sg5bwb10QpsspST0DrQYA52Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mdKST0QH; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mMnbP0Kh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mdKST0QH";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mMnbP0Kh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1836621DA7;
	Sat, 19 Sep 2026 19:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789847082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vMnIzq0jeVhj82nzM1btMxW/JCXfgOB67xDr2BdpXgs=;
	b=mdKST0QHR7gRFw1P6PjTLwjijesQYymAIn54kCttGfTsguA4LCghzSnhQUSOKZgCWh6Ybh
	p11NYjNCa+aT7M7/DTq7/T3GIAkhSFaEp9AqGkXYJ6T/bEDO5v03A7JT4y3iJHjbNxZ8+1
	XNU3QbgtW4WGoU7O47CHSw1FRG3yw8Y=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=mMnbP0Kh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789847078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=vMnIzq0jeVhj82nzM1btMxW/JCXfgOB67xDr2BdpXgs=;
	b=mMnbP0Kh+8yWRAD0GDG5PiHlCGAtIlspy74y0LgqWui4rvpUyLuWWAXeL4zCHgfpyPBY6R
	IiC3Hf8dotx2Jg2iX6GimJOMtEt/YxP/NKLfCrz3UTM3Ae3A41CzJvp6gbN8k0wsAbmgYO
	/LKopzvdyA9PzZ+Bq/RqRsvhyUtLv/c=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B914D133CF;
	Sat, 19 Sep 2026 19:44:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6M/vIyXmrmpMfgAAD6G6ig
	(envelope-from <dsterba@suse.com>); Sat, 19 Sep 2026 19:44:37 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.3-rc4
Date: Sat, 19 Sep 2026 21:44:31 +0200
Message-ID: <cover.1789845496.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 1836621DA7
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
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid];
	RCVD_TLS_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

Hi,

please pull the following fixes. Among the regular fixes, there are two
that were reported recently and have user impact:

- filesystem id is now stable again on the default and common case (it
  broke openconnect key derivation, while this is not secure, it's still
  in use), the intention was to change id for the temp_fsid use case

- fix detection of /dev/root and rename it after device scan, this broke
  booting of initramdisk-less system with grub2 as the probe needs the
  real device

Regular fixes:

- don't store compressed inline extent if the size is larger than
  uncompressed

- in zoned mode, handle activation of zones for all supported block
  group profiles in case there are still free ones left

- check space for a chunk item when reading sys array from superblock

- allow using space reserves when removing verity items fails

- fix error handling after free space tree rebuild fails

- abort transaction if reflink or hole punching fails and it's not
  possible to update the inode

- properly protect block group iteration during device replace start

- error message fixups

----------------------------------------------------------------
The following changes since commit 09f1294ee2abee7fe1c2d600671498b7642e0fe0:

  btrfs: tree-checker: validate name length for extref items (2026-09-07 18:36:38 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc3-tag

for you to fetch changes up to 72de4807ba84da485dda1a91572d66da9149e95a:

  btrfs: derive f_fsid with dev_t only when temp_fsid is active (2026-09-17 19:45:12 +0200)

----------------------------------------------------------------
Anand Jain (1):
      btrfs: derive f_fsid with dev_t only when temp_fsid is active

Daniel Linjama (1):
      btrfs: handle lack of space when cleaning up verity items

Filipe Manana (5):
      btrfs: tree-checker: print dev extent offset in error message
      btrfs: tree-checker: fix error message regarding free space extent items
      btrfs: fix creation of compressed inline extents that don't save space
      btrfs: abort transaction on failure to update inode for hole punching and reflinking
      btrfs: check if there is space for chunk item when validating sys chunk array

Guanghui Yang (1):
      btrfs: clear free space tree creation state on rebuild failure

Hongling Zeng (1):
      btrfs: take commit root semaphore when iterating in mark_block_group_to_copy()

Johannes Thumshirn (1):
      btrfs: zoned: handle RAID profiles in btrfs_can_activate_zone()

Qu Wenruo (1):
      btrfs: add "/dev/root" exception for device path update

 fs/btrfs/dev-replace.c     |  1 +
 fs/btrfs/disk-io.c         |  4 ++++
 fs/btrfs/file.c            |  4 +++-
 fs/btrfs/free-space-tree.c | 14 ++++++++++----
 fs/btrfs/inode.c           | 18 +++++++++++++++++-
 fs/btrfs/super.c           |  8 ++++++--
 fs/btrfs/tree-checker.c    |  4 ++--
 fs/btrfs/verity.c          | 18 ++++++++++++++++--
 fs/btrfs/volumes.c         | 33 ++++++++++++++++++++++++++++++++-
 fs/btrfs/zoned.c           |  5 +++++
 10 files changed, 96 insertions(+), 13 deletions(-)
