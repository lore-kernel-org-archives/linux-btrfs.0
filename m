Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795165745;
	b=kteJgJ+v3+5qHmvyBz4ZoJyLlwuuLnH5WL61p+aRfKjXQUwWRnoLt91ohKv6okuuKLc1
	 gaUMdlb9k/O+fAq0tedNntH9nx4b0uwGgaGeBkmwmDPSPpOHAiU0EDDJ26wqUQ36lwGng
	 +f0ZF5P/cdk0BMWca6RxrHKXDEMbeSTD+nResrl3hZ3vIfzoJSSa5NTRJ+7LitWAP0VJi
	 epN+z/54baCENK9Z4868sIqVhFdWB2gCOvhC2Icysmqs1oacILtmauI3cWDO98/a3slNr
	 k7/BBAKzNDzpRGlWBMyhUovMLKOt15mO6d6pwtRMHN93If9NE558kD2MH4ZHzy4a9Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795165745;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=6b5iFkDB958ui6nWrB6BJ5IgzYQaTtsHyvBjl8nIP+E=;
	b=1pPP+Q91BcWvfuTm6N5xGZ0mtg6Ma9KIFPqW32wJd6Le8DX0okAP6Lmz8ITngbAh3e3H
	 6MBweSbHwEs9JrwOIp4o9ANl/D4/wcV6iW0kXTs5Mf4SoiaNXIL2GMODN966GuAp/vi/L
	 jJvCr2VCLna2bGB/meBmXYt7hU3RQgcdTjYzI8KV2hDVgBA99elmxm9EvT2fTqzBjQi3p
	 YBP4DQqpaoWvInjnEkAMjFVvvSjiPyXyaggfAUUCIwdqxubD7b8U+mGENbBBTI8n/WF4d
	 y5I0MuLDs1BbKqISNZP1AW3Gn0UIihw3trY/C7tDuBXZUXrqCTg6K+OJgJwntuKM06A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=mfhMOHto;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=mfhMOHto;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529F1606A32A
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:09:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 529F1606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=mfhMOHto;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=mfhMOHto
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CBAD31F390
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795165737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6b5iFkDB958ui6nWrB6BJ5IgzYQaTtsHyvBjl8nIP+E=;
	b=mfhMOHtoqH06kKh8Ub2Wu4u7FNcQrKkXb2Mad7Mq+rM9FMKBCmCtb1iw9HqqwJPGDDSV4k
	2L+o+fkbhAetEvBLEZdoAJabjdq57cw9dJdKsKFkq2/XDfdxnVJk848OGI6Zor2P/3PjDw
	amNQlOgGsJW/SfWfuYknWCloJelMb0Q=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=mfhMOHto
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795165737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=6b5iFkDB958ui6nWrB6BJ5IgzYQaTtsHyvBjl8nIP+E=;
	b=mfhMOHtoqH06kKh8Ub2Wu4u7FNcQrKkXb2Mad7Mq+rM9FMKBCmCtb1iw9HqqwJPGDDSV4k
	2L+o+fkbhAetEvBLEZdoAJabjdq57cw9dJdKsKFkq2/XDfdxnVJk848OGI6Zor2P/3PjDw
	amNQlOgGsJW/SfWfuYknWCloJelMb0Q=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9B5761342D
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:08:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7jwnOScOAGsJYwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2026 09:08:56 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/3] btrfs: qgroup: rescan related message minor fixes
Date: Fri, 20 Nov 2026 19:38:34 +1030
Message-ID: <cover.1795165635.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBAD31F390
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim]
X-Spam-Score: -12.01

The first one is from Sashiko.

The second one is to make sure we output the rescan related message even
if we failed to start a transaction (e.g. transaction aborted).

The final one is to fix a bug that rescan cancelled message is never
shown.

Qu Wenruo (3):
  btrfs: qgroup: handle the transaction commit error during rescan
  btrfs: qgroup: ensure the qgroup rescan messages are always shown
  btrfs: qgroup: show the "qgroup scan cancelled" message correctly

 fs/btrfs/qgroup.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

-- 
2.56.0

