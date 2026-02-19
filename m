Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0353332EBE
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2026 08:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771489315; cv=none; b=gy9n3ez3FZeTtOvGMH7BfbXVYdSuqR6ntMGkR2EsQ7rzbGoWMquGaP63ujH+1iXuhKUvqO2TCCzVHg8Tr8Pgm/6M2o0WktrdhscniK08tbsT2kH+30wpsGQJjUMiRWa3mjYuaGk2Ak97B4t0Baz8tCiUABZa7TfMH1Ilzdhpelg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771489315; c=relaxed/simple;
	bh=rP3++q75lYEGR1gXcUabcPfPW1pJJbKXibvx2B1VDys=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awbWsJvmzwQ8yaWLL1Du4V3vrACvgErZC2ubyTbIRmHES1EPSpgd9F5Dw2J6TgHcCkCw3uRBcQ7PywSVxvMSFAqaDu18CJdY7n2F31dYwpL57BZ7sOEm+bBaT3yGRQe4SJEOrVzO5GQDCE90OTsGu0Wkhe9pxcnsH+5oXGlfyCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pnZzhTUU; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=pnZzhTUU; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pnZzhTUU";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="pnZzhTUU"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 516033E6ED
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2026 08:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771489298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yq7wiMp29yBhS2CC7rSZRbOp//TCSapC6GFfnB8qjvg=;
	b=pnZzhTUUsByc/KPl/rmjSaR21YCGAZQaw9EF+5IAU1/WOFQ3ZRu7f+saWfyGjPoDi2YM+Z
	ECG2HuWww3Gb/HMoKL2iRYl2rJKraPKlJYIZ80lL52zAO7gVFLjGcNhJZbVsxoFtzLLqrg
	wxOSE1c2Y+l8k91rvvhCCRDm1ePqWto=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=pnZzhTUU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1771489298; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yq7wiMp29yBhS2CC7rSZRbOp//TCSapC6GFfnB8qjvg=;
	b=pnZzhTUUsByc/KPl/rmjSaR21YCGAZQaw9EF+5IAU1/WOFQ3ZRu7f+saWfyGjPoDi2YM+Z
	ECG2HuWww3Gb/HMoKL2iRYl2rJKraPKlJYIZ80lL52zAO7gVFLjGcNhJZbVsxoFtzLLqrg
	wxOSE1c2Y+l8k91rvvhCCRDm1ePqWto=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81B653EA65
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2026 08:21:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SH0VERHIlmkYZAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Feb 2026 08:21:37 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/4] btrfs: fix an incorrect ASSERT() condition inside lzo_decompress_bio()
Date: Thu, 19 Feb 2026 18:51:14 +1030
Message-ID: <6c9530ebc218de97439aa5043840d544e9b6470a.1771488629.git.wqu@suse.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771488629.git.wqu@suse.com>
References: <cover.1771488629.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:mid,suse.com:dkim,suse.com:email];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 516033E6ED

[BUG]
When running btrfs/284 with 64K page size and 4K fs block size, it
crashes with the following ASSERT() triggered:

 BTRFS info (device dm-3): use lzo compression, level 1
 assertion failed: folio_size(fi.folio) == sectorsize :: 0, in lzo.c:450
 ------------[ cut here ]------------
 kernel BUG at lzo.c:450!
 Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
 CPU: 4 UID: 0 PID: 329 Comm: kworker/u37:2 Tainted: G           OE       6.19.0-rc8-custom+ #185 PREEMPT(voluntary)
 Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
 Workqueue: btrfs-endio simple_end_io_work [btrfs]
 pc : lzo_decompress_bio+0x61c/0x630 [btrfs]
 lr : lzo_decompress_bio+0x61c/0x630 [btrfs]
 Call trace:
  lzo_decompress_bio+0x61c/0x630 [btrfs] (P)
  end_bbio_compressed_read+0x2a8/0x2c0 [btrfs]
  btrfs_bio_end_io+0xc4/0x258 [btrfs]
  btrfs_check_read_bio+0x424/0x7e0 [btrfs]
  simple_end_io_work+0x40/0xa8 [btrfs]
  process_one_work+0x168/0x3f0
  worker_thread+0x25c/0x398
  kthread+0x154/0x250
  ret_from_fork+0x10/0x20
 Code: 912a2021 b0000e00 91246000 940244e9 (d4210000)
 ---[ end trace 0000000000000000 ]---

[CAUSE]
Commit 37cc07cab7dc ("btrfs: lzo: use folio_iter to handle
lzo_decompress_bio()") added the ASSERT() to make sure the folio size
match the fs block size.

But the check is completely wrong, the original intention is to make
sure for bs > ps cases, we always got a large folio that covers a full fs
block.

However for bs < ps cases, a folio can never be smaller than page size,
and the ASSERT() gets triggered immediately.

[FIX]
Check the folio size against @min_folio_size instead, which will never
be smaller than PAGE_SIZE, and still cover bs > ps cases.

Fixes: 37cc07cab7dc ("btrfs: lzo: use folio_iter to handle lzo_decompress_bio()")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/lzo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index 8e20497afffe..971c2ea98e18 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -429,7 +429,7 @@ static void copy_compressed_segment(struct compressed_bio *cb,
 int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
-	const struct btrfs_fs_info *fs_info = cb->bbio.inode->root->fs_info;
+	struct btrfs_fs_info *fs_info = cb->bbio.inode->root->fs_info;
 	const u32 sectorsize = fs_info->sectorsize;
 	struct folio_iter fi;
 	char *kaddr;
@@ -447,7 +447,7 @@ int lzo_decompress_bio(struct list_head *ws, struct compressed_bio *cb)
 	/* There must be a compressed folio and matches the sectorsize. */
 	if (unlikely(!fi.folio))
 		return -EINVAL;
-	ASSERT(folio_size(fi.folio) == sectorsize);
+	ASSERT(folio_size(fi.folio) == btrfs_min_folio_size(fs_info));
 	kaddr = kmap_local_folio(fi.folio, 0);
 	len_in = read_compress_length(kaddr);
 	kunmap_local(kaddr);
-- 
2.52.0

