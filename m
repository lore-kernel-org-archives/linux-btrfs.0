Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E817718787A
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778647007; cv=none; b=h9RopXzUvx6dYg6kswFkt0CoVT+DS5fI5lnsrQW6ngneoJew/28D98PQ8WDicd+WGHajZ+TxWLBOt/0KEf5lF5gn9cPLWMY1AdNro2c/UfWerSUe+pC/LXVtImGXaO3TOKR45QCHhP9xZK0EmutbB/xE14If8KnHZqhk7BHXnrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778647007; c=relaxed/simple;
	bh=B2NhYyH+9/9EBG4E5ABiW0Ys2zZ6FP31skrbbFi5JZI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=a9MD8euS/NGPkrjDQuReWx+KEPrHupKkyZuWPfzd2KnFxjCMSDdME0ENY3GaL0/l0o+P8B6krq1LYeiP9CqRB0Czkix+PekG5MhiLGHYBYlsepVKpuR4hOPTgyl8ZUIBZvOS1uFXWrP604NuN8i8G+tsNVo7XXabBZqX6JqRKTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Gn8bKQkE; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Gn8bKQkE; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Gn8bKQkE";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Gn8bKQkE"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 35C016706A
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778647004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2pC+gTa1JGByMcaAudDvosoDh5JbwAe/1FBErtomvYQ=;
	b=Gn8bKQkE/sjrnpvvjAigY2ufLcA1+ifI0b5Hv5AQhy7nBcjsN0mIX7XUQsvUSnQJflWhyo
	1WgkhC7o4ThHD5OL3GKdxxjMGzJDZfLD5IC0p6q3Am+di3e/Hxwh2PGIHAouV0lC6LOTu0
	AQW/v5vlxVumwUMdzTA+l9Z4/auE6JA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Gn8bKQkE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778647004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2pC+gTa1JGByMcaAudDvosoDh5JbwAe/1FBErtomvYQ=;
	b=Gn8bKQkE/sjrnpvvjAigY2ufLcA1+ifI0b5Hv5AQhy7nBcjsN0mIX7XUQsvUSnQJflWhyo
	1WgkhC7o4ThHD5OL3GKdxxjMGzJDZfLD5IC0p6q3Am+di3e/Hxwh2PGIHAouV0lC6LOTu0
	AQW/v5vlxVumwUMdzTA+l9Z4/auE6JA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 742E3593A9
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9q78Ddv/A2r1SQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 13 May 2026 04:36:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs: experimental support for huge data folios
Date: Wed, 13 May 2026 14:06:17 +0930
Message-ID: <cover.1778646753.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: 35C016706A
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Score: -3.01

[CHANGELOG]
v2:
- Rebased to the latest for-next branch
  There are several conflicts with the removal of locked and ordered
  sub-bitmaps.

  Now huge folios will take full advantage of the reduced sub-bitmap
  size.
  Previously we need 5x64 bytes for the sub-bitmaps, now it's only
  3x64 bytes, a reduction of 40%.

  Although the increase on on-stack memory usage is still there.

- Minor grammar fixes
  Mostly in the commit message.

RFC->v1:
- Rebased to the latest for-next branch
  Which provides a stable baseline that can pass usual fstests runs, and
  no more 2K fs block size support.

- Mark the new huge folio support as experimental
  Since the large folio support itself is moved out of experimental
  features, the huge folio support will need to be hidden behind
  experimental.

- Rework the blocks per folio limit
  Previously blocks per folio limit is always calculated by
  BTRFS_MAX_FOLIO_SIZE / BTRFS_MIN_BLOCK_SIZE, but the real blocks per
  folio is also depending on the fs block size.

  Now introduce a new BTRFS_MAX_BLOCKS_PER_FOLIO macro, which is either
  BITS_PER_LONG (the old one), or 512 (the new experimental one).

  This will allow non-experimental builds to get rid of the enlarged
  bitmap, thus lower the on-stack memory usage for non-experimental
  builds.

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

The final patch will enable the huge folio support, by using on-stack
bitmap that can contain 512 bits.
That will ensure 2MiB folio size, which is order 9 on 4K page sized
systems.

Qu Wenruo (4):
  btrfs: update the out-of-date comments on subpage
  btrfs: prepare subpage operations to support >= BITS_PER_LONG
    sub-bitmaps
  btrfs: migrate btrfs_bio_ctrl::submit_bitmap to support larger bitmaps
  btrfs: introduce support for huge folios

 fs/btrfs/disk-io.c   |  11 ++-
 fs/btrfs/extent_io.c |  71 ++++++++++--------
 fs/btrfs/fs.h        |  16 ++++
 fs/btrfs/subpage.c   | 173 ++++++++++++++++++++++++++-----------------
 fs/btrfs/subpage.h   |   8 +-
 5 files changed, 175 insertions(+), 104 deletions(-)

-- 
2.54.0

