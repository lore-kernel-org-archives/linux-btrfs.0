Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792947818;
	b=qvPCcQ+jfUsvS9AfPEkx03gEh4dPWx7eN1I8j78UtQy8ROPwLpCcxB91goQO1iEZOy1b
	 ix3tdKMAwf5X77aJdIQHItVgToXeusjtgpDCcFuZMPoUKqOAUapwbYM7EX9tANMGE9HgD
	 dmSQSfqTh9XMkv3FBF6IaLeubh7h5F0v/P/xnGUPR/11dmzcvcRhaI9unXbs2HoG2AF6H
	 fJGAFQz+mt07hp8QWQnDggB2OII2wVbTviLNz8rejh8w9t3cqN9IRShJ4GQYSzQV+rmLT
	 8mvhz21dBNjOxso7l5dB/9oz4dUB2EDd01QzzfZUJWj1LKM3iggQmZKoAMcTS/MT6vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792947818;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Spam-Score:X-Spam-Level:
	 X-Spam-Flag;
	bh=Upb6pTRlJjRU6wJ39mtFq3FyWkFkQOOHET/C22knccw=;
	b=e/gf+bQSDJY5wKnuwhHPyfsUzwh0LnCzDBvkbeErLhbZ2pipeW5DO6kajTNmrLB4dH/M
	 EwOtAWS1oRxgGUEE/+GnYDZXrEJ0b3ZcjuVsfyzAy4TGlgyzb0FhLhmEbyRmj3NlnsxYI
	 ZAqznD8kkPhhj2Ows4szxRLhOpcTG+guM57J5MxHLHH6ezQXVzUXKte9SvOGGfD+hhLCr
	 /CWewwsGO8EfXqAUlTDfhrQzyIcnKKHmigZcOUDU2ltHxBH4R1Y+NN8bqavBytCpBqGt+
	 KsmZQxHL6jMkgDSPZ8gh96Dy3EX2l4TiR8Oxri+WMgKhsbmHhPRwEsFjBOWcnMxOfZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fgQNUbrI;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fgQNUbrI;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DFE6606A31A;
	Sun, 25 Oct 2026 17:03:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6DFE6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fgQNUbrI;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=fgQNUbrI
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C5A6222D5;
	Sun, 25 Oct 2026 17:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792947815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Upb6pTRlJjRU6wJ39mtFq3FyWkFkQOOHET/C22knccw=;
	b=fgQNUbrIZsyn9rinjL2pFUFxViHNCLfyRsHOOFAElL1MGlNFFhJmXuZpjEtSf1klu6eObP
	uXa4w9RxjY2PHMytowk4AOsXg5HFlyr8vIfkUBiA5gztHgntFAiK/g07x9fSKKieD5E9Z9
	FePZ5dZDl7C/w+Jt7yWVbAYVfrJmgQM=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792947815; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Upb6pTRlJjRU6wJ39mtFq3FyWkFkQOOHET/C22knccw=;
	b=fgQNUbrIZsyn9rinjL2pFUFxViHNCLfyRsHOOFAElL1MGlNFFhJmXuZpjEtSf1klu6eObP
	uXa4w9RxjY2PHMytowk4AOsXg5HFlyr8vIfkUBiA5gztHgntFAiK/g07x9fSKKieD5E9Z9
	FePZ5dZDl7C/w+Jt7yWVbAYVfrJmgQM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53F6313314;
	Sun, 25 Oct 2026 17:03:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5AZdC2c23mrYFQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Sun, 25 Oct 2026 17:03:35 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 7.4, part 2
Date: Sun, 25 Oct 2026 18:03:33 +0100
Message-ID: <cover.1792947250.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
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

this pull request removes unused code of free space caching, disabled in
7.3 (545e560a5b0f "btrfs: disable v1 space cache").

It's been the original free space cache feature, superseded by free
space tree (4.5) and mkfs default since 5.15. The grace period was
sufficiently long, backward compatibility still exists with a
performance impact, effectively as if mounted with '-o nospace_cache'.

This is a separate pull as there were a few iterations based on sashiko
feedback, but 90% of the code has been in linux-next within the
pre-merge window period. Too late I noticed a glitch in the branch,
unrelated commit "btrfs: fix use-after-free on quota enable allocation
failure" is duplicated due to addition of reviewed-by to the original
base (no code change).  If anything of that is a problem, postponing the
merge is also fine for us.

Please consider pulling, thanks.

----------------------------------------------------------------
The following changes since commit 940983a3000361ddff834a1c55bdb0e9e47ed88b:

  btrfs: prevent use-after-free in btrfs_transaction::switch_commits (2026-10-12 19:18:10 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.4-part2-tag

for you to fetch changes up to 293aae0123e1c178c7f76fd7a93bcced41e6663c:

  btrfs: remove TRANS_JOIN_NOLOCK (2026-10-16 19:10:46 +0200)

----------------------------------------------------------------
Tal Zussman (19):
      btrfs: drop the extent maps of the written part of a failed ordered extent
      btrfs: update the inode item when removing a free space inode
      btrfs: stop enabling the v1 space cache from the on-disk state
      btrfs: remove the v1 space cache writeout from the transaction commit
      btrfs: remove the free space cache endio workqueue
      btrfs: remove the v1 space cache write path
      btrfs: rename cache_write_mutex to dirty_bgs_update_mutex
      btrfs: drop the transaction handle from the prealloc helpers
      btrfs: remove the v1 space cache load path
      btrfs: remove btrfs_disk_cache_state
      btrfs: remove the SPACE_CACHE mount option flag
      btrfs: replace btrfs_set_free_space_cache_v1_active() with a cleanup helper
      btrfs: remove the free space cache trimming ranges
      btrfs: remove BTRFS_RESERVE_FLUSH_FREE_SPACE_INODE
      btrfs: remove the free space inode ordered extent special cases
      btrfs: remove the free space inode special cases from the COW paths
      btrfs: stop special-casing free space inodes in the delalloc accounting
      btrfs: stop reading free space inodes from the commit root
      btrfs: remove TRANS_JOIN_NOLOCK

Yalagada Pavan Kumar (1):
      btrfs: fix use-after-free on quota enable allocation failure

 fs/btrfs/block-group.c      |  497 ++--------------
 fs/btrfs/block-group.h      |   14 -
 fs/btrfs/btrfs_inode.h      |    6 -
 fs/btrfs/delalloc-space.c   |   13 +-
 fs/btrfs/disk-io.c          |   81 +--
 fs/btrfs/file-item.c        |   11 -
 fs/btrfs/free-space-cache.c | 1354 +------------------------------------------
 fs/btrfs/free-space-cache.h |   29 +-
 fs/btrfs/fs.h               |    2 -
 fs/btrfs/inode.c            |  155 +----
 fs/btrfs/ordered-data.c     |   27 +-
 fs/btrfs/qgroup.c           |    7 +
 fs/btrfs/relocation.c       |    2 +-
 fs/btrfs/space-info.c       |    2 -
 fs/btrfs/space-info.h       |    4 -
 fs/btrfs/super.c            |   48 +-
 fs/btrfs/transaction.c      |   62 +-
 fs/btrfs/transaction.h      |   27 +-
 fs/btrfs/zoned.c            |    9 -
 19 files changed, 154 insertions(+), 2196 deletions(-)
