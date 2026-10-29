Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793268312;
	b=uVXC4FnCM/G513/iK2BRkRnqcZg70uTLphPTde8Kuj8HXZSNfqChynUlESpZI9PQA1OO
	 V3vZhYUhqjej3pYjyy876csy9d1LWguIuMpIeNlcFH6rNVnaJd8DSDOd2aYHPvsczV9QQ
	 WNQFVvpz5TQl2hu34YwvUdl8OcmomFL8uvXlmG6gnsQQsI2wg+LJKjdTdcd+7EXFtNS0d
	 gAze09zOunXoZAEmhv/jiPxMW7vv+QhTI2FB8bPYLtkSPMQRhkUr5/CQ98b99omETnMg+
	 r8SeaS7xYFZtsKYfyLBDARchOU1enVjZRT2javCCNZi/mgpUKpJ2b61Ln/010e06Q/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793268312;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=R1iONANSsRC1lfDXURj7pMSmInFvRBIXP0yrjBhQzNA=;
	b=tDF44mlTzV9euthihla6VqvvGs/mlFXOuoh0hNhVKgU7hMJBz9lCMVfM2IwlYV18v2X9
	 6BFVSJUwvsrkkJfv5QvsfBmFwYcZ+Hes36EdsINoVpdVW+K+zY5/m6ETZuuww6ixEgAWG
	 iskhP7j42ponLlAJTmsh/F1/UNhwFWqnAmehi5rujKebu+Bks1FO0KIn18tRt8lDXdgaW
	 tNZjMiSjuk/96NFOTd+n2xeiBJxo4q0XLcBvI/mmLL3DwvOEXS4gc62sDeuLML6DuzXal
	 axPyLJ3D2qrdCbkua8ioLrg86o+/TnVuvLCgES4gF+fsCKziURofpCMuEyej7abrDiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gfBTmqoF;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gfBTmqoF;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5768F606A326
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5768F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gfBTmqoF;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=gfBTmqoF
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6488D1FB0E
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793268309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=R1iONANSsRC1lfDXURj7pMSmInFvRBIXP0yrjBhQzNA=;
	b=gfBTmqoF6FHn8mKj2k6yHo2rlY6uWTVOUFxNNd7guyg/4mBNtMD/Q09bahgS+3K2wlnrIM
	dE9g5fjl1XhgUiGFP/ueEPCT+h0q+C7Jasllr74cdLoVpAqpv6nJnM8Q0u3fE4CT9UQtRl
	3Tv6UuT2Tmgyxr0HuZuciu1V5QgIQR0=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=gfBTmqoF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793268309; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=R1iONANSsRC1lfDXURj7pMSmInFvRBIXP0yrjBhQzNA=;
	b=gfBTmqoF6FHn8mKj2k6yHo2rlY6uWTVOUFxNNd7guyg/4mBNtMD/Q09bahgS+3K2wlnrIM
	dE9g5fjl1XhgUiGFP/ueEPCT+h0q+C7Jasllr74cdLoVpAqpv6nJnM8Q0u3fE4CT9UQtRl
	3Tv6UuT2Tmgyxr0HuZuciu1V5QgIQR0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4950813419
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 380rJ1Ma42qwKgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 10:05:07 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/5] btrfs-progs: btrfs path leak fix, part 1
Date: Thu, 29 Oct 2026 20:34:36 +1030
Message-ID: <cover.1793268211.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: 6488D1FB0E
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Score: -12.01

[CHANGELOG]
v2:
- Drop unused cleanup functions
  Those functions uses "auto" attribute, which we didn't define.

  Considering we don't use them yet, just remove them.

To avoid future LLM script kiddos, we need to fix path leaks.

This is part 1, focusing on leaks on btrfs_alloc_path().

The most important part is the second patch, which introduces
BTRFS_PATH_AUTO_(FREE|RELEASE), so that we can finally get the same
capability.

Unfortunately this will require the compiler support for the __cleanup__
attribute. If not supported, configure will reject the build.

Then several fixes using BTRFS_PATH_AUTO_FREE().

The last one has several other small fixes batched together, as they are
all inside the same btrfs-corrupt-block.

Part 2 will focus on the on-stack paths, which can still leak the ebs,
and are the most common sites in btrfs-progs.


Qu Wenruo (5):
  btrfs-progs: introduce compiler_attributes.h
  btrfs-progs: utilize __cleanup__ attribute for btrfs_path
  btrfs-progs: sync btrfs_translate_remap() to fix a path leak
  btrfs-progs: fix a path leak in alloc_reserved_tree_block()
  btrfs-progs: fix several memory bugs in btrfs-corrupt-block

 btrfs-corrupt-block.c         | 34 +++++++++++++++-------
 configure.ac                  | 15 ++++++++++
 include/compiler_attributes.h | 39 +++++++++++++++++++++++++
 include/kerncompat.h          |  7 +----
 kernel-lib/overflow.h         |  8 +----
 kernel-shared/cleanup.h       | 31 ++++++++++++++++++++
 kernel-shared/ctree.h         | 10 +++++++
 kernel-shared/extent-tree.c   |  4 +--
 kernel-shared/volumes.c       | 55 +++++++++--------------------------
 9 files changed, 135 insertions(+), 68 deletions(-)
 create mode 100644 include/compiler_attributes.h
 create mode 100644 kernel-shared/cleanup.h

--
2.56.0

