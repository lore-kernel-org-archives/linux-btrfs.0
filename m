Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD1135B658
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777020732; cv=none; b=H2ldqLrMcgRP0LoZGT0rfa6DizDVt82Ra7sFvJCCNpOwK1UX5c2HBPwHMokWVzp4r8XIbH4rQftIciVSX9hOKXnNvxeEZy8RV5wSn9t7UH8CPAfKRZE+XDwRKDl+G5M/uYgqkxsbk5+wfg+oWRhF6ja6UR6Ez80FfkJuOrJCjos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777020732; c=relaxed/simple;
	bh=1aOaEHjxmKwCoF5ke7ALlF2IGeA38vgFcrA+WkKox/U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=n+RGN1wMDNIPjy+9cHZ/fpRA+qrGWwVfqh4514XH6Ik+rhif5mRsiCHnnZNrXjZCzJNMHNH73r8PVLS6mXyFqVNw6GxMKQPSr+E/o3O0uwAsHtgo2F+Ukn8X246ptjF8Xuynykd59C/rpeOw3Ucf33/3bGou4iC9MhfBPX0FY8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YZ7hKHPR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=YZ7hKHPR; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YZ7hKHPR";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YZ7hKHPR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9BC485BD89
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=evwYRGUZ0hYHRvgEwxnqIyfVxuulPpuUgjNCmaW3fSg=;
	b=YZ7hKHPRt2FW5yMdXVx/ZvVh6seKbk6XmwV/gBGswRzIG5+bAT4YaVp8ejhYU91f3+YLI6
	sHrH1obwNREPoJc9hZsU9N7AKYxqYAJF0IrBjF0umTM6TamXCV25PNey8XVTZ1EiUZ8PCF
	HntA5JZsvI6gM5PtXRx9EnEiCvnHNIw=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=YZ7hKHPR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777020722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=evwYRGUZ0hYHRvgEwxnqIyfVxuulPpuUgjNCmaW3fSg=;
	b=YZ7hKHPRt2FW5yMdXVx/ZvVh6seKbk6XmwV/gBGswRzIG5+bAT4YaVp8ejhYU91f3+YLI6
	sHrH1obwNREPoJc9hZsU9N7AKYxqYAJF0IrBjF0umTM6TamXCV25PNey8XVTZ1EiUZ8PCF
	HntA5JZsvI6gM5PtXRx9EnEiCvnHNIw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 97909593A4
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oScuETEv62m2HQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 24 Apr 2026 08:52:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 0/5] btrfs: support huge data folios for 4K page size
Date: Fri, 24 Apr 2026 18:21:29 +0930
Message-ID: <cover.1777019132.git.wqu@suse.com>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 9BC485BD89
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[REASON FOR RFC]

- Unstable baseline for-next branch
  The current for-next branch has a known regression where
  btrfs_async_reclaim_metadata_space() kworker can fall into a dead loop
  and fail several ENOSPC test cases.
  Although the regression is pinned down, I'm still waiting for a good
  baseline to rebase the series.

- Extra on-stack memory usage
  Currently we have two bitmaps that are using extra on-stack memory.
  Each of them uses 64 bytes on-stack memory, so in total we can have
  128 bytes just for the bitmaps.

  Not sure if it's a concern.

- Uncertainty related to v7.2 large folio support
  I'm planning to move large data folio support out of experimental.
  So when that support is no longer experimental, this huge folio support
  would need to start as experimental

  Depends on which patch(set) is merged first, there needs to be some
  modification to ensure end users won't suddenly get not only large but
  also huge folios.

Currently btrfs only supports folios as large as BITS_PER_LONG * blocks.
This is an artificial limit introduced to make bitmap operations easier.

Btrfs has two extra bitmaps that are out of btrfs_folio_state structure,
btrfs_bio_ctrl->submit_bitmap and @delalloc_bitmap inside
writepage_delalloc().

Limits the bitmap size to BITS_PER_LONG makes it very easy to handle the
above two bitmaps, we can just use a local unsigned long, no need to do
any memory allocation.

On the other hand, those two external bitmaps are the only thing
limiting huge folios.

The 1st patch will update the comments related to subpage implementation
first.
The 2nd patch will handle the subpage internal operations, mostly to
handle bitmap dumping.
The 3rd patch will prepare btrfs_bio_ctrl::submit_bitmap to be a proper
pointer for the incoming huge folios support.

The 4th patch will remove the 2K block size support, as it will double
the bitmap size for no obvious benefit, as it doesn't even improve the
coverage on 4K page sized systems anymore.

The final patch will enable the huge folio support, by using on-stack
bitmap that can contain 512 bits.
That will ensure 2MiB folio size, which is order 9 on 4K page sized
systems.

Qu Wenruo (5):
  btrfs: update the out-of-date comments on subpage
  btrfs: prepare subpage operations to support >= BITS_PER_LONG
    sub-bitmaps
  btrfs: migrate btrfs_bio_ctrl::submit_bitmap to support larger bitmaps
  btrfs: remove 2K block size support
  btrfs: introduce support for huge folios

 fs/btrfs/disk-io.c   |   2 +-
 fs/btrfs/extent_io.c |  73 +++++++++------
 fs/btrfs/fs.h        |  16 ++--
 fs/btrfs/subpage.c   | 209 +++++++++++++++++++++++++------------------
 fs/btrfs/subpage.h   |   8 +-
 5 files changed, 176 insertions(+), 132 deletions(-)

-- 
2.53.0

