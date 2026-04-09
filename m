Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365CD27281D
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775724747; cv=none; b=Mj40qvqcZM1z/Z+QFHL2JP2HT6lZ9XK3pd/6QxfyJtfVwM2BGIwKhwuveB6+CMdKeg0reHbKRs6LczBAIBrjzCMUwQHNK17SLY4dws7VbL0o7w17XgeYStX9ua8e0jpNImumG2A4bqGSh8kAtBOQwp/aLQhHXFpL37mtX7bSI3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775724747; c=relaxed/simple;
	bh=aAah9SjeOrAbcu804LZSLFRvw6JJ8UPVmb9qbHXiXUk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=M2v+gAtq/t1KkL9e1FWHCyIClrkH1CTOFNuvIPSlAgg5KUpyGsa7xLd8OetdI8wMao6VKazgh8x/h5CIzYiYJsvBYodtLikcL5a3UUxeBRl5Pf3Nf+Z+EY6kXiuqAN6JkSHS1vZtAulS/QzATiYB9eiCC3kkKdATddZoll9hl38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RtUcSGHL; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RtUcSGHL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RtUcSGHL";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RtUcSGHL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 660164EE58
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775724744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/NjSBNQSLAKg/tjiGpL53OgSOPIWArJEYQVb8LzgKdg=;
	b=RtUcSGHLc979I7RISkunY87Zby0ZU3Wp9zoe0bGrbrSKolUhz549v7+9uPQBv+XfAhadm/
	JuITr7mpFuCX4ob8N+SiLi5yLeezE2RcDlbJrPtkLLbFqGbRyIzQG9QbAvvxKfKkolzd7a
	UkKteB3i+KY+uTu3nrU1jOiKjtVGMxM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=RtUcSGHL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775724744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=/NjSBNQSLAKg/tjiGpL53OgSOPIWArJEYQVb8LzgKdg=;
	b=RtUcSGHLc979I7RISkunY87Zby0ZU3Wp9zoe0bGrbrSKolUhz549v7+9uPQBv+XfAhadm/
	JuITr7mpFuCX4ob8N+SiLi5yLeezE2RcDlbJrPtkLLbFqGbRyIzQG9QbAvvxKfKkolzd7a
	UkKteB3i+KY+uTu3nrU1jOiKjtVGMxM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 62C064A0B3
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 08:52:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NSVPBMdo12lUJwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 08:52:23 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/5] btrfs-progs: mkfs/rootdir: cleanup and test case enhancement
Date: Thu,  9 Apr 2026 18:21:59 +0930
Message-ID: <cover.1775724568.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: 660164EE58
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[CHANGELOG]
v4:
- Fix a bug that adds the data size twice
  It's in the last patch, when the source fs supports SEEK_DATA,
  ftw_data_size is added twice (by on-disk size and st_size)

v3:
- Remove the fiemap based prealloc detection
  The complexity doesn't really bring any other benefit and preallocated
  space itself is not that commonly used for fs image creation.

- Update the image size estimation
  To fully co-operate with the new hole detection.

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

The first 2 patches are enhancing mkfs test cases to be more robust,
covering both no-holes and ^no-holes features, as Mark exposed a bug
affecting ^no-holes only in previous hole-detection.

The 3rd patch extracts btrfs_insert_hole_extent() to make it a little
simpler to use, without the need to populate a local on-stack file
extent item.

The 4th patch makes compressed write path easier to read, without
combining both compressed and uncompressed paths.

The final one is to use st_blocks to estimate the data size, so the
resulted fs image can be as small as possible.

Qu Wenruo (5):
  btrfs-progs: mkfs-tests: also test hole-deteciton without no-holes
  btrfs-progs: mkfs-tests: add a test case to verify the content of
    rootdir
  btrfs-progs: implement the missing btrfs_insert_hole_extent()
  btrfs-progs: mkfs/rootdir: extract compressed write path
  btrfs-progs: mkfs/rootdir: use st_blocks for size estimation

 Makefile                                      |   2 +-
 kernel-shared/file-item.c                     |  17 ++
 kernel-shared/file.c                          |   6 +-
 mkfs/rootdir.c                                | 277 ++++++++++--------
 tests/mkfs-tests/041-hole-detection/test.sh   |  48 +--
 tests/mkfs-tests/042-rootdir-contents/test.sh |  57 ++++
 6 files changed, 265 insertions(+), 142 deletions(-)
 create mode 100755 tests/mkfs-tests/042-rootdir-contents/test.sh

--
2.53.0

