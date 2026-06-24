Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768F029ACDD
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782275031; cv=none; b=okuoz69IdgEci0KNGfOKCtPCLKQPmoxq/EgQ+cSjVG7bn19m2pua8vbXyHrGaUcTyeuSavrlEiSBKmHhBGPGo9hYM/rbVnr6KmGau64E1aW4ck5R9LyJg4owMedYkJRryDn1I/hXffw76la4Wj8RJunomGpkIsm6fZpmP/399Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782275031; c=relaxed/simple;
	bh=vHHd1BLT3XDL2ftp1qvVEZJ6xMSP/vKxG2m9lUTkKzA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=WAT2ePZ7cCpfX6u5xSH9TVAvoJPUEKnNUzztHESYPX+iep6nMy+KDGh+Z64/MJyVDsWTe1A1QkF9aLdiI+V1SVHFN/to3MOrjkA7xbMfNR9LJciKvJH/WC3Ra4zcH6e6+sWO2WgsSyx1A3no0+5wsuKtedOrFv5HT8soYI+L8yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KSOfm+sg; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=KSOfm+sg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KSOfm+sg";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="KSOfm+sg"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C8A3D75F5A
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782275027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Q2K8f/A3lSx1WTX/lDOm32mgESOJOWBWhv6CBWczsno=;
	b=KSOfm+sg1Vt2V5h/X+RfeLzp8RMTahXJcfigvvajpw/7HCCX6Te79eCguWyBjlgEAt3sN5
	M6vrzhbWWpZnMhz42TUA7/m6bEYDe2qnpOMRamalwnSSIDw3+D5SrEvOpBAjLHvMqVbk7G
	EK3UilwusFSdOYwP8m/xevnyKZB4zKU=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=KSOfm+sg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782275027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Q2K8f/A3lSx1WTX/lDOm32mgESOJOWBWhv6CBWczsno=;
	b=KSOfm+sg1Vt2V5h/X+RfeLzp8RMTahXJcfigvvajpw/7HCCX6Te79eCguWyBjlgEAt3sN5
	M6vrzhbWWpZnMhz42TUA7/m6bEYDe2qnpOMRamalwnSSIDw3+D5SrEvOpBAjLHvMqVbk7G
	EK3UilwusFSdOYwP8m/xevnyKZB4zKU=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB932779A8
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:23:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FTluHtJbO2q0SgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 04:23:46 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: remove btrfs_fs_info::stripesize
Date: Wed, 24 Jun 2026 13:53:28 +0930
Message-ID: <8a10be3992b88b143585dd1736998b4479c48b46.1782275006.git.wqu@suse.com>
X-Mailer: git-send-email 2.54.0
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
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received,2a07:de40:b281:104:10:150:64:97:from];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: C8A3D75F5A
X-Spam-Score: -3.01

Btrfs does not support variable stripe length yet, all RAID0/5/6/10
chunks have the fixed stripe length 64K for now.

Furthermore, btrfs_fs_info::stripesize is not the real chunk stripe
length, it's always the same value as sectorsize.

Remove btrfs_fs_info::stripesize, and for the only callsite utilizing
that member, replace it with fs_info->sectorsize instead.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c     | 4 ----
 fs/btrfs/extent-tree.c | 2 +-
 fs/btrfs/fs.h          | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index fa5922a21e51..1783f5c89eb0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2900,7 +2900,6 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	fs_info->nodesize = 4096;
 	fs_info->sectorsize = 4096;
 	fs_info->sectorsize_bits = ilog2(4096);
-	fs_info->stripesize = 4096;
 
 	/* Default compress algorithm when user does -o compress */
 	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
@@ -3359,7 +3358,6 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 {
 	u32 sectorsize;
 	u32 nodesize;
-	u32 stripesize;
 	u64 generation;
 	u16 csum_type;
 	struct btrfs_super_block *disk_super;
@@ -3468,7 +3466,6 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	/* Set up fs_info before parsing mount options */
 	nodesize = btrfs_super_nodesize(disk_super);
 	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = sectorsize;
 	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
 	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
 
@@ -3479,7 +3476,6 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	fs_info->block_min_order = ilog2(round_up(sectorsize, PAGE_SIZE) >> PAGE_SHIFT);
 	fs_info->block_max_order = calc_block_max_order(fs_info->sectorsize_bits);
 	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
-	fs_info->stripesize = stripesize;
 	fs_info->fs_devices->fs_info = fs_info;
 
 	if (fs_info->sectorsize > PAGE_SIZE)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 624d76e0ca01..235381b31298 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4757,7 +4757,7 @@ static noinline int find_free_extent(struct btrfs_root *root,
 
 		/* Checks */
 		ffe_ctl->search_start = round_up(ffe_ctl->found_offset,
-						 fs_info->stripesize);
+						 fs_info->sectorsize);
 
 		/* move on to the next group */
 		if (ffe_ctl->search_start + ffe_ctl->num_bytes >
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 5f0cfb0b5466..ab5ed7b4f639 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -888,7 +888,6 @@ struct btrfs_fs_info {
 	u32 sectorsize_bits;
 	u32 block_min_order;
 	u32 block_max_order;
-	u32 stripesize;
 	u32 writeback_bio_size;
 	u32 csum_size;
 	u32 csums_per_leaf;
-- 
2.54.0

