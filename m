Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D8E49CF23;
	Wed,  7 Oct 2026 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791380967; cv=none; b=jVVmmtgiV6RaQQT2oIiBo+U2dkXrvJ+WZIfnm8ut02TsFKl9AdRS2xmlHKG70Rka7R4Njz8rcdcxgEzaHQrp0RbmJlOdHZcIuKWHOIZxpuLA3UJ8sWIQ2IRWK5ysqh6VnjYlT7VP0uNA90/F+uKMy4r+6+P8K1WEgY8zGfabou4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791380967; c=relaxed/simple;
	bh=XDa4ymiuCGqnxnidMLd6onlZjtCD3o0Gxpdi08xPas8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mitweIqZDXFAgFnbV70NO30qYOVdSLG61o5ggxYpIxEGz4na1QGZcA/pfeXwrdFaktg0ybyek+be4/AfB5cqOBCBc7N/zbBSJYeHuUdJlhV2DEuqq3eF9gW3sPeTgeS2dQiEHKLS0DUhsASgJWlUTbNahILqDXaAHkztO1v6BdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZL+ojTNt; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZL+ojTNt; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZL+ojTNt";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZL+ojTNt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1C5CA21B78;
	Wed,  7 Oct 2026 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791380955; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3AkkdbQ4cGFuJ6BtO+d8OQk+EQwgQQMu7Mz0i41cvpI=;
	b=ZL+ojTNt8CJ27NKaGrKtYkobFqTqlLpnPqG3yBjUzDDJlHOzc4C3yGN8Lz8prAbFGbpvJc
	klf4bjYLgfM8EgTkonV9i2uyS+xWzBvJsGTWor/vGbjoxJoVlu9E1UV+Nn52x+QbtMl0u+
	LFen3R0z1P/U47a7vCZPACbnJBVGhP8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791380955; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=3AkkdbQ4cGFuJ6BtO+d8OQk+EQwgQQMu7Mz0i41cvpI=;
	b=ZL+ojTNt8CJ27NKaGrKtYkobFqTqlLpnPqG3yBjUzDDJlHOzc4C3yGN8Lz8prAbFGbpvJc
	klf4bjYLgfM8EgTkonV9i2uyS+xWzBvJsGTWor/vGbjoxJoVlu9E1UV+Nn52x+QbtMl0u+
	LFen3R0z1P/U47a7vCZPACbnJBVGhP8=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EAEBF13312;
	Wed,  7 Oct 2026 13:49:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nNi4MNpNxmpXIQAAD6G6ig
	(envelope-from <dsterba@suse.com>); Wed, 07 Oct 2026 13:49:14 +0000
From: David Sterba <dsterba@suse.com>
To: torvalds@linux-foundation.org
Cc: David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 7.3-rc7
Date: Wed,  7 Oct 2026 15:49:12 +0200
Message-ID: <cover.1791380069.git.dsterba@suse.com>
X-Mailer: git-send-email 2.55.0
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
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]

Hi,

please pull a few more fixes, mostly error handling. Half of that is for
io_uring integration with encoded read/write ioctls.

Thanks.

- fix command queuing and cleanup in encoded read/write ioctls

- fix root and transaction association to avoid unnecessary lock
  contention and transaction start

- properly handle replacing multiple xattrs in the same item

- in scrub, fix root reference leak after reporting an unresolved file
  path

----------------------------------------------------------------
The following changes since commit 72de4807ba84da485dda1a91572d66da9149e95a:

  btrfs: derive f_fsid with dev_t only when temp_fsid is active (2026-09-17 19:45:12 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git tags/for-7.3-rc6-tag

for you to fetch changes up to 41c8899d59898f6fa51ceebd2b6e55257191a8ee:

  btrfs: fix lost error return value in btrfs_listxattr() (2026-10-05 16:05:44 +0200)

----------------------------------------------------------------
Filipe Manana (3):
      btrfs: clear BTRFS_ROOT_IN_TRANS_SETUP on early exit from record_root_in_trans()
      btrfs: fix xattr replace when multiple xattrs are packed in the same item
      btrfs: fix lost error return value in btrfs_listxattr()

Wentao Liang (1):
      btrfs: scrub: fix local_root reference leak in scrub_print_warning_inode()

Yang Xiuwei (4):
      btrfs: always return -EIOCBQUEUED after btrfs_uring_read_extent_endio
      btrfs: free iov when btrfs_uring_read_extent() fails
      btrfs: unlock inode and extent in caller when io_uring read extent fails
      btrfs: don't stash io_uring encoded data across -EAGAIN

 fs/btrfs/inode.c       |  7 +++----
 fs/btrfs/ioctl.c       | 31 ++++++++++++++++---------------
 fs/btrfs/scrub.c       |  4 +++-
 fs/btrfs/transaction.c |  1 +
 fs/btrfs/xattr.c       | 15 +++++++++++----
 5 files changed, 34 insertions(+), 24 deletions(-)
