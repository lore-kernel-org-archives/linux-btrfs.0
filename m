Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EED231A813
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 09:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725181; cv=none; b=QtWgGdkQDfSZaQvmx9amltiOByithXFMow70M2GgDV/WhtexHFLelZp/m6MrmRyUV2lrD+VFY2hpHwWMkEvVonhFGEUCrhCCOEPXKkEO6fykLHzT4gTEyIC0//afnKQ7s6oHOSGzjHSGb/UsVgR1Puuckvv1KRhUcYIR0Dpjy8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725181; c=relaxed/simple;
	bh=hjhSrL/KtrLLnFFQpQnaXG8y90PaHpgvL94noLXyyBg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tDq07OkgvuTgONWJZu49aGyMJc8OXsf7ZDu5dLA5EZR1h7xlDh92x8MI494caDAs2I8XPaYWD6X2q93Rjs4/meTqE3zMIZwbz73HjJYKKJnU0Vl++I06OOFtAF3C+YzDQlnTj+iDX2qpkRX5D91yL5gES6SmfSrjGnXIQld6apE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RScoMOql; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RJSZsHyt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RScoMOql";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RJSZsHyt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 46E4B72FC0
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 09:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782725178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nIYuOekR1kAS/7II+3pyjk2ZhzzvhW47MRmNxOus6CY=;
	b=RScoMOqlh81fUwwK2/ws056e7Q97m4jr0DLMskpPW+s3tvimiFcLjuINPvKTN2qhbL6Uj0
	GNXaucK5K8cSAeUUnsvEG+I9brfVxSwoH1paU3L6amFccp7F2IF+MNxE+Ih20NRjzjqqGt
	HDfBIFBKFtJL9DGqmi/LVjkJbiqUTzk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782725177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=nIYuOekR1kAS/7II+3pyjk2ZhzzvhW47MRmNxOus6CY=;
	b=RJSZsHyt0QXDB1FA6PYAbLsSC/NsEgij1UOzTz2IeP3PkuYwjLD9aAkoY0ZbbBAhqDHl5B
	10wfgGr8NIIwU5wkdxxGUx7DJgBQYMI7SoYy+ZpNzkw2m4KJ4URKqZG36edMBWlPOF1WOV
	9fHXDMygCWjEOWdoR1EVaO701UXHHA8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4E5B6779A8
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 09:26:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id rU8tADg6QmojWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 09:26:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/2] btrfs: simplify the stripe buffer handling
Date: Mon, 29 Jun 2026 18:55:51 +0930
Message-ID: <cover.1782725129.git.wqu@suse.com>
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
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
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
X-Spam-Level: 

[CHANGELOG]
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

Qu Wenruo (2):
  btrfs: remove SCRUB_MAX_SECTORS_PER_BLOCK
  btrfs: use kvmalloc() for stripe buffer of scrub_stripe

 fs/btrfs/raid56.c |  18 +----
 fs/btrfs/raid56.h |   2 +-
 fs/btrfs/scrub.c  | 183 ++++++++++++++++++++--------------------------
 3 files changed, 85 insertions(+), 118 deletions(-)

-- 
2.54.0

