Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49D718FDBD
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781859315; cv=none; b=K3eebn0TYm+K+HeJxNK4LDcnimQgZyu/Ms0rkB0+Tjd0O/P0LZKE6+gjV71egwP7N9PQrDlcL2Ra37uHVAXq3drzB2UaV033ExPTcGsAfCi4ZiHgrktkZKkMJQkLVTiVb4dVPL9/98zp73QL5fn3tVJ3a+4TtfwT9wVoszMElIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781859315; c=relaxed/simple;
	bh=3Y4pWE6wZZRl7amO8QyoFAYWA4IeFq4yoBAyFSdsTNE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QObWv1gkp4WVyvlSAbuTStoB5ESNwx7w5j80ygkBdrT0/eyhDkjMB+gsIW1QSTInk2kWe2mkFgiIgqPQspf4HcfzpCl1NaiLIb720mZIKrgkEBHYO8/DVJAIS2wUclIvqWoUaj67ZDHh4SSOlyL1OTwjEkM08ta03qLeZmPnymI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Z5wUmi0P; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lPApKIcK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Z5wUmi0P";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lPApKIcK"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C63CA758DE
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781859312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=soavloQc5J77p0jkyLrhOCRkZc0k2MLebc4DDYG+WwY=;
	b=Z5wUmi0P4tcRqJrbigJSHLa5lVfHriB6D29lp6BqjMNRKchuol+Ud1kdUas30ySbi1vtkn
	fhrANtxegRokWcplqYOn9kjxdaSYfhnfrnSTEtZNRNrR700i5Yi5fbkri9+yBxAL3it8Zc
	yyCNpQFy62YEehUueO4GRNkMFbM5dJ4=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781859310; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=soavloQc5J77p0jkyLrhOCRkZc0k2MLebc4DDYG+WwY=;
	b=lPApKIcKIXjiXI+rSZoLXIgAIcZ0enC/1W4v0JXNTAT8ChXQGdSqqm23ieFXApqXhfwn5e
	UTdsiaxyrOyWdupMXGA3/r4sNQW2z3Y2fHSpgk+4PXx9IinF3QcypKvee0mHpGpAOMTiBx
	vHviww1u57kCq0Ni/FB5enH+uTc9o4k=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BB489779A8
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SO4wGu0DNWrBTwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Jun 2026 08:55:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: enable full bs <= ps support
Date: Fri, 19 Jun 2026 18:24:45 +0930
Message-ID: <cover.1781859111.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
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
X-Spam-Level: 
X-Spam-Score: -2.80

Btrfs has supported block size < page size for a while, but that is only
when the block size is 4K.
So for 64K page size, 8K/16K/32K block sizes are not supported no matter
what.

That's is completely an artificial limit, introduced just to reduce our
test workload.
But after all these years, we even have experimental bs > ps support
now.

There is really no reason not to support the extra block sizes.

The first patch is a small comment update.
The second one introduces the real change.

Qu Wenruo (2):
  btrfs: remove the out-of-date comments on the 2K block size
  btrfs: allow any block size that is no larger than page size

 fs/btrfs/fs.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

-- 
2.54.0

