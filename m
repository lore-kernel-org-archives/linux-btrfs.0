Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D583A6B6A
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791845952; cv=none; b=CnI5oWwqyzxwytvW3q1jxQhjg70sWmu4Jo/KSiJ4q5iItVMhkrmsNTNORb4keCmhro5GpENu796WTuSXaa8Elc0OwqVNNaSVWXDnKDL5vTNmbdI9lLDQxnWIqIICvbe2ptDscJSk7B7lttf0Xogo+zpV5XSUUE+j4xQJ1hHVsQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791845952; c=relaxed/simple;
	bh=scxb/KfP8PYInLv2KTPibt10iTsar2t6L2Aib16OqcQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zqm7r6p6jJIj8ojudA4xScf7gNuV3+PzutmEnFS3n0faBzqpCG4LIkjYE1Ddlp38SuzqhWXH8upfAwLZhGsbXwXHxX0wdPcsCTekHbjc6TXEOAXe2DOuMneA13fZcjreZTvn/SGeS5q7IiNdv13m+CU3IzcZhwNk1RXwYE9KoCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PD6Lj3kw; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=PD6Lj3kw; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PD6Lj3kw";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="PD6Lj3kw"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 55FB721F30
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791845949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vh9EWKNHsIZFLKSu3gTvK4tkxvJ6YHib1cgD5lb1/ec=;
	b=PD6Lj3kwSNGh7AQeNmF28U4219MREU0AiJpbJGhtaVOv6uTNA5SLOnj+pIdDLCUnV/mRNn
	noUkUU3w6m80e6DiRqpMRYuGju+bOtiv4mDurzMdMk0xpOvyWHAw+VG5Vp/7xrrSFNS9GM
	mdOBxTrlwyPeD6ypES6E6tk8/+a+sF0=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1791845949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vh9EWKNHsIZFLKSu3gTvK4tkxvJ6YHib1cgD5lb1/ec=;
	b=PD6Lj3kwSNGh7AQeNmF28U4219MREU0AiJpbJGhtaVOv6uTNA5SLOnj+pIdDLCUnV/mRNn
	noUkUU3w6m80e6DiRqpMRYuGju+bOtiv4mDurzMdMk0xpOvyWHAw+VG5Vp/7xrrSFNS9GM
	mdOBxTrlwyPeD6ypES6E6tk8/+a+sF0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4259B139B7
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nmCJOzlmzWojUQAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 12 Oct 2026 22:59:07 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: always remove quota_root from dirty_cowonly_roots
Date: Tue, 13 Oct 2026 09:28:47 +1030
Message-ID: <e71e6fcda482f306e8841292ea0031594de78577.1791845501.git.wqu@suse.com>
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
	TO_DN_NONE(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email]
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spam-Flag: NO

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

