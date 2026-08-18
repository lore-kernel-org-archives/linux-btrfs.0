Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5926644606D
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787045408; cv=none; b=Q1vk7BuMhUq0JiSGZNxKpgT9g2j4EI3MV35rCSh2pweB6u8KX+tCqSzCEFyxwIqVrGgnU2BFWQ6jfVtBjOFcGhAObBZiDLrZ5iGqZjdMdQZuI5zlvI/Y0p9hviHKS6sRxZypo5JWGe5gsyoITibHTNUEZIYy7wXOsDH2B295oGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787045408; c=relaxed/simple;
	bh=0RqXPZhA8Qa6HokjHleTHDF0z7OAgurr02SmOLk0LwI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=hzK9AHnyUra0eY2FrGpvN+0LwJMqpdvT1J9g8uyI4m8xuZa0EnQ1Af0X3ie1jv1kzhVx3cSNZaaJRP6ptAfOGWZi+UMBq70unEJ7TyW7hQcpoBBLauO4V2nYY5N9SW10552/mlCJDAxCewzwqMsxZx59IxDUx56wGUAX4lZQLpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=nGH1ixG8; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=evKC2FPF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="nGH1ixG8";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="evKC2FPF"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1E91884484
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PLmf3Oul7A1vJvAzY6lVTDitkBCjANJUN+ABSwLhz1A=;
	b=nGH1ixG8a5uY2/VmDBNJ0sB0H8F691nsSspcPSDG8ArapPGUIViybzcgqeX3D4fFKedIZP
	vOUAw1f7gugtOkFX1xK8vnqgKcyUVmvoP0aGUMOjexECfNGyijf2StNLvFJ0R2Hs8j17We
	+aYt0apDqeBgOaOfiABwVwWdy4KuvtA=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=evKC2FPF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1787045396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PLmf3Oul7A1vJvAzY6lVTDitkBCjANJUN+ABSwLhz1A=;
	b=evKC2FPFAURhEd7aDi+vXWWplFHuaBQdD7QxbqfXrUz9O66VpwvL/q01fGRc21b3Sx3t6j
	G9hTG9HGlFveVrNTzNoI6oqdK6KxqtP4MWMx4NQy8PFkiArkymkPnthGZm5pYp/AepYQ17
	EUzkAJ1T2J7fpcZ3La4DS12m73WKHso=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 022FF339C
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:29:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 79pVJhImhGrKWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2026 09:29:54 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] btrfs-progs: add detection for unexpected file extents
Date: Tue, 18 Aug 2026 18:59:30 +0930
Message-ID: <cover.1787045341.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1E91884484
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO

There is a kernel patch (*) which mentioned a corrupted fs image where
there is at least one file extent item which shouldn't exist, as the
inode is not a symlink or regular file.

It turns out btrfs check can not detect such case.

The first 3 patches introduce the ability to generate such image.

The 4th patch adds the detection ability, and the last one is the test
case.

*: https://lore.kernel.org/linux-btrfs/20260817132051.267646-1-gality369@gmail.com/


Qu Wenruo (5):
  btrfs-progs: corrupt-block: allow inode corruption to use --value
    option
  btrfs-progs: corrupt-block: allow dir item corruption to use --value
    option
  btrfs-progs: corrupt-block: allow corrupting dir item flags
  btrfs-progs: check: detect invalid file extent items
  btrfs-progs: fsck-test: add a test case for unexpected file extent
    items

 btrfs-corrupt-block.c                         |  68 ++++++++++--------
 check/main.c                                  |   5 ++
 check/mode-lowmem.c                           |  26 ++++---
 .../075-blk-inode-with-data/default.img.xz    | Bin 0 -> 2104 bytes
 .../075-blk-inode-with-data/test.sh           |  16 +++++
 5 files changed, 77 insertions(+), 38 deletions(-)
 create mode 100644 tests/fsck-tests/075-blk-inode-with-data/default.img.xz
 create mode 100755 tests/fsck-tests/075-blk-inode-with-data/test.sh

--
2.54.0

