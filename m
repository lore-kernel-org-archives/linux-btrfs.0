Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A46340312B
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778866483; cv=none; b=soxoSCI4MuxclBUu7g4ucGb+4SPZZ9bcHumkvHiAGACqzQ2J15p5ey3NOMIVdkdy7wBNFviHPO+aqeby6aXLzIyCPUb/B64xIfqkanbWeecBvaCuc20fCDTUvkJAZQZD5pM7r3JkMR81PvTnHD+Ikkitx9xGW4frpkuDcxsNgQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778866483; c=relaxed/simple;
	bh=ZrZ+dvF8YEQsUF2393WP/bLMon/dSZ2c8QxmL9cCi+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AwTWJgfBXbUz0IWb7JS1A5FpWeiZhbVKq+ZopK1E82tPK1I3p/lBq1DQLC+9hm/JZXm/L0thTHEDNVnGebDnU/vDa1SF9oGJgwOPvgtoBcdwojAqEDCCkWnt+2iJ6LSbqnIqx3Pnbd7p9bZtJPxq7X+JNMj83mu8sYvXMpupzwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LCp0QV63; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LCp0QV63; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LCp0QV63";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LCp0QV63"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5AE846B352;
	Fri, 15 May 2026 17:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778866479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PvWSUHfQB4Yk4Qch6hrqt7LaA9RNvzPXiaG2DRKgcKs=;
	b=LCp0QV631uloGOFs0gKdXthJJ//2vCKie/fOOdkYYrTvvdsc9sLxePyM4dFaCuHxFKPEld
	WWKlhpD/k/G9vJtaX3i7I2wfWa1PIyOpf9YjQO9fRNsRPE+FnsXxnTogGc7KYjCm/0Dcbx
	Tjz4fu9oM98LZUekLpbdSQs+pjIBCDA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=LCp0QV63
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778866479; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PvWSUHfQB4Yk4Qch6hrqt7LaA9RNvzPXiaG2DRKgcKs=;
	b=LCp0QV631uloGOFs0gKdXthJJ//2vCKie/fOOdkYYrTvvdsc9sLxePyM4dFaCuHxFKPEld
	WWKlhpD/k/G9vJtaX3i7I2wfWa1PIyOpf9YjQO9fRNsRPE+FnsXxnTogGc7KYjCm/0Dcbx
	Tjz4fu9oM98LZUekLpbdSQs+pjIBCDA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4ECEA593A9;
	Fri, 15 May 2026 17:34:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id T8jXEi9ZB2pPXgAAD6G6ig
	(envelope-from <dsterba@suse.com>); Fri, 15 May 2026 17:34:39 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org,
	torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.1-rc4
Date: Fri, 15 May 2026 19:34:23 +0200
Message-ID: <cover.1778865786.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 5AE846B352
X-Spam-Level: 

Hi,

please pull the following fixes, thanks.

- fixup warning when allocating memory for readahead, __GFP_NOWARN was
  accidentally dropped when setting mapping constraints

- in tracepoint of file sync, fix sleeping in atomic context when
  handling dentries

- harden initial loading of block group on crafted/fuzzed images,
  iterate all chunk mapping entries unconditionally

- fix freeing pages of submitted io after checking for errors

- fix incorrect inode size after remount when using fallocate KEEP_SIZE
  mode (also requires disabled 'no-holes' feature)

----------------------------------------------------------------
The following changes since commit 82323b1a7088b7a5c3e528a5d634bff447fa286f:

  btrfs: fix double-decrement of bytes_may_use in submit_one_async_extent() (2026-04-21 04:03:08 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.1-rc3-tag

for you to fetch changes up to c562ba61fc5e11798720acc1b172862158f1fa0b:

  btrfs: fix incorrect i_size after remount caused by KEEP_SIZE prealloc gap (2026-05-08 00:32:08 +0200)

----------------------------------------------------------------
Calvin Owens (1):
      btrfs: always pass __GFP_NOWARN from add_ra_bio_pages()

Filipe Manana (1):
      btrfs: tracepoints: fix sleep while in atomic context in btrfs_sync_file()

Qu Wenruo (1):
      btrfs: only release the dirty pages io tree after successful writes

Robbie Ko (1):
      btrfs: fix incorrect i_size after remount caused by KEEP_SIZE prealloc gap

ZhengYuan Huang (1):
      btrfs: fix check_chunk_block_group_mappings() to iterate all chunk maps

 fs/btrfs/block-group.c       | 23 ++++++++---------------
 fs/btrfs/compression.c       | 26 ++++++++++++++------------
 fs/btrfs/disk-io.c           |  1 +
 fs/btrfs/inode.c             | 28 ++++++++++++++++++++++++++++
 fs/btrfs/transaction.c       |  9 ++++-----
 include/trace/events/btrfs.h |  4 +---
 6 files changed, 56 insertions(+), 35 deletions(-)
