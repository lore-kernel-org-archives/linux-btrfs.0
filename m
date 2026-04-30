Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E38B227B94
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 01:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777511273; cv=none; b=obloqZGE+4Pv/l8r/k/3pxtvDAmpx3YBcWcgLSwPApSiEwtUfPjl6v1mgwmWFGtUNFva1OCm+xWHS3YATUPajX2VG+DRXuWNO92ov/Of4QJTGbcORVwBFL0NEBsBfhteDmlowKDpCRNS9jcTSPH1hJqITZMODsK1hefIIqklWuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777511273; c=relaxed/simple;
	bh=Vh1nnXslVHZ4yPhcIr5kg2QGckONIjlqkvS2bzMM6V0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=pDp2fHZgwVbuVquCHvtNDlc/GTX5dJla5u7ZV8slsJ63Oj5RL8IGrFJpGL0rMED2nzUkCAeCWsTYxFm82Jj00f1f5EhKfdQxKietD0wGEGjGN1Kul28n48UJHP1H/sL4wGQB4aetPax695rqceAPyrSWreFMvPyfzFM/sFyE0v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=taIuLR6H; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=taIuLR6H; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="taIuLR6H";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="taIuLR6H"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A0C745BD65
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 01:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777511269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RhEiCPJoI9E2SWy0WUK/vPJ15rgS1KXljn+4POsWEiE=;
	b=taIuLR6HAhHPw8yvjooVT5NMbwXRmiAw7aa6iH3yYPyQ4f+hYUj+QSMxkPwyorkrmXeptg
	Q7RCXVfv99EEFK8i+EPMnb0VKqfctPBanPJoC6UWir7gZT+r41FpXy1CLQ2uW8C4/ftxIm
	QZC1iI98JkPhG3S2YWepoyyv1LpTh4g=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=taIuLR6H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1777511269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=RhEiCPJoI9E2SWy0WUK/vPJ15rgS1KXljn+4POsWEiE=;
	b=taIuLR6HAhHPw8yvjooVT5NMbwXRmiAw7aa6iH3yYPyQ4f+hYUj+QSMxkPwyorkrmXeptg
	Q7RCXVfv99EEFK8i+EPMnb0VKqfctPBanPJoC6UWir7gZT+r41FpXy1CLQ2uW8C4/ftxIm
	QZC1iI98JkPhG3S2YWepoyyv1LpTh4g=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E008A593B0
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 01:07:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9opKKGSr8mlyWgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2026 01:07:48 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 0/2] btrfs: fix and detect dirty/held ebs at unmount time
Date: Thu, 30 Apr 2026 10:37:21 +0930
Message-ID: <cover.1777510825.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
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
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Queue-Id: A0C745BD65
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

[CHANGELOG]
v4:
- Add the patch into the series which fixes the dirty ebs

- Remove the transid output
  It's not really utilized for the particular bug, and can be added
  later easily.

- Rename the detecting function to invalidate_and_check_btree_folios()

- Update the commit message in the 1st patch
  The dirty ebs won't cause NULL pointer dereferences even all workers
  are already stopped.
  As in this particular case the fs is already in RO mode, thus all
  metadata writeback will fail immediately without going through the
  writeback path.

  But still better to fix the bug other than relying on extra safety
  nets.
  
v3:
- Revert the DEBUG_WANR_ON_ONCE() change
  As there is only one user, a simple
  WARN_ON_ONCE(IS_ENABLED(CONFIG_BTRFS_DEBUG)) is more than enough.

- Output the generation of the unreleased eb too
  Since it's possible to have 2 transactions (one committing and reached
  UNBLOCKED state, one new running), the generation output will help us
  to know which transaction the unreleased eb belongs to.

- Also output the transid when a transaction is aborted
  To co-operate with the above change for debugging.

v2:
- Add one extra ref before checking the eb
  Although readahead has one extra ref, after the readahead finished the
  extra ref will be dropped, and memory pressure can kick in to free the
  extent buffer.

- Use rcu lock with xa_for_each() instead of xas lock and xas_for_each()
  Since we're holding one extra eb ref to prevent eb from disappearing,
  we no longer needs the more strict xas lock nor the extra xas
  pause/unlock.

  Although xa_for_each() is more time consuming, we're at the cold path
  already, not a huge cost.

- Remove the temporarary void pointer
  And pass eb pointer directly into xas_for_each().

- Introduce DEBUG_WARN_ON_ONCE() helper
  To follow the existing DEBUG_WARN() helper.

- Fix a typo

- Also fix the checkpatch warning on the exist DEBUG_WARN()

There is a report about readahead triggering NULL pointer dereferences,
which inspired me to add a detection mechanism about any dirty/held ebs
during unmount.

It turns out that several error injection/shutdown test cases can
trigger the new detection mechanism, and after more debugging it shows
that we had a bug in the transaction abort path that doesn't properly
cleanup the dirty ebs.

The first patch fixes the bug first, then the second patch introduces
the new detection mechanism.

Qu Wenruo (2):
  btrfs: only release the dirty pages io tree after successful writes
  btrfs: warn about extent buffer that can not be released

 fs/btrfs/disk-io.c     | 55 ++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/extent_io.c   |  6 -----
 fs/btrfs/extent_io.h   |  6 +++++
 fs/btrfs/transaction.c |  9 +++----
 4 files changed, 63 insertions(+), 13 deletions(-)

-- 
2.54.0

