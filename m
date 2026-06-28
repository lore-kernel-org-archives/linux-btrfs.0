Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF9012F585
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2026 06:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782628018; cv=none; b=DJPhIDYYgQrWdfWREAlbIuBoTgZUqC5GmddaRjlkjtMyLYmSeYMfOFChi9nrEX5TiaUktkqjZ5/9cXX2MNXkVkN4BZeg+MrBGYfT1sho5HXPCdV2uTLF2ZckWgcA5ZXHmu/B9836FbSLCR1QyTG03NS7eGvn5LxpHrmS+2tIu70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782628018; c=relaxed/simple;
	bh=5jOFAt+cNadcI40fZQd4DMEBHnlUsaOBW0mBs8A5Ang=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=s+PNZBZmwa2mxsnJsF2ZqMxK3/EoCBXTE6pHdCXeRz7x71718VP4XFL3WNv/aRJgsEV0JCWMsloiDHjplUYRKs4Mg6MwuAYy6JYNfRPSWezfluW76XX8tPbs2hVhMdPqogZQewxBcOD+701/q7SBFKfZXTpDkR2ehx2cyTFKRfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rWqQOTos; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=TB68hAmS; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rWqQOTos";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="TB68hAmS"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BA07275860
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2026 06:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782628015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FN9394PNwkBbc7qxsek/YhVJRmVU0VyWKJI5/sogc3Y=;
	b=rWqQOTosJu8LRojfkJbvYmwP/tbCL4iaCp5AUirIGkQnUPfoWYiIgHLzkIFk0mj/bzCHwq
	9Cp7kWIcKQJzslTI/iL84X0iEqIpuSSZlXjTZtqiiCfl1ZIBm1WnqFQFJYBNK5rFmqCtn+
	HwwkKRzfqiKqaBVizdgr58zfqR5tOIk=
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=TB68hAmS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782628014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=FN9394PNwkBbc7qxsek/YhVJRmVU0VyWKJI5/sogc3Y=;
	b=TB68hAmSzIxKP3wrlAYdZCOyxhrDVSQnzY6m9Kc9fnkU5NvhB0st8eI5edBve/Pa8O67Pj
	Jwos5jsZSjhNpDBm82Rh1AT9uPBRJ8n3jK+qEg2vPLWFX1Mllu5bnAZhXoJqTvzZ8NlawU
	tJfpfEQ7U9WxQOQuqkYKgP0T3ll4q5w=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B8531779A8
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2026 06:26:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ELD4Ga2+QGpfBgAAD6G6ig
	(envelope-from <wqu@suse.com>)
	for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2026 06:26:53 +0000
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH RFC] btrfs-progs: introduce data_io_size compat ro flags and mkfs support
Date: Sun, 28 Jun 2026 15:56:31 +0930
Message-ID: <a98607908d20df39e665dd8b041387771fd02e68.1782627984.git.wqu@suse.com>
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
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
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
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	PREVIOUSLY_DELIVERED(0.00)[linux-btrfs@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:dkim,suse.com:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: BA07275860
X-Spam-Score: -3.01

This introduces the progs part of the data io size feature.

For now only mkfs.btrfs can support this feature, and this feature can
not be enabled on an existing fs through btrfstune.

Mkfs.btrfs will have a new option "--data-io-size" to enable this
feature on experimental builds.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
Reason for RFC:

This is just the progs support for data-io-size feature, but the idea is
still far from concrete, and still need a lot of discussion before full
implementation.
---
 common/help.h                   |  1 +
 kernel-shared/accessors.h       |  2 ++
 kernel-shared/ctree.h           |  9 ++++++++-
 kernel-shared/print-tree.c      |  1 +
 kernel-shared/uapi/btrfs.h      |  7 +++++++
 kernel-shared/uapi/btrfs_tree.h |  3 ++-
 mkfs/common.c                   |  2 ++
 mkfs/common.h                   |  1 +
 mkfs/main.c                     | 22 ++++++++++++++++++++++
 9 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/common/help.h b/common/help.h
index 67ad0747837e..9fa38969d251 100644
--- a/common/help.h
+++ b/common/help.h
@@ -38,6 +38,7 @@ struct cmd_group;
 #define GETOPT_VAL_HELP				520
 #define GETOPT_VAL_PARAM			521
 #define GETOPT_VAL_DRY_RUN			522
+#define GETOPT_VAL_DATA_IO_SIZE			523

 #define ARGV0_BUF_SIZE	PATH_MAX

diff --git a/kernel-shared/accessors.h b/kernel-shared/accessors.h
index 23d7fd4a622b..83efc6127583 100644
--- a/kernel-shared/accessors.h
+++ b/kernel-shared/accessors.h
@@ -960,6 +960,8 @@ BTRFS_SETGET_STACK_FUNCS(super_remap_root_generation, struct btrfs_super_block,
 			 remap_root_generation, 64);
 BTRFS_SETGET_STACK_FUNCS(super_remap_root_level, struct btrfs_super_block,
 			 remap_root_level, 8);
+BTRFS_SETGET_STACK_FUNCS(super_data_io_size, struct btrfs_super_block,
+			 data_io_size, 32);

 /* struct btrfs_file_extent_item */
 BTRFS_SETGET_STACK_FUNCS(stack_file_extent_type, struct btrfs_file_extent_item,
diff --git a/kernel-shared/ctree.h b/kernel-shared/ctree.h
index 37baae9335ec..411c908170e0 100644
--- a/kernel-shared/ctree.h
+++ b/kernel-shared/ctree.h
@@ -71,7 +71,7 @@ static inline u32 __BTRFS_LEAF_DATA_SIZE(u32 nodesize)
 #define BTRFS_SUPER_INFO_OFFSET			(65536)
 #define BTRFS_SUPER_INFO_SIZE			(4096)

-#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
+#define BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE		\
 	(BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE |	\
 	 BTRFS_FEATURE_COMPAT_RO_FREE_SPACE_TREE_VALID | \
 	 BTRFS_FEATURE_COMPAT_RO_VERITY |		\
@@ -99,9 +99,16 @@ static inline u32 __BTRFS_LEAF_DATA_SIZE(u32 nodesize)
 	 BTRFS_FEATURE_INCOMPAT_EXTENT_TREE_V2 |	\
 	 BTRFS_FEATURE_INCOMPAT_RAID_STRIPE_TREE |	\
 	 BTRFS_FEATURE_INCOMPAT_REMAP_TREE)
+
+#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
+	(BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE |		\
+	 BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE)
 #else
 #define BTRFS_FEATURE_INCOMPAT_SUPP			\
 	(BTRFS_FEATURE_INCOMPAT_SUPP_STABLE)
+
+#define BTRFS_FEATURE_COMPAT_RO_SUPP			\
+	(BTRFS_FEATURE_COMPAT_RO_SUPP_STABLE)
 #endif

 /*
diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
index 0afa36963b6a..6efa6ffe8706 100644
--- a/kernel-shared/print-tree.c
+++ b/kernel-shared/print-tree.c
@@ -1932,6 +1932,7 @@ static struct readable_flag_entry compat_ro_flags_array[] = {
 	DEF_COMPAT_RO_FLAG_ENTRY(FREE_SPACE_TREE_VALID),
 	DEF_COMPAT_RO_FLAG_ENTRY(VERITY),
 	DEF_COMPAT_RO_FLAG_ENTRY(BLOCK_GROUP_TREE),
+	DEF_COMPAT_RO_FLAG_ENTRY(DATA_IO_SIZE),
 };
 static const int compat_ro_flags_num = ARRAY_SIZE(compat_ro_flags_array);

diff --git a/kernel-shared/uapi/btrfs.h b/kernel-shared/uapi/btrfs.h
index a765fbc440e8..d4677b1b826d 100644
--- a/kernel-shared/uapi/btrfs.h
+++ b/kernel-shared/uapi/btrfs.h
@@ -338,6 +338,13 @@ _static_assert(sizeof(struct btrfs_ioctl_fs_info_args) == 1024);
  */
 #define BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE	(1ULL << 3)

+/*
+ * Force all IOs (including buffered, direct, compressed) to be aligned
+ * to btrfs_super_block::data_io_size other than sectorsize.
+ * Meanwhile still data checksum to be calculated based on sectorsize.
+ */
+#define BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE		(1ULL << 4)
+
 #define BTRFS_FEATURE_INCOMPAT_MIXED_BACKREF	(1ULL << 0)
 #define BTRFS_FEATURE_INCOMPAT_DEFAULT_SUBVOL	(1ULL << 1)
 #define BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS	(1ULL << 2)
diff --git a/kernel-shared/uapi/btrfs_tree.h b/kernel-shared/uapi/btrfs_tree.h
index 1ca637118622..2876b9aced52 100644
--- a/kernel-shared/uapi/btrfs_tree.h
+++ b/kernel-shared/uapi/btrfs_tree.h
@@ -721,9 +721,10 @@ struct btrfs_super_block {
 	__le64 remap_root;
 	__le64 remap_root_generation;
 	__u8 remap_root_level;
+	__u32 data_io_size;

 	/* Future expansion */
-	__u8 reserved[199];
+	__u8 reserved[195];
 	__u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];

diff --git a/mkfs/common.c b/mkfs/common.c
index 85cfa60d25aa..e9597a2c25b1 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -494,6 +494,8 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	if (free_space_tree)
 		btrfs_set_super_cache_generation(&super, 0);
 	btrfs_set_super_compat_ro_flags(&super, cfg->features.compat_ro_flags);
+	if (cfg->data_io_size)
+		btrfs_set_super_data_io_size(&super, cfg->data_io_size);

 	if (extent_tree_v2)
 		btrfs_set_super_nr_global_roots(&super, 1);
diff --git a/mkfs/common.h b/mkfs/common.h
index d08a5fd87203..0585b7ffc03a 100644
--- a/mkfs/common.h
+++ b/mkfs/common.h
@@ -79,6 +79,7 @@ struct btrfs_mkfs_config {
 	u32 sectorsize;
 	u32 stripesize;
 	u32 leaf_data_size;
+	u32 data_io_size;
 	struct btrfs_mkfs_features features;
 	/* Size of the filesystem in bytes */
 	u64 num_bytes;
diff --git a/mkfs/main.c b/mkfs/main.c
index b8b4cb7d1409..ac4736e07641 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1534,6 +1534,7 @@ int BOX_MAIN(mkfs)(int argc, char **argv)
 	bool nodesize_forced = false;
 	u32 sectorsize = 0;
 	u32 stripesize = 4096;
+	u32 data_io_size = 0;
 	u64 metadata_profile = 0;
 	bool metadata_profile_set = false;
 	u64 data_profile = 0;
@@ -1600,6 +1601,7 @@ int BOX_MAIN(mkfs)(int argc, char **argv)
 #if EXPERIMENTAL
 			{ "param", required_argument, NULL, GETOPT_VAL_PARAM },
 			{ "num-global-roots", required_argument, NULL, GETOPT_VAL_GLOBAL_ROOTS },
+			{ "data-io-size", required_argument, NULL, GETOPT_VAL_DATA_IO_SIZE },
 #endif
 			{ "help", no_argument, NULL, GETOPT_VAL_HELP },
 			{ NULL, 0, NULL, 0}
@@ -1753,6 +1755,9 @@ int BOX_MAIN(mkfs)(int argc, char **argv)
 			case GETOPT_VAL_REFLINK:
 				do_reflink = true;
 				break;
+			case GETOPT_VAL_DATA_IO_SIZE:
+				data_io_size = arg_strtou64_with_suffix(optarg);
+				break;
 			case GETOPT_VAL_HELP:
 			default:
 				usage(&mkfs_cmd, c != GETOPT_VAL_HELP);
@@ -1996,6 +2001,21 @@ int BOX_MAIN(mkfs)(int argc, char **argv)
 		features.compat_ro_flags &= ~BTRFS_FEATURE_COMPAT_RO_BLOCK_GROUP_TREE;
 	}

+	if (data_io_size) {
+		if (source_dir) {
+			error("the option --data-io-size and -r are incompatible for now");
+			exit(1);
+		}
+		if (!is_power_of_2(data_io_size) || data_io_size < sectorsize ||
+		    data_io_size > BTRFS_MAX_METADATA_BLOCKSIZE) {
+			error("data io size invalid, has %u expect power of 2 in range [%u, %u]",
+			      data_io_size, sectorsize, BTRFS_MAX_METADATA_BLOCKSIZE);
+			exit(1);
+		}
+		mkfs_cfg.data_io_size = data_io_size;
+		features.compat_ro_flags |= BTRFS_FEATURE_COMPAT_RO_DATA_IO_SIZE;
+	}
+
 	if (opt_zoned) {
 		const int blkid_version =  blkid_get_library_version(NULL, NULL);

@@ -2532,6 +2552,8 @@ raid_groups:
 		printf("Node size:          %u\n", nodesize);
 		printf("Sector size:        %u\t(CPU page size: %lu)\n",
 		       sectorsize, sysconf(_SC_PAGESIZE));
+		if (data_io_size)
+			printf("Data io size:       %u\n", data_io_size);
 		printf("Filesystem size:    %s\n",
 			pretty_size(btrfs_super_total_bytes(fs_info->super_copy)));
 		printf("Block group profiles:\n");
--
2.54.0

