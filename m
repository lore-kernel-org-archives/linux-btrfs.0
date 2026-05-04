Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0D638CFEF
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777938586; cv=none; b=lsElyo/j+9PvZ4zf96iVsA92STFncVM6XLIwRzjv/I9cf2t7nWukKhUd+yvr8qXbTGDz98gi6direBPE996icJthz9MTEV8Vo4G0LmK0YdKocJJ0lgzaYKyvAqIKTZIyOjnUgC9uIyvTfH0KiQyMsTDIkUndXJpHQLpPLKaPipE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777938586; c=relaxed/simple;
	bh=lJb8XA4pEoxO626F27Rj7RFxh6+U2a95hwWZrITZe4A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rvtc7AVbxhojLCaUvmTDKzwyTjs4SSe6RlqapAqOUHoUG/orFvxp8AAWc1pnVd7CyTlEAsR0siCHeKdaf/kqWAwyBpi+ekTebcY4PyjL1F9hrypn7oEIdDnItpOTbK5QE2aV4phiQV1cmHbb4K8/0O8c7uScbMlYUWIVgk5VQ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Wna/dbSz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Wna/dbSz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Wna/dbSz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Wna/dbSz"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9D6846B565
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777938582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fjyR/bfcaSrX6ky1Cemqi9ZeRXCLfFqHOI6mNj8ZwlA=;
	b=Wna/dbSzBpPUknK/zVkxoGH5pK6t+F9rjbrpbk0/G0GDgcCx46xYWkPCw4Wst7WwqoR5iG
	ex5RAv8E3XfCgdN0MC1iNvwXEeR2Bs4Ikjv/4a1VlJ8jK08pO2ZcKGhd9GpGEv0YtOjvI+
	4S90S8F9vdxWyj3CrEe9aFBcUNwVXc8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777938582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=fjyR/bfcaSrX6ky1Cemqi9ZeRXCLfFqHOI6mNj8ZwlA=;
	b=Wna/dbSzBpPUknK/zVkxoGH5pK6t+F9rjbrpbk0/G0GDgcCx46xYWkPCw4Wst7WwqoR5iG
	ex5RAv8E3XfCgdN0MC1iNvwXEeR2Bs4Ikjv/4a1VlJ8jK08pO2ZcKGhd9GpGEv0YtOjvI+
	4S90S8F9vdxWyj3CrEe9aFBcUNwVXc8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DBB78593A3
	for <linux-btrfs@vger.kernel.org>; Mon,  4 May 2026 23:49:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yCE4J5Uw+WmKAgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 May 2026 23:49:41 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC 0/4] btrfs: remove folio ordered flag
Date: Tue,  5 May 2026 09:19:20 +0930
Message-ID: <cover.1777937175.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
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
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	URIBL_BLOCKED(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Btrfs has a long history using an internal folio flag called ordered,
which is to indicate if an fs block is covered by an ordered extent.

However this means we need to synchronize between ordered extents, which
are managed by a per-inode ordered tree, and folio flag/subpage bitmap.

Furthermore with huge folio support, the ordered bitmap can be as large
as 64 bytes (512 bits), which is not a small amount.

The series is going to remove folio ordered flag completely, along with
the ordered subpage bitmap.

Most call sites of folio_test_ordered() are just inside ASSERT()s, so
it's not too hard to remove them.

But there is a special call site inside btrfs_invalidate_folio() where
we use ordered flag to check if we can skip an ordered extent.
This is worked around by using the fact that we have waited for
writeback of the folio, so that endio should have already finished for
the writeback range. Then check dirty flags to determine if we can skip
the OE range.

To get a reliable dirty flag for both sub-folio and full-folio cases, we
can not clear the folio dirty flag early, so the first patch is
introduced to change the folio dirty flag clearing timing, then the
second patch can remove the folio_test_ordered() usage.

Then the third patch is to remove the remaining folio_test_ordered()
usage, and finally we can remove the whole ordered flag/subpage bitmap
completely.

[REASON FOR RFC]
I'm not sure if we should remove the folio ordered flag completely, or
keep it an internal debug feature for a while.

The main concern is that we're removing quite some ASSERT()s, some are
never hit, but at least one is very useful and had triggered several
times during development, exposing bugs.

In the long run, we will eventually remove the folio ordered
flag/subpage bitmap so that we can align btrfs_folio_state with
iomap_folio_state, so ordered flags should still be gone eventually.


Another point of concern is the new btrfs_ordered_extent_in_range()
helper for extent_writepage_io().
Previously we're just doing a folio flag check, now we have to do an
rbtree search.
I hope the overhead is not that huge.

Qu Wenruo (4):
  btrfs: unify folio dirty flag clearing
  btrfs: use dirty flag to check if an ordered extent needs to be
    truncated
  btrfs: remove folio_test_ordered() usage
  btrfs: remove folio ordered flag and subpage bitmap

 fs/btrfs/extent_io.c    | 35 ++++++++++--------------
 fs/btrfs/extent_io.h    | 12 ++++++++-
 fs/btrfs/fs.h           |  8 ------
 fs/btrfs/inode.c        | 60 ++++++++++-------------------------------
 fs/btrfs/ordered-data.h | 16 +++++++++++
 fs/btrfs/subpage.c      | 41 ++--------------------------
 fs/btrfs/subpage.h      | 12 +++------
 7 files changed, 60 insertions(+), 124 deletions(-)

-- 
2.54.0

