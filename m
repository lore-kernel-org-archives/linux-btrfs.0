Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB082AD35
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787546084; cv=none; b=JXU+nLVBjKcSHsiwPSSXGhkAhLadTbxI0w8dlrR4eaS4w50DM4cCIs2Z91C5q6Rx1qMLEqQ1f3HRfrErrGjv+mZ+Thd7V4dme5GmecxO9/7DgKtnJ8OOgHNjg9e48AW7isvcAQchx/7I0YTTjvO1AcyqMaNp+vu7Rrhomr6pQ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787546084; c=relaxed/simple;
	bh=kjsi7mUaX45vIxK544L+EE58BVj9mYtFMyklilrmlyc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=gb/niwlyhn7qxad9FEaELdnke/VzqN/rerpcDNmtQdMuIUU4Yh0sMpWZSpSVr4C5A6dkNydNLcFzGXuBgn2c0KO391WIK6PrO1LQpNyLcP/AczMDAFnWmu4BJtyHBUa6YTGbCRi1ciudWCIpdBzRmffxMsasMPOeLMYOPN4L8FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nrcKc1NB; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=LkVFzv2u; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nrcKc1NB";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="LkVFzv2u"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 429913E42
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787546072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VGEN0ReEc6QxVw7Z4d0bkmd2YCDf6ckGSThbyTgIpjs=;
	b=nrcKc1NBIj9u5vYpftSV36ZAhrqEJsUadMsZWyxwT67wz310k938mQ9ddJKBzzrUDqiLyR
	nFWJwBGIIny1OrsJ2d41KhM8J3PsQHWCTPDPpzAJWhQtQq9U6XXFaIReLYiGyWLwq+/f9Y
	rSyF9Zj92OashTT8GS0H505ccSU6Pvw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787546068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=VGEN0ReEc6QxVw7Z4d0bkmd2YCDf6ckGSThbyTgIpjs=;
	b=LkVFzv2uitu3Em86qxKmFiT7QbwLXTa+89M6BzG25BjMhSpGGiaJsBJfZ91xMNK2cIXGLL
	bQ9OfkbkomupPPXFFsUkqq6OE+mzMT25eaN3ozkhz8v5zlqnBEY0GKi6RiQ9XUkf68ATM0
	ozC4njmMu+ltlx2wmph1ClStnM6moE8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3A19C13331
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0wqMNdLJi2p1SAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2026 04:34:26 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 0/4] btrfs: dev-replace: replace_task related cleanup
Date: Mon, 24 Aug 2026 14:04:04 +0930
Message-ID: <cover.1787545216.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
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
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

[CHANGELOG]
v3:
- More cleanup patches for dev-replace
  Most newer ones are minor, e.g. changing the message and its timing.
  But the error handling inside btrfs_dev_replace_finishing() is
  important for later replace_task cleanup.

- Directly modify replace_task when the replace is suspended
  We do not need any extra lock, since the only reader is accessing
  replace_task without lock anyway.

We have 4 errors paths that do not properly reset replace_task to NULL
after the replace is cancelled/finished/suspended.

This is reported by Sashiko.

And since we're here, also do extra cleanup related to dev-replace error
message and its timing.

Qu Wenruo (4):
  btrfs: dev-replace: fix the incorrect error message
  btrfs: dev-replace: concentrate all messages into
    btrfs_dev_replace_finishing()
  btrfs: dev-replace: fix the error handling in
    btrfs_dev_replace_finishing()
  btrfs: dev-replace: properly cleanup replace_task

 fs/btrfs/dev-replace.c | 79 +++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 35 deletions(-)

-- 
2.55.0

