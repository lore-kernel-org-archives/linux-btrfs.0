Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E17F43A7F7
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790142308; cv=none; b=GPAe7DdbrOT0KVGBZN2lCMKxJwoJNVfXdsL/LWq49DEwe0R2xdZem5h4Edqdq5tW0CKUyvbMF6TyslfqWM9LOPjpTdvoqeRUvm4CzovRHC1AVc049l6HhGr7BnCUIHvqYHwuQ3GdCpAtsTJx8PTVDQNzymiIrY/4hSFb7rr73R4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790142308; c=relaxed/simple;
	bh=VVCdNdLIysLLxbZC/SYIC7bkDuRgfRH0yzv5wIea0V0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=SDURg3pVNzcPc0kr+k0900Wb1bNiCpHEq7M1bLEwCVcupg3za1W1X1lZF9cQAX20UE4dlXgKZZvj5bz1x+YAdP5aOFC/GIoAojt2C5SzMHdbwo9obJEGKK+ydw+V/+yk1gvx42NAjYPaleWI1O9cAcZX9FpEAeHdZlk+zokUz5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=IxLDvqot; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fgzUbhQQ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="IxLDvqot";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fgzUbhQQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BBDD621CDB
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790142299; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wqU8yFHM7DODFW1N6GKaHrNsmPJUiP3BaxPbwUKy0mI=;
	b=IxLDvqotYtATUkPAsaLX7tXCEPKOP1D9Xz3hH9OzyYiVjYM21ZJtF+uprRiOm68wh9CWww
	uMJRbp8Dy0/FI+n/2nEsvXkerGFISHgOZncC1puqG5UDopiGxBZv+DpJvIP2U3mnjVVLrk
	WvQevs78Y86B0X3D7NyKBfJqVjY8JjE=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790142295; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wqU8yFHM7DODFW1N6GKaHrNsmPJUiP3BaxPbwUKy0mI=;
	b=fgzUbhQQWfLY5Zjdg4IwZY5Y0kX8Juw1OpKAct+LMnT7cN6HRRGGhb2Nb8g4uc3c4uCnVs
	U1kGc0jo4XzyLoYzCagA8Zcqa4WnzkEqxzJpLJg5pPF10sTw6dlvc1Xwly0J4tf9iYN5iq
	oP9qX/c14am4x6NrtcK3Q3y8t8iIfyM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7BECD134E8
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 40aCMlVns2o/dgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2026 05:44:54 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: use kvmalloc() for cases where allocation can be more than one page
Date: Wed, 23 Sep 2026 15:14:24 +0930
Message-ID: <cover.1790142027.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -2.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

There are still some cases where kmalloc() and its variants are called
where the memory allocated can be multiple pages on x86_64.

Normally any kmalloc() with a size that <= PAGE_ALLOC_COSTLY_ORDER (3)
should not fail that easily, so even we allocate a multi-page buffer
using kmalloc() as long as it's not reaching 64K (4K page size) it
should still be fine.

Thus those cases are all very rare:

- An inlined extent larger than 4K
  This can only be archived by a system with page size larger than 4K,
  along with larger max_inline.

  And still, only 64K sized inlined extent can really cause problems.

- Too many RAID56 data stripes with SHA256
  To go beyond 4K, it only requires 9 data stripes, but to reach 64K
  (order > 3) it requires 128 data stripes which is beyond sanity.

- Fragmented memory at btrfs module load time
  This is in fact more common than the above 2 cases, but this requires
  CONFIG_BTRFS_FS_RUN_SANITY_TESTS and load the module after the memory
  is fragmented, it's still very rare.
  
So all of those fixes are just another bike shred problem, but
considering it's not that hard to fix, so here comes the patches.

Qu Wenruo (3):
  btrfs: use kvmalloc() for btrfs_encoded_read_inline()
  btrfs: use kvzalloc() for btrfs_raid_bio::csum_buf
  btrfs: use kvmalloc() inside test_eb_bitmaps()

 fs/btrfs/inode.c                 | 4 ++--
 fs/btrfs/raid56.c                | 8 ++++----
 fs/btrfs/tests/extent-io-tests.c | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.55.0

