Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B2330B502
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778131788; cv=none; b=mUUoSo+lAw369rHVpMZzR6hV7MF5IXvcs628e/uVduZ/0UYAmOSEQPRQ+mEWUqF5P2GqFMSqzulgwSMXi7v0mAIG19GhQh1IzefVltvP7DG3CGphLhF1ago5po5W2fhX4GBW18rgBXA396VnVhHQ5hBxzUKCXWM8R0JDpxibCVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778131788; c=relaxed/simple;
	bh=WUU2/iRHmbY6yE1V4O0Hxqb9SMsmDqTAZuCURaEezms=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=dmUC+MwkbJE/PMGjHyN2UQrB4XGjiVpqWwLnNFPnu4woStqRrnYnyX7GtpebsV+gNDLIa91V70S70kdymOz/xAmlIreLTzd6ZaoaOKvDWFlOXupwNUecp6HzhD9+wh33B5gxFlpAM2+4DKp2czadW5yP6qkqk1gAjIHahzXd3lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NIfnSGa2; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NIfnSGa2; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NIfnSGa2";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NIfnSGa2"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8F0EE5D10A
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778131780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RIwF3ZRV1133RKtA1QRs5AkTWPpxdidwu6aiVZNfdzk=;
	b=NIfnSGa2bcc+YLb2IRdI8eQuszuSDFWRW1CvjguK4cU2XR3NvNzrIEgEZLlb8bs0jdTukV
	n2AHootEn4md2P5wcPHrwtui62CDKCnr9+NlTrVPNfWDUXfhwP3NOtB1dB1loF8bnTOHRc
	tPPbjYETWEa467RlUq2BzY6ooVqXHrA=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778131780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RIwF3ZRV1133RKtA1QRs5AkTWPpxdidwu6aiVZNfdzk=;
	b=NIfnSGa2bcc+YLb2IRdI8eQuszuSDFWRW1CvjguK4cU2XR3NvNzrIEgEZLlb8bs0jdTukV
	n2AHootEn4md2P5wcPHrwtui62CDKCnr9+NlTrVPNfWDUXfhwP3NOtB1dB1loF8bnTOHRc
	tPPbjYETWEa467RlUq2BzY6ooVqXHrA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C69C3593A7
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 05:29:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /jiCIUMj/GmvEgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2026 05:29:39 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] btrfs: remove folio ordered flag
Date: Thu,  7 May 2026 14:59:16 +0930
Message-ID: <cover.1778131118.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

[CHANGELOG]
RFC->v1:
- Replace the folio_test_ordered() inside extent_writepage_io()
  Now do the check inside alloc_new_bio(), which is already doing the OE
  search.

  Now we can detect dirty blocks without an OE at per-block level, much
  better than the previous per-folio level checks, and without any extra
  overhead.

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

There are two call sites that utilizing *_folio_test_ordered():

- Inside extent_writepage_io()
  The warning left by the legacy COW fixup mechanism.
  The 1st patch is to introduce a more reliable way to detect dirty
  blocks without an OE, other than checking the folio ordered flag, now
  it's doing a per-block level check without introducing new overhead.

- Inside btrfs_invalidate_folio()
  We use ordered flag to check if we can skip an ordered extent.
  This is worked around by using the fact that we have waited for
  writeback of the folio, so that endio should have already finished for
  the writeback range. Then check dirty flags to determine if we can skip
  the OE range.

  To get a reliable dirty flag for both sub-folio and full-folio cases, we
  can not clear the folio dirty flag early, so the 2nd patch is
  introduced to change the folio dirty flag clearing timing, then the
  3rd patch can remove the folio_test_ordered() usage.

Then the 4th patch is to remove the remaining folio_test_ordered()
usage, and finally we can remove the whole ordered flag/subpage bitmap
completely.

I tried to hide the ordered flag/bitmap behind DEBUG, but unfortunately
the subpage bitmap macros are not that easy to be tweaked to handle
conditional ordered flags.

So the ordered flag/bitmap must be either there, or be completely gone.
I hope enough test runs will cover the removed ASSERT()s.

Qu Wenruo (5):
  btrfs: detect dirty blocks without an ordered extent more reliably
  btrfs: unify folio dirty flag clearing
  btrfs: use dirty flag to check if an ordered extent needs to be
    truncated
  btrfs: remove folio_test_ordered() usage
  btrfs: remove folio ordered flag and subpage bitmap

 fs/btrfs/extent_io.c | 117 ++++++++++++++++++++++++-------------------
 fs/btrfs/extent_io.h |  12 ++++-
 fs/btrfs/fs.h        |   8 ---
 fs/btrfs/inode.c     |  60 ++++++----------------
 fs/btrfs/subpage.c   |  41 +--------------
 fs/btrfs/subpage.h   |  19 +++----
 6 files changed, 100 insertions(+), 157 deletions(-)

-- 
2.54.0

