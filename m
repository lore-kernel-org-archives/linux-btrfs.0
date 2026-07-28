Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594D641F7E3
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229916; cv=none; b=e/o795lmGMnNB5eVAojrggG8NrGHAquc+DGvyW+uFaA3QceS9mlWi8caMuqBtDRRCNcVzmQfdz7FE4swkHyCnNDx0p/eiCtExzx1IR/JR7INA6aYEsI6X0ACI+8x6G6EzgS16mIseAyUeD7vxUSXp/2cGW6XrDPBlvpHE8PphZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229916; c=relaxed/simple;
	bh=IY/nPqcmav0Mk1Z/qc9izMnJYm/xithRbMxyyp6Yz4I=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LTm8Y+VOGFx2Elvd6XNwcvFKrKuf5hZ66X4vH0lDhaV/B+MZKj/QD+9rlubz3h6w61KjRTk9tDy1p7czLLTO5UpiMSowmf6NgIfWdzC6oZaJTJZeNwR7e7AoJOg2OFHOAtJQuVrwy2AjSGxHSF/S27JjiycVASZL1PR8kNNHaZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=L0u+rE+z; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LgDUkfZq; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="L0u+rE+z";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LgDUkfZq"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 479BF3DFB
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785229908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UZLA6PE1vLfmN08BG4fAU1Tj3F/b6QsQdkm5U/oWyhU=;
	b=L0u+rE+zIBHWmNgEbhWlp2jzjJWA1an6v8oPhKxA0K2kOsoivH9J4x9B7L/jJLSTNNFr3a
	LrIh2jhu/egLM7qXjK0XCkgAZZkLKreLQEQZGT2uM0lfkIGUtNj3zJC1LPNE0/blin7AWO
	UxBEvmrrGZG+/lrGsJuWNC+TqtoyAeE=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785229904; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=UZLA6PE1vLfmN08BG4fAU1Tj3F/b6QsQdkm5U/oWyhU=;
	b=LgDUkfZqrcYfNxwcInDabUvVRLNsKrrGBPd0fgEnKT8CMtQrYzwISO7bJ7GaHQ3dq2iX63
	s02k5TYpbw92ZbWmVCzJqjGQXlVpGJAd4rNDZD13l0H25No7NQQnUOCuPv9AQi97hybtzD
	P/f/ne1P+qnUxLtZ074cOqLYA9XsJII=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50CA5779B3
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DjDpAE9yaGpfXQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: add basic alignment checks for extent_state
Date: Tue, 28 Jul 2026 18:41:21 +0930
Message-ID: <cover.1785229591.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

[CHANGELOG]
v2:
- Fix a crash caught by generic/136
  Since btrfs allow reflinking the last block until EOF, the range
  passed for btrfs_clone() can be unaligned.

  Fix it by passing aligned range end into btrfs_lock_extent().
  This won't affect the btrfs_clone() call as it doesn't use inclusive
  end.

- Slightly rewords the first patch
  To explain it more clearly that the fix is for btrfs_lock_extent().

Commit 3f255ece2f1e ("btrfs: introduce extra sanity checks for extent
maps") introduced sanity checks for extent maps, but for extent state we
do not have any extra sanity checks.

This series will introduce the check in the 2nd patch, meanwhile the
first one is to fix an exposed unaligned access in extent_fiemap().

Qu Wenruo (3):
  btrfs: use aligned range for locking in extent_fiemap()
  btrfs: use aligned range for locking in reflink
  btrfs: add validation for extent states

 fs/btrfs/extent-io-tree.c | 21 +++++++++++++++++++++
 fs/btrfs/fiemap.c         |  8 ++++----
 fs/btrfs/reflink.c        |  4 ++--
 3 files changed, 27 insertions(+), 6 deletions(-)

-- 
2.54.0

