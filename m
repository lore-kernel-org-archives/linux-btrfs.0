Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8031E7660
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781140450; cv=none; b=P5gx4oHvbFEQctR1dydUD2aPR6x0Gfu4moaMlplAbknT6jF2L2//BUBHsCyU2cnNuS6N8Xx57uVUm8Vs+uGs6gMoBbYNF66H+/2cJu6WIkLGN63pJLQ1OqTsqF0WNJg9sZP9Lr+uG7AUWfIG7sSi0ng1R25ZPboQO6lsJWD3AnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781140450; c=relaxed/simple;
	bh=04HzNkRY3pg2rG8O5sYsGYGPGzj7rRON53nieJ66pTs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=LiJh5fBpwoLEGyf2Er9tZkKTevtc229JhtItj4yDFTxod6m7YFEJJSZkb+srDdKqo6SlfXhyEGBhncP536K3sYNBA1stCCnYoF/lzAGrf4odgkXJZS7t8rbYnVwDWboAeA1wavevsebhDSILJWZeVwwLR0wzEtZ+IMTE8waOJQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Z492vpJV; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=L0y4KJxV; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Z492vpJV";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="L0y4KJxV"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE9286AEEC
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781140447; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=bBxNsidA4ZyU7v86x0RRuV5E1X/8PbMDjvb5zOSG0iY=;
	b=Z492vpJV0BhYQO100h6Po+OA/hCVt7+o625kA9esH759mzFAjef/BKjPxLz5YMmp/e04Zk
	EXuV0t2C/XnPSYRzT+g4PBumzldL/2GRh19TsIolRLP40oRmczBSiYUDjp82aDzXLg2RuC
	BY9E+GEQogjjW1hhKLRu3LXpMerVMHw=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=L0y4KJxV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1781140446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=bBxNsidA4ZyU7v86x0RRuV5E1X/8PbMDjvb5zOSG0iY=;
	b=L0y4KJxVQYGjxbL8Ct2QdOafztSDbRH8iq18djMlUM7rMJ2XZ8I2ssF6NynCuok1gpAf0u
	kJ4dAq64d2Wr4kMz4+kSlFRJgmRCdFpv5Q0SdzOHzm+a3/kWsZgdEu/PfXE+oIgtTFJq88
	MdFP3kJvIh5QSkzmWMO42ZJOe58uSm8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D0E25779A7
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9RhsH90LKmqFWwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2026 01:14:05 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs-progs: fix memory leaks related to zone/RST
Date: Thu, 11 Jun 2026 10:43:40 +0930
Message-ID: <cover.1781140396.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: DE9286AEEC
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

Just give a full test run (except libbtrfsutil run) with D=asan, all kinds of
memory leaks related to zone/RST are exposed.

Fix them one by one.

Qu Wenruo (3):
  btrfs-progs: fix a memory leak in btrfs_prepare_device() for zoned
    devices
  btrfs-progs: fix a memory leak in btrfs_load_block_group_zone_info()
  btrfs-progs: fix a memory leak in __btrfs_map_block() after RST lookup
    failure

 common/device-utils.c   |  4 ++--
 kernel-shared/volumes.c |  6 ++++--
 kernel-shared/zoned.c   |  3 ++-
 kernel-shared/zoned.h   | 10 ++++++++++
 4 files changed, 18 insertions(+), 5 deletions(-)

--
2.54.0

