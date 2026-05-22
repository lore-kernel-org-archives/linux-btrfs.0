Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF41A3BED0C
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779444435; cv=none; b=ADszvOXDbgGJ0Q2LTHrvf6z3IB7xl6EpikXZmpieTZMtnHWQ6EZZKKqKIk6UhWFI8ZsIUM84/R95wVlbUQfOpSG5p7j9kg0jkQnbBw76jswcgUbMsHtgYMsSzFGTYWnnqOD9+WZoNjFrUrTTeWEljxsvwaU62voIiXx+ig2nB7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779444435; c=relaxed/simple;
	bh=hjAtIiiqjl1xUN9U8opXB9yxFZObwtHLSqBVORcVBOo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=l8Ch2UPWZOXFVqm/dk7IbYi/c82rPf23yhVbjcbgU62Ef0xqQdqZ5+rmpWvACq0E83+GcMAzU9HpfKvPMRM5riVEPia3UPc72QXpehLhqLk1hMlqmDA+TnSSn7BQf2wc1pnD/QRKNKBZ6IuRNw2jsX0HPaApJk+N6GPmkhp+sXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tKbykr/h; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DmVs+Qry; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tKbykr/h";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DmVs+Qry"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B9E8867AC4
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779444432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QEDnpIFHnM1UCX9ousKWNmN3bVbtAghCwt6CZ0Fg2dM=;
	b=tKbykr/h/Mj56aGenFDr7V7vIqkp4azwBL5pGgdHLC+oJBFVvrRh44ujOtJ1X8ensLJ3Hn
	AQliSESdmKJQWeV/DOx0d27iW98turogBuqTcIDOY4a+IZFWT1MezO4VYChBtndLLtGhoy
	hCBBsghk/Kv4nDZ3tv1C5y0gspREl/U=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=DmVs+Qry
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779444431; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QEDnpIFHnM1UCX9ousKWNmN3bVbtAghCwt6CZ0Fg2dM=;
	b=DmVs+Qryn1dlGlylGjcys3qPng8fo36LBm5/z3TuB/vYNGwhnm9pdim37yIf1GI3EFe0Cr
	N6EDEUWzDPKi9QrTvJu26KMiBjNoqNUSlPTYSCkeVMkiQVl7IGlZ7sYS7UD2LTMWW7S+wK
	DW4EFHB2/iwWnH9b2dvrt3micXPTIOM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E8295593A8
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2Si5Kc4qEGpnbAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 10:07:10 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: fix a heap-overflow bug in raid56 reconstruction
Date: Fri, 22 May 2026 19:36:51 +0930
Message-ID: <cover.1779442619.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: B9E8867AC4
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO

During my local tests on a kernel patchset of falling back to
RAID1/RAID1C3 for single-data-RAID56, it turns out that "btrfs check
--check-data-csum" can report a lot of false csum mismatch.

It turns out that there is heap-overflow bug where we can get garbage
into the IO buffer for RAID56 reconstruction read.

Fix it and add a regression test case.

Qu Wenruo (2):
  btrfs-progs: fix raid56 reconstruction read
  btrfs-progs: fsck-tests: add a new test case for the raid56 read fix

 Makefile                                 |  2 +-
 kernel-shared/extent_io.c                | 14 +++++++++++-
 tests/fsck-tests/074-raid56-read/test.sh | 27 ++++++++++++++++++++++++
 3 files changed, 41 insertions(+), 2 deletions(-)
 create mode 100755 tests/fsck-tests/074-raid56-read/test.sh

--
2.54.0

