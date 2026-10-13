Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D164C47604B
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791870107; cv=none; b=dcorUWen7741396br6w96QsYpxoE0yg8N/1wdTRqRGXbBLl5tJ3OpEDAaWuWeF/v1hGRnpocssjb7SlX5giqxVON8HLc4XwWJL6hasUlBNJ5YYGhURGqAu//G6HdMzsY0M0IdO+7daB1I5wP2bNAlR9Mv2ExaHKFBGr+ebaYep4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791870107; c=relaxed/simple;
	bh=scxb/KfP8PYInLv2KTPibt10iTsar2t6L2Aib16OqcQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSl4wLZ3/Q3N7f6oZTsyiwCM+StGV3uyYi5G8cga4UymTkw6VxlbTPAT64FgokiZ357aUSOFSmyxgmFc7Lzto/iPSpobhVdItxkLYUMhiwceZu0LAA9h+Pkji20ONJ+rD9J6xOp/NI/oSeQ061GAJoPr58NP1+bY76KsL1/k5HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Qf37l986; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Qf37l986; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Qf37l986";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Qf37l986"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B21C21FB64
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791870103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vh9EWKNHsIZFLKSu3gTvK4tkxvJ6YHib1cgD5lb1/ec=;
	b=Qf37l986kV94ZI9cHiahTnm5vUoOv1h/kQ8U2Hxw/knhTT067iN7WnIUUFd8IdY8uYGxwi
	4ypJYj+fg3CFPd9F0AiBo9kSsTmgpL2mSu1s/UOa3qklxLpkYMxlUlKMUP4LERua9Vj13O
	SecNJiiSDAEukEF4hQi8zl5MRNH/+3w=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=Qf37l986
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791870103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vh9EWKNHsIZFLKSu3gTvK4tkxvJ6YHib1cgD5lb1/ec=;
	b=Qf37l986kV94ZI9cHiahTnm5vUoOv1h/kQ8U2Hxw/knhTT067iN7WnIUUFd8IdY8uYGxwi
	4ypJYj+fg3CFPd9F0AiBo9kSsTmgpL2mSu1s/UOa3qklxLpkYMxlUlKMUP4LERua9Vj13O
	SecNJiiSDAEukEF4hQi8zl5MRNH/+3w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8DA8E13460
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 78ziEpTEzWq8bgAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2026 05:41:42 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/3] btrfs: always remove quota_root from dirty_cowonly_roots
Date: Tue, 13 Oct 2026 16:11:17 +1030
Message-ID: <e71e6fcda482f306e8841292ea0031594de78577.1791869895.git.wqu@suse.com>
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
X-Rspamd-Queue-Id: B21C21FB64
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

[ERROR HANDLING QUIRK]
When btrfs_quota_disable() failed at btrfs_clean_quota_tree() or
btrfs_del_root(), the quota_root->dirty_list is not removed from
fs_info->dirty_cowonly_roots, but the quota_root itself will be freed.

This leaves a dangling pointer in the dirty_cowonly_roots.

This is not a huge problem, as the transaction is aborted thus no one
will read the dirty_cowonly_roots for now.

Furthermore, quota_root should never be logged nor have qgroup swapped
tree blocks, thus it won't cause leaks from extent io tree nor qgroup
swapped blocks.

[ENHANCEMENT]
For the incoming cleanup of dirty_cowonly_roots during
btrfs_free_fs_roots(), any root that is still linked to
dirty_cowonly_roots will be read again, and this existing dangling
pointer is going to cause problem.

To prepare for that cleanup, move the list_del() call into the out
label, so that even if the transaction is aborted, we still unlink
quota_root from dirty_cowonly_roots before freeing it.

Assisted-by: LLM (exposing the bug during review)
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/qgroup.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index a0651fbfe778..8bd3abdf4805 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1440,10 +1440,6 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 		goto out;
 	}
 
-	spin_lock(&fs_info->trans_lock);
-	list_del(&quota_root->dirty_list);
-	spin_unlock(&fs_info->trans_lock);
-
 	btrfs_tree_lock(quota_root->node);
 	btrfs_clear_buffer_dirty(trans, quota_root->node);
 	btrfs_tree_unlock(quota_root->node);
@@ -1454,6 +1450,12 @@ int btrfs_quota_disable(struct btrfs_fs_info *fs_info)
 		btrfs_abort_transaction(trans, ret);
 
 out:
+	if (quota_root) {
+		spin_lock(&fs_info->trans_lock);
+		list_del(&quota_root->dirty_list);
+		spin_unlock(&fs_info->trans_lock);
+	}
+
 	btrfs_put_root(quota_root);
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	if (ret && trans)
-- 
2.56.0

