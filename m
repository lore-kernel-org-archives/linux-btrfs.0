Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199F047887F;
	Sat, 12 Sep 2026 13:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220251; cv=none; b=IPEif36sbsRCpjTBGl8IgN2TA4HrsFUlF8b8WdrdWWl1VUzfKUtAYEPIyLw9gUNeoa/ms+6l9C5WqN/YGSX5iTvZ1GcjFrabhkqnLYqTiKKkWo1NBESutWMj67PIyHTesqcjbZwtQj7/F9iSbab8XnQhvj61avZOKCyT+pBA2ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220251; c=relaxed/simple;
	bh=bXK18epuhy/Ut+FltnK8DzjxT3d8D434dlLbpwfUGug=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eYRS9AjdNFSB1EiEWKw0gbjkle1Jauw0cEkSH0Lsr4Axdm8O1o5KA1O+LT5qdHnI3OjvAngCymaS3bQKrFV553QtfkqKgZOjAf3O7HsFVjuP+yZPI63vHDd0lffEuJjlKNdDfqtjj47Zei5QnwUW0EFr31FxM8lfdiXlfQvwBrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=lJ6Ckkhr; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jGjxogvb; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="lJ6Ckkhr";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jGjxogvb"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA20421CBF;
	Sat, 12 Sep 2026 13:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789220244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ztc2mLmdjkQmGOM2VPnbFKRRjLRWZ3LweQVCEFc0Iww=;
	b=lJ6CkkhroIoUFIOJ+bFoZSP6i4Xk0soD3PslZtiRJIHGEAxpT8zm/y/t9qSyrwqnH5l0nr
	LGzT8SJHJsWAqcO8fTa4G33Fua1EmDHG4oW0/rLU7ragC75qnAF1UsGl965+C2qvUQUwEx
	vnJF7GqYYD5PHdM0xVMnb0yB2o/MUaQ=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jGjxogvb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789220239; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=ztc2mLmdjkQmGOM2VPnbFKRRjLRWZ3LweQVCEFc0Iww=;
	b=jGjxogvbxGzXzs5dAQ8c/lUXNU8ncl8dDXvLPErcccFPfrdr/Nae3x9FkhQatgHSMZ3Umu
	3QZbWEGvq948RJVAqaQvmvsYpqP4Y1av3TKiQItSm7F1qCOu4ei+1dlTr66+BybbIE2t5V
	GqnQdjs/ZZy6Q1KEf7zDbqJB6guLxVU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7D35D13331;
	Sat, 12 Sep 2026 13:37:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gWEFHo9VpWrZSAAAD6G6ig
	(envelope-from <dsterba@suse.com>); Sat, 12 Sep 2026 13:37:19 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.3-rc3
Date: Sat, 12 Sep 2026 15:37:14 +0200
Message-ID: <cover.1789169569.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: CA20421CBF
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

Hi,

please pull a few small fixes. Thanks.

- tree-checker updates, validate values in b-tree item keys, other item
  length checks

- don't do unnecessary transaction commit fallback when logging parent
  directories

- in zoned mode, initialize space info of a block group early enough so
  it does not lead to NULL pointer dereference

----------------------------------------------------------------
The following changes since commit 6a7a45b1d94799a5eb8e6d26e65cf31a3fcda9e5:

  MAINTAINERS: update Chris Mason's email address (2026-09-02 22:19:30 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc2-tag

for you to fetch changes up to 09f1294ee2abee7fe1c2d600671498b7642e0fe0:

  btrfs: tree-checker: validate name length for extref items (2026-09-07 18:36:38 +0200)

----------------------------------------------------------------
Filipe Manana (4):
      btrfs: fix unnecessary transaction commit fallback from btrfs_log_all_parents()
      btrfs: tree-checker: validate key offset for inode ref keys
      btrfs: tree-checker: validate parent field for inode extref items
      btrfs: tree-checker: validate name length for extref items

Johannes Thumshirn (1):
      btrfs: set space_info before adding new free space in btrfs_make_block_group()

 fs/btrfs/block-group.c  | 20 ++++++++++++--------
 fs/btrfs/tree-checker.c | 29 +++++++++++++++++++++++++++++
 fs/btrfs/tree-log.c     | 16 ++++++++++++++++
 3 files changed, 57 insertions(+), 8 deletions(-)
