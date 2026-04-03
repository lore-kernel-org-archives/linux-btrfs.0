Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1411E0B9C
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775190802; cv=none; b=Qn8ueDRsmRhnJSXXdJrp/RMOVXL9IoEzVDhMZMe/reJLbrUkXV8KOORSvhmXW5pNgKv4zD1THIjKxpVuilN0B/56uMmpCTSYjAOp9nu7fkYc/8zPwKHKwtr5p3JZ9SoYocx/04S0WtVOJjkkF30XcFPKo8aghqhu4j/JS8CFrFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775190802; c=relaxed/simple;
	bh=hGgc8Am9QAkWlOfvj/tao8t1iR5uIBhHlUK1Rf4iyWI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cJ+pFpHOp7f3C/YlUGulTT4wf7xV+xWegXkrZUYsiFiY0PCa+hJoryUFUSIkIWyWlpIzidbsyM4plZd6PaG9C4Vn/ZU5weuc2kO9NsJxCqTtg3LUhOtm7fcpTKcj/9DqizACfGZD4JzcIaBDSyDKCt58mYvmSWN2LI6ZIdtZhuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DhQuC4s9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Bf97w+40; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DhQuC4s9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Bf97w+40"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F03F84D1C3
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775190799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LJOcwjSOjpJJ39wMzR9jgSYRIRE76DLBfHGTLrYUyYY=;
	b=DhQuC4s9YxAl5FeyPdGd7m2Q9Ktwj3ncLP4daPb5mh1StZjPreGXVGaxUc4qSS27cPUPDr
	h3CJmxnEWt7ExzlzVCVbHzhVq26EqUOVUYeAm+nQnbBHEovbefMYLEc+mcpc0SYs9GeBPa
	kyt/aME5ztdesVMrXA8MRV2oDreuKaI=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Bf97w+40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775190798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=LJOcwjSOjpJJ39wMzR9jgSYRIRE76DLBfHGTLrYUyYY=;
	b=Bf97w+40Gye+lR+bsHyJwLAvDZjjqqBkrx9b1Ecp61CJFpUC7/D85TsPqX3w5mF6x5Epyp
	Yb0f6dwpXfKxC4NdrsRRds5XPOQ5FRXL7H5dRwgm4pgUqs2vDXogZtGwCoqJG7D01WEuPd
	Tuph/UmAYvZyOMRre1DRYHuMV3m3jmc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B7F14A0B0
	for <linux-btrfs@vger.kernel.org>; Fri,  3 Apr 2026 04:33:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /fw9AA5Dz2nTYQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 03 Apr 2026 04:33:18 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/6] btrfs-progs: mkfs/rootdir: cleanup and new fiemap based prealloc detection
Date: Fri,  3 Apr 2026 15:02:54 +1030
Message-ID: <cover.1775190565.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: F03F84D1C3

[CHANGELOG]
v2:
- Add a new test case to verify hole detection with/without no-holes
  There is a bug in the ^no-holes handling that an incorrect file extent
  is inserted with uninitialized type.

  Exposed and fixed by Mark.

- Add a new test case to verify the file contents of hole detection

  There is a bug in the refactor of read, which overwrites the buffer
  instead of properly advance the cursor.

  Exposed by Mark with Chris Mason's review prompts.

- Keep the existing first block based bad compress ratio detection
  Previously if we had bad compression ratio after the first block, we
  do not mark the inode incompressible.

  Follow the existing behavior.

- Fix the hole size capping in fiemap mode
  Which previously is not capping the hole size, and can trigger
  UASSERT()s.

- Enhance the new fiemap test case with fssum
  To verify both the hole and file contents matches.

The PR can be found here:

  https://github.com/kdave/btrfs-progs/pull/1103

Although previously I added a SEEK_DATA/SEEK_HOLE based hole detection,
it doesn't distinguish holes from preallocated ranges.
Thus if a rootdir contains some preallocated extents and the end user
also expects such preallocated space in the target fs, they will be
replaced by holes.

The first 2 patches are enhancing mkfs test cases to be more robust,
covering both no-holes and ^no-holes features, as Mark exposed a bug
affecting ^no-holes only in previous hole-detection.

The 3rd patch extracts btrfs_insert_hole_extent() to make it a little
simpler to use, without the need to populate a local on-stack file
extent item.

The 4th patch makes compressed write path easier to read, without
combining both compressed and uncompressed paths.

The 5th patch is the core of the new fiemap based hole detection, which
utilized fiemap to detect preallocated space.

The final one is a functional test for the new fiemap feature.

Qu Wenruo (6):
  btrfs-progs: mkfs-tests: also test hole-deteciton without no-holes
  btrfs-progs: mkfs-tests: add a test case to verify the content of
    rootdir
  btrfs-progs: implement the missing btrfs_insert_hole_extent()
  btrfs-progs: mkfs/rootdir: extract compressed write path
  btrfs-progs: mkfs/rootdir: use fiemap to do prealloc detection
  btrfs-progs: mkfs-tests: add a new test case for fiemap based
    detection

 Makefile                                      |   2 +-
 kernel-shared/file-item.c                     |  17 +
 kernel-shared/file.c                          |   6 +-
 mkfs/rootdir.c                                | 369 ++++++++++++------
 tests/mkfs-tests/041-hole-detection/test.sh   |  48 ++-
 tests/mkfs-tests/042-rootdir-contents/test.sh |  57 +++
 tests/mkfs-tests/043-fiemap-detection/test.sh |  64 +++
 7 files changed, 420 insertions(+), 143 deletions(-)
 create mode 100755 tests/mkfs-tests/042-rootdir-contents/test.sh
 create mode 100755 tests/mkfs-tests/043-fiemap-detection/test.sh

--
2.53.0

