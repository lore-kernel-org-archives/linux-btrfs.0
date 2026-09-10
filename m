Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA334BFE8A
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789005984; cv=none; b=Yl1KGfFwFVT1azW5WVUK7jAr28XkHa58rYZYMvH0NFNu5CX/Y9VAcmxlhkDU2c4vapHyVlXbnEQmLdJJCz483vXFJE9eMaEMTJqdLQd47Wp7jDCzm5HB5MHFFnp23scoA0tNRhfqLMj188p5vtjOYYtDwJDC4+xrHno/xmR4NU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789005984; c=relaxed/simple;
	bh=/n1lKuoanpbNEBm2KufgP2DvPTVOLDqDGTAWoua+3pE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=h3X3r+LNBvvYlycVnfz4e8SXBdFErSYxu/QAyKL0tSA3STnvhDWwhOn3MAdyieK+E6bIclP7LuQhxRqzeobUrzI79bNque2TfCP1FO34ImquJwT5dYWRYfVWTtFZ4ufa01bk7rwS12wzL39KYHb029Jk++a7EEKcBuKQXdpDj50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=QEioJdj4; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KOs5SYG3; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="QEioJdj4";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KOs5SYG3"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA8661FD62
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789005976; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QBLJHqzDaOJ9CKup8vsTeSqaU2tJYhoIj5uR09IUbTs=;
	b=QEioJdj4N685isM1jz5zWUJ7I0G9y1pcm7+7bzphyH9tK4uM7HxTVxBWsp2UJWoaTNGv7i
	JV4dQ6hxPrMrGtno0MamaSttXbTrLhCwLSKgqXE2FrAOdv/VLwR46btam50mlN12B3+rjH
	3sHfzwQJP/+kxJvHztVKQUbnjYOkJUE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=KOs5SYG3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789005972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QBLJHqzDaOJ9CKup8vsTeSqaU2tJYhoIj5uR09IUbTs=;
	b=KOs5SYG3+mEcvSQkn5UBrVTLy55lCIQLCfrHzT9LVw2UVvkOP6/1MccSoj19M+yC5C30AH
	wiXAoEtxPwHzI7VEusY9pips1rzhAPBY92ZFLiPa2kjxsUO90+yd1XcluFcUIP4xrnFbsB
	WFvP1yIGhXRqekMdCRC9IXvZCgnGLTM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 966F513866
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lZjDEZMQomqaHgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 10 Sep 2026 02:06:11 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix and simplify heuristic_collect_sample()
Date: Thu, 10 Sep 2026 11:35:51 +0930
Message-ID: <cover.1789003160.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BA8661FD62
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

The first one fixes an off-by-one problem related to
inode_need_compress() and heuristic_collect_sample().
Thankfully that off-by-one is not causing any real problems.

The second one enhances heuristic_collect_sample() to handle large
folios in a more efficient way, inspired by the recent cleanup from Tal.

Qu Wenruo (2):
  btrfs: fix off-by-one end related to inode_need_compress()
  btrfs: simplify heuristic_collect_sample() to handle large folios
    better

 fs/btrfs/compression.c | 51 +++++++++++++++++-------------------------
 fs/btrfs/inode.c       |  5 ++++-
 2 files changed, 25 insertions(+), 31 deletions(-)

-- 
2.55.0

