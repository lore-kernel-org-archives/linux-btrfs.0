Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B7348EC75
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791870111; cv=none; b=c9ec1vlYHODRX3+HQqyb4X5FKJTWVo0QrY1iveppt3AurC+2iFNe1hpL8MPG85EZ6g0OSOfaktKVqyPeQmFuY0m1BYA++dwNPARgYvp/zp/72nvMCgVqzcpe142kfme/bfVhflqDtKLBoh0pNZ2598lPCcj0MZZN09dSg/7XjKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791870111; c=relaxed/simple;
	bh=WgUCbTGgJQQRpF9DbDzBRgyEMXJSsWxBqskC5yyYdRg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVoxBtl+NwLB2Zh3g2yq6g9YXqlozQQYCWEZNEOZ1kSpYdc9CnjU8C/1pBWis9z4ectHt1w2bD1JL6XEDl9cen9OF7skhk0t0PElz2dWuoJGQ3HGdtOmME1vJzF2Isdsxbz0fIzeJvSfjsUMyRQbT8ao1wXREafSVO/r8zrOa+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q06HJfr5; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Q06HJfr5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q06HJfr5";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Q06HJfr5"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7ED4921F4C
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791870108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NpulqT42igYg2t4bNlAj28Ex1WuzhO7PE6lvH/PoR+U=;
	b=Q06HJfr5l9RweyttW4knJDBCo36NXfMTBLdgYKq4ri/J1jkQ3qWYcCvBk/LChANwQK1G/a
	VcnA4t8L3+aNzvmFIeDMo4BhFesaAtZbJF8+79ie9wRJ7ot0tz5rDwrBtAMUoii8hnVdlU
	33zG5U4k+ESbiH3TEHrcBxXFzYqvkR0=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Q06HJfr5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791870108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NpulqT42igYg2t4bNlAj28Ex1WuzhO7PE6lvH/PoR+U=;
	b=Q06HJfr5l9RweyttW4knJDBCo36NXfMTBLdgYKq4ri/J1jkQ3qWYcCvBk/LChANwQK1G/a
	VcnA4t8L3+aNzvmFIeDMo4BhFesaAtZbJF8+79ie9wRJ7ot0tz5rDwrBtAMUoii8hnVdlU
	33zG5U4k+ESbiH3TEHrcBxXFzYqvkR0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6AE1013460
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 78ziEpTEzWq8bgAAD6G6ig:T5
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:47 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/3] btrfs: cleanup dirty_cowonly_roots during btrfs_free_fs_roots()
Date: Tue, 13 Oct 2026 16:11:20 +1030
Message-ID: <939508997b264d3b328d6d055a644a0f929f9280.1791869895.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1791869895.git.wqu@suse.com>
References: <cover.1791869895.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Level: 
X-Rspamd-Queue-Id: 7ED4921F4C
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

[EXISTING ERROR HANDLING QUIRK]
Sashiko mentioned an existing problem that, if btrfs_abort_transaction()
is triggered during the following call site, some roots will be attached
to dirty_cowonly_roots without being cleaned up:

 btrfs_commit_transaction()
 |- commit_cowonly_roots()
    |- list_move_tail();
    |  One root's dirty_list is moved from dirty_cowonly_roots to
    |  switch_commits.
    |  But there are still other dirty roots in dirty_cowonly_roots.
    |
    |- update_cowonly_root()
    |  |- btrfs_update_root()
    |     |- btrfs_abort_transaction()
    |
    |- return ret;

In that case, those dirty roots linked into dirty_cowonly_roots will
never be removed from that list.
As normally we require a transaction commit to move them, but since the
fs is already marked error, no new transaction can be started.

For roots that are already moved to switch_commits list, they are
cleaned up by btrfs_cleanup_one_transaction().

This is not going to cause memory leak on the btrfs_root structure
itself, as after a transaction is aborted, no one will read
dirty_cowonly_roots.

Furthermore dirty_cowonly_roots only tracks trees that are not
subvolume or log trees. They should not have root->dirty_log_pages.
And qgroup swapped blocks are going to be released during
btrfs_put_root().

Thus no memory leak from those two members either.

But we're still relying on a hidden behavior to keep us from leaking
memory.

[ENHANCEMENT]
Unlink all roots that are still linked to dirty_cowonly_roots during
btrfs_free_fs_roots(), and do one extra ASSERT() to make sure that their
dirty_log_pages are empty.

At that timing there is no other thread thus we're safe to unlink roots
without holding trans_lock.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 70c1ee40bf02..91eceb1ab4f9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1864,6 +1864,25 @@ void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info)
 	struct btrfs_root *gang[8];
 	int i;
 
+	/*
+	 * Some dirty roots may still be linked to dirty_cowonly_roots after
+	 * the transaction is aborted. Cleanup them here.
+	 */
+	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
+		struct btrfs_root *root;
+
+		root = list_first_entry(&fs_info->dirty_cowonly_roots,
+					struct btrfs_root, dirty_list);
+		list_del_init(&root->dirty_list);
+		/*
+		 * The dirty_log_pages should never be populated for
+		 * cowonly trees.
+		 */
+		spin_lock(&root->dirty_log_pages.lock);
+		ASSERT(RB_EMPTY_ROOT(&root->dirty_log_pages.state));
+		spin_unlock(&root->dirty_log_pages.lock);
+	}
+
 	while (!list_empty(&fs_info->dead_roots)) {
 		gang[0] = list_first_entry(&fs_info->dead_roots,
 					   struct btrfs_root, root_list);
-- 
2.56.0

