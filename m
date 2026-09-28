Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B4C36195A
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 05:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790572549; cv=none; b=qdYwHqP8lUPT/8dG5IbXrGoKKw/ZmYCUFuwEcYBjhYfhFc2D1edIhm7GOKKVn31HvsZglCRnRJr42S3lYqBSw+7uwrHGLTqzrBmn+mReDu8hqMtF85gdzOr9bUM7ASw3dxm9w5lAL/h7SCfcb9bJI1DCcgnRjqfhuAkbB/KX2Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790572549; c=relaxed/simple;
	bh=d/FkP1oroXBJa/IodRfysr3RAUNJY2y2KaWETvMRWsw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Bl2Sqqa8vS7y7vl8pl/f6q7hqbjYWcEMbzICf7Uke/f7PMb2JXSwjnAw3iFrKkQq06coLMENN4Tp+G5tEDg8eR3mhEtGg2RZQcSoB4j2ffL4LB/GT3sQEXLT+11qkKmQHj494ozpOJ4G72hxGhGbmgy7HvE+lKjoE1+EsHe3Ej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RnA0Vw8q; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pwEm0U9p; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RnA0Vw8q";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pwEm0U9p"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A7EE521CF3
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 05:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790572539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cQHiwrZGV/g7mp6Q7FkjPyqxo5R3MSlHPJv0ypGds40=;
	b=RnA0Vw8qjlD/ZS8rkcvWm8xb7K22eUw3NZrvcGlQlG4bUQyKqUcivEP2x0NYmoU5aulTE+
	aIA5LcU4CPfmYr14yH9K209SgR7q8a3eh3qC5dq+W83ns6FPE6YplQk9GS0MSmjgqNMYsy
	L/9diaWrK5LjryEBJl0IzpTMcDm7U6Q=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=pwEm0U9p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1790572535; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cQHiwrZGV/g7mp6Q7FkjPyqxo5R3MSlHPJv0ypGds40=;
	b=pwEm0U9p8ntQWL46KsJ2/Ax4XBD7I6Qtx0Hvt1WGKyfT+5EGe6xOcx1GAodmn7HKq+bRny
	6IPjJfX0uMJELZLRvXTCklPDli4dEaUuC5W5RmacTjya/1awuC5ynqIxo0dpU8ZzZH9g1E
	fR31J6bZKl783Pvw8zP++0NROysBAmo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32A05133F1
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 05:15:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PBZ2F/X3uWrlLwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 05:15:33 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: go extent-by-extent for buffered reads and writes
Date: Mon, 28 Sep 2026 14:45:08 +0930
Message-ID: <cover.1790571994.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: A7EE521CF3
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO

Although we have large data folio support for a while, the buffered
reads and writes are still iterating a large folio block-by-block.

For a large block sized buffered IO, the large folio has a very high
chance to contain only one single extent.

In that case, although doing block-by-block checks is good for
readability, it's not really performant.

The series changes the behavior to do extent-by-extent iteration
instead, this can bring a very slight performance improve.

For best case scenario, the runtime to submit a folio read can be
reduced from 32us to 2.5us, and a much better distribution.

For writes it's not that obvious for the average runtime, but an obvious
improvment to the distribution.

My current guess for the lack of write performance improment is more
bio_add_folio() failure thus more bio allocations.

Qu Wenruo (2):
  btrfs: read a folio extent-by-extent instead of block-by-block
  btrfs: write back a folio extent-by-extent instead of block-by-block

 fs/btrfs/extent_io.c | 312 +++++++++++++++++++++++++------------------
 fs/btrfs/subpage.c   |  49 +++++++
 fs/btrfs/subpage.h   |   4 +
 3 files changed, 236 insertions(+), 129 deletions(-)

-- 
2.55.0

