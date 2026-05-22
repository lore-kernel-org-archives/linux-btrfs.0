Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1525D1AB6F1
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 09:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779441855; cv=none; b=LDQfPie7HqFpJkU5oR2s0Hhb2ZKsWmdK+B46udZOtKeibnloD36fpjQvsxmjzAf2cFNX/6NcsIofVWAETGRDSfeV51o/DZAW7kWmYZfhpFl2nFS2VpZn6/TPBsK0oBBfZRd+8xLYIXjjRhVF8EivXHLRBxi/k34Ziva/171F34I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779441855; c=relaxed/simple;
	bh=ahdBajnGIia7rJRmkcgrkNusISseMLPg5V30BukLUP4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T83T7kdoKpXf40AwJ1qH3LNjFNzBmtmayWPI5KZ1kYQYF16xv65Gv5qWDLHE79vR3ZNs8RtLfZ0RWLzALpurLSq/3QqFbXZcmZb4rSipn8wgv3hk9LHs/e5VcgZ0BZDhC8moZ5Vug8IiaCuqv3EZ+AtcEm+Af3i3+j1PdhmaSz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=l7PPyKpp; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=l7PPyKpp; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="l7PPyKpp";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="l7PPyKpp"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6948A67A66;
	Fri, 22 May 2026 09:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779441852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cBNL1p9LpwkumQSCgJx3CtoxLri1zLmHlWTv0UdmR5M=;
	b=l7PPyKppz/gqckM6JrUm7wwH/7Lz4rzO/w6EkJkIw5Zk8LEL2UEAdB70EdfXMh3ocbdbii
	zh/RsB+pF/yuVHfYeswVSeWTOaV1A77hHGTv6t51GdNw1OF+G+L4B4k+Rotbe4O+Rpd4GO
	e86MyQX9UNroOYiz4UJtYqvl1MN327A=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779441852; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cBNL1p9LpwkumQSCgJx3CtoxLri1zLmHlWTv0UdmR5M=;
	b=l7PPyKppz/gqckM6JrUm7wwH/7Lz4rzO/w6EkJkIw5Zk8LEL2UEAdB70EdfXMh3ocbdbii
	zh/RsB+pF/yuVHfYeswVSeWTOaV1A77hHGTv6t51GdNw1OF+G+L4B4k+Rotbe4O+Rpd4GO
	e86MyQX9UNroOYiz4UJtYqvl1MN327A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32609593A8;
	Fri, 22 May 2026 09:24:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Cc+MObogEGoXQgAAD6G6ig
	(envelope-from <wqu@suse.com>); Fri, 22 May 2026 09:24:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: hch@lst.de,
	linux-raid@vger.kernel.org
Subject: [PATCH 0/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
Date: Fri, 22 May 2026 18:53:50 +0930
Message-ID: <cover.1779412152.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_NONE(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	internal_greylist_whitelist(0.00)[10.150.64.97];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid]
X-Spam-Flag: NO

[CHANGELOG]
RFC->v1:
- Remove unused btrfs_chunk_map::io_(align|width) members
  To make space for the new member.

- Fix a duplicated bg->flags assignment in fill_dummy_bgs()
  Just exposed by the last patch which also touches that code.

- Use a dedicated member to record the on-disk chunk type
  So it's less fragile than the RFC patch.

The single-data-RAID56 (2 disks raid5 or 3 disks raid6) is not a feature
that should be supported in the first place, thus raid56 is going to
remove such support.

Meanwhile rejecting single-data-RAID56 will cause existing btrfs users
unable to mount their fs, even if there is only a single
empty chunk with that flag, mostly caused by some degraded mount.

So to avoid impacting existing users, implement an internal
single-data-RAID56 to RAID1/RAID1C3 mapping, to co-operate with the
upstream raid56 lib changes.

Qu Wenruo (3):
  btrfs: remove btrfs_chunk_map::io_(align|width) members
  btrfs: remove duplicated block group type assignment
  btrfs: disguise single-data-RAID56 as RAID1/RAID1C3

 fs/btrfs/block-group.c |  3 +--
 fs/btrfs/volumes.c     | 25 ++++++++++++++++++-------
 fs/btrfs/volumes.h     | 10 ++++++++--
 3 files changed, 27 insertions(+), 11 deletions(-)

-- 
2.54.0

