Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7257F2BEFF5
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782807855; cv=none; b=X4pJm4DGp0+GsiPvr4gDv8BYgnxMNV6ZNsRdfSFg3ru4DXnWYsWnZYfcC1sm6/A8B5S/sUV5rB2z1+FDZN2gJIb8wgyPyN0l7CpFGdLjwq8Y14rrR91abLp9eUGBpBu6zVXmA2ZLPMiXvIjuubIr3swePY2x6AMGR7/X2yieL5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782807855; c=relaxed/simple;
	bh=I1ELFZ8+l+9Tg9RVAHkTBSoDJ2vWb782NVv0laguFUA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hpJJCBQJ+jpAfvQVnxpBWCdY4TkCirI9yBowdhXivAiS6mxfIsDFF1E/iTRzLtMbDt+ozygnfSlU9AJDVXmL7p09dH1Qkc76zJvj8v2D03gqaj6cgrJPDtuN4ORZbu79QkVaw20UA9dRPucd6dHWb+XnsMFMUqcEwfUtjixWP0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dROKKCrh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dROKKCrh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dROKKCrh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dROKKCrh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C456B73553
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782807851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qoCki5qhw3RB8rUilN5jeDRbql6zYBRFdAt14YL6Vu0=;
	b=dROKKCrhDPNBOd3XANdYhDy2XQ+BF6UxIB62jNks2E3O271PMhL3/rnNkcqixyvILd7/nv
	MGT47MelDQOp8K9Qna6dM0rXOKrW/M8ERi3aycMiIIk81ymiBmXSxX7Jes+duYsxDRdeYo
	wV7H+lu74uU+mBpA0H0It5stiBxluXs=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782807851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=qoCki5qhw3RB8rUilN5jeDRbql6zYBRFdAt14YL6Vu0=;
	b=dROKKCrhDPNBOd3XANdYhDy2XQ+BF6UxIB62jNks2E3O271PMhL3/rnNkcqixyvILd7/nv
	MGT47MelDQOp8K9Qna6dM0rXOKrW/M8ERi3aycMiIIk81ymiBmXSxX7Jes+duYsxDRdeYo
	wV7H+lu74uU+mBpA0H0It5stiBxluXs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8D5F779A8
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W63XHSp9Q2oBEAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2026 08:24:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/3] btrfs: simplify the stripe buffer handling
Date: Tue, 30 Jun 2026 17:53:48 +0930
Message-ID: <cover.1782795330.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
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

Qu Wenruo (3):
  btrfs: remove SCRUB_MAX_SECTORS_PER_BLOCK
  btrfs: extract the common scrub read endio into a helper
  btrfs: use kvmalloc() for stripe buffer of scrub_stripe

 fs/btrfs/raid56.c |  18 +---
 fs/btrfs/raid56.h |   2 +-
 fs/btrfs/scrub.c  | 235 +++++++++++++++++++++-------------------------
 3 files changed, 111 insertions(+), 144 deletions(-)

-- 
2.54.0

