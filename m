Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4D333D6ED
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2026 23:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778370720; cv=none; b=GGmozuzWY3nU5hQcUxrcYy8BqgmDHnAPDWPcU9KOrcJOekNCGoaNS+rcREiARgBdKABoS+BSwpk7O5uNd6O4fvhgxfH2SzXgIQNnm+eOmN2rXLUQJZkxJnoNLol7pb/5FMXOTOg/6qUEVO/JOQAT22+Kca/dgbuut7FDqOyS2BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778370720; c=relaxed/simple;
	bh=tUkez5ndkychCIYFJGbkI6C1Ru5hpNkY1l1rE9f8Jdk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rKqDhhw4WByDBnriX7fudIHyeSpgNHFnoqPQCoGkKFRvE11cutz66wyr/o8ZwhhWsbdTI2dV4DQj8G167pG8GFKyC077xTq/OP26Q7GBjTYHoxhRThqCi1BG6F9MmNKMMxsjbQJ4dmj4z7+fWFEA8jZXGTBKow1LymTJU/Ufg50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OaQXT3ve; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OaQXT3ve; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OaQXT3ve";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OaQXT3ve"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B7F015E532
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2026 23:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778370711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2mjqzhZ/y1hiIoDQsji6+YOe3AfO4ax/ah2QCZd5MHY=;
	b=OaQXT3vej/yicv+aCOhFfAtooBAPlxIkQmr3ecsb6U0cGgzHEsPt4hEEdX0ygy4rqCy/yS
	U/+UNkO8lTrTxZZtnurIJJ9ASRxOGFmWkO8YTvcPvFqg3YI8WDBYjqkuGfhjUD8TsXjzKi
	jYyeQA9dLV0itxz2dorFV01yREP6i54=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778370711; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=2mjqzhZ/y1hiIoDQsji6+YOe3AfO4ax/ah2QCZd5MHY=;
	b=OaQXT3vej/yicv+aCOhFfAtooBAPlxIkQmr3ecsb6U0cGgzHEsPt4hEEdX0ygy4rqCy/yS
	U/+UNkO8lTrTxZZtnurIJJ9ASRxOGFmWkO8YTvcPvFqg3YI8WDBYjqkuGfhjUD8TsXjzKi
	jYyeQA9dLV0itxz2dorFV01yREP6i54=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACA04593A3
	for <linux-btrfs@vger.kernel.org>; Sat,  9 May 2026 23:51:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cEytKZfI/2l9NwAAD6G6ig
	(envelope-from <dsterba@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sat, 09 May 2026 23:51:51 +0000
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 7.0
Date: Sun, 10 May 2026 01:51:48 +0200
Message-ID: <20260509235151.2070978-1-dsterba@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
X-Spam-Flag: NO
X-Spam-Score: -2.80

Hi,

btrfs-progs version 7.0 have been released.

Mixed changes, notable one is a faster crc32c implementation on Musl. The
release on GH now provides ARM v8 static binaries (built on the GH
infrastructure, like the x86_64 ones).

Changelog:

* btrfstune: add ability to do offline conversion to the remap tree
  (experimental feature)
* mkfs: add hole detection when precalculating size for --rootdir
* fixes: recognize fs-verity tree items in various tools (check)
* enable PCLMUL implementation on Musl (previously using SSE 4.2 at best)
* help format changed to be in line with common packages like util-linux
* reject writes to filesystem during check/btrfstune in case there's pending
  state of device replace or balance
* other:
  * build ARM64 static binaries (attached to GH release) backward
    compatibility level is 'archv8-a'
  * CI updates
  * documentation updates

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
Release: https://github.com/kdave/btrfs-progs/releases/tag/v7.0
Python: https://pypi.org/project/btrfsutil/
