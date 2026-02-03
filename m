Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2704A347C7
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 03:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770087713; cv=none; b=ZE8alF88u+OQR+D5ZlCe0LeiXHaCh3IdoQEZxirxBWy1yOqoIEAoOlBc8DeMrUS6BWUI42q5ISGhIeTiWeKDYTb2HkwKHp+MCxOv7nb0weKTYwvts+HVhOCRpzOQ/+aVamh0l1Ph4T46Hp8ACFQoXCSCNLpZScL+iz6URv8mb5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770087713; c=relaxed/simple;
	bh=jg7yhvuM5YYlucaDqToU+r/qP+CeuuhqorJlSSC5KLM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=EeTC0HU98LakIIRjjlAinIupLySqKTMIPFd7GSCEtNCydsE7qz11DcHcwPetK/yVK2KpOX0Mzn7VQ/s/vz8YLNN0SKdEpjKGRxbtkHupeIwsJ9qpoG8BOlbRWBy0O547MU4TkikLc/ji2s124MHAm3Oawfeik6NXtri8qGRIaNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iUwYUvLL; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=iUwYUvLL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iUwYUvLL";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="iUwYUvLL"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2C7C75BCC3
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 03:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770087710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Wze5ob/wGqHQEsZddyCXBIBcvUQgzaZ+EYOWPygLKrM=;
	b=iUwYUvLLfCjjdrHh67iklqdQHGjT1SlDeRTlllgGIFSkTs+Ndh0fAyCbMdviEojrk8Q7+4
	9MH4ZSl/bZx9GUh7b1/2xnFJSLZ8ZdgkybAu0C3t/BR9eAN7MWnLaQVL+bJSpSYDTPxI3b
	XhF18sa37KcLPJxANsqgWxM6UVYMFQk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=iUwYUvLL
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770087710; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Wze5ob/wGqHQEsZddyCXBIBcvUQgzaZ+EYOWPygLKrM=;
	b=iUwYUvLLfCjjdrHh67iklqdQHGjT1SlDeRTlllgGIFSkTs+Ndh0fAyCbMdviEojrk8Q7+4
	9MH4ZSl/bZx9GUh7b1/2xnFJSLZ8ZdgkybAu0C3t/BR9eAN7MWnLaQVL+bJSpSYDTPxI3b
	XhF18sa37KcLPJxANsqgWxM6UVYMFQk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59F463EA62
	for <linux-btrfs@vger.kernel.org>; Tue,  3 Feb 2026 03:01:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PZvvBh1lgWnVUgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 03 Feb 2026 03:01:49 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: unbalanced disks aware per-profile available space estimation
Date: Tue,  3 Feb 2026 13:31:28 +1030
Message-ID: <cover.1770087101.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2C7C75BCC3
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

[CHANGELOG]
v1:
- Revive from the v5.9 era fix

- Make btrfs_update_per_profile_avail() to not return error
  Instead just mark all profiles as unavailable, and
  btrfs_get_per_profile_avail() will return false.

  The caller will need to fallback to the existing factor based
  estimation.

  This greatly simplified the error handling, which is a pain point in
  the original series.

- Remove a lot of refactor/cleanup
  As that's already done in upstream.

- Only make calc_available_free_space() to use the new infrastructure
  That's the main goal, fix can_over_commit().
  Further enhancement can be done later.

There is a long known bug that if metadata is using RAID1 on two
unbalanced disks, btrfs have a very high chance to hit -ENOSPC during
critical paths and flips RO.

The bug dates back to v5.9 (where my last updates ends) and the most
recent bug report is from Christoph.

The idea to fix it is always here, by providing a chunk-allocator-like
available space estimation.
It doesn't need to be as heavy as chunk allocator, but at least it
should not over-estimate.


The demon is always in the details, the previous v5.9 era series
requires a lot of changes in error handling, because the
btrfs_update_per_profile_avail() can fail at critical paths in chunk
allocation/removal and device grow/shrink/add/removal.

But this time that function will no longer fail, but just mark
per-profile available estimation as unreliable, and let the caller to
fallback to the old factor based solution.

In the real world it should not be a big deal, as the only error is
-ENOMEM, but this greatly simplifies the error handling.

Qu Wenruo (3):
  btrfs: introduce the device layout aware per-profile available space
  btrfs: update per-profile available estimation
  btrfs: use per-profile available space in calc_available_free_space()

 fs/btrfs/space-info.c |  27 ++++---
 fs/btrfs/volumes.c    | 173 +++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/volumes.h    |  30 ++++++++
 3 files changed, 217 insertions(+), 13 deletions(-)

-- 
2.52.0

