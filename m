Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2962B25333F
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785458729; cv=none; b=Kts9vN+EvTWFug+pZ/FSHw6AED4YZdjSB5/GsjaV7riUMjPaG6VjiJUNJB38m6RFVlB/At00jhW11u18ypOeeJY8LgPWMTaAecQ/d/mVHfz42ZoAVuLBspU9+DsG3Sp0ObJaRo0Mp/ICd5t1CI/qymR3t+rRp/60Sb8vlkJ6wCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785458729; c=relaxed/simple;
	bh=6PTlLh3OLAr+ipv66ezsWUwL18ZZVRSce67LFNKIfPc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cJaALtLfawFGioK7EhU55TdcwpAtwE7oCGJBWKxoIoWY974ZyIBfxUZ8RigRQxmRMsjZ8qahEa2Kao2xQlx2lHc56FJpEBODVn8iThpgApCqtzRb4xz2tL/x/FniiZbCyq96MaVF54zJ3A+3AeSjeRIjx0z1P4FCbDJprmxYH0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=URmhbEWe; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lJ9uL/aF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="URmhbEWe";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lJ9uL/aF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C5A377DC81
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785458722; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XD3jDKour7jCk1gSkNjxhvS9ef2OwtjONy9bbSs9BUI=;
	b=URmhbEWefWRzZbzFUqCWyi9pIOCtC3c8zFw/K9cgVqwE814i9Ffl+tMCdOF1yMCVrqZj+2
	WqoorO4imSYYWjxRdaOVn4FvXTyt2n0LOq05S5J4LDym9DYb/WRXE8GBxRNVlsJp5ycVag
	J1N4L6pQghABYHNsnHuN5XD70cMc3FI=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785458717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XD3jDKour7jCk1gSkNjxhvS9ef2OwtjONy9bbSs9BUI=;
	b=lJ9uL/aFNJT7pUuRUYYs8562Q/sISU8tFr//yyTTd3JD1ohLmLnD0NNzTSzXmHJMk8Hx1/
	O121ev9pPcjqoJuWPsLJvBhGKFCJ6llug5tb+w0UpHRE0D0NUQ5pObZU8YPGHp/PQrcn57
	fIj85XsGs8URbQ7C+oPNxjT1ojgMmX0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA8ED779B0
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tOgAGhzwa2qCZgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 00:45:16 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix generic/795 crash for bs > ps cases
Date: Fri, 31 Jul 2026 10:14:48 +0930
Message-ID: <cover.1785457950.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]

During my development of the incoming data_size feature, it turns out
that we have a new crash triggered by the new test case, generic/795 on
bs > ps cases.

It turns out that for cached inode items (btrfs_delayed_node) we can
skip the inode mapping flag settings.

This bug is fixed by the first path.

The second patch is to introduce the extra debug ASSERT()s, which
greatly reduced the search range by showing the mapping's minimal folio
order.

Qu Wenruo (2):
  btrfs: initialize inode mapping flags for cached inodes
  btrfs: add extra ASSERT()s to make sure the folio size is correct

 fs/btrfs/extent_io.c | 19 +++++++++++++++++++
 fs/btrfs/inode.c     |  3 ++-
 2 files changed, 21 insertions(+), 1 deletion(-)

-- 
2.54.0

