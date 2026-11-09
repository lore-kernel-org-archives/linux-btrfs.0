Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794197431;
	b=XKeQ5uXYOWgMYAfDjb3nsU5RjtyyezHwss1ExisHttVWeckGM8hA0url4ytgbu67eB2/
	 7KdJTbRzfdhO9MPFh4g6Q/3YvY6k4QU5os5FVWgdpmgsthBGelyFX649oy1c/HcrYwJyF
	 0rFH+gSl0Mw+kTbWTLwkplDAmz+XZqt2TEVfiNynR9xXAniax21bUDZf96HkXGOXiDmUf
	 vRHAihhfjPQvmFhvbxnAgdST8bJkJseh5gY3n7M8rHOXh/tRVCjSXz+V3uy1nj0/s7DJV
	 MVWZjjRI4VpkF3bj0K2TUo/yyIg2PzQN1RrElVRN+6sqDf2EcraBgbXBe9I9w9c/xtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794197431;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=yeKSsEtHP1h32L3M9eozwVH2D3Eh8Dhv9VRYZ5mqav0=;
	b=kfpLBtz+ComaXUpuhIfeiPDWDzKQ09Oo6lX+4VWOecSDdGjbOODggLkbMegTYyP1J1nY
	 rX165P8dgrGdo2+j7m9H0wZnJVtDyQ+XrJCeKbR6ZhR9LQl2dXWjb83SHJG5Nda1gQ/jj
	 HbbwVT6MurhGldgf6qtpTcIB/Ojxcc3mt+TEdQ1EFOlfLzJtp0jDqwQMMQyQpLvNQFWfD
	 0XE3l2+1eICNy39ar0KqOwstNnieAYofOjnqgvaRr26lPXmA85ftJmx8xz32VbeRTx6Z2
	 A5p3OnBY68cukGZAubEmKXR10I1YQZevqia41hs+ymkuybhXRC5RUxhHVIZGGAIEeDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RrW6bUEN;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=sL3aQAaq;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F16606A332
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59F16606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=RrW6bUEN;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=sL3aQAaq
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B2B401F82A
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yeKSsEtHP1h32L3M9eozwVH2D3Eh8Dhv9VRYZ5mqav0=;
	b=RrW6bUENqBEeRhRupl/HKd1w/DoGayZXdlR6617Aztzk0OfJCCFD3giTIOlCVmZIk8ZrJm
	emA+AJytQaaschSYOqsxlv9dr9OqMCc5Lx7T36UxgJaT9ZqVW/NiHznUsUJ5X9jAYHlZqs
	Xzc1LLif24Yo18ifhE3QqTNz43tWRbE=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=sL3aQAaq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1794197421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yeKSsEtHP1h32L3M9eozwVH2D3Eh8Dhv9VRYZ5mqav0=;
	b=sL3aQAaq/930DAY9trgo5jQGcMHavQ06pOaz/AlLxiTriq4vWB1iU6xdmH+r/Ye1Mc7KnA
	GDjj2oC5MNfWYdTEXqrvrks+GiAYywWcRKLqcz4REj23URSGUCeTCz72PHmIrhicSZz8wl
	m0pYJDe9c+ISNURWpH9YPcxDnYCl0Fk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9139413319
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Nov 2026 04:10:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AKhEN6tH8WrIZAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 09 Nov 2026 04:10:20 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/7] btrfs-progs: crypto: cleanup and prepare for new architectures
Date: Mon,  9 Nov 2026 14:39:54 +1030
Message-ID: <cover.1794196688.git.wqu@suse.com>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-12.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,configure.ac:url,suse.com:dkim];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.51
X-Spam-Level: 
X-Rspamd-Queue-Id: B2B401F82A

[CHANGELOG]
v2:
- Introduce new cleanups as a preparation for new architectures
- Enhance hash-*test to bring more coverage

The patchset is split into 3 mostly independent parts:

- ASM cleanup
  Patch 1 and 2.
  To remove existing inlined or dedicated ASM file usages.
  Use compiler wrappers instead, and port an existing ASM file for
  pclmul optimization to pure C with compiler wrappers.

- Minor rename and cleanups for new architecture
  Patch 3 ~ 5.

- Enhance existing hash-*test
  Patch 6 and 7.

  To bring more block sizes.

Qu Wenruo (7):
  btrfs-progs: cleanup inline asm usage
  btrfs-progs: crypto/crc32c: port crc32c-pcl optimization to C
  btrfs-progs: rename cpu features to prepare for other archs
  btrfs-progs: simplify the cpu utils for future expanasion
  btrfs-progs: crypto: select accelerated algo directly for testing
  btrfs-progs: crypto: hash-speedtest: cover more block sizes
  btrfs-progs: crypto: hash-vectest: cover more block sizes

 .gitignore                       |   1 +
 Makefile                         |  14 --
 common/cpu-utils.c               | 104 +++------
 common/cpu-utils.h               |  19 +-
 config/ax_gcc_builtin.m4         |   1 +
 configure.ac                     |   1 +
 crypto/blake2.h                  |   2 +
 crypto/blake2b-ref.c             |  30 ++-
 crypto/crc32c-pcl-intel-asm_64.S | 370 -------------------------------
 crypto/crc32c.c                  | 320 +++++++++++++++++++++++---
 crypto/crc32c.h                  |   2 +
 crypto/hash-speedtest.c          | 179 ++++++++-------
 crypto/hash-vectest.c            | 212 ++++++++++++++++--
 crypto/hash.c                    |   9 +
 crypto/hash.h                    |   2 +
 crypto/sha.h                     |   2 +
 crypto/sha224-256.c              |  18 +-
 libbtrfs/crc32c.c                |  43 +---
 18 files changed, 676 insertions(+), 653 deletions(-)
 delete mode 100644 crypto/crc32c-pcl-intel-asm_64.S

--
2.56.0

