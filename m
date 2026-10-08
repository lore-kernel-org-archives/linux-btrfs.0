Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A4637F8B3
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 06:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440807; cv=none; b=TfgxchVQlOCWEoApKRuqqHBPnZVMGEltzssdI+JttsCefdU0SMG6lhk/zg9PVQsE9NuvNwRzhB7dBIS2hetX+umRbMfVWRkbaGxhVHPbRyCfGNRagE/4Kchgj/EtcWoWrAPwyGQN6K8Bc2v6ZyvN0BRJpu2YR/sYGMlE0JZBY8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440807; c=relaxed/simple;
	bh=rFVHXE/asmoDFm5GfyhlAnTdbRFJexKCylAnqRJMafU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=cF+LlFjvrx1uT/MIGoQAL+Nx1/LgvQ1HskenuLSmLYWiRLiA8dRnDI58o/KQFu5O/zb3V0M5IZJ6nX4HaXfpLVLR4PFijzLP5Hg1Np3knwYVik1pqgG04QezwEpGuoF1Hp7luFqKzztrVny8KbAjG2AEGu/1aX49C3gMqFXIIXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=la/5D1co; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=la/5D1co; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="la/5D1co";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="la/5D1co"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6991E1F43B
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 06:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791440803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9EwgmurdD6ObwuUlEZxrPAL7DTvIDWCVmILF3+6BsN0=;
	b=la/5D1coKCDbNpImPCFTbUdsa4O6yIm9JOmDlnKtxjO8crjQ1/KagyinTi1z5iPYfNEM2D
	kwS3a08a23YucYUTr0zXBS/oGThv9yduGqmJMEK6jm6/sLmvat9oeSxws0aYjiZDYS290E
	a9ey2WJV99n54k1CTOlSna07GdiId00=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b="la/5D1co"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791440803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=9EwgmurdD6ObwuUlEZxrPAL7DTvIDWCVmILF3+6BsN0=;
	b=la/5D1coKCDbNpImPCFTbUdsa4O6yIm9JOmDlnKtxjO8crjQ1/KagyinTi1z5iPYfNEM2D
	kwS3a08a23YucYUTr0zXBS/oGThv9yduGqmJMEK6jm6/sLmvat9oeSxws0aYjiZDYS290E
	a9ey2WJV99n54k1CTOlSna07GdiId00=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 266C11339F
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 06:26:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fq1+HqE3x2q6OAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2026 06:26:41 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 0/3] btrfs: fix a UAF where btrfs_root::dirty_list is freed but still referred
Date: Thu,  8 Oct 2026 16:56:20 +1030
Message-ID: <cover.1791439852.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 6991E1F43B
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo]

The first patch is to make lock consistent when accessing
btrfs_root::dirty_list, btrfs_fs_info::dirty_cowonly_roots and
btrfs_transaction::switch_commits.

Normally it's not a big deal as the existing lock-holding callers are
also holding a trans handle, thus they can not race with transaction
committing.
But the last commit will change the cleanup timing, and Sashiko is not
happy with that, so make it more consistent and shut Sashiko up.

The second patch is an existing bug exposed by Sashiko, which also
affects the last UAF fix.

The last one is the final UAF fix for the bug reported by syzbot.

Qu Wenruo (3):
  btrfs: protect dirty_cowonly_roots, switch_commits and
    root->dirty_list
  btrfs: prevent use-after-free in btrfs_transaction::switch_commits
  btrfs: unlink btrfs_root::dirty_list during btrfs_put_root()

 fs/btrfs/disk-io.c         | 20 ++++++++++++++++++--
 fs/btrfs/free-space-tree.c |  4 ----
 fs/btrfs/qgroup.c          |  4 ----
 fs/btrfs/transaction.c     | 30 ++++++++++++++++++++++++++----
 4 files changed, 44 insertions(+), 14 deletions(-)

-- 
2.55.0

