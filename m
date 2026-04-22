Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240883B8BD7
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 09:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776851001; cv=none; b=X8Jqh8IurFdXCYWioBS8mcbix/dyR5Zr7Y64ftS+QsofUC7KBm6/Lk/qBMAzl38FlPbIs4zyl7nfQntQWuVnD2r7Iz25BL311a9pVkBsrdwT3rY6iqXhPR6h46/N5x5IuFyzG50mOaAXcx4uyVGSLvfM18Kq3QXdlcW9BSeBrgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776851001; c=relaxed/simple;
	bh=qcteyWMELKGWHeSsF5nBCd7xLDAuuAOC2j3ZAwPwS9s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lHmp72UXIaNdFIHXI4EFpmDMl2ASnUdus4MFwd1CFZy9gLWaOZT72i5L/K1LQ6uemcVL7+v0XYj69gwIWQnsbQGs3/Fh1aSagahbxJdOgC/iMyBxE651tU2yapANvFU4tEN8IPlXQMgQq9CVRRr/Rcj48LNa13yrOVDO/IDy0/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NpRCVmo7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xa4xkLzg; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NpRCVmo7; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=xa4xkLzg; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NpRCVmo7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xa4xkLzg";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NpRCVmo7";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="xa4xkLzg"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3D8355BCC8;
	Wed, 22 Apr 2026 09:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776850998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hsniasnb2zgEHuGmeRp0H7YwbCmHk+XJ3BsbIZ0tWTw=;
	b=NpRCVmo7ttVcbSi3cgPfBX2KyxA83myuyxhbLJKuv30Rt16ocXFYP3BGzbZljDKlqmis8Y
	hwM6HO9wjc5/eHSud066x9AMPTL5iM+Hf1wLtM6w1b3dCoX8qYkpzJCdp+nwFSJZum0z3Q
	reC13paCMOiSqOmspmmtsBKeZDLgg/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776850998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hsniasnb2zgEHuGmeRp0H7YwbCmHk+XJ3BsbIZ0tWTw=;
	b=xa4xkLzg12NppNgvxXTGj/T6MDF3/lz14ekLGKyR6/Bw31VBBjTp5pTwhGLVpwpGTg9tqZ
	k9yEj6kzmLEYwBDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776850998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hsniasnb2zgEHuGmeRp0H7YwbCmHk+XJ3BsbIZ0tWTw=;
	b=NpRCVmo7ttVcbSi3cgPfBX2KyxA83myuyxhbLJKuv30Rt16ocXFYP3BGzbZljDKlqmis8Y
	hwM6HO9wjc5/eHSud066x9AMPTL5iM+Hf1wLtM6w1b3dCoX8qYkpzJCdp+nwFSJZum0z3Q
	reC13paCMOiSqOmspmmtsBKeZDLgg/w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776850998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hsniasnb2zgEHuGmeRp0H7YwbCmHk+XJ3BsbIZ0tWTw=;
	b=xa4xkLzg12NppNgvxXTGj/T6MDF3/lz14ekLGKyR6/Bw31VBBjTp5pTwhGLVpwpGTg9tqZ
	k9yEj6kzmLEYwBDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 28920593AF;
	Wed, 22 Apr 2026 09:43:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qJzoCTaY6GmuRQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 22 Apr 2026 09:43:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E934CA0B60; Wed, 22 Apr 2026 11:43:13 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Jan Kara <jack@suse.cz>
