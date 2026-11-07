Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794085476;
	b=Stks+Qy59o4z151vTyaKiew+RBWW+bseLzF1IJ89ssrLrLlReD1Yj6Ng0jBFJUldlKoZ
	 V96X6VfmXLogz+/RwEHXP0UFMG/jKczMB4zWBna2qAnjGiQ9fVjTfDRDB9KppWK+LKk0U
	 UrgM59SRxd0o3n/T3C/fNQ/HxXJWSg1d1SSbE5AKcxhfYjFK/Q1VOIBhkMlCSRm73MCRi
	 4fXx4+w5U0vKDoGnAkzkX2yRlbP1M9aqs020zj+OGChgf+Oq57TZXuh7AEG53BjjfCPsK
	 4eJ8MjqwTZKCt7zLax8Ebn8JnSoVSMFkwH4vNfuTwCMui6GFgZBtLEuHjk57GQx5oqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794085476;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=GUjVQoo2IsvtXInQRPCzjFJ5aVei2WEkFAWaKbyVoQc=;
	b=qtxJ4y+BLi1+4xpXSfk6/DKmbmMXPMIxPxD3gF1PirbW+WbxlyVZ61nNb9Y09lAYY9JE
	 A/jiDxRPUSXYXowuRvvhUmAuArzhApw7aCEYZmMIXwes3yHL4I/sPo50xrg6lMPRJBjno
	 /t8K7CxQDPXuK8AnJaiQmizGTWSwNbjZBHvjKL/g1qjCpHjPCbTQIoRuQSNeQUjUM9kUQ
	 EtrOkomcMPhfSoUo7TqBVm0Q8s068ZKQN90sAijd2zWxwUF6F1osJSvT4O8j81azkn+EO
	 JI90SZbXo7pzHIR1r7KT5/p2QgTOjP1Ub6wNNbiHmNJwnOJlnwgf66XWrdcNMhEaVzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=SWqR6E7y;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=SWqR6E7y;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF458606A326;
	Sat,  7 Nov 2026 21:04:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF458606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=SWqR6E7y;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=SWqR6E7y
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 77C621F38F;
	Sat,  7 Nov 2026 21:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794085467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GUjVQoo2IsvtXInQRPCzjFJ5aVei2WEkFAWaKbyVoQc=;
	b=SWqR6E7ye1bXSXPaZ7J0s7MRACpK6LUqiCugtBj6HgFcpDXpd8EVDBKi9GdpZRlp07GdKJ
	aXY3MAw/qqaILLHNkojqnw3KA8k2n5BuLWy8vvY6IIKAT6iRmJMjS4v/c9L24KqXp0O7DG
	O7SjidF6SrnPdl46FDbA47c8E/26XaI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=SWqR6E7y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794085467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=GUjVQoo2IsvtXInQRPCzjFJ5aVei2WEkFAWaKbyVoQc=;
	b=SWqR6E7ye1bXSXPaZ7J0s7MRACpK6LUqiCugtBj6HgFcpDXpd8EVDBKi9GdpZRlp07GdKJ
	aXY3MAw/qqaILLHNkojqnw3KA8k2n5BuLWy8vvY6IIKAT6iRmJMjS4v/c9L24KqXp0O7DG
	O7SjidF6SrnPdl46FDbA47c8E/26XaI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 30A3F132C9;
	Sat,  7 Nov 2026 21:04:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4XSkAluS72oOLQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Sat, 07 Nov 2026 21:04:27 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.4-rc2
Date: Sat,  7 Nov 2026 22:04:25 +0100
Message-ID: <cover.1794085177.git.dsterba@suse.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 77C621F38F
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.51

Hi,

please pull a few btrfs fixes. The ones that could have some user
noticeable impact are enumerated, the rest is one-liners.

Please pull, thanks.

- fix chattr failing on files with nodatasum and compress flags

- fix inode defrag status with concurrent truncation so it's not skipped
  in defrag in the future

- fix merging compressed extent in fiemap output

- fix deleting wrong subvolume by id if it gets renamed during the ioctl

- error handling fixes: sysfs, quotas, fs-verity, scrub, zoned mode

----------------------------------------------------------------
The following changes since commit 58e844c3ba387ceb0f527a6ba82aa50c81c4d7b7:

  btrfs: fix use-after-free on quota enable allocation failure (2026-10-12 23:59:21 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-7.4-rc1-tag

for you to fetch changes up to 8c66a6aa59a5df1d672d72b7cd379d897ff73200:

  btrfs: zoned: fix double free of bitmaps on clone failure (2026-10-30 23:17:16 +0100)

----------------------------------------------------------------
Adarsh Das (1):
      btrfs: unwind device add when sysfs registration fails

Filipe Manana (6):
      btrfs: defrag: prevent inode truncated to zero from not being defragged again
      btrfs: fix fiemap merging compressed extents
      btrfs: scrub: fix lost error return value when scrubbing raid56 parity stripe
      btrfs: scrub: fix lost wakeup and hang when cancelling a scrub that is finishing
      btrfs: scrub: fix race leading to use-after-free in the scrub progress ioctl
      btrfs: scrub: fix race between scrub and scrub progress ioctl

Hengyu Liang (1):
      btrfs: fix chattr failing on nodatasum files that have the compress flag

Qu Wenruo (4):
      btrfs: always remove quota_root from dirty_cowonly_roots
      btrfs: cleanup qgroup swapped blocks at root release
      btrfs: cleanup dirty_cowonly_roots during btrfs_free_fs_roots()
      btrfs: fix the fsverity callback where unexpected range is verified

Thomas Fourier (1):
      btrfs: zoned: fix double free of bitmaps on clone failure

guolingxing (3):
      btrfs: sysfs: restore NOFS context on early return in btrfs_sysfs_add_block_group_type()
      btrfs: verity: propagate orphan insertion errors when enabling verity
      btrfs: prevent deleting the wrong subvolume by ID

 fs/btrfs/defrag.c    | 11 ++++++++++-
 fs/btrfs/disk-io.c   | 20 ++++++++++++++++++++
 fs/btrfs/extent_io.c |  2 +-
 fs/btrfs/fiemap.c    |  3 ++-
 fs/btrfs/ioctl.c     | 24 ++++++++++++++++++++++++
 fs/btrfs/qgroup.c    | 12 +++++++-----
 fs/btrfs/scrub.c     | 22 +++++++++++++++++-----
 fs/btrfs/sysfs.c     |  4 ++++
 fs/btrfs/verity.c    |  2 +-
 fs/btrfs/volumes.c   |  7 ++++++-
 fs/btrfs/zoned.c     |  5 +++++
 11 files changed, 97 insertions(+), 15 deletions(-)
