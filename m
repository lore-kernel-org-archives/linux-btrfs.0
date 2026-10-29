Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267201;
	b=qi8hFiNvBg+CCOW7s+Dhw5TUwi9ouQy2vLmQA1eVgdJtJgvD/C8gwaWDCzIBjTpse12u
	 q7CGzAg8/4g1zpiNEoH19jwugpqwI2xFsbL7th7/XuihKwb9hoSJtdCj5jakSFua+YR/c
	 vCtYfO2AZ8jCPR06QKcobGJ2KSqASRqY0XfY/1VshzZjZ3DljANlN4Zmd7W8RoKQy92rH
	 XTkTfyy8TY4bSlzxU5sQ2sIULIakAcCxk1/BvygYCFVdT2x5JH8d37smqxi9Jg8MqxzPf
	 wS6JnNkBcaz9ymHdYkVFp7uPm/7DyQgaTTCUURMNeq5jg0ggfCrYxI+c7TcBeIbL3eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267201;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:Received:
	 Received:From:To:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-Spamd-Result:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=iVjiOj6sGitQ8h87jP5tPRnlg68XSiGs4R7B4Stduoc=;
	b=pfvk8HTJ/fkw/lUYZSR/FyZYAXKivRWpO3l8kUrpVFtqZ/EZLd4ZOU3JwD4nQX3/S3pO
	 q0Emk7MqrSlMVwABnx3TM8Zc2EBjqyxjg6Uj8WCHU92+jsIAwIef2SCmwCP52x4052R+i
	 jFpXZiYSV6oS5GYcuj89ngqqKprW1A6I37Z8fWQNtVXSubiNMWdItqWx2meOM2jqnHqG9
	 IQpg7f8inikjlzMPJ5S9CjinydCVqR7QKjMctoP9H60/Pvjf+zZlNjsmnQ6F5+k8RvQoh
	 kDCSGnk8tNoNmg3b3qlFfXOJsqISU32Y00JAxx4/qtXcldn2lwIPMxQo7P/eTXiofrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="ETX13Y/W";
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b="ETX13Y/W";
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12982606A31A
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12982606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ETX13Y/W;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=ETX13Y/W
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F19F21F6D
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793267199; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iVjiOj6sGitQ8h87jP5tPRnlg68XSiGs4R7B4Stduoc=;
	b=ETX13Y/WUQWei7tsE8jBqL/XFDb9GChJ041NlY8ZlZ3/pFGmz/wd91eYDu3XfTIixpiDVC
	0ZUqupuO2YMXIG/uUsJauM9MzrIZs2jnOsk54e2A9VBzpBGm95cbEEvLH0crenu4OamjUC
	xrcon1zeqoA7DiFxbxqUlEPDf1m7gGM=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="ETX13Y/W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1793267199; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=iVjiOj6sGitQ8h87jP5tPRnlg68XSiGs4R7B4Stduoc=;
	b=ETX13Y/WUQWei7tsE8jBqL/XFDb9GChJ041NlY8ZlZ3/pFGmz/wd91eYDu3XfTIixpiDVC
	0ZUqupuO2YMXIG/uUsJauM9MzrIZs2jnOsk54e2A9VBzpBGm95cbEEvLH0crenu4OamjUC
	xrcon1zeqoA7DiFxbxqUlEPDf1m7gGM=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0036D13419
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fpy8FP0V42o+FwAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 09:46:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/5] btrfs-progs: btrfs path leak fix, part 1
Date: Thu, 29 Oct 2026 20:16:10 +1030
Message-ID: <cover.1793266694.git.wqu@suse.com>
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
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 1F19F21F6D

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

 btrfs-corrupt-block.c         | 34 ++++++++-----
 configure.ac                  | 15 ++++++
 include/compiler_attributes.h | 39 +++++++++++++++
 include/kerncompat.h          |  7 +--
 kernel-lib/overflow.h         |  8 +---
 kernel-shared/cleanup.h       | 89 +++++++++++++++++++++++++++++++++++
 kernel-shared/ctree.h         | 10 ++++
 kernel-shared/extent-tree.c   |  4 +-
 kernel-shared/volumes.c       | 55 +++++-----------------
 9 files changed, 193 insertions(+), 68 deletions(-)
 create mode 100644 include/compiler_attributes.h
 create mode 100644 kernel-shared/cleanup.h

--
2.56.0

