Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5B43F6606
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788418189; cv=none; b=jT8ErdGBfA1KUlGw3iaP4G7dgheRqHtBkqzSgoeuwPwQuHGmNoplr8ZcCbCDu+TmXi6bKUWCl+MND7twzDHEy/vmkzXrbo2fDfs4yW1YNIC0oYswORv+kmYEJR4E7LMFNw2562Ug2EwC7y6FfW/oNZpSJuGGf1GhXC2ZK7GhQ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788418189; c=relaxed/simple;
	bh=4iqsCz4UJZkft2FrbXbEkJlMqNTRbzbgMFM0DKpotj4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMoqH084HlwKvUTzeQAvyqsfIAQeDVXMkVaRiK2p1TmXOOiMJEJ3ENP+Js5X6c/sd5YODApyfQgOO5yiAAIE75wwmSjbzXBCqJ3k6lL2riMH2GKUTokPddm1YDrMzRf5SvyzCHzM8A2eTSEi54A7/NoQE2R0ko7r/2EMiRQh9+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=uhVQGLwS; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=EoBDA8OW; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="uhVQGLwS";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EoBDA8OW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EC33221E48
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788418181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NFPurEulrZ6bKlGCoa2TAkRyB9Sg9W/lK6HF5xSQOSw=;
	b=uhVQGLwS8pPuPUN4JX4EhxU4B0t/n2Z/PzhJb0n1BIPEQi5S/aC6QJTTmBh/IIEroohzb6
	qih8BV0JI4cKe1huX3rppLGajTdZ3VEz/+KcrFHV1V5MRFS3EIFvMwq+SD5MMNxPrP9ztz
	iIC5Lb7gJcGRacwmZ9OZcQeCZ3RU3fw=
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=EoBDA8OW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1788418176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NFPurEulrZ6bKlGCoa2TAkRyB9Sg9W/lK6HF5xSQOSw=;
	b=EoBDA8OWa8DiilFHezTkO8p/dJy5NhTVPOF11VwbVn8/2N5RZxfg5xcCyWUDXDXVDlfZJo
	HO8107OFOSdO2Xen4NB0VgvWbNAcmbS8ofwlQj/EKLXSMwa3+ts3JJ1bOnrLs5CPhfep/o
	nRgTajPV/3RL9u4Nt1MoEOZEASoFWXE=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA76613738
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:49:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SMmXFX8YmWosRAAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Thu, 03 Sep 2026 06:49:35 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: implement a new incompat feature, raid56_vsl
Date: Thu,  3 Sep 2026 16:19:04 +0930
Message-ID: <58395db01b6e70a270946caeb4ba9113dc0039e5.1788417288.git.wqu@suse.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788417288.git.wqu@suse.com>
References: <cover.1788417288.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.01
X-Rspamd-Queue-Id: EC33221E48
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Rspamd-Action: no action
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
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:email,suse.com:mid];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+]
X-Spam-Flag: NO

The new feature is a new, and hopefully simpler solution to raid56 write
hole.

The VSL part stands for Variable Stripe Length, the whole feature is in
fact two features combined:

- Data size feature
  This forces all data reads and writes to follow @datasize from the
  super block.
  And @datasize is power of 2 times @sectorsize, and must be larger than
  @sectorsize.

  Meanwhile data checksum is still calculated based on @sectorsize.

  This @datasize can only be specified at mkfs time, there is no plan to
  provide offline conversion to this feature.

- RAID56_VSL chunks
  The new RAID56_VSL chunks will get rid of the fixed 64K stripe length,
  but uses a stripe length and device numbers so that the full stripe
  length is always matching the above @datasize.

  This will allow every data write to be full stripe aligned, thus
  completely resolve the write hole problem, at least for COW writes.

  The cost is that the number of devices for each RAID56_VSL chunk must
  be power of 2 + P/Q device(s).

  This means at mkfs time one has to determine the maximum number of
  devices the btrfs will support.
  Please note that, the btrfs can still have more than
  (datasize/sectorsize + 1/2) devices, it's the RAID56_VSL will not
  spread the data beyond (datasize/sectorsize) for each chunk.

  So for a datasize 64K and sectorsize 4K, the maximum device number is
  17 (RAID5) or 18 (RAID6), which should be reasonable enough for most
  use cases.

