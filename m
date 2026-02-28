Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C64674C14
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Feb 2026 00:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772238214; cv=none; b=oCSlYqnH0+ZuNHHpd6hViU7DwxDk1Eg4DfVJcA5VdAOekBFLow6kIkJb2qJfkCDqHzLjGI7/lW0xAOcve0v97r01x1yGVGOqqiUBkh3Xk8QBaUm+55fElHZ3r/YDveguYNhhqUPHjmulmAbsIP/v3dp6hyWhLxeC9hhSr8uZMZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772238214; c=relaxed/simple;
	bh=EcpZ7eR/vK1b43oGybCB/UcFVp/8O55QoYC+wfRFESY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VJ0/Gz4X9q1etzSjatYsV1NBKQMou1+EedaYDdmULMpGQUWvGq+SOwq3TniCOl8dV/BErNG2GcLnpfFFjoXPxmXQCjeKpTVQI/OuuYH0lpENB1kW4J0Y0uvwKqgQceC5t2KkXyr7fhz+C9XywBFepK5KtE8P27v+cnTUvnWH5PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=D2OqmOhe; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=D2OqmOhe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="D2OqmOhe";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="D2OqmOhe"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 50FC23F9BB
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Feb 2026 00:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772238211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=y3CflqBGCdq2aw9er7jVsoAb5GHg4OzL9IV972Ux/vk=;
	b=D2OqmOhe0fxsiJwZrWFezWVezAlTerCZZU3XBIBJbFjS9MA60YfaEESwBTlsoDkjVE/okY
	vXZ+8E9gOzQJr04ZF2ZdH3S+VR6J8sMEv5G4FhFZKqE6NkU/K0mLyG8qzgUwu5DHm/rprW
	+jndUhiVezMgIMzZn3Yz+zlZXKK2Xzo=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=D2OqmOhe
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772238211; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=y3CflqBGCdq2aw9er7jVsoAb5GHg4OzL9IV972Ux/vk=;
	b=D2OqmOhe0fxsiJwZrWFezWVezAlTerCZZU3XBIBJbFjS9MA60YfaEESwBTlsoDkjVE/okY
	vXZ+8E9gOzQJr04ZF2ZdH3S+VR6J8sMEv5G4FhFZKqE6NkU/K0mLyG8qzgUwu5DHm/rprW
	+jndUhiVezMgIMzZn3Yz+zlZXKK2Xzo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 875C23EA65
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Feb 2026 00:23:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qunAEYI1omkgbgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Feb 2026 00:23:30 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix unpaired compr folio allocation/freeing
Date: Sat, 28 Feb 2026 10:53:10 +1030
Message-ID: <cover.1772238005.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 50FC23F9BB

With the recent *_compressed_bio() rework, we're using compressed_bio
everywhere for reads/writes (including regular and encoded).

However this requires us to allocate/free folios using
btrfs_alloc_compr_folio() and btrfs_free_compr_folio().

Not using the later to release a folio allocated by
btrfs_alloc_compr_folio() can screw up the LRU list.

Fix the unpaired calls as a hot fix.

For the long run, I'd like to remove btrfs_(alloc|free)_compr_folios()
with regular folio_(alloc|put)() instead.
As I do not think the compr pool is that helpful compared to the extra
maintanance needed.

Qu Wenruo (2):
  btrfs: fix the incorrect freeing of a compression folio in
    btrfs_submit_compressed_read()
  btrfs: fix the incorrect freeing of a compression folio in
    btrfs_do_encoded_write()

 fs/btrfs/compression.c | 2 +-
 fs/btrfs/inode.c       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.53.0

