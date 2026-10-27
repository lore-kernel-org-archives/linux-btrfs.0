Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793093713;
	b=p38+AcOh6Kc+WvWciwyJdVikQjGAhd4ygbRT3wXA/FJOdPHfq5S8foi7bhvfsnMBXa2M
	 zj1hjgFShYhoBkRH8SMDesG7VePdyIJYubRzxruUZnFqNLRX+N0GBvUAWrKnfG38szAzE
	 O9jgz9BOyibnaZNuArWLYI36Os4gHvVJPwVpewdwaXkzi63uQmKv8BuPjloghlmisemmq
	 cdfrbVHf9B2pQiGFVxIfeltRsuOhirGAd1nnl0CjC7j7higtLo0OZCzGKZpYb2Fz7RKAl
	 unaa/QulanrMT9UyOST2ZHO8zJeamvHKzZpqdhboeaQybfYKTbbCZ9OUIWk4bn9YAqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093713;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:
	 X-Spam-Score;
	bh=MQea9ol6/RJjtZzDl8CYbR/PcRUymiAUiwp/SIaGts4=;
	b=WSyJ5+UdtxlXv+7pkM0M/LnVDWN9unJbc1AVeSH+Km8Ib10DYhQTJBOJgLX7BqgzVTP+
	 U+0ro7VSe2/wdafOx3y9PeGkumQhOwtsU8sLnHEa0w6Ayo2L1YlT7zQAOXpLlxaIiiUw7
	 Eae4Cwu3qOsMtzPbJsMA0erCtzs1NefTjj9FWlq7dypEwRjeX0D1AjhNZ/2OXNj7fJKrS
	 mZOcJhV98L4EGn4tLBrkEslip4F+mVhNbJfseJplFfxsnfEvHgRBCf5Ws8zKlXc18LaVK
	 IayAEUXclVAAMK41aQ/J40wP5juYssBJZLtB78fGnl7u5yJCka0MTVa0zc0oje7oPKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="iAy2d/mm";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="iAy2d/mm";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBD2606A31E
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BCBD2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=iAy2d/mm;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=iAy2d/mm
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 14E1421F4F
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793093711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MQea9ol6/RJjtZzDl8CYbR/PcRUymiAUiwp/SIaGts4=;
	b=iAy2d/mmX0mQkurYd5SJ/l9tzem+BzBcVpefKeXSrsMneK1FlNbTm62nbyikg+BfofxGe6
	Z3JXFPvJvub2dhnbuk6DjcSm5MQM0HQ6b8Ox0lkJiPhRXUB3NZ9//psPx2iU6DUponuZ8u
	/J54i/SFe6IV2D+1QTcjFm6xa5e+gM0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793093711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MQea9ol6/RJjtZzDl8CYbR/PcRUymiAUiwp/SIaGts4=;
	b=iAy2d/mmX0mQkurYd5SJ/l9tzem+BzBcVpefKeXSrsMneK1FlNbTm62nbyikg+BfofxGe6
	Z3JXFPvJvub2dhnbuk6DjcSm5MQM0HQ6b8Ox0lkJiPhRXUB3NZ9//psPx2iU6DUponuZ8u
	/J54i/SFe6IV2D+1QTcjFm6xa5e+gM0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EF02213319
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RUo5FE1w4Gr8VgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2026 09:35:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/2] btrfs-progs: simple cleanup related to LLVM (not LLM)
Date: Tue, 27 Oct 2026 20:04:49 +1030
Message-ID: <cover.1793093611.git.wqu@suse.com>
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
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -11.80

[CHANGELOG]
v2:
- Fix the second patch
  Which added the GNUmakefile, not adding the file into .gitginore.
  Facepalm.

When using LLVM to compile btrfs-progs, two unused global variables are exposed.
Fix them.

Secondly recently I move to use `GNUmakefile` to customize the make behavior,
e.g. add "-j12" make flags, without modifying the existing Makefile.

Also add GNUmakefile to gitignore.

Qu Wenruo (2):
  btrfs-progs: remove set but unused variables
  btrfs-progs: gitignore: add GNUmakefile

 .gitignore                      | 1 +
 cmds/inspect-tree-stats.c       | 3 ---
 cmds/rescue-fix-data-checksum.c | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

--
2.56.0