For now, this patch only implements the data size part for testing.

However if the new feature is enabled, some features will be
disabled/changed:

- LZO compression
  Since our data write path is using datasize, LZO compression will also
  require datasize as the minimal block size.
  But an older kernel will still treat the LZO payload using sectorsize,
  causing data read errors, as LZO payload is data size dependent.

- Mixed block group support
  Since data size is larger than sector size, thus it will not match
  nodesize, thus causing mount failure.

- Reported blocksize through super block/stat/statx
  The reported block size will be datasize, not sectorsize anymore,
  since our data IO size is datasize.

  This means for most cases, the fs acts if it has a larger block size.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/accessors.h            |  2 ++
 fs/btrfs/disk-io.c              | 27 ++++++++++++++++++++-------
 fs/btrfs/fs.h                   |  3 ++-
 fs/btrfs/sysfs.c                |  2 ++
 include/uapi/linux/btrfs.h      | 22 ++++++++++++++++++++++
 include/uapi/linux/btrfs_tree.h |  3 ++-
 6 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/accessors.h b/fs/btrfs/accessors.h
index 8938357fcb40..85edd861c093 100644
--- a/fs/btrfs/accessors.h
+++ b/fs/btrfs/accessors.h
@@ -889,6 +889,8 @@ BTRFS_SETGET_STACK_FUNCS(super_remap_root_generation, struct btrfs_super_block,
 			 remap_root_generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_remap_root_level, struct btrfs_super_block,
 			 remap_root_level, 8);
+BTRFS_SETGET_STACK_FUNCS(super_data_size, struct btrfs_super_block,
+			 data_size, 32);
 
 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_type, struct btrfs_file_extent_item,
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 42e05e26c442..aaba6e64504b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2528,6 +2528,16 @@ int btrfs_validate_super(const struct btrfs_fs_info *fs_info,
 		ret = -EINVAL;
 	}
 
