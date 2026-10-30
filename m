Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793333743;
	b=z/+fgpCcpHT9jrf5R8m7O2wpTdCwh2Fsl/vRgT07opGp6BXFCKY50mkdMHmD2ayouK/P
	 VLM3htgHoT3y7S1jO/NepsRaXiQLe+zoH2iCR91lA8KMB1GDMg1yN5pSrZ8C1uEh6+2Ub
	 8MjYmnqNHhUNQqX0zZrIX1suey8cOcjozCJCp76D521N4/4caN+Kg2Or0IarDj2GpqNzz
	 ZYwKXoUNLHe6BhY8x0THcnW5/9gtUFentlYfEaTgAiIdaaA1HzhvOPdqJ3E0Ud2ChLTi6
	 6RBLnucGIbnnq2QUiQmOkwf0QSnKwAZnu6nPfEvmocWo7UtacpPA0KvXfZ2NzjCG78g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793333743;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=R7lBHNNpVOx7G8nwqeF3B/BhnDrCAlzUOZskEH/0oYQ=;
	b=ylQuT5MC/IWZO6SDMk6Op0rGG9+2PWpiYVJyyi4Fao/6HDEem+qSl+V83dD+rD8Iillf
	 R4pQMlg33C68FKyjZTHiixyUWLklkDTUYU7Iy2gd+8dzb/ePJuCL27L85OUWS29WBY3GM
	 JgwFpv+gLhbExqeZv56aXe7FjOqwIQyNLv9E0fkhwBXRjY2taRHIk9pofJ3WrQ8gkRIZ2
	 /i1nP9ePjkg7XJ57Cn8UN0ng4no9Enwew+gmrgRSYP4PoBl36OB1XYEutKcLy4FhndHm0
	 FMRMlsn/ZpW5epQOvXHVWhR4ZhVmyzEUnHNwdtQ1c4qLP43rk5ADPvVdLsz2wfR4vTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uCTry0YD;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uCTry0YD;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8F0606A31C
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E8F0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uCTry0YD;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=uCTry0YD
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0D9EB1FCF9
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=R7lBHNNpVOx7G8nwqeF3B/BhnDrCAlzUOZskEH/0oYQ=;
	b=uCTry0YD5fsEN0VnIRBp9fw0djIAmSqv7ugFFpmYv8gJPAIIfvLDpXDNrhOnhygAYJ/s7x
	v6h24gwocC/rqrfD1Rbv/iblMTF3AUXOQ05rCV8whK0QNkXl9RexMKYGQwgVEBDPrmf1U6
	Afkj+Y0gPny3ARRBXbVQ9CPAFydHPd8=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=uCTry0YD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793333739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=R7lBHNNpVOx7G8nwqeF3B/BhnDrCAlzUOZskEH/0oYQ=;
	b=uCTry0YD5fsEN0VnIRBp9fw0djIAmSqv7ugFFpmYv8gJPAIIfvLDpXDNrhOnhygAYJ/s7x
	v6h24gwocC/rqrfD1Rbv/iblMTF3AUXOQ05rCV8whK0QNkXl9RexMKYGQwgVEBDPrmf1U6
	Afkj+Y0gPny3ARRBXbVQ9CPAFydHPd8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E474B13432
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0uAiEekZ5GrDGwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2026 04:15:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 00/12] btrfs-progs: fix btrfs_path leak, part 2
Date: Fri, 30 Oct 2026 14:45:07 +1030
Message-ID: <cover.1793333606.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 0D9EB1FCF9
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

This is the part 2, focusing on the on-stack btrfs_path.

Unlike heap-allocated btrfs_path, which needs proper btrfs_free_path()
call, or the btrfs_path itself along with the held ebs will leak.

The on-stack one only leaks the held ebs, but still we should fix them.

Just by the amount of code, one should know this is largely generated by
LLM, although I spent more time drafting the plan and review the final
patch.

There are some extra notes other than just converting existing
"btrfs_path" on-stack declaration to BTRFS_PATH_AUTO_RELEASE:

