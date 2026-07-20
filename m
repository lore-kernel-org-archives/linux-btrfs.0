Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AF53D567F
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 09:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784541008; cv=none; b=bxfGVodIjXvbcqy7O6i9xfumKKfcEC+JYsQ2EB1CbtH5oyypk2LRd3OJfCCUGVKIMdWAsI/MW46rG2l6OushjT7WxzIOm7VQRxdZRYMfjxGwWguO29R/NGFQ/6KLs+hKx5YC2WQ3x6RBz8TWhIoZPn5Grxdxkp3ki+WqCeJbEqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784541008; c=relaxed/simple;
	bh=37UNphOcNNQnFLHFRkwR0EzrszIQrZq35gCFofzCCO4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=e3FgXK8JXe6ZkkQ3m7ygHTgLMJTUTR3S9bvzbE/2BS1gCmssGRXb4so2QPZG0+TUX601CfTR2AIiqofV+31M9iwpPy3SnOahCqa8SrafDj0RYAdNdm3xb32Zc3fK9ep0qawVTxoMQxETIkmNac378kGqPxhBoR4d+QbN7llTED4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SVd9SnJn; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SVd9SnJn; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SVd9SnJn";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SVd9SnJn"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3B7AC3E18
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784541004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NPBkgfC4u77ljgWao1/e8NForHzxWzPQJobkFcs0miM=;
	b=SVd9SnJnhyS+TRtGd41NDgOB6fPYi2ZwereF1peXUGsJ99xCMPFXNEcvN9YouXLceUDGZc
	M8jZIRfmrdIeK/oubVA4iTA6pHpOAMMoJsVR9xOKlbJN/zy5Om0DU4uZyrtpSrAJeIN3gl
	+6fhkRl2smy9QMbn/Q2pFSBOlwB+0/U=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=SVd9SnJn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1784541004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=NPBkgfC4u77ljgWao1/e8NForHzxWzPQJobkFcs0miM=;
	b=SVd9SnJnhyS+TRtGd41NDgOB6fPYi2ZwereF1peXUGsJ99xCMPFXNEcvN9YouXLceUDGZc
	M8jZIRfmrdIeK/oubVA4iTA6pHpOAMMoJsVR9xOKlbJN/zy5Om0DU4uZyrtpSrAJeIN3gl
	+6fhkRl2smy9QMbn/Q2pFSBOlwB+0/U=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7838E779AA
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 09:50:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nIjcDkvvXWpbOQAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Mon, 20 Jul 2026 09:50:03 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: disable large folios for systems with highmem
Date: Mon, 20 Jul 2026 19:19:41 +0930
Message-ID: <555623ad2f49989444fd60eb2bd11f0371086670.1784540975.git.wqu@suse.com>
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
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DKIM_TRACE(0.00)[suse.com:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 3B7AC3E18
X-Spam-Score: -3.01

[BUG]
There is a bug report that on 32bit systems (i686), btrfs crashes when
trying to do zstd compression:

 BUG: unable to handle page fault for address: fffbc000
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 CPU: 0 UID: 0 PID: 61 Comm: kworker/u8:5 Tainted: G                 N  7.2.0-rc3-P3 #2 PREEMPTLAZY
 Hardware name: LENOVO 2007F2G/2007F2G, BIOS 79ETE7WW (2.27 ) 03/21/2011
 Workqueue: btrfs-delalloc btrfs_work_helper
 EIP: ZSTD_compressStream2+0x221/0x5fc
 Call Trace:
  ZSTD_compressStream+0xd/0x48
  zstd_compress_stream+0x8/0x10
  zstd_compress_bio+0x20a/0x564
  btrfs_compress_bio+0x94/0xc0
  compress_file_range+0x20a/0x380
  btrfs_work_helper+0xc1/0x1b4
  process_scheduled_works+0x15f/0x204
  worker_thread+0x10c/0x178
  kthread+0xe1/0xe8
  ret_from_fork+0x1d/0x14c
  ret_from_fork_asm+0x12/0x18
  entry_INT80_32+0xf0/0xf0
 CR2: 00000000fffbc000
 ---[ end trace 0000000000000000 ]---

[CAUSE]
Inside zstd_compress_bio(), we assume the whole page cache folio can be
mapped in one go.

However that assumption is not true on systems with CONFIG_HIGHMEM, the
pages of the large folio can be in HIGHMEM, which needs to be mapped
before access.

Meanwhile zstd_compress_bio() only map the page of a large folio where
the start filepos is, the remaining pages are not mapped, and accessing
the remaining pages will trigger the above crash.

[FIX]
Do not enable large folios when the kernel has CONFIG_HIGHMEM enabled.

This is the same handling for bs > ps support.

Link: https://github.com/kdave/btrfs-progs/issues/1146
Fixes: 9bce95edb1b4 ("btrfs: move large data folios out of experimental features")
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 37fc0d6b960d..5de8210070eb 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3477,7 +3477,15 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	fs_info->sectorsize = sectorsize;
 	fs_info->sectorsize_bits = ilog2(sectorsize);
 	fs_info->block_min_order = ilog2(round_up(sectorsize, PAGE_SIZE) >> PAGE_SHIFT);
-	fs_info->block_max_order = calc_block_max_order(fs_info->sectorsize_bits);
+	/*
+	 * For HIGHMEM, a large folio cannot be mapped in one go, breaking a lot
+	 * of basic assumptions for btrfs IOs.
+	 * Disable large folios for such 32-bit systems.
+	 */
+	if (IS_ENABLED(CONFIG_HIGHMEM))
+		fs_info->block_max_order = fs_info->block_min_order;
+	else
+		fs_info->block_max_order = calc_block_max_order(fs_info->sectorsize_bits);
 	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) / fs_info->csum_size;
 	fs_info->fs_devices->fs_info = fs_info;
 
-- 
2.54.0