Subject: [PATCH] btrfs: Limit size of bios submitted from writeback
Date: Wed, 22 Apr 2026 11:42:56 +0200
Message-ID: <20260422094255.12672-2-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5462; i=jack@suse.cz; h=from:subject; bh=qcteyWMELKGWHeSsF5nBCd7xLDAuuAOC2j3ZAwPwS9s=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBp6Jgg3n0TIj7SE0PFSzGQBafbhx0kN4mU7ouF9 6d4CQGjZwuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaeiYIAAKCRCcnaoHP2RA 2WcQB/47KT0LrOzeyXxpN9jDVEHYsfxlgZldw+V9Q6QFHiveptFMdVo0ijyebySCk9sB0Dihdjm VroiaDY76AClrJwbzm9smQv0JsFrnxxvdO9W92eaulaag6/7Nbv3h2ca6TO10XC9RI0MGdUpTuv nAZjqFrF/55wlzzSBUeA/nFA/Rd0dDLaktihTTyEE8b1wn6/76GZKULvAOLgv92+OPIjxJCY3J1 OWYudCQIPV23JngdhCCqXNw1udVL8qUyLVpQINjM7CC1F1af1sowC6yp26awyF2k280ExRUJU1x nGgNHN9YEtW/5xxSky0QWyg8U1SSGLFfQaWkVjG+WRdgPmHe
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
	RCPT_COUNT_THREE(0.00)[3];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:mid,suse.cz:email]
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
 fs/btrfs/disk-io.c   |  7 ++++++
 fs/btrfs/extent_io.c | 10 ++++++++
 fs/btrfs/fs.h        |  1 +
 fs/btrfs/volumes.c   | 54 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/volumes.h   |  1 +
 5 files changed, 73 insertions(+)

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
index ca3e4b99aec2..9c603d59a09b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2555,6 +2555,16 @@ static int extent_write_cache_pages(struct address_space *mapping,
 				break;
 			}
 
+			/*
+			 * If we have accumulated decent amount of IO, send it
+			 * to the block layer so that IO can run while we are
+			 * accumulating more folios to write.
+			 */
+			if (bio_ctrl->bbio &&
+			    bio_ctrl->bbio->bio.bi_iter.bi_size >=
+			    inode_to_fs_info(inode)->writeback_bio_size)
+				submit_write_bio(bio_ctrl, 0);
+
 			/*
 			 * The filesystem may choose to bump up nr_to_write.
 			 * We have to make sure to honor the new nr_to_write
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
index a88e68f90564..cb654e990333 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -8179,6 +8179,60 @@ int btrfs_init_dev_stats(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+/*
+ * At maximum we submit writeback bios 64MB in size to avoid too large
+ * submission latencies
+ */
+#define BTRFS_MAX_WB_BIO_SIZE (64 << 20)
+
+int btrfs_init_writeback_bio_size(struct btrfs_fs_info *fs_info)
+{
+	struct rb_node *node;
+	u32 writeback_bio_sectors = 1;
+
+	read_lock(&fs_info->mapping_tree_lock);
+	/*
+	 * For each data chunk compute the size of bio large enough to submit
+	 * optimum size request for each of chunk's disk and take maximum
+	 * over all data chunks.
+	 */
+	for (node = rb_first_cached(&fs_info->mapping_tree); node;
+	     node = rb_next(node)) {
+		struct btrfs_chunk_map *map;
+		unsigned int data_stripes, opt_rq_size = fs_info->sectorsize;
+		int i;
+
+		map = rb_entry(node, struct btrfs_chunk_map, rb_node);
+		if (!(map->type & BTRFS_BLOCK_GROUP_DATA))
+			continue;
+		data_stripes = calc_data_stripes(map->type, map->num_stripes);
+		for (i = 0; i < map->num_stripes; i++) {
+			struct request_queue *queue;
+			unsigned int io_opt;
+
+			if (!map->stripes[i].dev)
+				continue;
+			queue = bdev_get_queue(map->stripes[i].dev->bdev);
+			io_opt = queue_io_opt(queue) ? :
+				queue_max_sectors(queue) << SECTOR_SHIFT;
+			opt_rq_size = max(opt_rq_size, io_opt);
+		}
+		opt_rq_size >>= fs_info->sectorsize_bits;
+		writeback_bio_sectors = max(writeback_bio_sectors,
+					    data_stripes * opt_rq_size);
+	}
+	read_unlock(&fs_info->mapping_tree_lock);
+
+	if (BTRFS_MAX_WB_BIO_SIZE >> fs_info->sectorsize_bits <=
+						writeback_bio_sectors)
+		fs_info->writeback_bio_size = BTRFS_MAX_WB_BIO_SIZE;
+	else
+		fs_info->writeback_bio_size =
+			writeback_bio_sectors << fs_info->sectorsize_bits;
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