- If a label is only for cleanup, remove the label when possible
  As a lot of call sites can directly return without jumping to the
  cleanup label.

  Also cleanup some "ret = x; return ret;" patterns.

- Keep dedicated btrfs_release_path() if needed
  As our C code is not fully aligning the path lifespan with the scope,
  we still need to manually release path halfway for certain call sites.

  E.g. before calling btrfs_commit_transaction(),
  btrfs_abort_transaction(), btrfs_search_slot(), close_ctree() or
  before lowmem mode modifying the tree.

  Releasing the path before btrfs_commit_transaction() is to follow the
  kernel convension. There are a lot of existing call sites breaking it,
  so here we do not intentionally fix them.

  This will require a dedicated change in the future.

- Reduce the lifespan of btrfs_path when possible
  E.g. the path is only utilized inside a loop or if () branch, declare
  path there.

This applies to patch 01~08, which are all straightforward conversion
with minor cleanups.

After that, the code review process exposed some other bugs in the
touched functions, which are all pretty simple and low severity ones.
Patch 09~12 are to fix those minor bugs.

Qu Wenruo (12):
  btrfs-progs: kernel-shared: use BTRFS_PATH_AUTO_RELEASE() for on-stack
    paths
  btrfs-progs: common, convert, image: use BTRFS_PATH_AUTO_RELEASE() for
    on-stack paths
  btrfs-progs: mkfs: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
  btrfs-progs: tune: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
  btrfs-progs: cmds: use BTRFS_PATH_AUTO_RELEASE() for on-stack paths
  btrfs-progs: check: use BTRFS_PATH_AUTO_RELEASE() for repair,
    qgroup-verify and mode-common
  btrfs-progs: check: use BTRFS_PATH_AUTO_RELEASE() for lowmem mode
  btrfs-progs: check: use BTRFS_PATH_AUTO_RELEASE() for original mode
  btrfs-progs: check: fix fixup_extent_flags() retry path
  btrfs-progs: fix missing transaction commit in
    truncate_free_ino_items()
  btrfs-progs: dump-tree: fix exit code and leak on open failure
  btrfs-progs: check: return error if fill_csum_tree_from_fs() fails to
    read a root

 check/main.c                     | 235 +++++++++++--------------------
 check/mode-common.c              | 141 +++++++------------
 check/mode-lowmem.c              | 202 +++++++++-----------------
 check/qgroup-verify.c            |  29 ++--
 check/repair.c                   |   5 +-
 cmds/device.c                    |  11 +-
 cmds/inspect-dump-tree.c         |  11 +-
 cmds/rescue-chunk-recover.c      |  43 ++----
 cmds/rescue-fix-data-checksum.c  |  10 +-
 cmds/rescue.c                    |   7 +-
 cmds/restore.c                   | 126 +++++++----------
 common/clear-cache.c             |  79 ++++-------
 common/root-tree-utils.c         |  10 +-
 convert/main.c                   |   9 +-
 convert/source-ext2.c            |   3 +-
 convert/source-fs.c              |   3 +-
 image/common.c                   |   2 +-
 image/image-create.c             |   2 +-
 image/image-restore.c            |  20 +--
 kernel-shared/extent-tree.c      |  62 +++-----
 kernel-shared/file.c             |   3 +-
 kernel-shared/free-space-cache.c |  24 ++--
 kernel-shared/inode.c            |   8 +-
 kernel-shared/print-tree.c       |   9 +-
 kernel-shared/volumes.c          |  15 +-
 mkfs/main.c                      |  42 ++----
 mkfs/rootdir.c                   |  36 ++---
 tests/btree-test.c               |   2 +-
 tune/change-csum.c               |  50 ++-----
 tune/change-uuid.c               |  38 ++---
 tune/convert-remap-tree.c        |  12 +-
 tune/quota.c                     |  19 ++-
 32 files changed, 447 insertions(+), 821 deletions(-)

--
2.56.0

