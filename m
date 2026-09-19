Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA50370AC8
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 11:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789816770; cv=none; b=BYyoqw1SIP/auEpbe5gILaF8TO3/2kNMTFU56Plv8WGru4ihiFSHL1R2kpnL/1/Hm/gPd0v3PrDbqvXmBVW2LvwHBcTBwpVvd1hH7wjgknUcHuePXzqoa8oPWW9cR3GuJEzeYWVGQoNNp+KQtJ0DPB//mEQect1U4IFQ6mhrbqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789816770; c=relaxed/simple;
	bh=mfCh9YfardgJB9/y0vBOLYXfuUVmsIV8Cgd+wEptbOQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=M6/ylpafCOnW0/xZAmIWmrTIVPr7r5s7MMoFNlXQsNQgIerqRhRjLorKBPQ1bfXihaUo22SDExA2N0eiHt/eoqdNkbHVHxp38q/rT/7EqksrEBW8/cwbAnpERp97QcW5SLJPBx1sD/YTujhc3ptwWKqtieY7nlLPwceXvIRM+hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ltRnS0l8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=titRUtyd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ltRnS0l8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="titRUtyd"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 50A9521E29
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 11:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789816756; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rCYYVt4FRaaTX6QM1PF5DEm6GMkVtXONAYNe9bgXPqo=;
	b=ltRnS0l8VDxc/80tjgrYmaGPYFU+F8GdCvWNGUAr1vp+CjR7LeQi/2wZpqVXpxL1IENM/A
	5QCkXzkgq2tcYuXn7jYnApITcx81YARzT3TTc6GeVRUeJpn/cF27iG+DsA6YCtVqUwRUXq
	D+6CmisegVRPUSuFJBYv4IdB0KwhUWM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=titRUtyd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789816752; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=rCYYVt4FRaaTX6QM1PF5DEm6GMkVtXONAYNe9bgXPqo=;
	b=titRUtyd9xx0nJFeFiHJ/g8UbKtbbz2xiOQpYuHccOWtUBQJTqfhSGFdKLpoKjDa7AZmTl
	tB2c36OYnfCDqdPp0K3x5qsBevbdRousA1Vl0fTQoi90VMTtfeWC2pjWjYDWWyKvc+GKUO
	c/ZME8+3w3POogd7jdzrdswSA7LQAMw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0CF8113869
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 11:19:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fM2AF61vrmrlBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 11:19:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: remove the tailing zeros from compressed inline extents
Date: Sat, 19 Sep 2026 20:48:49 +0930
Message-ID: <cover.1789816636.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: 50A9521E29
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
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
	URIBL_BLOCKED(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:dkim,suse.com:mid]
X-Spam-Flag: NO

Commit 3eaf5f082c4c ("btrfs: extract inlined creation into a dedicated
delalloc helper") changed the compression input from [0, i_size) to [0,
blocksize), which caused two problems:

- Other tools unable to decompress the inlined extent

  U-boot and btrfs-restore are affected, as they only allocated a buffer
  which is @ram_bytes sized.
  That buffer is too small to contain the decompressed data, which is
  @sectorsize.

  Those projects are fixed to have a more robust decompression routine
  which can handle both cases now.

- Worse ratio for those compressed inline extent.

  For the same 3K 0xcd filled range, the results are small but
  observable, 48 vs 61 bytes.

Filipe's v1 fix is very close to a proper fix, but btrfs will unable to
create inlined extents for lzo.
It turns out to be another bug in the copy_compressed_data_to_bio()
function.

So this series is to properly fix the bug, firstly fix the lzo
regression which prevents inlined extent creation, then we can apply
Filipe's v1 fix.

However since Filipe's v3 is already in the for-next, the second patch
is reverting part of the v3 fix while keeping the extra size check, then
apply v1 fix.

If the series got reviewed, I'll change the 2nd patch to use Filipe's v1
fix with extra checks from v3 kept.

Qu Wenruo (2):
  btrfs: fix the incorrect lzo space saving checks
  btrfs: remove the trailing zeros from compressed inline extent

 fs/btrfs/inode.c |  7 +------
 fs/btrfs/lzo.c   | 32 +++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 13 deletions(-)

-- 
2.55.0

