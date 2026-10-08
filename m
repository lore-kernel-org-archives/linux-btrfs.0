Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B293E40F1
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 21:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791495920; cv=none; b=Lpz7DqvJDcnI+2PD3D+rI+wRV+g2hj9M9rVsYvu1ZOwjfq/3t5ev0/kWYOi5dX4mZhkg7wpm0T/Sp3bblamdWWNVJN2yinlDwCbuL5VENfH8bDu1UDvJuTxUvFu6b7e1v52yYaHGCUOcLyMmTO9U0ZokovNTud4+l2XG+NqtxNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791495920; c=relaxed/simple;
	bh=NXouUJ4gs9Ut12iArT87KVmXnly1zfxc3rnnXY+u1G8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag980joOBpS8hmxYia41g/ksCSa3sW3NOIsn66iYzj/yUbS60MqUjz/BEGDW4HfPuM2kPHexcS2slfZHkGDSJb8xX/UjKBDfQ/mzzngx+iHjp6Mm+f4vamfjfcXkIcTwCBeBAndin08csMxfy2DbM/1YUVt7YU9jwGH1gVkd9Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 620591F7E4
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 21:45:17 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4847913354
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 21:45:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wNpSEegOyGpBFQAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2026 21:45:15 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 2/3] btrfs: prevent use-after-free in btrfs_transaction::switch_commits
Date: Fri,  9 Oct 2026 08:14:49 +1030
Message-ID: <1a24290635eed5061304598d6994b41c50530678.1791495862.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1791495862.git.wqu@suse.com>
References: <cover.1791495862.git.wqu@suse.com>
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
X-Spam-Score: 0.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=Unknown lua;
	unknown reason
X-Spamd-Result: default: False [0.00 / 50.00]

If a transaction is aborted during committing,
btrfs_transaction::switch_commits can be non-empty, but the
btrfs_transaction structure can be freed at the last
btrfs_put_transaction() inside cleanup_transaction().

The btrfs_root::dirty_list entry still linked into switch_commits will
point to already released memory, causing use-after-free.

Address this problem by manually deleting all entries inside
btrfs_transaction::switch_commits.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 66b054eb98c6..757db0c363b0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4966,6 +4966,16 @@ void btrfs_cleanup_one_transaction(struct btrfs_transaction *cur_trans)
 		list_del_init(&dev->post_commit_list);
 	}
 
+	spin_lock(&fs_info->trans_lock);
+	while (!list_empty(&cur_trans->switch_commits)) {
+		struct btrfs_root *root;
+
+		root = list_first_entry(&cur_trans->switch_commits,
+					struct btrfs_root, dirty_list);
+		list_del_init(&root->dirty_list);
+	}
+	spin_unlock(&fs_info->trans_lock);
+
 	btrfs_destroy_delayed_refs(cur_trans);
 
 	cur_trans->state = TRANS_STATE_COMMIT_START;
-- 
2.55.0

