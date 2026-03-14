Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D74D10785
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773446466; cv=none; b=qqvx3MqCydNY+EcZFH7M6yJKesonJTqEInq41ip8ZqM+qa7hcTV8Utpwq2HByCstYTMpM5uiJMu9tXmpchN2dYzjLUbjB0+B9LrDXyvVOCzVkU4XuFQOiZCAr7IB9eqsXkOthlDM2GUvq140As76CJx2Sn4dTP2GE3NDF4p9K7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773446466; c=relaxed/simple;
	bh=MGdlABhgoxdEyxveA9off0TE6sI9HTLF91pDhhoQfEA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mvO35r7Ea4dFl+gLSbxhDleLqm14zqrVd0fihs3hieOw9zBZtOlOZ9dOxykSB3FvQm7QDCKVt5sygNklWoWcyyiQYlL2kztoIr2JiWewcAWuk0VL7OsYhryzXocPqYi1YHVKI3gjmqmKlxNNiw4CRmWgyXLgQgdr5EDBD548hMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EgJLobsh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EgJLobsh; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EgJLobsh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EgJLobsh"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AAF874D1CD
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773446457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=75Bguq4PPIcLVihA/FXJUE0dPQJm91/8f/7evEWjIUw=;
	b=EgJLobshBk/+/4tRNPCqkVAn0eSBhD10W/LkhKtzY6FBEW6fOhIqr5lYprPy2GbQ1wxZBZ
	MncGZxdaAakPEDwmRSaIX/a50AiaNYsEhNcrQaJ+vTHmM9woKjMl/olwqRranocR5CIk0/
	QYpvoXtlmx4uzrBpswubTk0G49p1rUA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=EgJLobsh
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1773446457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=75Bguq4PPIcLVihA/FXJUE0dPQJm91/8f/7evEWjIUw=;
	b=EgJLobshBk/+/4tRNPCqkVAn0eSBhD10W/LkhKtzY6FBEW6fOhIqr5lYprPy2GbQ1wxZBZ
	MncGZxdaAakPEDwmRSaIX/a50AiaNYsEhNcrQaJ+vTHmM9woKjMl/olwqRranocR5CIk0/
	QYpvoXtlmx4uzrBpswubTk0G49p1rUA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E63CA407C3
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:00:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3w2EKTiltGl9dQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Mar 2026 00:00:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: enhance BTRFS_ORDERED_* flags sanity checks
Date: Sat, 14 Mar 2026 10:30:37 +1030
Message-ID: <cover.1773446363.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: AAF874D1CD

[CHANGELOG]
v2:
- Minor grammar fixes
- Change the output message when overlapping OEs are found
- Use has_single_bit_set() to replace hweight*()


During my development of introduce a new DELAYED type, I incorrectly
called something like:

	oe = alloc_ordered_extent(.., BTRFS_ORDERED_DELAYED, ..);

That doesn't trigger any warning at runtime, but will cause unexpected
bugs due to the fact that, BTRFS_ORDERED_* can not be directly used as a
flag. They are only bit numbers, thus should be utilized with bit
operations like "test_bit(BTRFS_ORDERED_DELAYED, ..)".

My stupid bug inspired me to enhance the @flags sanity checks in
alloc_ordered_extent().

The first one is to make sure that my stupid bug can always be caught
early.

The second one is to enhance the error message when a duplicated OE is
found during insert_ordered_extent().

Qu Wenruo (2):
  btrfs: check type flags in alloc_ordered_extent()
  btrfs: output more info when duplicated ordered extent is found

 fs/btrfs/ordered-data.c | 24 +++++++++++++++---
 fs/btrfs/ordered-data.h | 55 +++++++++++++++++++++++------------------
 2 files changed, 52 insertions(+), 27 deletions(-)

-- 
2.53.0

