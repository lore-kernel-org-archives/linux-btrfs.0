Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6793C1D76
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 06:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791440809; cv=none; b=q3zQiBjzVPcfHTQ+RWl+1KfaTlLkx3tlaUil5KatDJRzelw2QZN4gyrP+RiqgdCV2syV7ZWPSUnvWGNWFIPPFZak7XIbdhcaqVkUWrkSjvGu2ZcqL7lIdolGcNiAijYvFsofm37EDDBqHXM1dSpNvsQvzH1dkQxa9HofzwnPJfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791440809; c=relaxed/simple;
	bh=NXouUJ4gs9Ut12iArT87KVmXnly1zfxc3rnnXY+u1G8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCXoL9jk9TJK4n3whzrZmIYPKl3rJY/XJQL33//suW6qR5ibvuVq58Sd+TFch87pftB8E4oudQGOEWgxZHRBtNuXY+F2plB50TnF6SE4HpFTlFToPlW+aQwic3k/znYwsbtDef05mtXkNeQ8alcBYEaXrp2flP8oyiYLn/MGUHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DYp1u9ZG; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DYp1u9ZG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DYp1u9ZG";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DYp1u9ZG"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6DF051F794
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 06:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791440806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0l7c8i1mT96ub7AhQKoDoDPh+j0wUrmXcL8p6YMqw0=;
	b=DYp1u9ZG8AasTFm/jDzUkfdSlpg+z7cCGmTO9iqxzuk7AI4VUPhYkpp/yJSBcADj8cIs5+
	IVpdAaH8JLrj/CzGSSHSvtlLCNRi/iPQ3VIiplTdCMv/7JirEcPKqhOc2TGFKIM3gQwFZd
	SeQ0lYVU6ttvlnNzG0qcn8iIk3+LORI=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=DYp1u9ZG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791440806; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0l7c8i1mT96ub7AhQKoDoDPh+j0wUrmXcL8p6YMqw0=;
	b=DYp1u9ZG8AasTFm/jDzUkfdSlpg+z7cCGmTO9iqxzuk7AI4VUPhYkpp/yJSBcADj8cIs5+
	IVpdAaH8JLrj/CzGSSHSvtlLCNRi/iPQ3VIiplTdCMv/7JirEcPKqhOc2TGFKIM3gQwFZd
	SeQ0lYVU6ttvlnNzG0qcn8iIk3+LORI=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5BDAB1339F
	for <linux-btrfs@vger.kernel.org>; Thu,  8 Oct 2026 06:26:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fq1+HqE3x2q6OAAAD6G6ig:T3
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 08 Oct 2026 06:26:45 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: prevent use-after-free in btrfs_transaction::switch_commits
Date: Thu,  8 Oct 2026 16:56:22 +1030
Message-ID: <1a24290635eed5061304598d6994b41c50530678.1791439852.git.wqu@suse.com>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim]
X-Rspamd-Action: no action
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 6DF051F794

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

