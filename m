Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C55A32F766
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772163268; cv=none; b=bFRjbF51bp4EMBkSusbNbTBwaeGsR/MfC1NEzaN4RQAmeDMUzcFAD4yLICheMaTwTZzEnAFGiDZohiEmGJoUAVVeMGOF214gV89lHinklpOUqu3dJH+QB2DsPsWME7hCNlgI8zsCcmmZfv45xGR5p1LAJBSgn1GqqnBQ2X2Hcio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772163268; c=relaxed/simple;
	bh=VILCLS3KdsoFWsJ8v7pEASR4B0aI/bOZfPc3FHD22ZY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmSiDwCC/ycoE5KSI6kNyM3bFhhrAKBpSgQ/aiBLcu0L7CZ6SO6xpkkIm9tN52/1NreM6QYLEuJlTMlWOFcMIvI2Q6i4/IxSmqUYlK4rjnAvBOqusI9HTM6hQrg+TAnPknIsOge4ZVYBlFhBoXCyfd59/T8YqI4tx1YkHB2DTAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V2BRy8ps; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=V2BRy8ps; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V2BRy8ps";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="V2BRy8ps"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DAE0740416
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772163255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zFLRcFqBKnyE2hVo5hfbXqrIHg57g197QeA8FpcMHbw=;
	b=V2BRy8pst8Y06wjMrSpoL2mqrZoSqw5YHwkQ/tmrw/TgHG068pEjoT7N10J9dTQdfk3zOk
	a15/LhJw5B+/ucvUjtqI73NCB5VWUgG2f2hMtisO6c84R3NDQR56n97ut2b20rMLD/l+ak
	qM5o1ZzJot4+WvEZxNdiPjEXA9/oxqs=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1772163255; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zFLRcFqBKnyE2hVo5hfbXqrIHg57g197QeA8FpcMHbw=;
	b=V2BRy8pst8Y06wjMrSpoL2mqrZoSqw5YHwkQ/tmrw/TgHG068pEjoT7N10J9dTQdfk3zOk
	a15/LhJw5B+/ucvUjtqI73NCB5VWUgG2f2hMtisO6c84R3NDQR56n97ut2b20rMLD/l+ak
	qM5o1ZzJot4+WvEZxNdiPjEXA9/oxqs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1CE823EA69
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MNycM7YQoWmcNAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Feb 2026 03:34:14 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/4] btrfs: move shutdown and remove_bdev callbacks out of experimental features
Date: Fri, 27 Feb 2026 14:03:44 +1030
Message-ID: <23b2b0a8d249d0ead16acf0b017109321719213a.1772162871.git.wqu@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772162871.git.wqu@suse.com>
References: <cover.1772162871.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

These two new callbacks are introduced in v6.19, and it has been two
releases in v7.1.

During that time we have not yet exposed bugs related that two features,
thus it's time to expose them for end users.

It's especially important to expose remove_bdev callback to end users.

That new callback makes btrfs automatically shutdown or go degraded
when a device is missing (depending on if the fs can maintain RW), which
is affecting end users.

We want some feedback from early adopters.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/Kconfig | 2 --
 fs/btrfs/super.c | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index ede184b6eda1..5e75438e0b73 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -112,8 +112,6 @@ config BTRFS_EXPERIMENTAL
 
 	  - large folio and block size (> page size) support
 
-	  - shutdown ioctl and auto-degradation support
-
 	  - asynchronous checksum generation for data writes
 
 	  - remap-tree - logical address remapping tree
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b4d26ca9220a..52137366b79b 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2423,7 +2423,6 @@ static long btrfs_free_cached_objects(struct super_block *sb, struct shrink_cont
 	return 0;
 }
 
-#ifdef CONFIG_BTRFS_EXPERIMENTAL
 static int btrfs_remove_bdev(struct super_block *sb, struct block_device *bdev)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
@@ -2481,7 +2480,6 @@ static void btrfs_shutdown(struct super_block *sb)
 
 	btrfs_force_shutdown(fs_info);
 }
-#endif
 
 static int btrfs_show_stats(struct seq_file *seq, struct dentry *root)
 {
@@ -2511,10 +2509,8 @@ static const struct super_operations btrfs_super_ops = {
 	.nr_cached_objects = btrfs_nr_cached_objects,
 	.free_cached_objects = btrfs_free_cached_objects,
 	.show_stats	= btrfs_show_stats,
-#ifdef CONFIG_BTRFS_EXPERIMENTAL
 	.remove_bdev	= btrfs_remove_bdev,
 	.shutdown	= btrfs_shutdown,
-#endif
 };
 
 static const struct file_operations btrfs_ctl_fops = {
-- 
2.53.0

