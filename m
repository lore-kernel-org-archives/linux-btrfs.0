Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7512E6CA6
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789541566; cv=none; b=auCqmeNi0ewfYRHIEMW0XmNKQEpapc3/W6xtehfNCyllDY0HV4O9SFJ1jPoLKsmZkQKOD4WXZ3anJwKzhebZ5fB/Mkk/ZWnQ57MjISEMV16L8I0ATr6l4eFbqQS5w66tjN62qrXryBWfTFqGsM9G6Lj8BBEr3ypLfRQYdSgkXDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789541566; c=relaxed/simple;
	bh=BAuJqwJ4yurxRPx0YQ67wHVrA1BSA0CIBLSIYvqTBuA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJNQ9iIw+CcKQrnFpqgjv4He/Npq4kwmNleMgqs29x3pebKfEjz4OVq38TZUYzNKb2YHeSvaWedlgyxuTyrj/91UYTfAmzzkOr3VLBNAV3HBSg6Y5rkCKXcKnHvkmWHSVOSAmKGlVtjLg8tZjgnH7dUSj2AFgbOlePILKFMfVeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=JR/lrBlc; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=godrMoDL; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="JR/lrBlc";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="godrMoDL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 224D521C1D
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789541559; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PL7AA7YQqkSYVIAx/G4djhPLmjJ5gH9ilyjcZ481U68=;
	b=JR/lrBlcPJDwcUDbgk+7B9UXBXKCEVMP6bWKNCxGw/jjUs9S/AlbmMd79bdr+QP0j05mE4
	yrJ6EplT5IB4awvI1yLsk+4ALR8z2o0yy18QmY0Yb366f9S+4cqZwzYgr4iN7I3GawwZja
	wQW9SznZNSVaLiebm60EgmKTNsxPIh8=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1789541555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PL7AA7YQqkSYVIAx/G4djhPLmjJ5gH9ilyjcZ481U68=;
	b=godrMoDL/aD1P66CjS0RFy7QCGNaxQwFu7yQkwbyoQG201hklVEe5WtTBooh/XpOKN3P3S
	YTLY8UfTbhVVOCaScDBO88tdq8Lv7liSzNdJkqsVpqv9yEZ/bHKc0ZXxY7+CON+su77t4y
	oVhzrC42PGHhJHRxmB4vw6p7ILO2fMU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2830136D1
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ts9hJK88qmr0ZAAAD6G6ig:T2
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:33 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs-progs: restore: handle full block compressed inline extent
Date: Wed, 16 Sep 2026 16:22:03 +0930
Message-ID: <c2f4188216e7a1d6b5be4dcf85afa543455d9b74.1789541428.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789541428.git.wqu@suse.com>
References: <cover.1789541428.git.wqu@suse.com>
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
	NEURAL_HAM_SHORT(-0.20)[-0.996];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO

Since kernel commit 3eaf5f082c4c ("btrfs: extract inlined creation into a
dedicated delalloc helper"), the creation of compressed inlined extent
has changed to compress the whole block, then truncate the ram_bytes to
isize.

This means the compressed data needs to have a full block as the output
buffer.
This is fine for kernel, as the inlined extent is alwasy decompressed to
a folio which is at least one block sized.

But for progs, if the output buffer is smaller than a block, the
decompression will fail early (not enough output buffer), causing
btrfs-restore to completely skip the content of the inlined extent.

Fix it by always allocating a full block for copy_one_inline().

Issue: #1171
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 cmds/restore.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/cmds/restore.c b/cmds/restore.c
index 7d16cc99fa6a..00471b486ac6 100644
--- a/cmds/restore.c
+++ b/cmds/restore.c
@@ -298,6 +298,7 @@ static int copy_one_inline(struct btrfs_root *root, int fd,
 	char buf[4096];
 	char *outbuf;
 	u64 ram_size;
+	u64 out_buf_len;
 	ssize_t done;
 	unsigned long ptr;
 	int ret;
@@ -324,13 +325,14 @@ static int copy_one_inline(struct btrfs_root *root, int fd,
 	}
 
 	ram_size = btrfs_file_extent_ram_bytes(leaf, fi);
-	outbuf = calloc(1, ram_size);
+	out_buf_len = root->fs_info->sectorsize;
+	outbuf = malloc(out_buf_len);
 	if (!outbuf) {
 		error_mem(NULL);
 		return -ENOMEM;
 	}
 
-	ret = decompress(root, buf, outbuf, inline_item_len, &ram_size,
+	ret = decompress(root, buf, outbuf, inline_item_len, &out_buf_len,
 			 compress);
 	if (ret) {
 		free(outbuf);
-- 
2.55.0

