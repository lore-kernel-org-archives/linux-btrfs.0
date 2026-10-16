Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02B226299
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792111723; cv=none; b=Xk/WI+0C3pOj/7blEAZ4XUFtCtcHWKzVWoX8asvHzlSPRKU3hMimGdZEMYd8Sg/493DqwoenLj8oO3eqixmMeaD6ue5KX6SQ1L8t+Oa4mOURp0e3OdcskkmrdmDbdLssv6zsGuIrtV5oY9M/vtGkvtdAMsjLWK++CfuAGTyJu+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792111723; c=relaxed/simple;
	bh=6DrlkicTdWwNRPPeB4cM7csSLgPclQ0jX+/t2N8hQtA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Dqo7FDsyXOx9j/uN1vF1css6A1uBwF6z0lYH7En8bJCRLHQ9WJSA5uqonbsLOI4pJwrJc445YwJUCLwoFselcPT7bNcD9ZHgaa72T81xWbhWcMgnsmDzcXkxQ5+WxRVhMnjzJDO3HDlNKfjC0Kdu23UNcHVvWV4EGJPgnSLTS3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=J9fuFm4C; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=J9fuFm4C; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J9fuFm4C";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J9fuFm4C"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 78A57223B9
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792111719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2ckxJcbl4WLWQuSstHgfPz4fcdT1tskOP6Jce6738oE=;
	b=J9fuFm4CZcG8GskZKLDF7+XSFSq4CQ5M6f6NOUT/68kfPvnuueRoqIpB7lpr9Ea5zxLPv7
	ISMHDP3yTWMo0fjXeUj4GuR6Wa4xxOw7ja0uGRdHSPyy7JJlb5u2/LuxYBtUPvyr1Vn0D5
	e6Tcy7sIXZSfjGNy8M1WDI1UKLHMFig=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=J9fuFm4C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1792111719; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2ckxJcbl4WLWQuSstHgfPz4fcdT1tskOP6Jce6738oE=;
	b=J9fuFm4CZcG8GskZKLDF7+XSFSq4CQ5M6f6NOUT/68kfPvnuueRoqIpB7lpr9Ea5zxLPv7
	ISMHDP3yTWMo0fjXeUj4GuR6Wa4xxOw7ja0uGRdHSPyy7JJlb5u2/LuxYBtUPvyr1Vn0D5
	e6Tcy7sIXZSfjGNy8M1WDI1UKLHMFig=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B0A91339F
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id inJNK2V00WojCAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 16 Oct 2026 00:48:38 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: minor changes related to btrfs_chunk_map
Date: Fri, 16 Oct 2026 11:18:16 +1030
Message-ID: <cover.1792111604.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 78A57223B9
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

The first two are renames of "stripe_size" to avoid confusion with
"stripe_len". Both names are similar but have completely different
meanings.

The last one is to enhance the chunk map reading to reject overlapping
or different chunk maps from the existing ones.

Qu Wenruo (3):
  btrfs: rename btrfs_chunk_map::stripe_size
  btrfs: rename stripe_size inside volumes.c
  btrfs: reject existing chunks that don't match

 fs/btrfs/block-group.c            |   4 +-
 fs/btrfs/scrub.c                  |   2 +-
 fs/btrfs/tests/extent-map-tests.c |   2 +-
 fs/btrfs/volumes.c                | 138 +++++++++++++++++-------------
 fs/btrfs/volumes.h                |   4 +-
 5 files changed, 83 insertions(+), 67 deletions(-)

-- 
2.56.0

