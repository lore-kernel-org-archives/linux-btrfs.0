Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A173DA5B2
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 09:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782725187; cv=none; b=IVZJdG0H8xpA/kF4JCahuCtCwyYmZ292P+qj8iea0YjT4hnD8nB8VY0AqYVXF/V4NjkMaiQkzDxAXCQ7UCeYHImCfnWglvN7ReD5QzX83f3BAAVf8twnRmcTbt/e8t6Kfq8NBGR7AiyedN460soONL31mmqc0Qg/HmA0ly/Y6UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782725187; c=relaxed/simple;
	bh=6ORF9l+1dayDThXN6kKckQ6gcol2TZ2IgpAwd+r5Xw0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr/HvIe8YkdxO0x1QKbYXUFqkpJyxkRBxcs1TN7OoCJW4WCT1Pi3WQZmW6xNirOvXUi1WWuGigpA4zSTSOZfOaDzLeNoy+Mif9occxqGhHdZEP7nxQtmaNumPToWrCtLdgm1Q4klG0mZ/vjWv/KV0rulKHfbzabfj+11wCp7J/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SkNIoHO7; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SkNIoHO7; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SkNIoHO7";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SkNIoHO7"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D711F72FC8
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 09:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782725178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XO5+ybZZVqoVb3/AJKWj+Y7UAaUrYcKQxSPlK8ClpiU=;
	b=SkNIoHO71FRedau+L5RvzSPBVOgJQXZaBVALK9hwErmXtjuA0y60Z9rMH5oZdABgdmiRt6
	78Pdnz6E/r6HOjGBp8a/Rp3FSXiATLAJMc0nTlXlgtRYhLbOClQKTbq+Rka6gmbZ2vIJfg
	C4aE/lylNaVdkbWCtJ+XuVs0UQYdat0=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=SkNIoHO7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782725178; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XO5+ybZZVqoVb3/AJKWj+Y7UAaUrYcKQxSPlK8ClpiU=;
	b=SkNIoHO71FRedau+L5RvzSPBVOgJQXZaBVALK9hwErmXtjuA0y60Z9rMH5oZdABgdmiRt6
	78Pdnz6E/r6HOjGBp8a/Rp3FSXiATLAJMc0nTlXlgtRYhLbOClQKTbq+Rka6gmbZ2vIJfg
	C4aE/lylNaVdkbWCtJ+XuVs0UQYdat0=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DEBA2779AB
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 09:26:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GOdpIzk6QmojWQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 09:26:17 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/2] btrfs: remove SCRUB_MAX_SECTORS_PER_BLOCK
Date: Mon, 29 Jun 2026 18:55:52 +0930
Message-ID: <04c42fe35460477ebfa619dc8d37a7d83c6d5f96.1782725129.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782725129.git.wqu@suse.com>
References: <cover.1782725129.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_NONE(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.com:dkim];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: D711F72FC8
X-Spam-Score: -3.01

The last user of this macro is removed in commit 001e3fc263ce ("btrfs:
scrub: remove scrub_block and scrub_sector structures").

Now that macro is only utilized in an ASSERT(), which no longer makes
much sense.

Just remove it completely.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/scrub.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index d2f7ac5b6e96..5ec04c91e12d 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -57,12 +57,6 @@ struct scrub_ctx;
 
 #define SCRUB_TOTAL_STRIPES		(SCRUB_GROUPS_PER_SCTX * SCRUB_STRIPES_PER_GROUP)
 
-/*
- * The following value times PAGE_SIZE needs to be large enough to match the
- * largest node/leaf/sector size that shall be supported.
- */
-#define SCRUB_MAX_SECTORS_PER_BLOCK	(BTRFS_MAX_METADATA_BLOCKSIZE / SZ_4K)
-
 /* Represent one sector and its needed info to verify the content. */
 struct scrub_sector_verification {
 	union {
@@ -3091,14 +3085,6 @@ int btrfs_scrub_dev(struct btrfs_fs_info *fs_info, u64 devid, u64 start,
 	/* At mount time we have ensured nodesize is in the range of [4K, 64K]. */
 	ASSERT(fs_info->nodesize <= BTRFS_STRIPE_LEN);
 
-	/*
-	 * SCRUB_MAX_SECTORS_PER_BLOCK is calculated using the largest possible
-	 * value (max nodesize / min sectorsize), thus nodesize should always
-	 * be fine.
-	 */
-	ASSERT(fs_info->nodesize <=
-	       SCRUB_MAX_SECTORS_PER_BLOCK << fs_info->sectorsize_bits);
-
 	/* Allocate outside of device_list_mutex */
 	sctx = scrub_setup_ctx(fs_info, is_dev_replace);
 	if (IS_ERR(sctx))
-- 
2.54.0

