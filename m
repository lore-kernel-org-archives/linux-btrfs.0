Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E121283FE6
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 22:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782168964; cv=none; b=EeUpXbzG2nHMEmOb2iC2rnzpCNIifsSKmf2e1KnBgpktDbvVyGj4H6ZsuNXG/Bg9Qzeah+WMkny5N48jJVatAev4ajGN8FZL9Y1Os3u7T9mns8pUQbLZ2NFvghSZW+hNZSDMlnqcfhVLwGnoTRFrLDM8WKtFQIGaQS8qS3ZJEn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782168964; c=relaxed/simple;
	bh=Q8a60ErtAudeSt6zXIethora/cl7gdyLq2cJ1Tk/Q9s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=EBQKfP5iwBQoe6hyudX5vQZs2f3gmqrA2uSVnKmhBdaFw/P+4Xv3qa2Imel6rOnrBMqKTRD5lKcqis7aQOXFjFPft+kcKScvMDY6z3opjH8a2MZhpM2QVIRheGLq8igINUXoPhaEGJNTEOG+8Zy4O6eQ1JYHjK0g8e3c9zRUqfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=l2uscxhm; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=l2uscxhm; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="l2uscxhm";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="l2uscxhm"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4857C70A88
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 22:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782168961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cHkkkGdDG7/9T54IlEaxaxLCifurYOWHUCw0szuWehs=;
	b=l2uscxhmMlv9jg1JUy/sAIDQfHr46lo/o0hHEdCwE55eL6X485ewT0jqvcldMZznWZ0zo0
	wmpzZ5dzmprK1u5+z7vmdu7sFsLkjt/A8fa7ZAakQA7WXTYO/0pnHGssYx+oUnYXWcC5/P
	L8lqpXPb5aqJM3NJHEUrSmOOP0NHagA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=l2uscxhm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782168961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cHkkkGdDG7/9T54IlEaxaxLCifurYOWHUCw0szuWehs=;
	b=l2uscxhmMlv9jg1JUy/sAIDQfHr46lo/o0hHEdCwE55eL6X485ewT0jqvcldMZznWZ0zo0
	wmpzZ5dzmprK1u5+z7vmdu7sFsLkjt/A8fa7ZAakQA7WXTYO/0pnHGssYx+oUnYXWcC5/P
	L8lqpXPb5aqJM3NJHEUrSmOOP0NHagA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4C477779A8
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 22:55:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bfH/On+9OWq0OQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2026 22:55:59 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs: fix inlined file extent items in data reloc
Date: Tue, 23 Jun 2026 08:25:38 +0930
Message-ID: <cover.1782168847.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 4857C70A88
X-Spam-Score: -3.01

[CHANGELOG]
v2:
- Add more explanation on why we can created inlined extents even if
  relocation is preallocating space

- Add the fixes: tag since the behavior is caused by a specific commit

There is a syzbot report that an inlined file extent item in a data
reloc inode triggered a sanity check in get_new_location().

It turns out that we can create inlined file extents for data reloc
inodes in the first place after commit 3eaf5f082c4c ("btrfs: extract
inlined creation into a dedicated delalloc helper").

So the first patch will avoid compression for data reloc inodes first,
then the second patch to reject inlined file extent items in
get_new_location(), making the checks more robust.

Qu Wenruo (2):
  btrfs: do not try compression for data reloc inodes
  btrfs: reject inline file extent item in get_new_location()

 fs/btrfs/btrfs_inode.h | 2 ++
 fs/btrfs/relocation.c  | 7 +++++++
 2 files changed, 9 insertions(+)

-- 
2.54.0