+	if (btrfs_fs_incompat(fs_info, RAID56_VSL)) {
+		const u32 data_size = btrfs_super_data_size(sb);
+
+		if (unlikely(!is_power_of_2(data_size) || data_size <= sectorsize)) {
+			btrfs_err(fs_info,
+		"invalid data size, has %u expect power of 2 values larger than %u",
+				  data_size, sectorsize);
+			ret = -EINVAL;
+		}
+	}
 	if (btrfs_fs_incompat(fs_info, REMAP_TREE)) {
 		/*
 		 * Reduce test matrix for remap tree by requiring block-group-tree
@@ -3371,11 +3381,11 @@ static void invalidate_and_check_btree_folios(struct btrfs_fs_info *fs_info)
 	invalidate_inode_pages2(fs_info->btree_inode->i_mapping);
 }
 
-static u32 calc_block_max_order(u32 sectorsize_bits)
+static u32 calc_block_max_order(u32 datasize_bits)
 {
 	u32 max_size;
 
-	max_size = min(BTRFS_MAX_BLOCKS_PER_FOLIO << sectorsize_bits,
+	max_size = min(BTRFS_MAX_BLOCKS_PER_FOLIO << datasize_bits,
 		       BTRFS_MAX_FOLIO_SIZE);
 	return ilog2(round_up(max_size, PAGE_SIZE) >> PAGE_SHIFT);
 }
@@ -3497,11 +3507,14 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 
 	fs_info->nodesize = nodesize;
 	fs_info->nodesize_bits = ilog2(nodesize);
-	fs_info->datasize = sectorsize;
 	fs_info->sectorsize = sectorsize;
-	fs_info->datasize_bits = ilog2(sectorsize);
 	fs_info->sectorsize_bits = ilog2(sectorsize);
-	fs_info->block_min_order = ilog2(round_up(sectorsize, PAGE_SIZE) >> PAGE_SHIFT);
+	if (btrfs_fs_incompat(fs_info, RAID56_VSL))
+		fs_info->datasize = btrfs_super_data_size(disk_super);
+	else
+		fs_info->datasize = sectorsize;
+	fs_info->datasize_bits = ilog2(fs_info->datasize);
+	fs_info->block_min_order = ilog2(round_up(fs_info->datasize, PAGE_SIZE) >> PAGE_SHIFT);
 	/*
 	 * For HIGHMEM, a large folio cannot be mapped in one go, breaking a lot
 	 * of basic assumptions for btrfs IOs.
@@ -3560,8 +3573,8 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	sb->s_bdi->ra_pages = max(sb->s_bdi->ra_pages, SZ_4M / PAGE_SIZE);
 
 	/* Update the values for the current filesystem. */
-	sb->s_blocksize = sectorsize;
-	sb->s_blocksize_bits = blksize_bits(sectorsize);
+	sb->s_blocksize = fs_info->datasize;
+	sb->s_blocksize_bits = blksize_bits(fs_info->datasize);
 	/*
 	 * When temp_fsid is active, fs_devices->fsid is assigned a random UUID
 	 * at mount. This inconsistent UUID causes issues for layered filesystems
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index a99aa3a7b4c7..a3ac2b85d270 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -334,7 +334,8 @@ enum {
 	(BTRFS_FEATURE_INCOMPAT_SUPP_STABLE |	\
 	 BTRFS_FEATURE_INCOMPAT_RAID_STRIPE_TREE | \
 	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2 | \
-	 BTRFS_FEATURE_INCOMPAT_REMAP_TREE)
+	 BTRFS_FEATURE_INCOMPAT_REMAP_TREE |	\
+	 BTRFS_FEATURE_INCOMPAT_RAID56_VSL)
 
 #else
 
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 277d2f4cc12a..ac833c35ca2f 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -188,6 +188,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(extent_tree_v2, EXTENT_TREE_V2);
 BTRFS_FEAT_ATTR_INCOMPAT(raid_stripe_tree, RAID_STRIPE_TREE);
 /* Remove once support for remap tree is feature complete. */
 BTRFS_FEAT_ATTR_INCOMPAT(remap_tree, REMAP_TREE);
+BTRFS_FEAT_ATTR_INCOMPAT(raid56_vsl, RAID56_VSL);
 #endif
 #ifdef CONFIG_FS_VERITY
 BTRFS_FEAT_ATTR_COMPAT_RO(verity, VERITY);
@@ -221,6 +222,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(extent_tree_v2),
 	BTRFS_FEAT_ATTR_PTR(raid_stripe_tree),
 	BTRFS_FEAT_ATTR_PTR(remap_tree),
+	BTRFS_FEAT_ATTR_PTR(raid56_vsl),
 #endif
 #ifdef CONFIG_FS_VERITY
 	BTRFS_FEAT_ATTR_PTR(verity),
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 0a13baf3d8d1..99e51a73dc06 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -338,6 +338,28 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_SIMPLE_QUOTA	(1ULL << 16)
 #define BTRFS_FEATURE_INCOMPAT_REMAP_TREE	(1ULL << 17)
 
+/*
+ * This feature includes two parts:
+ * - Force data read/writes to be aligned to data size
+ *   And the data size is power of 2 times of sectorsize.
+ *   This feature must be determined at mkfs time, and will limit the number
+ *   of data stripes for RAID56 VSL chunks.
+ *
+ *   This can be implemented as a compat RO feature, but doesn't make much
+ *   sense as an independent feature.
+ *
+ * - Variable stripe length RAID56 profiles
+ *   This forces the full stripe length to match the above data size.
+ *   This will allow all data writes to be full stripe aligned, thus
+ *   no more write holes.
+ *
+ *   The cost is that data stripes will be limited by (datasize / sectorsize),
+ *   and larger IO sizes.
+ *
+ * For now, only the data size part is implemented.
+ */
+#define BTRFS_FEATURE_INCOMPAT_RAID56_VSL	(1ULL << 18)
+
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
 	__u64 compat_ro_flags;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index fa4984c80c9d..75e76ac2104a 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -724,9 +724,10 @@ struct btrfs_super_block {
 	__le64 remap_root;
 	__le64 remap_root_generation;
 	__u8 remap_root_level;
+	__u32 data_size;
 
 	/* Future expansion */
-	__u8 reserved[199];
+	__u8 reserved[195];
 	__u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 
-- 
2.55.0

