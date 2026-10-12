Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A77D3B47CD
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791845954; cv=none; b=WBu5fE9Zy+6InEFq7qUS7GYRcX6pSmFo171OmsDu3fUsZS3Ol9vH49Hi9//Nu/fwi8njP+Fgi/M5LkFDtfbUSI9j1HibiKOXx0IK+mj/0NCjNoq50rWrDJnhhkb/dC6lnoD1z+Ebo6tTb/oDByzxPK6+ZVNGMdyxaZffjHnrfmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791845954; c=relaxed/simple;
	bh=p2PCjy/hhfdmyGFWTU1TUYzlxRdmwpP0K4SVlwB5/zg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxANki7DDK0bP/xQKvpNkudPmlo5Ss44N/XUtMUEzgwL189czPQO1GutKzJ3tOfIpsLV1gdUp+UsxElQ+ZF/Y+hqq0EnvtO3L6M51NNq40d8oPn8WsGhpNk06uUhGajeHFxT7ph4nzWDRyqJhWCDLCiroa9SQZDOb/kkezeWS/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZIP77s/i; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ALUVhuAz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZIP77s/i";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ALUVhuAz"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E90D91F770
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791845951; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WqPxwDTj5JML2pP9XIZjXvqq2sU5oULxyLzVcFViRmc=;
	b=ZIP77s/iwBjEZMdXovizfMYeF99OHEIImL+i7l52yPJegJ9oWuEnFS8m5hBjb2hExuXS5d
	1aRw0plSDVo2ROkktprTGH3wxc1EcfgLHbI29x4t4w7Rd756tuw775I2Yr0bqmgKsNnypV
	02mO/c+3PS79yiwhiymvalj0zzv28Xk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=ALUVhuAz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791845950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WqPxwDTj5JML2pP9XIZjXvqq2sU5oULxyLzVcFViRmc=;
	b=ALUVhuAzXjQQAcKnq5KeAAe3SpqjG1FkstxXuxkqZRCNgWCBaHFmH3wdeLwYGnzNML8KOB
	v8nUOnN1DYgBL4DsQwIbfLrsIaaHZ/oPApczQ11hqo1aIPpGa8rFUWVH5qVcvRdITFPpia
	K1XEBk6TFsKiRpfXqAaHAzRA/PaMOJk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D695613314
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nmCJOzlmzWojUQAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:09 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: cleanup dirty_cowonly_roots during btrfs_free_fs_roots()
Date: Tue, 13 Oct 2026 09:28:48 +1030
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
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Level: 
X-Rspamd-Queue-Id: E90D91F770
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

