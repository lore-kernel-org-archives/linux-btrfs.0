Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E8E3B0AE4
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 22:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791497646; cv=none; b=ekMyPClnPfp5RaGWRwROW+DLvS7AruDeTQzMmBZr7/iOowju8fOg9e8GUpoWtGWYtLphK6NCaiIC9o6Yhufxq0gbohT11gYb7jgJvw0McDZx4w6EG5aEtQeTCJmnDcBDhkr7cr+y04iWn+URRmmwKL9vPYCeq9ZqrEXHoqB49Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791497646; c=relaxed/simple;
	bh=UMnM6mu4SXycSyFQAxO9fKQm+yZhRI+l8N7xQDuIs/w=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lmu2lzvEl8/KhvGhCooiHKYt31Te8rsy/i+cgaGkHqi9QA0Xnxwhzqp6Jk92fuYUwGhnwM+VipCf1HvIb0/ENhlWZHXR+XjwVRi8ErHomj9OZWxbwsuGHZ13/Ak/esjmY9PJYdYbhIuZ1zao0d1VaizYSFXANcuwytp9FUgFYkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 12F9121C89
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 22:14:03 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F30A713354
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 22:14:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oyywBqYVyGrLMQAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2026 22:14:01 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v4 2/3] btrfs: prevent use-after-free in btrfs_transaction::switch_commits
Date: Fri,  9 Oct 2026 08:43:39 +1030
Message-ID: <39a88e84c0b516f9e8f923b112b4448f2709ecbc.1791497576.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791497576.git.wqu@suse.com>
References: <cover.1791497576.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spamd-Result: default: False [0.00 / 50.00]
X-Spam-Score: 0.00

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

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 66b054eb98c6..3f8ed5732c11 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4966,6 +4966,20 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans)
 		list_del_init(&dev->post_commit_list);
 	}
 
+	spin_lock(&fs_info->trans_lock);
+	while (!list_empty(&cur_trans->switch_commits)) {
+		struct btrfs_root *root;
+
+		root = list_first_entry(&cur_trans->switch_commits,
+					struct btrfs_root, dirty_list);
+		list_del_init(&root->dirty_list);
+		spin_unlock(&fs_info->trans_lock);
+		btrfs_extent_io_tree_release(&root->dirty_log_pages);
+		btrfs_qgroup_clean_swapped_blocks(root);
+		spin_lock(&fs_info->trans_lock);
+	}
+	spin_unlock(&fs_info->trans_lock);
+
 	btrfs_destroy_delayed_refs(cur_trans);
 
 	cur_trans->state = TRANS_STATE_COMMIT_START;
-- 
2.55.0

