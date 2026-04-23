Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EC33E3DB5
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 09:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776936681; cv=none; b=FCgTWvx54EaD3DHQ7tv1bUsWifKFQOzOx2CME1IuWX2F9RMz+hjSNqiN0yFrS5r0/pg6t0ntDaSBkURwL3uMaOxC28G1ntPj1Cqcz2FO51cJtp+pHRNK3Pexpv35jV5gpBf6k01JKvpZeI7cOx4WmIpEQxEZNBL9CFaqDw3+/5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776936681; c=relaxed/simple;
	bh=hdsDwl2APIzcR4aM1M8aSiRLGzf70uF8BEx4eNFOuGw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CUNtt0C2r6p0REzOMibOA28ERBn8b4v2p1Sx6Q9/Z7uVgFDpDOBgH+gbuNzV2ObtsZyolBGbYzzacShBqcrfZm9MT3ZE0nEdwF62LuT122IOZJQovFzs6dT2nEy1wt9KcLbDIamikJltSu7aGS5wPcQ7j7J4RaiZUsoYJuYN94w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=tII/FeWQ; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=yh5FrGnS; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=y5ht5lU6; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+OfGtnAN; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="tII/FeWQ";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="yh5FrGnS";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="y5ht5lU6";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+OfGtnAN"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E11E46A97B;
	Thu, 23 Apr 2026 09:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776936678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0wWZCPs4bxYn12Eh29WOxKOOZGWj5cr+1jGCoPjskww=;
	b=tII/FeWQ4fDtdgWYuwxEbKyRxgpNwpBEBTrtW9bCIbaQqivcnmSTMEZVhrZ0npwGJP5tkZ
	7FzfvXO4KtNtLhfATAYto/Ygq64Kz5KPLyNGjJ4/93K6QN2ShPoOUbO+60p7NeQmrD/2ia
	xgwSqXMWeKjwvDmrCQEOaaq5S2fv9kA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776936678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0wWZCPs4bxYn12Eh29WOxKOOZGWj5cr+1jGCoPjskww=;
	b=yh5FrGnSShQHxIbYvjb86IXxNgsqKm1IiUon2nEmk3lC6evo0nckqyXKjCfh4Y9BMFyNcx
	SdePIFambG8BFDCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776936677; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0wWZCPs4bxYn12Eh29WOxKOOZGWj5cr+1jGCoPjskww=;
	b=y5ht5lU666GoefCBJA4W71/RuUiO6+LdaFvtlTUstSI0O2MN68qFZr5cn/0+4SMidV7FnH
	EhFfCJ3lPGy4kryH+7gkT2ZglAuIUH0XL7DQH0xD9tk6BE1XwUIK+OG5FK41Y6/wysRRVR
	iM3+Mkof/aXOwNSsRaGJeEFURQi3uqM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776936677;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=0wWZCPs4bxYn12Eh29WOxKOOZGWj5cr+1jGCoPjskww=;
	b=+OfGtnAN4ORMA8f2xctHzgCw7GJbYtTkgDsDUL7Wc7s9hJlyDLOzNedsS7o9QD851Rvqfn
	YxyuECzX2+kkJ/AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CC7E1593A3;
	Thu, 23 Apr 2026 09:31:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vzfSMeXm6Wn1NQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 23 Apr 2026 09:31:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 90EB4A0A2D; Thu, 23 Apr 2026 11:31:13 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>,
	linux-btrfs@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: [PATCH v2] btrfs: Limit size of bios submitted from writeback
Date: Thu, 23 Apr 2026 11:30:53 +0200
Message-ID: <20260423093052.13219-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4818; i=jack@suse.cz; h=from:subject; bh=hdsDwl2APIzcR4aM1M8aSiRLGzf70uF8BEx4eNFOuGw=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBp6ebMPKZKC8K3t79KNO2Xp3oIdBIIgOTtpVSqP DjeToNbf+aJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaenmzAAKCRCcnaoHP2RA 2TGjB/9CHtzhumy7JVq8cO8ErJJhUfW1m9k1+Oj4GPDnonY/a9rxqFXDzilD0rLim/E0Kx/VYFg Qn+RwIkTW9lJlO3wytP1BkB0YehIrc/BqdFeeTppftHaozPM0W96e7MEiCFeYBtXtERebbjIGV+ K0L9pwFi3DmjHZBNw4zz222tgE7ffpHdEyDd04VsoMB5THxJ0aRu9Zmc/nm4mJ1L/jL2A0xtb3p Z3XucGaM6TCyPSb9EEl3LPifOPEpf7bc0I7tQJht+QMNS/JdAsj8IhbqmI/ZF1cerp9fXi7Vaqi 2PAL7elvijTMpZCTCHSOo9lqqJHxGYSWpiZyWLnsZXbmFu8J
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

