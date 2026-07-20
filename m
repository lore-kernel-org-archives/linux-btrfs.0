Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9376225775
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 08:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784537838; cv=none; b=hF5XuMWFyIcXVp4OqLXFHS/EW8HuMi6aSdO1rT0Cbdw4FH4sLRkzrT3UlDQzAM/18qzu1X7iAK4d5FOQp+nm8xfD1biNhTFUEcQ+wtiS5tQDkO7kwaWMUj50xYBv851nzcZzM/iQQO8kChKNVVNchbvVxV8BrxQSk90iw0vjnVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784537838; c=relaxed/simple;
	bh=lKrEfbyi9ko4gwPzWfUaCmxoA4JCrSU+tHuUNZpIY48=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ouQFhKXCjWt0MH00nAPcd6a/Y2EJ7PntIoGL7slX9k8P94MKfkPL1nG1YhszDL9R2UG8hB+qv56Ez3KMcR/5sqGj+9JHMqZieBjhnlXnBKb7PrTstGnfTgjmLFiVq168D8NbWk4oP+JKAIS3JncN9BF8lLUqKVyO2GCNMkPoGvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NZmIfwN9; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=NZmIfwN9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NZmIfwN9";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="NZmIfwN9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BB5883DFC
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 08:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784537834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SXsMBjCFPkrhjigYPaK/G/+iKQj8jwmLHqSc3L6dous=;
	b=NZmIfwN9S9VbSjBfIMlHgwrsHh3LIJwe5bIsMat8MDOFYZvkvo2A07UARaB+kLvtJ9dR0j
	cAgKncEyEGKYz0Zpfj/eW1nqDfMuLhUR3pGzKGAf+kLLzTNc2lp5C08QuTezhulH812wSk
	T4QmlmEvajxRZq3zDuynqYEVUYfpWMo=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=NZmIfwN9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784537834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SXsMBjCFPkrhjigYPaK/G/+iKQj8jwmLHqSc3L6dous=;
	b=NZmIfwN9S9VbSjBfIMlHgwrsHh3LIJwe5bIsMat8MDOFYZvkvo2A07UARaB+kLvtJ9dR0j
	cAgKncEyEGKYz0Zpfj/eW1nqDfMuLhUR3pGzKGAf+kLLzTNc2lp5C08QuTezhulH812wSk
	T4QmlmEvajxRZq3zDuynqYEVUYfpWMo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F2949779AA
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 08:57:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Bjk3LOniXWrbBAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 08:57:13 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: open-code BTRFS_BYTES_TO_BLKS()
Date: Mon, 20 Jul 2026 18:26:52 +0930
Message-ID: <df638c77eb7c4f39492c03722062f250fd6e72cf.1784537784.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: BB5883DFC
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:dkim,suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org

That macro is only utilized 4 times, all inside file.c, meanwhile we
have tons of open-coded usages.
And since it's a macro, there is no proper type checks at all.

There isn't much need for such a rarely utilized macro.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/file.c | 8 ++++----
 fs/btrfs/fs.h   | 2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 8f078c58e940..818c53c445f8 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2661,8 +2661,8 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 
 	lockstart = round_up(offset, fs_info->sectorsize);
 	lockend = round_down(offset + len, fs_info->sectorsize) - 1;
-	same_block = (BTRFS_BYTES_TO_BLKS(fs_info, offset))
-		== (BTRFS_BYTES_TO_BLKS(fs_info, offset + len - 1));
+	same_block = (offset >> fs_info->sectorsize_bits) ==
+		     ((offset + len - 1) >> fs_info->sectorsize_bits);
 	/*
 	 * Only do this if we are in the same block and we aren't doing the
 	 * entire block.
@@ -2945,8 +2945,8 @@ static int btrfs_zero_range(struct inode *inode,
 	}
 	btrfs_free_extent_map(em);
 
-	if (BTRFS_BYTES_TO_BLKS(fs_info, offset) ==
-	    BTRFS_BYTES_TO_BLKS(fs_info, offset + len - 1)) {
+	if ((offset >> fs_info->sectorsize_bits) ==
+	    ((offset + len - 1) >> fs_info->sectorsize_bits)) {
 		em = btrfs_get_extent(BTRFS_I(inode), NULL, alloc_start, sectorsize);
 		if (IS_ERR(em)) {
 			ret = PTR_ERR(em);
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index d3f74453b356..06b5884a9bcd 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -1058,8 +1058,6 @@ static inline u64 btrfs_calc_metadata_size(const struct btrfs_fs_info *fs_info,
 #define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info) >> 4) - \
 					sizeof(struct btrfs_item))
 
-#define BTRFS_BYTES_TO_BLKS(fs_info, bytes) ((bytes) >> (fs_info)->sectorsize_bits)
-
 static inline bool btrfs_is_zoned(const struct btrfs_fs_info *fs_info)
 {
 	return IS_ENABLED(CONFIG_BLK_DEV_ZONED) && fs_info->zone_size > 0;
-- 
2.54.0

