Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A9133E347
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982239; cv=none; b=l0KL1HUdGGBkKPQX6yS8O/9UKU5iZzINqBCCUpb0X5j32o69CoCje+rd1uk43Zh4ZaprsCRnAQV6G4HeP6JwPWgpTRrl55gdJnSDU6LNLQORuSSwYiPbhgdxnjkG2pPqj0mA3Gof4qgb0wa3yl1G8jT/jsr4iB7FbsIWG3dTbEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982239; c=relaxed/simple;
	bh=5+8b829sQ3AEjBArNaX1OvMFFDaPmO/b4VMlxPdVU5A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=eQYVOrOUdHggmibUWWPM6dD0NrdBajQO723rT/e/52sSwTc2An24fcG+4lCvj6zhlXIf/PJ0cmirOCNLWTLQbg0+nL9x0jRF59tIRE1kLwzXlIRmoJsdVXqIHTnrZe5wJDS0HoiJf5BC7QF+oLPpOpEgu28T3TJx/djLlt91Bj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=UCYhbgTn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=sv/iU7Vn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="UCYhbgTn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="sv/iU7Vn"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8D6B21F811
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789982231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wyqVDeGoQHl0cezj3ZVjjQwGTTMK/xBMcVGWdHmnf5s=;
	b=UCYhbgTnjMNylsMlru4oHrbxq8klPNSRMaHTQQmCi20FZomjbTCLLrxbmBarw9z2bk92F/
	2IZ7+abe/PDdHyRWbj7w118QwP88yRK65DYY8jFgK9PruMlde7n8SXHuTZsCAbrhkir4KD
	U0+V+THyb1wH2Ca7F2Z4iftTT2q+3co=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789982227; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wyqVDeGoQHl0cezj3ZVjjQwGTTMK/xBMcVGWdHmnf5s=;
	b=sv/iU7VnggrBD/NRv0uYfCzx/zaIUf52CLEakXuvOk72bZNa/MNsdt2vK0BCcZCEBFg7Ng
	SmT1mZ8yfrB9Izoyuoh5XUjveLSV+0HzsuJeO/fJUZ0tWf3AwY2hnQrN59SKJAsaqvswl3
	gQmDSclKdGkpK+p20Jx4kleUPFwVH5E=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 35CA11368D
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8dCGIhH2sGqkbAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 09:17:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: make qgroup rescan work to handle fs freezing
Date: Mon, 21 Sep 2026 18:46:43 +0930
Message-ID: <cover.1789981860.git.wqu@suse.com>
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

[CHANGELOG]
v2:
- Add a new patch to slightly change when RESCAN bit should be cleared

- Add a new small patch to always output the rescan ending message
  This is split from the original patch.

- Save if the rescan is cancelled or not when still holding
  qgroup_rescan_lock
  To reduce possible races affecting the output message

- Also clear the RESCAN bit if btrfs_try_start_transaction() failed

There is a user report about a running qgroup rescan failed the pm
suspension.

It turns out that if we sleep inside a work item, the workqueue still
counts as active during suspension, thus suspension can not continue.

The fix is to:

- Check if the fs is frozen in rescan_should_stop()
  To cover the common case.

- Use a trylock version o btrfs_start_transaction()
  So it won't sleep on sb_start_intwrite(). This is to cover
  the minor cases where fs is frozen between rescan_should_stop() and
  btrfs_start_transaction().

And two small patches to clean up the rescan code before the proper fix.

Qu Wenruo (3):
  btrfs: let rescan_should_stop() decide if the rescan flag is cleared
  btrfs: always show the message when qgroup rescan ended
  btrfs: make qgroup rescan work handle fs freezing

 fs/btrfs/qgroup.c      | 59 ++++++++++++++++++++++++++++++------------
 fs/btrfs/transaction.c | 22 +++++++++++++---
 fs/btrfs/transaction.h |  4 +++
 3 files changed, 65 insertions(+), 20 deletions(-)

-- 
2.55.0

