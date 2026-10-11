Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE41937F00C
	for <linux-btrfs@vger.kernel.org>; Sun, 11 Oct 2026 08:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791706952; cv=none; b=Wwp/oDfOTX8JNvKUS1FOpPKva3lYvPzY66SSUQAgfgKRaTx/hpg4cpEChi9ZS4v115ctF4J8pTKBJ6iKWdhNGF4+RmbXgRZtOkSt7WFPZ2G/KLU+Wjr99XnbfT0+F1cRN9DYtbpt3AJPQsqrSgcT2NXIQaSoPqzWp034aKeZtYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791706952; c=relaxed/simple;
	bh=rwfW5ADucOXtwh8jJKGutnypBGHcIbFniocSOMULPPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lzum8AcK3nHANYrIIhrFiuvxHr+yd9z3We1ElgN9Su+wNBV6jJMxql48p7QkDdxtZZBYU+luQXbj4M5EvzIzq4ATuj3mFIGp5E6MRElKSrkqQBiHW7hiMx0+9XhAHIkMHTDtcBmAhPv8k3CMYK4lmGLmCJpJKRelPfpQGQYqt58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tRg92z18; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=tRg92z18; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tRg92z18";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="tRg92z18"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6EC0321E43;
	Sun, 11 Oct 2026 08:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791706942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gHo1R84qTxwLgzaLPFaumiExc0oc/AZv6+CEKc4i+uk=;
	b=tRg92z18z4vv3UIA59AG72c08As1h1LTqyFsjzol8zHnt9dqOgFsRsjWUl0Ll1OmozUMSI
	iwUpYJ0kFlP6vxgtvpLIyZJ/vnWW5aylC7hS7Bx3vdfQG6Gqp32YH5eI/YI+GCZa5cGaaa
	bOIgoSq6K6Be+TMFyhFYYA5GFtU+JOk=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791706942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gHo1R84qTxwLgzaLPFaumiExc0oc/AZv6+CEKc4i+uk=;
	b=tRg92z18z4vv3UIA59AG72c08As1h1LTqyFsjzol8zHnt9dqOgFsRsjWUl0Ll1OmozUMSI
	iwUpYJ0kFlP6vxgtvpLIyZJ/vnWW5aylC7hS7Bx3vdfQG6Gqp32YH5eI/YI+GCZa5cGaaa
	bOIgoSq6K6Be+TMFyhFYYA5GFtU+JOk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA84313408;
	Sun, 11 Oct 2026 08:22:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JViNFDlHy2oHdgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>); Sun, 11 Oct 2026 08:22:20 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Boris Burkov <boris@bur.io>
Subject: [PATCH v5 1/2] btrfs: prevent use-after-free in btrfs_transaction::switch_commits
Date: Sun, 11 Oct 2026 18:51:57 +1030
Message-ID: <e0dd7f862cab85c1961d6ed38ff130c3c58ae61a.1791706855.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1791706855.git.wqu@suse.com>
References: <cover.1791706855.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[]

If a transaction is aborted during committing,
btrfs_transaction::switch_commits can be non-empty, but the
btrfs_transaction structure can be freed at the last
btrfs_put_transaction() inside cleanup_transaction().

The btrfs_root::dirty_list entry still linked into switch_commits will
point to already released memory, causing use-after-free.

Address this problem by manually deleting all entries inside
btrfs_transaction::switch_commits.

And since we're here, also release the dirty_log_pages and qgroup
swapped blocks for that root, which are only released during a
successful switch_commit_roots() call.

Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 66b054eb98c6..02adda065097 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4966,6 +4966,16 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans)
 		list_del_init(&dev->post_commit_list);
 	}
 
+	while (!list_empty(&cur_trans->switch_commits)) {
+		struct btrfs_root *root;
+
+		root = list_first_entry(&cur_trans->switch_commits,
+					struct btrfs_root, dirty_list);
+		list_del_init(&root->dirty_list);
+		btrfs_extent_io_tree_release(&root->dirty_log_pages);
+		btrfs_qgroup_clean_swapped_blocks(root);
+	}
+
 	btrfs_destroy_delayed_refs(cur_trans);
 
 	cur_trans->state = TRANS_STATE_COMMIT_START;
-- 
2.56.0

