Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355A738F62F
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791845951; cv=none; b=CF7Bf4wUakoQWfYcu/m7kdq8L40z8qnb8syeezc/gx2G9uZFozXz/niGpOl797dsa7SCNUjxOlbEwC85i20GV0r9us9JV40EbxuUKYxfoUgd3MSb3PqDGXva4UgSfcWJ2/cosZkfRx1PXNvaCDgE4cciKEJz2NFUpZF2i/xd/ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791845951; c=relaxed/simple;
	bh=HgXlM8T2bZfvQHijFFh7AWwQNv2ViwWK3a9r5+8clHA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=FnVYJrCaHRMI/C3RmS79jnAbZPQbOOISPRt2qQRvtOkRyIQ14b1/fdKb2u8/0pxyrpEf5EkxtUNxgc3z2mp8GL+J/BIuqwgJdgSDqyy0VAG1WPZN/tprvHx1o+hvx1+mNLe0OLaY1/7LvWhq62EuIMQ3gHtQUtqc504/u86wltY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OUix6s8x; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=dgrwgL5x; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OUix6s8x";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dgrwgL5x"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E372421F2F
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791845948; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=s5Hy1pT+eQtibA/9gnXmFol0P/rXTwHEm2D3NA/fHc0=;
	b=OUix6s8x5/BAH8F7QmwqyrrwjnFfMo81d5/lpGjhELdQuIz2HZ6ehEzRcB508poTA+3T1X
	syXv8rlxVW/vinHYQJkj2QMvHqabD0q/F5xSqTw1iFFVeZC6RF1IKxZPQc6majrz+2gaYI
	L14+WbVZTqY4v8vPR71/QUOvw60g/lQ=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=dgrwgL5x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791845947; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=s5Hy1pT+eQtibA/9gnXmFol0P/rXTwHEm2D3NA/fHc0=;
	b=dgrwgL5xNa9SG+36NwC2RwtBciQ9MIQ+hi6hHul8JwjWyYTXxSsNmPnCKV2zTSVIfHN4iy
	4evYr3NTQHJ5tK4Y9rhRjSPAVbzP57LwaFzZgtUg778h5H15NdB1LKDplSuDNgpJxFROWo
	FfeuqiZ323YpGICEHdfz5fJ/fW5ok5Q=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1AA713314
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nmCJOzlmzWojUQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:06 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: further cleanup on fs_info->dirty_cowonly_roots
Date: Tue, 13 Oct 2026 09:28:46 +1030
Message-ID: <cover.1791845501.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: E372421F2F
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

Sashiko mentioned that dirty_cowonly_roots can still be non-empty if a
transaction aborts during commit_cowonly_roots().

However it should not cause any problem, as after a transaction is
aborted, no one will ever touch dirty_cowonly_roots.
So even if it has some dangling pointers, as long as no one is reading
it, it's completely fine.

Furthermore, dirty_cowonly_roots contains roots that are not subvolume
nor log trees, thus they should not have swapped qgroup blocks nor
dirty_log_pages. This means no memory leak from those two members
either.

But we're still depending on such quirky behavior, and it's only going
to cause more false alerts from various LLMs, e.g. Sashiko is already
reporting problems on this.

This series change the behavior to a dedicated cleanup, so that we no
longer relies on those hidden quirks.

Qu Wenruo (2):
  btrfs: always remove quota_root from dirty_cowonly_roots
  btrfs: cleanup dirty_cowonly_roots during btrfs_free_fs_roots()

 fs/btrfs/disk-io.c | 14 ++++++++++++++
 fs/btrfs/qgroup.c  | 10 ++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

-- 
2.56.0