Currently btrfs_writepages() just accumulates as large bio as possible
(within writeback_control constraints) and then submits it. This can
however lead to significant latency in writeback IO submission (I have
observed tens of miliseconds) because the submitted bio easily has over
hundred of megabytes. Consequently this leads to IO pipeline stalls and
reduced throughput.

At the same time beyond certain size submitting so large bio provides
diminishing returns because the bio is split by the block layer
immediately anyway. So compute (estimate of) bio size beyond which we
are unlikely to improve performance and just submit the bio for
writeback once we accumulate that much to keep the IO pipeline busy.
This improves writeback throughput for sequential writes by about 15% on
the test machine I was using.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/disk-io.c   |  7 +++++++
 fs/btrfs/extent_io.c | 10 ++++++++++
 fs/btrfs/fs.h        |  1 +
 fs/btrfs/volumes.c   | 29 +++++++++++++++++++++++++++++
 fs/btrfs/volumes.h   |  1 +
 5 files changed, 48 insertions(+)

Changes since v1:
- moved limit checks to submit_extent_folio
- simplified computation of maximum bio size

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8a11be02eeb9..f063595d0cee 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3591,6 +3591,13 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 		}
 	}
 
+	ret = btrfs_init_writeback_bio_size(fs_info);
+	if (ret) {
+		btrfs_err(fs_info, "failed to get optimum writeback size: %d",
+			  ret);
+		goto fail_sysfs;
+	}
+
 	btrfs_free_zone_cache(fs_info);
 
 	btrfs_check_active_zone_reservation(fs_info);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index ca3e4b99aec2..d13d7eb95d44 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -857,6 +857,16 @@ static void submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
 		/* Ordered extent boundary: move on to a new bio. */
 		if (bio_ctrl->len_to_oe_boundary == 0)
 			submit_one_bio(bio_ctrl);
+		/*
+		 * If we have accumulated decent amount of IO, send it to the
+		 * block layer so that IO can run while we are accumulating
+		 * more folios to write.
+		 */
+		else if (bio_ctrl->wbc &&
+			 bio_ctrl->bbio->bio.bi_iter.bi_size >=
+			    inode->root->fs_info->writeback_bio_size)
+			submit_one_bio(bio_ctrl);
+
 	} while (size);
 }
 
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index a4758d94b32e..19e02452ab96 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -880,6 +880,7 @@ struct btrfs_fs_info {
 	u32 block_min_order;
 	u32 block_max_order;
 	u32 stripesize;
+	u32 writeback_bio_size;
 	u32 csum_size;
 	u32 csums_per_leaf;
 	u32 csum_type;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a88e68f90564..c27614a23ffb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8179,6 +8179,35 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+int btrfs_init_writeback_bio_size(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
+	struct btrfs_device *device;
+	u32 writeback_bio_size = fs_info->sectorsize;
+
+	mutex_lock(&fs_devices->device_list_mutex);
+	/*
+	 * Let's take maximum over optimal request sizes for all devices. For
+	 * RAID profiles writeback will submit stripe (64k) sized bios anyway
+	 * so our value doesn't matter and for simple profiles this is a good
+	 * approximation of sensible IO chunking.
+	 */
+	list_for_each_entry(device, &fs_devices->devices, dev_list) {
+		struct request_queue *queue;
+		unsigned int io_opt;
+
+		queue = bdev_get_queue(device->bdev);
+		io_opt = queue_io_opt(queue) ? :
+				queue_max_sectors(queue) << SECTOR_SHIFT;
+		writeback_bio_size = max(writeback_bio_size, io_opt);
+	}
+	mutex_unlock(&fs_devices->device_list_mutex);
+
+	fs_info->writeback_bio_size = writeback_bio_size;
+
+	return 0;
+}
+
 static int update_dev_stat_item(struct btrfs_trans_handle *trans,
 				struct btrfs_device *device)
 {
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 0082c166af91..96904d18f686 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -784,6 +784,7 @@ int btrfs_get_dev_stats(struct btrfs_fs_info *fs_info,
 			struct btrfs_ioctl_get_dev_stats *stats);
 int btrfs_init_devices_late(struct btrfs_fs_info *fs_info);
 int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info);
+int btrfs_init_writeback_bio_size(struct btrfs_fs_info *fs_info);
 int btrfs_run_dev_stats(struct btrfs_trans_handle *trans);
 void btrfs_rm_dev_replace_remove_srcdev(struct btrfs_device *srcdev);
 void btrfs_rm_dev_replace_free_srcdev(struct btrfs_device *srcdev);
-- 
2.51.0

