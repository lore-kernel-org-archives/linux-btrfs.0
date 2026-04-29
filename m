Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DAA1F4C8E
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777439059; cv=none; b=Mj366/zzt2ZEg13a/gY7Il9l7qfTaq/inu32yKaLrGuEfTEEcVlXU5sp2iSLfoOehzh44xXefDrre2q/4SszqcQk3IWyKrF0J3XxINzrRgqnTDclirQfb+8xlWfP06W+pHLZrBmEhtvGIYV+r/r3t3Lb0gEanGVXgEkVZw8RY2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777439059; c=relaxed/simple;
	bh=F/tT+Fb5VNikLFHUKR8sk1zyQHiMwZyhAsdjj8/RvTo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=FDC9xBy1qvkM6KrhLXqNpLiQgEMBiH44YZLSckcL/tpu0jMrx4/SqCknOpnt/Gp+XQqfT601pFHJ/RHZM3MqXgza4HG42M2GI53EAnc39IZO166wLFhtMz6sgBnkbS00fcUdRSvE2vYpf4EOnU7t3BTFxJKEJDxFgkiPqk/Jz1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MM0pwNQw; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=k51o3hG7; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MM0pwNQw";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k51o3hG7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E7EA25BCCA
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777439056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DUgj+PfWqOfZEA0OEcF8Ei2S6RQcXe5GjNMORsVRiuw=;
	b=MM0pwNQw4QyWiBdcfhCEwbDgHoXSI1OcXVn5oukrzLzqCjF1logO9CeYClD0/EEuXhD8MA
	BrwvEapMI/NXMZBK4AfRmpHJZPOpgVQbuyW3dxe3OhUJ7kTCf8uZAW+GfjkG6vcYLhPEL4
	zfojai9N6EiJJYQ0Oa4RFgIPdgDFByQ=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=k51o3hG7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777439055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=DUgj+PfWqOfZEA0OEcF8Ei2S6RQcXe5GjNMORsVRiuw=;
	b=k51o3hG7k6mnEozLFbR5dLYOeyhri+8xhm4sA37LVJhUatxwNb4DiO87TOIqsD+T/R4LwG
	sFV3pxEza0SmR6bJ0WHehELf6ugyuMwnetER2BAMKfLx/SnBg3+qCxtGXhNnG3gR5JIJhH
	tMEzhwgfNUcm+RHe+txudPUmqLFWcjs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E123B593B0
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LIcPI06R8WloAgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 05:04:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/4] btrfs: experimental support for huge data folios
Date: Wed, 29 Apr 2026 14:33:48 +0930
Message-ID: <cover.1777438651.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E7EA25BCCA

[CHANGELOG]
RFC->v1:
- Rebase to the latest for-next branch
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
 fs/btrfs/extent_io.c |  71 +++++++++-------
 fs/btrfs/fs.h        |  16 ++++
 fs/btrfs/subpage.c   | 191 ++++++++++++++++++++++++++-----------------
 fs/btrfs/subpage.h   |   8 +-
 5 files changed, 186 insertions(+), 111 deletions(-)

-- 
2.53.0

