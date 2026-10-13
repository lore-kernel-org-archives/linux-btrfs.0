Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270E64772AC
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791870108; cv=none; b=dPWenRH8guRBNyo8yKHBwJ54zN0dQCKmZMrkpFvrh2zxEFSWfmpg4tWTMUhMjNDFFp8yu8useQOKh+hydTlQ3A4nuBaXNdCegkk7q4VA8D4GX0sJyVWv1hfn5+Ivvy1L8hOIbyUtMdK2IhCxiC90oqevKaOI34O7Ypj9WtnaFIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791870108; c=relaxed/simple;
	bh=p2PCjy/hhfdmyGFWTU1TUYzlxRdmwpP0K4SVlwB5/zg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aiuwnj+Vc1NyBzwX+c0xQZJZLF1sp+ZEAnunMqN4icmsK8KLnBr4SA3/dE2Jq7kbugSZqLHiE5aJ3mJ4h6coHYhKT+WKWTi/k45OfjVm+AcrvB9rwAqR6Vz5I5PLNaVz+KX1VEFIBNDdOUKKPsaeGv+9WdL432+8gSGMuBmCEjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=H04tyfq9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=H04tyfq9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="H04tyfq9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="H04tyfq9"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4B5151F832
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791870105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WqPxwDTj5JML2pP9XIZjXvqq2sU5oULxyLzVcFViRmc=;
	b=H04tyfq9jlV4HzMv4ct3FlbBSpc52nrRcxJrXM4idGxgtkLs/HIGIx+x1KwmCrf59crOan
	mkxwMdy2IET1cvwRhSteU392kno7Az/XtNyGNHAqvlVFteLKOwnnqoVPzd7hMDWJKx8/rQ
	YQwbv6sV+3MIRyi9CuS/GlHpnHnL//A=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791870105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WqPxwDTj5JML2pP9XIZjXvqq2sU5oULxyLzVcFViRmc=;
	b=H04tyfq9jlV4HzMv4ct3FlbBSpc52nrRcxJrXM4idGxgtkLs/HIGIx+x1KwmCrf59crOan
	mkxwMdy2IET1cvwRhSteU392kno7Az/XtNyGNHAqvlVFteLKOwnnqoVPzd7hMDWJKx8/rQ
	YQwbv6sV+3MIRyi9CuS/GlHpnHnL//A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3612813460
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 78ziEpTEzWq8bgAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: cleanup dirty_cowonly_roots during btrfs_free_fs_roots()
Date: Tue, 13 Oct 2026 16:11:18 +1030
Message-ID: <644e46d1fce8d07cb58bd411a5f478d356515602.1791845501.git.wqu@suse.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <cover.1791845501.git.wqu@suse.com>
References: <cover.1791845501.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO
Message-ID: <20261013054118.IXpDUXtC4fFuZ8C4umKxBrH0gUW6IZQcETbLRrKuaDc@z>

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
subvolume or log trees. They should not have root->dirty_log_pages
nor qgroup swapped blocks, thus no memory leak from those two members
either.

But we're still relying on a hidden behavior to keep us from leaking
memory.

[ENHANCEMENT]
Unlink all roots that are still linked to dirty_cowonly_roots during
btrfs_free_fs_roots(), and follow btrfs_cleanup_one_transaction() to
release dirty_log_pages and qgroup swapped blocks even they should be
empty.

At that timing there is no other thread thus we're safe to unlink roots
without holding trans_lock.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 02adda065097..740c8b06d008 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1863,6 +1863,20 @@ void btrfs_free_fs_roots(struct btrfs_fs_info *fs_info)
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
+		btrfs_extent_io_tree_release(&root->dirty_log_pages);
+		btrfs_qgroup_clean_swapped_blocks(root);
+	}
+
 	while (!list_empty(&fs_info->dead_roots)) {
 		gang[0] = list_first_entry(&fs_info->dead_roots,
 					   struct btrfs_root, root_list);
-- 
2.56.0

