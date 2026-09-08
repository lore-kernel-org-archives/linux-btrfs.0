Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52113394785
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788851778; cv=none; b=qKYFqgLfX28MHTm/6ZJIdp6iW4d17lfbH3ifUBJuwzu+tEvYVeKhPOIevSdxhYyfIrMqkzFt20jEJATTBeN08YpVXqqXm2y504BnclqFqBES2+HyQHb0zYjV7hK5Q/E/jQMyztkuVv1NE8tYPoVruhJx3EmGPbylVDA0IGuCw4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788851778; c=relaxed/simple;
	bh=xsJcDcV5S5imDmGjUzR+av+scH7NBr53jSfd4OCiYeY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8WN/PdL51i/AxY9Au++TU7fODq/zFNCv9K7wAMrqZubwghblxmx7XTO77khKNX+q/GiDQT+DdymJb4upP/7bUXg4AtTVyRaDeWReOM2mGl0ZHaEka2TPs1ZZ7TmSUo2qjRYdlfctmKm0gDoqY4OH/UdE5D/z7AzNAFkcyymvao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NQAQQQkp; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mijnvmzh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NQAQQQkp";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mijnvmzh"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1A30F1F789
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788851770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fz3K6z4jfzHhM+Qeo9RPOPtSwFpbnHfflXqK+PJRn0s=;
	b=NQAQQQkpBjzRBjSLtlz67oufLdMvzgZGpAhPuVTCLzWRmEmo8vjoc+Zk0S6R4vtfuNae/V
	1cHUj9ozK39eK7GXGG7XgdVckjiPzL42Be+NnOyEcuGTDRSl28yuHpF0lzaoQdaMn9XY5x
	9MheumcmzdsDWDUI4NfMWz/+QJUhrgo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788851766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fz3K6z4jfzHhM+Qeo9RPOPtSwFpbnHfflXqK+PJRn0s=;
	b=mijnvmzhtg1Mr8zDeGZIG2KjX1pvF/H9h7PlvShn6iCaDMORFatWSRYwOh7BbMKVtpFAqw
	/f+VB23adDd8X0ohTH5n5oYgr0+d82ku3H2LI57YGLn7mfGlcghj4JdVBXZ6lrdxLPs4hP
	q+4uzJAQMtHqjuezSF+YvM0YSPpQHYw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7CF913786
	for <linux-btrfs@vger.kernel.org>; Tue,  8 Sep 2026 07:16:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CKh5ITS2n2qWVAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Tue, 08 Sep 2026 07:16:04 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/3] btrfs: use kvmalloc() to allocate compression workspace buffer
Date: Tue,  8 Sep 2026 16:45:41 +0930
Message-ID: <6feca601145a668a4d1365003bd390270706ea92.1788851649.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788851649.git.wqu@suse.com>
References: <cover.1788851649.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -2.80
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.997];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

With the experimental bs > ps support, the workspace buffer for both
zlib and zstd can be as large as 64K, and on 4K page sized systems such
kmalloc() calls have a much higher chance to fail, as that requires
physically contiguous memory to fulfill such allocation.

The same also applies to S390's hardware accelerated path, which
requires a buffer size of 4 pages.

Meanwhile lzo is already using kvmalloc() for its buffer, and there is
no special requirement for any physically contiguous memory anyway.

So change the zlib and zstd workspace buffer allocation to use
kvmalloc() to reduce the chance of memory allocation failure.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/zlib.c | 10 +++++-----
 fs/btrfs/zstd.c |  4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
index 486b52db583e..e995d0b1452b 100644
--- a/fs/btrfs/zlib.c
+++ b/fs/btrfs/zlib.c
@@ -49,7 +49,7 @@ void zlib_free_workspace(struct list_head *ws)
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 
 	kvfree(workspace->strm.workspace);
-	kfree(workspace->buf);
+	kvfree(workspace->buf);
 	kfree(workspace);
 }
 
@@ -84,13 +84,13 @@ struct list_head *zlib_alloc_workspace(struct btrfs_fs_info *fs_info, unsigned i
 	workspace->level = level;
 	workspace->buf = NULL;
 	if (need_special_buffer(fs_info)) {
-		workspace->buf = kmalloc(ZLIB_DFLTCC_BUF_SIZE,
-					 __GFP_NOMEMALLOC | __GFP_NORETRY |
-					 __GFP_NOWARN | GFP_NOIO);
+		workspace->buf = kvmalloc(ZLIB_DFLTCC_BUF_SIZE,
+					  __GFP_NOMEMALLOC | __GFP_NORETRY |
+					  __GFP_NOWARN | GFP_NOIO);
 		workspace->buf_size = ZLIB_DFLTCC_BUF_SIZE;
 	}
 	if (!workspace->buf) {
-		workspace->buf = kmalloc(fs_info->sectorsize, GFP_KERNEL);
+		workspace->buf = kvmalloc(fs_info->sectorsize, GFP_KERNEL);
 		workspace->buf_size = fs_info->sectorsize;
 	}
 	if (!workspace->strm.workspace || !workspace->buf)
diff --git a/fs/btrfs/zstd.c b/fs/btrfs/zstd.c
index 280ac5273438..cc92d0b1b948 100644
--- a/fs/btrfs/zstd.c
+++ b/fs/btrfs/zstd.c
@@ -373,7 +373,7 @@ void zstd_free_workspace(struct list_head *ws)
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
 
 	kvfree(workspace->mem);
-	kfree(workspace->buf);
+	kvfree(workspace->buf);
 	kfree(workspace);
 }
 
@@ -391,7 +391,7 @@ struct list_head *zstd_alloc_workspace(struct btrfs_fs_info *fs_info, int level)
 	workspace->req_level = level;
 	workspace->last_used = jiffies;
 	workspace->mem = kvmalloc(workspace->size, GFP_KERNEL | __GFP_NOWARN);
-	workspace->buf = kmalloc(fs_info->sectorsize, GFP_KERNEL);
+	workspace->buf = kvmalloc(fs_info->sectorsize, GFP_KERNEL);
 	if (!workspace->mem || !workspace->buf)
 		goto fail;
 
-- 
2.55.0

