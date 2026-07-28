Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCB1420E89
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229919; cv=none; b=IBnLNPdPEH4VFbjSxFvSRc15Tua58BZ+hfVDv1koyHHJ95v0qDIYDOX4jMRQ+aqf7BUX+vC++xwTtxYpWseDcKTjc+gRFN9HqMHhAJ88W//NLNUbOmeI9YmvU+kPb7gjHsFJLb/z7Ouq+h+BuaBeeDWopApO6OYg1PVgSjheQwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229919; c=relaxed/simple;
	bh=4PhPOcoOEFpcmC84n7iWy/lCfFNlttdi94A6UQ6mB8s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qODYYH/YAieLWz4hhg3SW3AgPcjZd0j9yHvS7KySbANPrenBMkHAS8MnwkVgkCmwpWo6aV6YQZcx0R7Yfmk7NWkbZUC+07/PEgeBTrpYY0zQFIi6Ide46aaS+iEOQP9M1c3t9b8teLKD2QAmnA1+qmc2Xj5f5GRTrZIILpOV0kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=myIBqRxP; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=qD3R/UCx; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="myIBqRxP";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="qD3R/UCx"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7040F7C0F7
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785229911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EBe6QXcalRuUxYZDGuuPJYVOy60ruQc9tUF2iQSSEao=;
	b=myIBqRxP2qfdwxA2zdYLiF9ZeqUNzed42CvWaUU6CaZk1ZMzDzvuxiZX5aYLyeDyY6r6zd
	bU6t0b/XVHgc1ZtUb6rKzeqftdQz/wTKq3B6ZBYFKCRy+dSOPVy6Ao+I2oklk1Y2AM+X++
	ds0HX/ylUjK4PXrNsSuF3xhrX//kI4c=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785229907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EBe6QXcalRuUxYZDGuuPJYVOy60ruQc9tUF2iQSSEao=;
	b=qD3R/UCxxtHxANm1TOK0Y1brOWti3dOQ+FH5FA346wVcOtnVm+BVDCfjegEaJMnt4KsAF4
	HC6np4K7eOZ0qZpk8iDE/AKoKKHNg7NT6jXxkINPDm74txhy58kg13xYm7p7OYcyjVjipn
	FLC1OaKcVA6136Zt4OafnwwRn47Dy3g=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 75C01779BC
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kOsBClJyaGpfXQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 09:11:46 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/3] btrfs: use aligned range for locking in reflink
Date: Tue, 28 Jul 2026 18:41:23 +0930
Message-ID: <884ce3562fa3f10bfdec3b490e2d9d6a0f98153b.1785229591.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785229591.git.wqu@suse.com>
References: <cover.1785229591.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

In btrfs_extent_same_range() and btrfs_clone_files(), the range passed
into btrfs_lock_extent() is not aligned at its end, because we can
reflink until the EOF, which may not be block aligned.

Although this is not a big deal, for the sake of consistency, and to
prepare for the upcoming stricter alignment check, pass an aligned range
end to btrfs_lock_extent() and btrfs_unlock_extent().

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/reflink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index ec6a760519d9..d2a4101912bd 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -687,10 +687,10 @@ static void btrfs_double_mmap_unlock(struct btrfs_inode *inode1, struct btrfs_in
 static int btrfs_extent_same_range(struct btrfs_inode *src, u64 loff, u64 len,
 				   struct btrfs_inode *dst, u64 dst_loff)
 {
-	const u64 end = dst_loff + len - 1;
 	struct extent_state *cached_state = NULL;
 	struct btrfs_fs_info *fs_info = src->root->fs_info;
 	const u32 bs = fs_info->sectorsize;
+	const u64 end = round_up(dst_loff + len, bs) - 1;
 	int ret;
 
 	/*
@@ -799,7 +799,7 @@ static noinline int btrfs_clone_files(struct file *file, struct file *file_src,
 	 * because we have already locked the inode's i_mmap_lock in exclusive
 	 * mode.
 	 */
-	end = destoff + len - 1;
+	end = round_up(destoff + len, bs) - 1;
 	btrfs_lock_extent(&inode->io_tree, destoff, end, &cached_state);
 	ret = btrfs_clone(src, inode, off, olen, len, destoff, false);
 	btrfs_unlock_extent(&inode->io_tree, destoff, end, &cached_state);
-- 
2.54.0

