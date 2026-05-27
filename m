Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C69A150997
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 05:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779858432; cv=none; b=QWGKZA12gI2mm3YlrxCtUWb+RZ/bMW4DarSIb64svSzm/d38DULSaSX03EXkUEl0oui2Nw1oHc7RvFbo/SYHk1Mnd17JjKy4XGMj8HOqhPamtgkr92k6p6ok3Qa4Vs+47zvwhOBC7dzuJVnRU1oNCITT7iCpuWtlY3FiqcG2jBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779858432; c=relaxed/simple;
	bh=N2YzvrRX162se28arco23V9IoeGuKlUjCaqTUcg2i6Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=b/UTd5wFywKHZaS1CacayXtHi2VB3z9u0/s4qufn3GWcNgwr2R0kiMAGwn7OwPi2zYNM+uckfvUgp6EE8q5XCrAG8+Y6hdUgOmIG+x49gwjnI67J0u9LguiS1djh3YL1KGjs7cwI0tvyjKdXgI7VRAuTMnU37fEJOu3dNu2Vweg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=D5WDJtuj; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=D5WDJtuj; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="D5WDJtuj";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="D5WDJtuj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7EFA16AD53
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 05:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779858428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QpptxUaSYhtda35Qzrwc/xi7WRC9p3lxNA55D+nQXUs=;
	b=D5WDJtujKM86S0GfNjSj8qJVMsScV32yDcoV5ni3he4IEouC1jY8ViGgbM40gql8JZaGC8
	xMwMEy/Z+PJd5qSf01wW4ivynDkik+VCUNmx45Xk6AqXUVnMElt6MXO/jJKYKy7o4lFIJn
	baPrtZh0ig3Dn1jWWjG5Id4VsZpNIcE=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=D5WDJtuj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1779858428; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=QpptxUaSYhtda35Qzrwc/xi7WRC9p3lxNA55D+nQXUs=;
	b=D5WDJtujKM86S0GfNjSj8qJVMsScV32yDcoV5ni3he4IEouC1jY8ViGgbM40gql8JZaGC8
	xMwMEy/Z+PJd5qSf01wW4ivynDkik+VCUNmx45Xk6AqXUVnMElt6MXO/jJKYKy7o4lFIJn
	baPrtZh0ig3Dn1jWWjG5Id4VsZpNIcE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5A2C5A653
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 05:07:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0b44Hft7Fmo4AQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 05:07:07 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs: fix generic/362 failures with nodatasum
Date: Wed, 27 May 2026 14:36:43 +0930
Message-ID: <cover.1779846117.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 7EFA16AD53
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO
X-Spam-Score: -3.01

The test case generic/362 is pretty well hidden by several factors:

- "nodatasum" will not take effect due to the bad design of the test
  case
  If the target file already exists, the test case will reuse it,
  meanwhile "nodatasum" mount option only affects new files, meaning
  if the test case is executed before with data checksum, it will never
  go through the nodatasum path.

  There is already an update on the test case to make the failure
  reliably reproducible:
  https://lore.kernel.org/linux-btrfs/20260526070055.60193-1-wqu@suse.com/

- Btrfs always falls back to buffered IO if the inode has csum
  Thus we do not exercise the zero-copy path, hide the failure for the
  default mount option.

With that said, the test case failure needs to be fixed, and there are
two bugs in the direct io path:

- Treat any short write as an error
  This is especially common as we have disabled page faulting for
  reading from the @from iov_iter.

  This is fixed by the first patch.

- No isize rollback after a short write
  The isize is increased at btrfs_get_blocks_direct_write() but when a
  short write happened, the isize is not propoerly rolledback, causing
  later buffered fallback to write at the new isize.

Qu Wenruo (2):
  btrfs: fix false IO failure after falling back to buffered IO
  btrfs: fix incorrect buffered IO fallback for append direct writes

 fs/btrfs/direct-io.c    | 33 +++++++++++++++++++++++++++------
 fs/btrfs/inode.c        |  6 +-----
 fs/btrfs/ordered-data.c | 12 ++++++++++++
 fs/btrfs/ordered-data.h |  2 ++
 4 files changed, 42 insertions(+), 11 deletions(-)

-- 
2.54.0

