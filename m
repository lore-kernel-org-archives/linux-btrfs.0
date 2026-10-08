Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A516A1B4F0A
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 06:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440808; cv=none; b=AWPQvK6juWBIsX9k8EEHAHW/FSkuIL/ULBAR19ay9FtWxfi0PnP7xg3TmbfINoS5Fs+JnqWpfUR4A/iWH3qNcw3Bo6Prl5pJPlE6dbIYg0hNhVi1UcLaB72BwBr5XivMz5ymecppx4sF6IxW/8Y0yeXgYRft1GGkvRZ7lKhTivs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440808; c=relaxed/simple;
	bh=IObY+nO5iNMtYttGwsxOHf1el/3fg8VdA0RiWFBW2no=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6+9/+BHJY5eYP9TYW0ja0PvtX+GODB357X1sIh3om1TLxEoux7NyuXu/brplIdoNEKCb4LcN0jUuXeK1vSx0P+fohkao5+Npd5UsABLUobwZ8Z+YzoIRAtm652PQi/VPm4xifZVXiZQSnfdpiN5RH4ibCRUS8aUZUN/HML9KYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MflgRk7u; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=MflgRk7u; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MflgRk7u";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="MflgRk7u"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CE9331F788
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 06:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791440804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4F+BCpjDdtIKWej6M7mtaPIY04Oz9DW6HcNsnjTr3Ys=;
	b=MflgRk7uKLnUJaPZPPoojZHszsDayTJbs8mQTD7+VdyT0MAjkeUF8LZHc4ylU+AFffJz8T
	Jnl0MHUQLsSueZ9VP4j9xYc/qfckQz+mPA+CNEfjyuzqC2we1YwAizRPAzHhBEDFg3zCln
	n8DvEYaH69az/qnUYHkA8xJ18+MsXKA=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=MflgRk7u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791440804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4F+BCpjDdtIKWej6M7mtaPIY04Oz9DW6HcNsnjTr3Ys=;
	b=MflgRk7uKLnUJaPZPPoojZHszsDayTJbs8mQTD7+VdyT0MAjkeUF8LZHc4ylU+AFffJz8T
	Jnl0MHUQLsSueZ9VP4j9xYc/qfckQz+mPA+CNEfjyuzqC2we1YwAizRPAzHhBEDFg3zCln
	n8DvEYaH69az/qnUYHkA8xJ18+MsXKA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BAFFA1339F
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 06:26:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fq1+HqE3x2q6OAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2026 06:26:43 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: protect dirty_cowonly_roots, switch_commits and root->dirty_list
Date: Thu,  8 Oct 2026 16:56:21 +1030
Message-ID: <0c39386362f588e7ad240959f87632242b8b26c7.1791439852.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791439852.git.wqu@suse.com>
References: <cover.1791439852.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
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
	URIBL_BLOCKED(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: CE9331F788

Currently root->dirty_list is accessed with inconsistent locking.

Several call sites hold fs_info->trans_lock when modifying
root->dirty_list, including:

- add_root_to_dirty_list()
- btrfs_delete_free_space_tree()
- btrfs_quota_disable()

On the other hand there are also several call sites not holding that lock:

- switch_commit_roots()
- commit_cowonly_roots()
- btrfs_commit_transaction()

Those are also fine, because in their context they are the only
process committing the transaction.
The lock-holding callers are all holding a transaction handle, thus they
cannot race with transaction commit.

But for the sake of consistency, still hold the trans_lock for the call
sites that read and modify btrfs_root::dirty_list,
btrfs_fs_info::dirty_cowonly_roots and
btrfs_transaction::switch_commits.

And for several list_for_each_entry_safe() call sites, since we need to
unlock the trans_lock for functions that can sleep, convert them to use
"while (!list_empty()) { }" loop instead to be extra safe.

This is a preparation for an incoming UAF fix, which will move the
btrfs_root::dirty_list cleanup into btrfs_put_root().

That incoming fix will change the timing of cleanup, thus a consistent
lock scheme will help to shut Sashiko up.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/transaction.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8df7b47b09e0..03c52566d65e 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -213,7 +213,6 @@ static noinline void switch_commit_roots(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_transaction *cur_trans = trans->transaction;
 	struct btrfs_fs_info *fs_info = trans->fs_info;
-	struct btrfs_root *root, *tmp;
 
 	/*
 	 * At this point no one can be using this transaction to modify any tree
@@ -227,18 +226,27 @@ static noinline void switch_commit_roots(struct btrfs_trans_handle *trans)
 	if (test_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags))
 		fs_info->last_reloc_trans = trans->transid;
 
-	list_for_each_entry_safe(root, tmp, &cur_trans->switch_commits,
-				 dirty_list) {
+	spin_lock(&fs_info->trans_lock);
+	while (!list_empty(&cur_trans->switch_commits)) {
+		struct btrfs_root *root;
+
+		root = list_first_entry(&cur_trans->switch_commits,
+					struct btrfs_root, dirty_list);
 		list_del_init(&root->dirty_list);
+		spin_unlock(&fs_info->trans_lock);
 		free_extent_buffer(root->commit_root);
 		root->commit_root = btrfs_root_node(root);
 		btrfs_extent_io_tree_release(&root->dirty_log_pages);
 		btrfs_qgroup_clean_swapped_blocks(root);
+		spin_lock(&fs_info->trans_lock);
 	}
+	spin_unlock(&fs_info->trans_lock);
 
 	/* We can free old roots now. */
 	spin_lock(&cur_trans->dropped_roots_lock);
 	while (!list_empty(&cur_trans->dropped_roots)) {
+		struct btrfs_root *root;
+
 		root = list_first_entry(&cur_trans->dropped_roots,
 					struct btrfs_root, root_list);
 		list_del_init(&root->root_list);
@@ -1439,6 +1447,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 		return ret;
 
 again:
+	spin_lock(&fs_info->trans_lock);
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
 		struct btrfs_root *root;
 
@@ -1447,11 +1456,14 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 		clear_bit(BTRFS_ROOT_DIRTY, &root->state);
 		list_move_tail(&root->dirty_list,
 			       &trans->transaction->switch_commits);
+		spin_unlock(&fs_info->trans_lock);
 
 		ret = update_cowonly_root(trans, root);
 		if (ret)
 			return ret;
+		spin_lock(&fs_info->trans_lock);
 	}
+	spin_unlock(&fs_info->trans_lock);
 
 	/* Now flush any delayed refs generated by updating all of the roots */
 	ret = btrfs_run_delayed_refs(trans, U64_MAX);
@@ -1474,8 +1486,12 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 			return ret;
 	}
 
-	if (!list_empty(&fs_info->dirty_cowonly_roots))
+	spin_lock(&fs_info->trans_lock);
+	if (!list_empty(&fs_info->dirty_cowonly_roots)) {
+		spin_unlock(&fs_info->trans_lock);
 		goto again;
+	}
+	spin_unlock(&fs_info->trans_lock);
 
 	/* Update dev-replace pointer once everything is committed */
 	fs_info->dev_replace.committed_cursor_left =
@@ -1588,8 +1604,10 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			smp_mb__after_atomic();
 
 			if (root->commit_root != root->node) {
+				spin_lock(&fs_info->trans_lock);
 				list_add_tail(&root->dirty_list,
 					&trans->transaction->switch_commits);
+				spin_unlock(&fs_info->trans_lock);
 				btrfs_set_root_node(&root->root_item,
 						    root->node);
 			}
@@ -2578,13 +2596,17 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 
 	btrfs_set_root_node(&fs_info->tree_root->root_item,
 			    fs_info->tree_root->node);
+	spin_lock(&fs_info->trans_lock);
 	list_add_tail(&fs_info->tree_root->dirty_list,
 		      &cur_trans->switch_commits);
+	spin_unlock(&fs_info->trans_lock);
 
 	btrfs_set_root_node(&fs_info->chunk_root->root_item,
 			    fs_info->chunk_root->node);
+	spin_lock(&fs_info->trans_lock);
 	list_add_tail(&fs_info->chunk_root->dirty_list,
 		      &cur_trans->switch_commits);
+	spin_unlock(&fs_info->trans_lock);
 
 	switch_commit_roots(trans);
 
-- 
2.55.0

