Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48404 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758984AbbKTD06 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Nov 2015 22:26:58 -0500
Received: from localhost.localdomain (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id tAK3PqdH022290
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Nov 2015 11:26:11 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 08/25] btrfs-progs: Introduce function to setup temporary superblock
Date: Fri, 20 Nov 2015 11:24:12 +0800
Message-Id: <1447989869-24739-9-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new function, setup_temp_super(), to setup temporary super
for make_btrfs_v2().

Unlike the old codes in make_btrfs(), it will also initialize
system_chunk_array before chunk tree allocation.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 utils.c | 117 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/utils.c b/utils.c
index 5619b85..6c4da04 100644
--- a/utils.c
+++ b/utils.c
@@ -400,6 +400,98 @@ static int reserve_free_space(struct cache_tree *free_tree, u64 len,
 	return 0;
 }
 
+static inline int write_temp_super(int fd, struct btrfs_super_block *sb,
+				   u64 sb_bytenr)
+{
+	u32 crc = ~(u32)0;
+	int ret;
+
+	crc = btrfs_csum_data(NULL, (char *)sb + BTRFS_CSUM_SIZE, crc,
+			      BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
+	btrfs_csum_final(crc, (char *)&sb->csum[0]);
+	ret = pwrite(fd, sb, BTRFS_SUPER_INFO_SIZE, sb_bytenr);
+	if (ret < BTRFS_SUPER_INFO_SIZE)
+		ret = (ret < 0 ? -errno : - EIO);
+	else
+		ret = 0;
+	return ret;
+}
+
+/*
+ * Setup temporary superblock at cfg->super_bynter
+ * Needed info are extracted from cfg, and root_bytenr, chunk_bytenr
+ *
+ * For now sys chunk array will be empty and dev_item is empty
+ * too.
+ * They will be re-initialized at temp chunk tree setup.
+ */
+static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
+			    u64 root_bytenr, u64 chunk_bytenr)
+{
+	unsigned char chunk_uuid[BTRFS_UUID_SIZE];
+	char super_buf[BTRFS_SUPER_INFO_SIZE];
+	struct btrfs_super_block *super = (struct btrfs_super_block*)super_buf;
+	int ret;
+
+	/*
+	 * We rely on cfg->chunk_uuid and cfg->fs_uuid to pass uuid
+	 * for other functions.
+	 * Caller must allocation space for them
+	 */
+	BUG_ON(!cfg->chunk_uuid || !cfg->fs_uuid);
+	memset(super_buf, 0, BTRFS_SUPER_INFO_SIZE);
+	cfg->num_bytes = round_down(cfg->num_bytes, cfg->sectorsize);
+
+	if (cfg->fs_uuid && *cfg->fs_uuid) {
+		if (uuid_parse(cfg->fs_uuid, super->fsid) != 0) {
+			error("cound not parse UUID: %s", cfg->fs_uuid);
+			ret = -EINVAL;
+			goto out;
+		}
+		if (!test_uuid_unique(cfg->fs_uuid)) {
+			error("non-unique UUID: %s", cfg->fs_uuid);
+			ret = -EINVAL;
+			goto out;
+		}
+	} else {
+		uuid_generate(super->fsid);
+		uuid_unparse(super->fsid, cfg->fs_uuid);
+	}
+	uuid_generate(chunk_uuid);
+	uuid_unparse(chunk_uuid, cfg->chunk_uuid);
+
+	btrfs_set_super_bytenr(super, cfg->super_bytenr);
+	btrfs_set_super_num_devices(super, 1);
+	btrfs_set_super_magic(super, BTRFS_MAGIC);
+	btrfs_set_super_generation(super, 1);
+	btrfs_set_super_root(super, root_bytenr);
+	btrfs_set_super_chunk_root(super, chunk_bytenr);
+	btrfs_set_super_total_bytes(super, cfg->num_bytes);
+	/*
+	 * Temporary btrfs will only has 6 tree roots:
+	 * chunk tree, root tree, extent_tree, device tree, fs tree
+	 * and csum tree.
+	 */
+	btrfs_set_super_bytes_used(super, 6 * cfg->nodesize);
+	btrfs_set_super_sectorsize(super, cfg->sectorsize);
+	btrfs_set_super_leafsize(super, cfg->nodesize);
+	btrfs_set_super_nodesize(super, cfg->nodesize);
+	btrfs_set_super_stripesize(super, cfg->stripesize);
+	btrfs_set_super_csum_type(super, BTRFS_CSUM_TYPE_CRC32);
+	btrfs_set_super_chunk_root(super, chunk_bytenr);
+	btrfs_set_super_cache_generation(super, -1);
+	btrfs_set_super_incompat_flags(super, cfg->features);
+	if (cfg->label)
+		strncpy(super->label, cfg->label, BTRFS_LABEL_SIZE - 1);
+
+	/* Sys chunk array will be re-initialized at chunk tree init time */
+	super->sys_chunk_array_size = 0;
+
+	ret = write_temp_super(fd, super, cfg->super_bytenr);
+out:
+	return ret;
+}
+
 /*
  * Improved version of make_btrfs().
  *
@@ -415,6 +507,10 @@ static int make_btrfs_v2(int fd, struct btrfs_mkfs_config *cfg)
 	struct cache_tree *used_tree = &cfg->convert_used;
 	u64 sys_chunk_start;
 	u64 meta_chunk_start;
+	/* chunk tree bytenr, in system chunk */
+	u64 chunk_bytenr;
+	/* metadata trees bytenr, in metadata chunk */
+	u64 root_bytenr;
 	int ret;
 
 	/* Shouldn't happen */
@@ -446,6 +542,27 @@ static int make_btrfs_v2(int fd, struct btrfs_mkfs_config *cfg)
 	if (ret < 0)
 		goto out;
 
+	/*
+	 * Inside the allocate metadata chunk, its layout will be:
+	 *  | offset		| contents	|
+	 *  -------------------------------------
+	 *  | +0		| tree root	|
+	 *  | +nodesize		| extent root	|
+	 *  | +nodesize * 2	| device root	|
+	 *  | +nodesize * 3	| fs tree	|
+	 *  | +nodesize * 4	| csum tree	|
+	 *  -------------------------------------
+	 * Inside the allocated system chunk, its layout will be:
+	 *  | offset		| contents	|
+	 *  -------------------------------------
+	 *  | +0		| chunk root	|
+	 *  -------------------------------------
+	 */
+	chunk_bytenr = sys_chunk_start;
+	root_bytenr = meta_chunk_start;
+	ret = setup_temp_super(fd, cfg, root_bytenr, chunk_bytenr);
+	if (ret < 0)
+		goto out;
 out:
 	free(free_tree);
 	return ret;
-- 
2.6.2

