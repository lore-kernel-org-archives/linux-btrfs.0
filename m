Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDE432ED58
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2026 04:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784608094; cv=none; b=fir/EphKwGoabq2Wsb1I1torT1xNg96zu0SUyHNoWjwTtlNkEHlZXUUtaiWG/ieHR2T47LNamCz9MM9qviYuoTblZw8u919lU/FZf/w6pf2zOjqXq2S/6kcyiPftQBUb+3HG78bvTL2S4a0gQgRE0IGNA13PRa2CM9VT8m7WoM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784608094; c=relaxed/simple;
	bh=8tmScOsejgMu/SuPaPH/NO4i3S1bniQkLQq4cnPPIGE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BDrkj0rLauCnxvuot0OSj1mkccNQ5vbY897LeTmCQm9m2e5oyTSnKuXz83jkyvRs70QLIb4uDWVjZWd19CfQyjRJozsdsn37/PeTl+cW6XnpXF+8RmBhL42tXECbicpK6ZM4U6lbd0L9KvfIY2B+Lw0xxWhUcEgBSWdLoXzaEVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KR3aLLS+; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=XSUMwOjn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KR3aLLS+";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="XSUMwOjn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BFEB33E38;
	Tue, 21 Jul 2026 04:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784608089; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=r1kkXw1/kH9kdAfFrcbXVToAnyjBvqIwxlyGih36gsA=;
	b=KR3aLLS+ako0p4JjfGxwr/FsGnQ9xX0e79Ct+V2XGUgKDUikTGmQLvOgwb/jmZ6UK9GgKF
	VmLYiAmdRKVChZUTANL5UIGDrXolRI9M1u7UB7knezt62jEEZZR6smTruNeCn5Yf8JbVKQ
	FNUo/Z1CEb8LmRP6v4N65LBdlmZPjoI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=XSUMwOjn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784608087; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=r1kkXw1/kH9kdAfFrcbXVToAnyjBvqIwxlyGih36gsA=;
	b=XSUMwOjnyGfAcrfSwlp4XrrlXCxXq48tNTgfqJMgHExrxkj2zx2DlpyglxvtqCp0PxO7HF
	QIRrteskcZC7csXxEv5RO9kOz+w6y1KhIofgwxgaNOvV6V2CeyQQJ1/w8J1raUiw93ZOU9
	U4cjW1WCc1BzlqBM3QjpDKuFg64ILMA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B40CE779AA;
	Tue, 21 Jul 2026 04:28:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eqNHK1f1Xmq8cQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Tue, 21 Jul 2026 04:28:07 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.2-rc5
Date: Tue, 21 Jul 2026 06:28:05 +0200
Message-ID: <cover.1784603168.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: BFEB33E38
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
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
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Hi,

please pull the following fixes. I'm catching up with fix backlog in
the development branch, so here's a number of them and will probably send
one more for this or the next rc.

Thanks.

- relocation fixes
  - skip attempting compression on reloc inodes
  - exclude inline extents from file extent offset checks
  - fix minor memory leak after error when adding reloc root
  - fix root cleanup after inserting and merging

- fix clearing folio tags after writeback

- clear logging flag of extent map before splitting

- fix unsigned 32/64 type conversions when accounting dirty metadata,
  leading to continually exceeding threshold

- fix regression in 32bit compat ioctl for subvolume info

- fix type of SEARCH_TREE ioctl buffer in UAPI header

- fix expression in ASSERT expression which can be unconditionally
  evaluated on some compilers

- only account delalloc bytes for regular inodes

----------------------------------------------------------------
The following changes since commit c0041b502e579a5c52e5cae918b90678f03faddd:

  btrfs: print-tree: print header owner as signed (2026-06-30 02:02:03 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.2-rc4-tag

for you to fetch changes up to 75a41e3e51eb0d6f7a4969c5056298c2aa3e85f2:

  btrfs: fix GET_SUBVOL_INFO after compat refactor (2026-07-14 07:05:10 +0200)

----------------------------------------------------------------
Daan De Meyer (1):
      btrfs: fix GET_SUBVOL_INFO after compat refactor

Dave Chen (2):
      btrfs: only account delalloc bytes for regular file inodes in btrfs_getattr()
      btrfs: fix u32 to s64 type conversion in dirty_metadata_bytes accounting

Filipe Manana (3):
      btrfs: fix use-after-free on reloc root after error in insert_dirty_subvol()
      btrfs: fix reloc root cleanup in merge_reloc_roots()
      btrfs: fix NULL pointer deref during assertion in btrfs_backref_free_node()

Guanghui Yang (1):
      btrfs: free mapping node on duplicate reloc root insert

Leo Martins (1):
      btrfs: don't propagate EXTENT_FLAG_LOGGING to split extent maps

Qu Wenruo (3):
      btrfs: do not try compression for data reloc inodes
      btrfs: reject inline file extents item in get_new_location()
      btrfs: fix a regression where PAGECACHE_TAG_DIRTY is never cleared

You-Kai Zheng (1):
      btrfs: declare btrfs_ioctl_search_args_v2::buf as __u8

 fs/btrfs/backref.c         |  5 ++++-
 fs/btrfs/btrfs_inode.h     |  2 ++
 fs/btrfs/extent_io.c       |  4 ++--
 fs/btrfs/extent_map.c      |  4 ++--
 fs/btrfs/inode.c           |  3 ++-
 fs/btrfs/ioctl.c           |  1 +
 fs/btrfs/relocation.c      | 55 ++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/subpage.c         | 26 +++++++++++++++++++---
 include/uapi/linux/btrfs.h |  2 +-
 9 files changed, 80 insertions(+), 22 deletions(-)
