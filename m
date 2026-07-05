Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A593769E4
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783252516; cv=none; b=ZogZCIxWLewuVZ7chOhi4pSltUF2rFhZ+IaopJM9QPO1YLbju6LyReL8HPOrMwRQIOCzuS4ASEwsZZlEFp/33T/32jGmEP+A6B7PgJCR7/rPRgey8KV/z8873u6d3oF+TcOiC2Zg9IaNJcNTwec0x1gJIZ7xh8aKCUpszJmfRBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783252516; c=relaxed/simple;
	bh=OMHZWDXo9mPQItSP8ljQ7Hkz5dY1qB7kTj+QvzHMHRE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rakkwM83PWmDKnSv2BxUMwujdL5rDhPNndoeU5GduQunogNcwvTdh5ZOAH+hm4J9NpMG9r0V+HeMbNiSmfEBn125yi1Gs2sJsHQMFGbiUEybQJkryVjRb2IOLiBrX5U9A8v0EXDvzuuXTVpJBcLCy+0rE7oG1nMDCRLwrCL+h7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OlVY7di7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OlVY7di7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OlVY7di7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OlVY7di7"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2854D75922
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783252513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6wco0N5n2wDcFy0yWMu8V8wrjPW/s8cMFYYvLxiLs84=;
	b=OlVY7di7aU5U6D4FYA/BjhbYl1Xu1245fJ61IegpPBJLen1+1+ptQZNwklmtKsJiajuaA/
	BrQMxgewyJbfmH5kEsKjGh53rcj40Sn8Fl9O26PlmE4OtD1KuZcOE70QIUkA84Kgqer68f
	mH4WPHg7wX7tflXW1+2xHeL4hLMTC+U=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783252513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6wco0N5n2wDcFy0yWMu8V8wrjPW/s8cMFYYvLxiLs84=;
	b=OlVY7di7aU5U6D4FYA/BjhbYl1Xu1245fJ61IegpPBJLen1+1+ptQZNwklmtKsJiajuaA/
	BrQMxgewyJbfmH5kEsKjGh53rcj40Sn8Fl9O26PlmE4OtD1KuZcOE70QIUkA84Kgqer68f
	mH4WPHg7wX7tflXW1+2xHeL4hLMTC+U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B362779AA
	for <linux-btrfs@vger.kernel.org>; Sun,  5 Jul 2026 11:55:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v45lMh9GSmqsTgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 05 Jul 2026 11:55:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v6 0/4] btrfs: simplify the stripe buffer handling
Date: Sun,  5 Jul 2026 21:24:45 +0930
Message-ID: <cover.1783252371.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Level: 

[CHANGELOG]
v6:
- Remove an ASSERT() that is no longer required
  Since there is no code that even bothers the underlying page layout
  anymore, the ASSERT() for the alignment of kvmalloc() returned address
  can be safely removed now.

v5:
- Use a simpler and faster way to implement calc_sector_number()
  Commit 81cea6cd7041 ("btrfs: remove btrfs_bio::fs_info by extracting
  it from btrfs_bio::inode") uses logical bytenr as the file_offset for
  scrub bbios, so we have a very reliable way to determine the bytenr,
  without the need to iterate through all the blocks.

  This removes the only the caller that iterates through the scrub block
  addresses, and should also completely shut sashiko up on the impossible
  unaligned address returned by kvmalloc(64K).

v4:
- Add a patch to extract the common handling of scrub read endios
  This is to reduce duplication and allow a single
  invalidate_kernel_vmap_range() call to be added with proper comments.

- Add a comment on why we need to call invalidate_kernel_vmap_range()
  for vmallocated memory
  It's mostly copied from dma-api doc.

v3:
- Add a patch to remove a unused macro

- Add new ASSERT()s to make sure the kvmallocated memory is page aligned
  The size is 64K, which is page aligned and power of 2, thus the
  resulted memory should at least be page aligned.

  Furthermore, we have several call sites using (BTRFS_STRIPE_LEN /
  PAGE_SIZE) or (BTRFS_STRIPE_LEN >> PAGE_SHIFT), add an build time
  assert to make sure our PAGE_SIZE is not larger than BTRFS_STRIPE_LEN.

v2:
- Fix a potential double-free during release_scrub_stripe()
  Reported by sashiko.

- Enlarge the scrub bbio to be able to contain the full buffer
  Since the buffer is allocated by kvmalloc(), it's possible that not
  all pages are physically contiguous.

  In that case we have to enlarge the bbio to contain
  (BTRFS_STRIPE_LEN >> PAGE_SHIFT) bvecs.

This is to use kvmalloc() to allocate a buffer for scrub, so that we do
not need to bother page-switching, and simplify the scrub progress.


Qu Wenruo (4):
  btrfs: remove SCRUB_MAX_SECTORS_PER_BLOCK
  btrfs: extract the common scrub read endio into a helper
  btrfs: scrub: implement calc_sector_number() in a faster way
  btrfs: use kvmalloc() for stripe buffer of scrub_stripe

 fs/btrfs/raid56.c |  18 +---
 fs/btrfs/raid56.h |   2 +-
 fs/btrfs/scrub.c  | 235 +++++++++++++++++++---------------------------
 3 files changed, 104 insertions(+), 151 deletions(-)

-- 
2.54.0

