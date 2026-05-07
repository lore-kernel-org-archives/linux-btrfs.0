Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37B93AB29D
	for <linux-btrfs@vger.kernel.org>; Thu,  7 May 2026 17:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778176786; cv=none; b=hmNCg5b9Y6QG5ab2dR384DjJNMFvDKnWdk7GFOWJCiHOLpQi1VX/Dmy7pR2eIqoFtrhA96UOHihsIlpXvje2+deXUkH9VUJAzxu/y/CIN4El6OYDU7giTdq+ohTAngegej5zOmD8OQFSDCh5U7JN6fiet9ryjoR3t4hWaVUVRds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778176786; c=relaxed/simple;
	bh=hfhbwDOw2mDIXOqmK29ImYFb7YbuMaz2P/Bh+vWC/gg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QrHpiSmXjsjVMCufyc6to0Olu7ahmXOlQjilmtfg7XXDbSqipTJJb1j7ma/fdZ1qDwebzQi63gqK9IntdQBMGhSyAeZFBXPmeh7cO59b/lfLlphWEPf65HpB4+W31Alv48F6r04AtK02gFJjkBTOk/NA2xFDe3+CEx2hHvL9eVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Zi4TigcZ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o5cZOe74; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Zi4TigcZ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o5cZOe74"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A92525C196;
	Thu,  7 May 2026 17:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778176782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BBOuawKhkDOMKI9SkBw6WwgZ+47f6dqosG0JWsGpx8Y=;
	b=Zi4TigcZ9Ou442wi2ZZAz3wjnuUpq0XENS3lVxAe901KKMXJ+dfBM/T0l/CWIpd7nVh1aR
	4z+ooCbsXGFBG+1vNOzsHGojrKsmvhQW5uVgDO+x55NhacGEtRQxnFFqS+auj3gk8UW09O
	UxtjoTVsN/YJCvKgjotE1ipoHFCHNsc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=o5cZOe74
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778176781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BBOuawKhkDOMKI9SkBw6WwgZ+47f6dqosG0JWsGpx8Y=;
	b=o5cZOe74n3H4coAGYr4jQXVwsIfIEd1E/g0VeXBccjD5NW0L8maRoBVUP2dD7o3cpIyiYV
	xHwsYgiJfhJP5Qnmfs29dy7+rgy7Y4OFswSILj4h6Vlpg9758EJJnOLl8kfRw7Y69A0w26
	PaGDpux8kj40kiMz0zzJog/sF7YK+fk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A229F593A7;
	Thu,  7 May 2026 17:59:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bCKRJw3T/Gl9CAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Thu, 07 May 2026 17:59:41 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH v2 0/2] Transaction abort macro optimizations
Date: Thu,  7 May 2026 19:59:30 +0200
Message-ID: <cover.1778176579.git.dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -3.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: A92525C196
X-Spam-Level: 

Optimize size of the macro btrfs_abort_transaction() by encoding the
'first hit' logic into the error code. Additionally also verify that the
error code is negative.

v2:

- add patch with the verification
- in second patch reuse local variable for btrfs_abort_should_print_stack()

David Sterba (2):
  btrfs: validate negative error number passed to
    btrfs_abort_transaction()
  btrfs: simplify how first hit is passed to __btrfs_abort_transaction()

 fs/btrfs/transaction.c | 13 ++++++++++++-
 fs/btrfs/transaction.h | 41 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 46 insertions(+), 8 deletions(-)

-- 
2.53.0

