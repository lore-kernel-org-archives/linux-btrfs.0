Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB3848E0D9
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791870110; cv=none; b=gjR8uu7UiwbdLmmCp67HJ6IIb/jGwxOKp0ZfKLDrSCKlxXM3YOWnt9M1zOfUcXkwskM1ugX4Mn05ShawurmT9lTlY0o7CcdECAuE1p4QPR9HEsdBySgVXie839qyDa0Q0MKMx1Pjj9C9bW6tcsm+aMwcYOJZTUXEbj70lkTTPZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791870110; c=relaxed/simple;
	bh=k9t9eRRJO1MhFwQnQsXvmPzrN1u2+2k5Gc5WDZz3BQ0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPghtlcJ5iUiq4C/WFl61ruqiDPwreUHoeY90df6TMMt9Go1XiChq9pFGA9w4w7H35BtOpD7IW3lFHW1o9pJD9V6ORjmNn0Too7nGcRGIdXUX6reKz+Mi98bqpk5iIMTdXXb4Wf97Otp2EAxYwBdaSNUjEY2snfo3BoOc3JmCRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=msV2uaQU; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=msV2uaQU; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="msV2uaQU";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="msV2uaQU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DE4DB1F840
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791870106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZQKvJNADI8faOi+UvY7kmNJyisl5n4DY9UZ+tvsH9w=;
	b=msV2uaQUqMiAam5p6JppGU9NjPsZJanIiG232MO9NQk+6ZJ/TH+Qnq7oa88x6H7mRfHXL7
	mgxdfATjMWU/PSPGL+5b9wB0NiqWpXanuVQyh0Y0kQUQFf/nWWZs/0Fu2MWqSgwDc3fysH
	Lr4vEqc8CG1ua9Zz6nXY9qv7C3RueSc=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=msV2uaQU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791870106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZQKvJNADI8faOi+UvY7kmNJyisl5n4DY9UZ+tvsH9w=;
	b=msV2uaQUqMiAam5p6JppGU9NjPsZJanIiG232MO9NQk+6ZJ/TH+Qnq7oa88x6H7mRfHXL7
	mgxdfATjMWU/PSPGL+5b9wB0NiqWpXanuVQyh0Y0kQUQFf/nWWZs/0Fu2MWqSgwDc3fysH
	Lr4vEqc8CG1ua9Zz6nXY9qv7C3RueSc=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA59B13460
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 78ziEpTEzWq8bgAAD6G6ig:T4
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:45 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: cleanup qgroup swapped blocks at root release
Date: Tue, 13 Oct 2026 16:11:19 +1030
Message-ID: <cad321ec81508ed69b1739cd91ff5c5408b5f1fa.1791869895.git.wqu@suse.com>
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
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
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
X-Rspamd-Queue-Id: DE4DB1F840
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

Normally btrfs_qgroup_clean_swapped_blocks() is called when switching
the commit root of a subvolume tree.

However if a transaction is aborted before all dirty subvolumes are
linked to switch_commits, those left-over dirty subvolumes won't get
their qgroup swapped blocks cleaned up.

And since a transaction is already aborted, no new transaction is
allowed to be started, thus no way to cleanup the qgroup swapped blocks
for those subvolume trees.

Fix the problem by calling btrfs_qgroup_clean_swapped_blocks() inside
btrfs_put_root() when the last ref is dropped, so that at unmount time
those left-over qgroup swapped blocks are properly released.

This fix is inspired by the recent Sashiko reports about similar cases
on cowonly roots.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 02adda065097..70c1ee40bf02 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1848,6 +1848,7 @@ void btrfs_put_root(struct btrfs_root *root)
 		if (root->anon_dev)
 			free_anon_bdev(root->anon_dev);
 		free_root_extent_buffers(root);
+		btrfs_qgroup_clean_swapped_blocks(root);
 #ifdef CONFIG_BTRFS_DEBUG
 		spin_lock(&root->fs_info->fs_roots_radix_lock);
 		list_del_init(&root->leak_list);
-- 
2.56.0

