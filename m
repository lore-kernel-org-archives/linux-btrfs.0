Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB63D3E4115
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790229533; cv=none; b=MO/vgTw9ypIbNZjQdwip937sWMJ+XTxPA9jZ0mvL2QWk8/BtLU29aoH9xcO3hN+eAtu+g6JAlYH+VfmGvjArW/WMCEEG62Bde6Cgg/G2BAKv7xBv7D7pCVTjjKD/J2KekEVaLITjvi294BuGRvFSz7btvesAH7VowT8cXnOhqMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790229533; c=relaxed/simple;
	bh=RSVnH8ZATtO8JTaVUWBuHAANQ9qY4GWJ2ztIWVXlwJ4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VQH+DSJaEpgGtQ//jCuLPJNVO+LwN2HbllpOulM5291JIvxjE/VnlB/p2uqOb4qmaXTIXrDoXqkGcJgTak4xzm3/V/AllO+Jf1WfdLRFDuHoCq+D4kf/I2Z8ebbOG4woVfOH0SDSrtyAwqxYRwe6ZMpj04PTfYGvjh2f//GInis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qgGXfhL/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=saWPl+kV; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qgGXfhL/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="saWPl+kV"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C9C9A1FF13
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790229520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=F5CPMKx+VhzH8cwUUFr3eE/tPRiN+KlKkB2a5y6OER8=;
	b=qgGXfhL/n+I0PW9KPjflR1rimnlmjfNvJgl2Z+i9assb9rO5Qm3BD1cFmQg0mfgk8lY/SP
	PysCcrbSCgY6Dvpd6/k/+75Xllq64u+THsADnyaluFKK58klVwMHeGHZJfOA5QOf8Zg1C7
	qN+6wYpCYdkcvSkShmWr5CqSFVgMG3Y=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790229515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=F5CPMKx+VhzH8cwUUFr3eE/tPRiN+KlKkB2a5y6OER8=;
	b=saWPl+kVGxDBnItPaLXoU06zQ5cti+0AK5qG0ezlGyEyANXsCOPA6RBNFl+uYNNSQRF0Sn
	LmjXHqgCW8669mlcECABWEtFG6/e6I7wO+8svjoK5SE/PQGBbue8xjw+57JbfvA6JUg/Vh
	ErX+i18iBXqus1fTQxSjY18I9OLMdRo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ADDAF136ED
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oEOcAwq8tGq3OAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2026 05:58:34 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: __TRANS_* flags cleanup
Date: Thu, 24 Sep 2026 15:28:13 +0930
Message-ID: <cover.1790229298.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

This series is inspired by a recent comment from David, mentioning that
"if (type & TRANS_START == TRANS_START)" doesn't look sane.

It turns out that we should not define TRANS_START as multi-bit mask in
the first place.

The first patch is one sent in into the mailing list before, but since
later patches all rely on it, it's included into the series.

The second one is to remove the only flag that caused the exception.

The final one removes __TRANS_* flags completely, so every TRANS_* flag
is just a single bit.

Qu Wenruo (3):
  btrfs: move __TRANS_* and TRANS_* flags out of transaction.h
  btrfs: remove __TRANS_FREEZABLE
  btrfs: remove __TRANS_* flags

 fs/btrfs/backref.c           |  2 +-
 fs/btrfs/tests/btrfs-tests.c |  9 ----
 fs/btrfs/tests/btrfs-tests.h |  2 -
 fs/btrfs/transaction.c       | 95 +++++++++++++++++++++++++-----------
 fs/btrfs/transaction.h       | 29 +++++------
 5 files changed, 78 insertions(+), 59 deletions(-)

-- 
2.55.0

