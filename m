Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85611E89C
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775709116; cv=none; b=bLyIjLxLi9HsmX0D1J0CNLTrLROzx3rxMuw9olEyjhmCxsacFM0k3lpTinE92CHrF83CrxmuSxWxKWl1CAkXju/tNfjuRUu4cKNRzoxOttlHf9p3MS+bgtIwWM8FrVdECI8MhbD1gs5sxHrfLTnBZeRtbZx+ywIhlSh2NPpfVOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775709116; c=relaxed/simple;
	bh=F9IEoR1w/xFvJqfwrXUyoRzLOYbzvf8LMv2M2R/5AK4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=BUG03SrOLZRkX2tcKGyr8ZEwbiA/fcIw50jZ8BSYwpi5JUm9VB0+RiAELzczzCdvqRqmUCSxFgLH12iajAPqzG1hL9pB0i8NDeogUiuJdb+Ed6KL4wmHzHRLyt7HH4cXAtsW5Mz1gbi+z4Df6txffrAxnNflc6SCLNKE113zuMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q3icl8p7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q3icl8p7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q3icl8p7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q3icl8p7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9771B5BCEB
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775709112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Dd6Q50pt4zUdFN+YuYXEYNJvjggzXuUSldyhTNbNYTo=;
	b=Q3icl8p7O3bDFfaAxul3r61ylgEcjYZx7yQ43pHOULAc/l+qYd0dv0fX5fYX7ldJ5k62Eb
	at4pT5LWHTGAYTWlE+pVNUmqGGrr9PLy6fWvXIQqk3TNyTrgMDXZJmwx0jbXTbx1hT9PXA
	fTjYCSu/ePXSZ9xRF0R0rRd74wxmySU=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1775709112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Dd6Q50pt4zUdFN+YuYXEYNJvjggzXuUSldyhTNbNYTo=;
	b=Q3icl8p7O3bDFfaAxul3r61ylgEcjYZx7yQ43pHOULAc/l+qYd0dv0fX5fYX7ldJ5k62Eb
	at4pT5LWHTGAYTWlE+pVNUmqGGrr9PLy6fWvXIQqk3TNyTrgMDXZJmwx0jbXTbx1hT9PXA
	fTjYCSu/ePXSZ9xRF0R0rRd74wxmySU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8AAF54A0B3
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 04:31:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6T9QDbcr12lLIgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 04:31:51 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/5] btrfs-progs: mkfs/rootdir: cleanup and test case enhancement
Date: Thu,  9 Apr 2026 14:01:12 +0930
Message-ID: <cover.1775708393.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

[CHANGELOG]
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
 mkfs/rootdir.c                                | 272 ++++++++++--------
 tests/mkfs-tests/041-hole-detection/test.sh   |  48 ++--
 tests/mkfs-tests/042-rootdir-contents/test.sh |  57 ++++
 6 files changed, 260 insertions(+), 142 deletions(-)
 create mode 100755 tests/mkfs-tests/042-rootdir-contents/test.sh

--
2.53.0

