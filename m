Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D162E738D
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780047385; cv=none; b=fayWFlGXUpuRYbwXeG/qDQe04CYt7GX+XhNyKmzJ5OnZjkE7OsGg2ZN/6ghFkFzzMymPJ32DK0HAf5aOLQ8UKguTSNrqgFV2CtyOQ04vgPfIgWxFcEu3px3Z6/q/bzl6hrxB5gD4+191EW8jNBFO31oINLRhwoHbwEALt/KZ3UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780047385; c=relaxed/simple;
	bh=VfrfKgcBEfnmxbrt9ZDeR0Ta6/cjp10d2R5Xf6EZXyQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=BNjLmCXXo1RvXx1TBg4JPpF5ikPVxNLW2SJ4ignDZFMLMhDYq8jHY9jvmQBFTYKii1y6HkSh5VmOSh/8FPSIw3kxvQHDy5x5Wwrx3VI0RfSiZDE0nETVKDhJxoLqZNGCeGLAqDqvgzqn2zcCARPIsoIHDkIzuNDuO3tmpYt+0IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PRMfVaS6; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PRMfVaS6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PRMfVaS6";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PRMfVaS6"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2676A6A7FC
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780047382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=npFYkUG5+3T7ZjeVz6GxE+k71hZPHYRDRxHFpGtgp1k=;
	b=PRMfVaS65ZgVvyBeOOJ0Z5yHbtuKXlHy/CFN/G66um2ov7ti2QMbpjZO6HmcGaUXogJF4h
	8JGeDyJn4mk/cesnUmi5soBhbuiKVwFaQpSAzdgnH/aqASkAexdpeeqHUKOkEHrc2dP7yW
	n8M8O9p6w0uyImQXwPtBn+ssDJnU5Xg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1780047382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=npFYkUG5+3T7ZjeVz6GxE+k71hZPHYRDRxHFpGtgp1k=;
	b=PRMfVaS65ZgVvyBeOOJ0Z5yHbtuKXlHy/CFN/G66um2ov7ti2QMbpjZO6HmcGaUXogJF4h
	8JGeDyJn4mk/cesnUmi5soBhbuiKVwFaQpSAzdgnH/aqASkAexdpeeqHUKOkEHrc2dP7yW
	n8M8O9p6w0uyImQXwPtBn+ssDJnU5Xg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5C9A3779A7
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5xpoCBVeGWqfWgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2026 09:36:21 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/2] btrfs-progs: fix the overly strict chunk type check on dump-tree
Date: Fri, 29 May 2026 19:06:16 +0930
Message-ID: <cover.1780047275.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]

Commit 408e45feb325 ("btrfs-progs: dump-tree: add extra chunk type
checks") introduced a chunk type check before dumping the tree.

However it's too strict as I'm a total idiot, and forgot to we still
need to dump chunk tree blocks.

Fix it and add a regression test.

Qu Wenruo (2):
  btrfs-progs: dump-tree: fix the chunk type check for system chunks
  btrfs-progs: misc-tests: add a regression test case for dump tree

 cmds/inspect-dump-tree.c                      |  5 ++--
 .../072-dump-tree-chunk-bytenr/test.sh        | 25 +++++++++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)
 create mode 100755 tests/misc-tests/072-dump-tree-chunk-bytenr/test.sh

--
2.54.0

