Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5EEC677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67FA02075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:04:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67FA02075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbeJKWbo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:50038 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727796AbeJKWbo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CA53EB0E5
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:04:07 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/8] btrfs-progs: Add support for metadata_uuid field.
Date:   Thu, 11 Oct 2018 18:03:59 +0300
Message-Id: <1539270244-27076-4-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270244-27076-1-git-send-email-nborisov@suse.com>
References: <1539270244-27076-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add support for a new metadata_uuid field. This is just a preparatory
commit which switches all users of the fsid field for metdata comparison
purposes to utilize the new field. This more or less mirrors the
kernel patch, additionally:

 * Update 'btrfs inspect-internal dump-super' to account for the new
 field. This involes introducing the 'metadata_uuid' line to the
 output and updating the logic for comparing the fs uuid to the
 dev_item uuid.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfstune.c               |  3 +++
 check/main.c              |  2 +-
 chunk-recover.c           | 16 ++++++++++---
 cmds-filesystem.c         |  2 ++
 cmds-inspect-dump-super.c | 22 ++++++++++++++---
 convert/common.c          |  2 ++
 ctree.c                   | 14 +++++------
 ctree.h                   |  8 +++++--
 disk-io.c                 | 60 ++++++++++++++++++++++++++++++++++++++---------
 image/main.c              | 25 +++++++++++++-------
 volumes.c                 | 34 +++++++++++++++++++++------
 volumes.h                 |  1 +
 12 files changed, 146 insertions(+), 43 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 3745a00c46ae..62a075b2defc 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -248,6 +248,9 @@ static int change_fsid_prepare(struct btrfs_fs_info *fs_info)
 	if (ret < 0)
 		return ret;
 
+	/* Also need to change the metadatauuid of the fs info */
+	memcpy(fs_info->metadata_uuid, fs_info->new_fsid, BTRFS_FSID_SIZE);
+
 	/* also restore new chunk_tree_id into tree_root for restore */
 	write_extent_buffer(tree_root->node, fs_info->new_chunk_tree_uuid,
 			    btrfs_header_chunk_tree_uuid(tree_root->node),
diff --git a/check/main.c b/check/main.c
index bc2ee22f7943..0790264190f2 100644
--- a/check/main.c
+++ b/check/main.c
@@ -8418,7 +8418,7 @@ static int btrfs_fsck_reinit_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(c, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(c, root->root_key.objectid);
 
-	write_extent_buffer(c, root->fs_info->fsid,
+	write_extent_buffer(c, root->fs_info->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
diff --git a/chunk-recover.c b/chunk-recover.c
index 1d30db51d8ed..31325bfc54e0 100644
--- a/chunk-recover.c
+++ b/chunk-recover.c
@@ -759,7 +759,7 @@ static int scan_one_device(void *dev_scan_struct)
 		    rc->nodesize)
 			break;
 
-		if (memcmp_extent_buffer(buf, rc->fs_devices->fsid,
+		if (memcmp_extent_buffer(buf, rc->fs_devices->metadata_uuid,
 					 btrfs_header_fsid(),
 					 BTRFS_FSID_SIZE)) {
 			bytenr += rc->sectorsize;
@@ -1155,7 +1155,7 @@ static int __rebuild_chunk_root(struct btrfs_trans_handle *trans,
 	btrfs_set_header_level(cow, 0);
 	btrfs_set_header_backref_rev(cow, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(cow, BTRFS_CHUNK_TREE_OBJECTID);
-	write_extent_buffer(cow, root->fs_info->fsid,
+	write_extent_buffer(cow, root->fs_info->metadata_uuid,
 			btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(cow, root->fs_info->chunk_tree_uuid,
@@ -1192,7 +1192,8 @@ static int __rebuild_device_items(struct btrfs_trans_handle *trans,
 		btrfs_set_stack_device_io_width(dev_item, dev->io_width);
 		btrfs_set_stack_device_sector_size(dev_item, dev->sector_size);
 		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
-		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_UUID_SIZE);
+		memcpy(dev_item->fsid, dev->fs_devices->metadata_uuid,
+		       BTRFS_FSID_SIZE);
 
 		ret = btrfs_insert_item(trans, root, &key,
 					dev_item, sizeof(*dev_item));
@@ -1432,6 +1433,7 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 	struct btrfs_fs_info *fs_info;
 	struct btrfs_super_block *disk_super;
 	struct extent_buffer *eb;
+	u64 features;
 	int ret;
 
 	fs_info = btrfs_new_fs_info(1, BTRFS_SUPER_INFO_OFFSET);
@@ -1464,6 +1466,14 @@ open_ctree_with_broken_chunk(struct recover_control *rc)
 	if (ret)
 		goto out_devices;
 
+	features = btrfs_super_incompat_flags(disk_super);
+
+	if (features & BTRFS_FEATURE_INCOMPAT_METADATA_UUID)
+		memcpy(fs_info->metadata_uuid, disk_super->metadata_uuid,
+		       BTRFS_FSID_SIZE);
+	else
+		memcpy(fs_info->metadata_uuid, fs_info->fsid, BTRFS_FSID_SIZE);
+
 	btrfs_setup_root(fs_info->chunk_root, fs_info,
 			 BTRFS_CHUNK_TREE_OBJECTID);
 
diff --git a/cmds-filesystem.c b/cmds-filesystem.c
index 06c8311bdfe3..10946b31976f 100644
--- a/cmds-filesystem.c
+++ b/cmds-filesystem.c
@@ -172,6 +172,7 @@ static int match_search_item_kernel(u8 *fsid, char *mnt, char *label,
 	return 0;
 }
 
+/* Search for user visible uuid 'search' in registered filesystems */
 static int uuid_search(struct btrfs_fs_devices *fs_devices, const char *search)
 {
 	char uuidbuf[BTRFS_UUID_UNPARSED_SIZE];
@@ -497,6 +498,7 @@ static int copy_fs_devices(struct btrfs_fs_devices *dst,
 	int ret = 0;
 
 	memcpy(dst->fsid, src->fsid, BTRFS_FSID_SIZE);
+	memcpy(dst->metadata_uuid, src->metadata_uuid, BTRFS_FSID_SIZE);
 	INIT_LIST_HEAD(&dst->devices);
 	dst->seed = NULL;
 
diff --git a/cmds-inspect-dump-super.c b/cmds-inspect-dump-super.c
index e965267c5d96..97e9624db8d7 100644
--- a/cmds-inspect-dump-super.c
+++ b/cmds-inspect-dump-super.c
@@ -228,7 +228,8 @@ static struct readable_flag_entry incompat_flags_array[] = {
 	DEF_INCOMPAT_FLAG_ENTRY(EXTENDED_IREF),
 	DEF_INCOMPAT_FLAG_ENTRY(RAID56),
 	DEF_INCOMPAT_FLAG_ENTRY(SKINNY_METADATA),
-	DEF_INCOMPAT_FLAG_ENTRY(NO_HOLES)
+	DEF_INCOMPAT_FLAG_ENTRY(NO_HOLES),
+	DEF_INCOMPAT_FLAG_ENTRY(METADATA_UUID)
 };
 static const int incompat_flags_num = sizeof(incompat_flags_array) /
 				      sizeof(struct readable_flag_entry);
@@ -319,6 +320,10 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	u8 *p;
 	u32 csum_size;
 	u16 csum_type;
+	bool metadata_uuid_present = (btrfs_super_incompat_flags(sb) &
+		BTRFS_FEATURE_INCOMPAT_METADATA_UUID);
+	int cmp_res = 0;
+
 
 	csum_type = btrfs_super_csum_type(sb);
 	csum_size = BTRFS_CSUM_SIZE;
@@ -365,6 +370,12 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 
 	uuid_unparse(sb->fsid, buf);
 	printf("fsid\t\t\t%s\n", buf);
+	if (metadata_uuid_present) {
+		uuid_unparse(sb->metadata_uuid, buf);
+		printf("metadata_uuid\t\t%s\n", buf);
+	} else {
+		printf("metadata_uuid\t\t%s\n", buf);
+	}
 
 	printf("label\t\t\t");
 	s = sb->label;
@@ -424,9 +435,14 @@ static void dump_superblock(struct btrfs_super_block *sb, int full)
 	printf("dev_item.uuid\t\t%s\n", buf);
 
 	uuid_unparse(sb->dev_item.fsid, buf);
+	if (metadata_uuid_present) {
+		cmp_res = !memcmp(sb->dev_item.fsid, sb->metadata_uuid,
+				 BTRFS_FSID_SIZE);
+	} else {
+		cmp_res = !memcmp(sb->dev_item.fsid, sb->fsid, BTRFS_FSID_SIZE);
+	}
 	printf("dev_item.fsid\t\t%s %s\n", buf,
-		!memcmp(sb->dev_item.fsid, sb->fsid, BTRFS_FSID_SIZE) ?
-			"[match]" : "[DON'T MATCH]");
+	       cmp_res ? "[match]" : "[DON'T MATCH]");
 
 	printf("dev_item.type\t\t%llu\n", (unsigned long long)
 	       btrfs_stack_device_type(&sb->dev_item));
diff --git a/convert/common.c b/convert/common.c
index 6ddf4a46ce3c..77cbaf14f3c7 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -107,9 +107,11 @@ static int setup_temp_super(int fd, struct btrfs_mkfs_config *cfg,
 			ret = -EINVAL;
 			goto out;
 		}
+		uuid_copy(super->metadata_uuid, super->fsid);
 	} else {
 		uuid_generate(super->fsid);
 		uuid_unparse(super->fsid, cfg->fs_uuid);
+		uuid_copy(super->metadata_uuid, super->fsid);
 	}
 	uuid_generate(chunk_uuid);
 	uuid_unparse(chunk_uuid, cfg->chunk_uuid);
diff --git a/ctree.c b/ctree.c
index d8a6883aa85f..883c2ae1861d 100644
--- a/ctree.c
+++ b/ctree.c
@@ -134,7 +134,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, new_root_objectid);
 
-	write_extent_buffer(cow, root->fs_info->fsid,
+	write_extent_buffer(cow, root->fs_info->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
@@ -308,7 +308,7 @@ int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, root->root_key.objectid);
 
-	write_extent_buffer(cow, root->fs_info->fsid,
+	write_extent_buffer(cow, root->fs_info->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	WARN_ON(!(buf->flags & EXTENT_BAD_TRANSID) &&
@@ -1458,7 +1458,7 @@ static int noinline insert_new_root(struct btrfs_trans_handle *trans,
 		btrfs_node_key(lower, &lower_key, 0);
 
 	c = btrfs_alloc_free_block(trans, root, root->fs_info->nodesize,
-				   root->root_key.objectid, &lower_key, 
+				   root->root_key.objectid, &lower_key,
 				   level, root->node->start, 0);
 
 	if (IS_ERR(c))
@@ -1474,7 +1474,7 @@ static int noinline insert_new_root(struct btrfs_trans_handle *trans,
 
 	root_add_used(root, root->fs_info->nodesize);
 
-	write_extent_buffer(c, root->fs_info->fsid,
+	write_extent_buffer(c, root->fs_info->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(c, root->fs_info->chunk_tree_uuid,
@@ -1595,7 +1595,7 @@ static int split_node(struct btrfs_trans_handle *trans, struct btrfs_root
 	btrfs_set_header_generation(split, trans->transid);
 	btrfs_set_header_backref_rev(split, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(split, root->root_key.objectid);
-	write_extent_buffer(split, root->fs_info->fsid,
+	write_extent_buffer(split, root->fs_info->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 	write_extent_buffer(split, root->fs_info->chunk_tree_uuid,
 			    btrfs_header_chunk_tree_uuid(split),
@@ -2157,7 +2157,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 			}
 		}
 	}
-	
+
 	if (split == 0)
 		btrfs_cpu_key_to_disk(&disk_key, ins_key);
 	else
@@ -2177,7 +2177,7 @@ static noinline int split_leaf(struct btrfs_trans_handle *trans,
 	btrfs_set_header_backref_rev(right, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(right, root->root_key.objectid);
 	btrfs_set_header_level(right, 0);
-	write_extent_buffer(right, root->fs_info->fsid,
+	write_extent_buffer(right, root->fs_info->metadata_uuid,
 			    btrfs_header_fsid(), BTRFS_FSID_SIZE);
 
 	write_extent_buffer(right, root->fs_info->chunk_tree_uuid,
diff --git a/ctree.h b/ctree.h
index 4719962df67d..c22d36b1871b 100644
--- a/ctree.h
+++ b/ctree.h
@@ -454,8 +454,9 @@ struct btrfs_super_block {
 	__le64 cache_generation;
 	__le64 uuid_tree_generation;
 
+	u8 metadata_uuid[BTRFS_FSID_SIZE];
 	/* future expansion */
-	__le64 reserved[30];
+	__le64 reserved[28];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 } __attribute__ ((__packed__));
@@ -489,6 +490,7 @@ struct btrfs_super_block {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_METADATA_UUID    (1ULL << 10)
 
 #define BTRFS_FEATURE_COMPAT_SUPP		0ULL
 
@@ -509,7 +511,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES |		\
+	 BTRFS_FEATURE_INCOMPAT_METADATA_UUID)
 
 /*
  * A leaf is full of items. offset and size tell us where to find
@@ -1077,6 +1080,7 @@ struct btrfs_device;
 struct btrfs_fs_devices;
 struct btrfs_fs_info {
 	u8 fsid[BTRFS_FSID_SIZE];
+	u8 metadata_uuid[BTRFS_FSID_SIZE];
 	u8 *new_fsid;
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
 	u8 *new_chunk_tree_uuid;
diff --git a/disk-io.c b/disk-io.c
index 26e4f6e93ed6..c3be4a1017b7 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -55,8 +55,9 @@ static int check_tree_block(struct btrfs_fs_info *fs_info,
 			    struct extent_buffer *buf)
 {
 
-	struct btrfs_fs_devices *fs_devices;
+	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	u32 nodesize = fs_info->nodesize;
+	bool fsid_match = false;
 	int ret = BTRFS_BAD_FSID;
 
 	if (buf->start != btrfs_header_bytenr(buf))
@@ -72,12 +73,26 @@ static int check_tree_block(struct btrfs_fs_info *fs_info,
 	    btrfs_header_level(buf) != 0)
 		return BTRFS_BAD_NRITEMS;
 
-	fs_devices = fs_info->fs_devices;
 	while (fs_devices) {
-		if (fs_info->ignore_fsid_mismatch ||
-		    !memcmp_extent_buffer(buf, fs_devices->fsid,
-					  btrfs_header_fsid(),
-					  BTRFS_FSID_SIZE)) {
+	         /*
+                 * Checking the incompat flag is only valid for the current
+                 * fs. For seed devices it's forbidden to have their uuid
+                 * changed so reading ->fsid in this case is fine
+                 */
+		if (fs_devices == fs_info->fs_devices &&
+		    btrfs_fs_incompat(fs_info, METADATA_UUID))
+			fsid_match = !memcmp_extent_buffer(buf,
+						   fs_devices->metadata_uuid,
+						   btrfs_header_fsid(),
+						   BTRFS_FSID_SIZE);
+		else
+			fsid_match = !memcmp_extent_buffer(buf,
+						    fs_devices->fsid,
+						    btrfs_header_fsid(),
+						    BTRFS_FSID_SIZE);
+
+
+		if (fs_info->ignore_fsid_mismatch || fsid_match) {
 			ret = 0;
 			break;
 		}
@@ -103,7 +118,7 @@ static void print_tree_block_error(struct btrfs_fs_info *fs_info,
 		read_extent_buffer(eb, buf, btrfs_header_fsid(),
 				   BTRFS_UUID_SIZE);
 		uuid_unparse(buf, found_uuid);
-		uuid_unparse(fs_info->fsid, fs_uuid);
+		uuid_unparse(fs_info->metadata_uuid, fs_uuid);
 		fprintf(stderr, "fsid mismatch, want=%s, have=%s\n",
 			fs_uuid, found_uuid);
 		break;
@@ -1169,6 +1184,12 @@ static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
 	}
 
 	memcpy(fs_info->fsid, &disk_super->fsid, BTRFS_FSID_SIZE);
+	if (btrfs_fs_incompat(fs_info, METADATA_UUID)) {
+		memcpy(fs_info->metadata_uuid, disk_super->metadata_uuid,
+		       BTRFS_FSID_SIZE);
+	} else {
+		memcpy(fs_info->metadata_uuid, fs_info->fsid, BTRFS_FSID_SIZE);
+	}
 	fs_info->sectorsize = btrfs_super_sectorsize(disk_super);
 	fs_info->nodesize = btrfs_super_nodesize(disk_super);
 	fs_info->stripesize = btrfs_super_stripesize(disk_super);
@@ -1289,6 +1310,7 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 	u32 crc;
 	u16 csum_type;
 	int csum_size;
+	u8 *metadata_uuid;
 
 	if (btrfs_super_magic(sb) != BTRFS_MAGIC) {
 		if (btrfs_super_magic(sb) == BTRFS_MAGIC_TEMPORARY) {
@@ -1377,11 +1399,16 @@ static int check_super(struct btrfs_super_block *sb, unsigned sbflags)
 		goto error_out;
 	}
 
-	if (memcmp(sb->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
+	if (btrfs_super_incompat_flags(sb) & BTRFS_FEATURE_INCOMPAT_METADATA_UUID)
+		metadata_uuid = sb->metadata_uuid;
+	else
+		metadata_uuid = sb->fsid;
+
+	if (memcmp(metadata_uuid, sb->dev_item.fsid, BTRFS_FSID_SIZE) != 0) {
 		char fsid[BTRFS_UUID_UNPARSED_SIZE];
 		char dev_fsid[BTRFS_UUID_UNPARSED_SIZE];
 
-		uuid_unparse(sb->fsid, fsid);
+		uuid_unparse(sb->metadata_uuid, fsid);
 		uuid_unparse(sb->dev_item.fsid, dev_fsid);
 		error("dev_item UUID does not match fsid: %s != %s",
 			dev_fsid, fsid);
@@ -1448,6 +1475,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 			 unsigned sbflags)
 {
 	u8 fsid[BTRFS_FSID_SIZE];
+	u8 metadata_uuid[BTRFS_FSID_SIZE];
 	int fsid_is_initialized = 0;
 	char tmp[BTRFS_SUPER_INFO_SIZE];
 	struct btrfs_super_block *buf = (struct btrfs_super_block *)tmp;
@@ -1455,6 +1483,7 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 	int ret;
 	int max_super = sbflags & SBREAD_RECOVER ? BTRFS_SUPER_MIRROR_MAX : 1;
 	u64 transid = 0;
+	bool metadata_uuid_set = false;
 	u64 bytenr;
 
 	if (sb_bytenr != BTRFS_SUPER_INFO_OFFSET) {
@@ -1499,9 +1528,18 @@ int btrfs_read_dev_super(int fd, struct btrfs_super_block *sb, u64 sb_bytenr,
 			continue;
 
 		if (!fsid_is_initialized) {
+			if (btrfs_super_incompat_flags(buf) &
+			    BTRFS_FEATURE_INCOMPAT_METADATA_UUID) {
+				metadata_uuid_set = true;
+				memcpy(metadata_uuid, buf->metadata_uuid,
+				       sizeof(metadata_uuid));
+			}
 			memcpy(fsid, buf->fsid, sizeof(fsid));
 			fsid_is_initialized = 1;
-		} else if (memcmp(fsid, buf->fsid, sizeof(fsid))) {
+		} else if (memcmp(fsid, buf->fsid, sizeof(fsid)) ||
+			   (metadata_uuid_set && memcmp(metadata_uuid,
+							buf->metadata_uuid,
+							sizeof(metadata_uuid)))) {
 			/*
 			 * the superblocks (the original one and
 			 * its backups) contain data of different
@@ -1602,7 +1640,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info)
 		btrfs_set_stack_device_io_width(dev_item, dev->io_width);
 		btrfs_set_stack_device_sector_size(dev_item, dev->sector_size);
 		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
-		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_UUID_SIZE);
+		memcpy(dev_item->fsid, fs_info->metadata_uuid, BTRFS_FSID_SIZE);
 
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
diff --git a/image/main.c b/image/main.c
index 351c5a256938..efab3c44fb23 100644
--- a/image/main.c
+++ b/image/main.c
@@ -1401,7 +1401,7 @@ static void *restore_worker(void *data)
 		list_del_init(&async->list);
 
 		if (mdres->compress_method == COMPRESS_ZLIB) {
-			size = compress_size; 
+			size = compress_size;
 			pthread_mutex_unlock(&mdres->mutex);
 			ret = uncompress(buffer, (unsigned long *)&size,
 					 async->buffer, async->bufsize);
@@ -1593,9 +1593,12 @@ static int fill_mdres_info(struct mdrestore_struct *mdres,
 
 	super = (struct btrfs_super_block *)outbuf;
 	mdres->nodesize = btrfs_super_nodesize(super);
-	memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
-	memcpy(mdres->uuid, super->dev_item.uuid,
-		       BTRFS_UUID_SIZE);
+	if (btrfs_super_incompat_flags(super) &
+	    BTRFS_FEATURE_INCOMPAT_METADATA_UUID)
+		memcpy(mdres->fsid, super->metadata_uuid, BTRFS_FSID_SIZE);
+	else
+		memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
+	memcpy(mdres->uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
 	mdres->devid = le64_to_cpu(super->dev_item.devid);
 	free(buffer);
 	return 0;
@@ -1722,7 +1725,7 @@ static int read_chunk_block(struct mdrestore_struct *mdres, u8 *buffer,
 
 	if (memcmp(mdres->fsid, eb->data + offsetof(struct btrfs_header, fsid),
 		   BTRFS_FSID_SIZE)) {
-		error("filesystem UUID of eb %llu does not match",
+		error("filesystem metadata UUID of eb %llu does not match",
 				(unsigned long long)bytenr);
 		ret = -EIO;
 		goto out;
@@ -2036,9 +2039,13 @@ static int build_chunk_tree(struct mdrestore_struct *mdres,
 	super = (struct btrfs_super_block *)buffer;
 	chunk_root_bytenr = btrfs_super_chunk_root(super);
 	mdres->nodesize = btrfs_super_nodesize(super);
-	memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
-	memcpy(mdres->uuid, super->dev_item.uuid,
-		       BTRFS_UUID_SIZE);
+	if (btrfs_super_incompat_flags(super) &
+	    BTRFS_FEATURE_INCOMPAT_METADATA_UUID)
+		memcpy(mdres->fsid, super->metadata_uuid, BTRFS_FSID_SIZE);
+	else
+		memcpy(mdres->fsid, super->fsid, BTRFS_FSID_SIZE);
+
+	memcpy(mdres->uuid, super->dev_item.uuid, BTRFS_UUID_SIZE);
 	mdres->devid = le64_to_cpu(super->dev_item.devid);
 	free(buffer);
 	pthread_mutex_unlock(&mdres->mutex);
@@ -2314,7 +2321,7 @@ static int update_disk_super_on_device(struct btrfs_fs_info *info,
 	key.offset = cur_devid;
 
 	btrfs_init_path(&path);
-	ret = btrfs_search_slot(NULL, info->chunk_root, &key, &path, 0, 0); 
+	ret = btrfs_search_slot(NULL, info->chunk_root, &key, &path, 0, 0);
 	if (ret) {
 		error("search key failed: %d", ret);
 		ret = -EIO;
diff --git a/volumes.c b/volumes.c
index d81b348eb14d..b8388194c38f 100644
--- a/volumes.c
+++ b/volumes.c
@@ -142,13 +142,19 @@ static struct btrfs_device *find_device(struct btrfs_fs_devices *fs_devices,
 	return NULL;
 }
 
-static struct btrfs_fs_devices *find_fsid(u8 *fsid)
+static struct btrfs_fs_devices *find_fsid(u8 *fsid, u8 *metadata_uuid)
 {
 	struct btrfs_fs_devices *fs_devices;
 
 	list_for_each_entry(fs_devices, &fs_uuids, list) {
-		if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) == 0)
+		if (metadata_uuid && (memcmp(fsid, fs_devices->fsid,
+					     BTRFS_FSID_SIZE) == 0) &&
+		    (memcmp(metadata_uuid, fs_devices->metadata_uuid,
+			    BTRFS_FSID_SIZE) == 0)) {
 			return fs_devices;
+		} else if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) == 0){
+			return fs_devices;
+		}
 	}
 	return NULL;
 }
@@ -160,8 +166,15 @@ static int device_list_add(const char *path,
 	struct btrfs_device *device;
 	struct btrfs_fs_devices *fs_devices;
 	u64 found_transid = btrfs_super_generation(disk_super);
+	bool metadata_uuid = (btrfs_super_incompat_flags(disk_super) &
+		BTRFS_FEATURE_INCOMPAT_METADATA_UUID);
+
+	if (metadata_uuid)
+		fs_devices = find_fsid(disk_super->fsid,
+				       disk_super->metadata_uuid);
+	else
+		fs_devices = find_fsid(disk_super->fsid, NULL);
 
-	fs_devices = find_fsid(disk_super->fsid);
 	if (!fs_devices) {
 		fs_devices = kzalloc(sizeof(*fs_devices), GFP_NOFS);
 		if (!fs_devices)
@@ -169,6 +182,13 @@ static int device_list_add(const char *path,
 		INIT_LIST_HEAD(&fs_devices->devices);
 		list_add(&fs_devices->list, &fs_uuids);
 		memcpy(fs_devices->fsid, disk_super->fsid, BTRFS_FSID_SIZE);
+		if (metadata_uuid)
+			memcpy(fs_devices->metadata_uuid,
+			       disk_super->metadata_uuid, BTRFS_FSID_SIZE);
+		else
+			memcpy(fs_devices->metadata_uuid, fs_devices->fsid,
+			       BTRFS_FSID_SIZE);
+
 		fs_devices->latest_devid = devid;
 		fs_devices->latest_trans = found_transid;
 		fs_devices->lowest_devid = (u64)-1;
@@ -712,7 +732,7 @@ int btrfs_add_device(struct btrfs_trans_handle *trans,
 	ptr = (unsigned long)btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
 	ptr = (unsigned long)btrfs_device_fsid(dev_item);
-	write_extent_buffer(leaf, fs_info->fsid, ptr, BTRFS_UUID_SIZE);
+	write_extent_buffer(leaf, fs_info->metadata_uuid, ptr, BTRFS_UUID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 	ret = 0;
 
@@ -1685,7 +1705,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 	cur_devices = fs_info->fs_devices;
 	while (cur_devices) {
 		if (!fsid ||
-		    (!memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE) ||
+		    (!memcmp(cur_devices->metadata_uuid, fsid, BTRFS_FSID_SIZE) ||
 		     fs_info->ignore_fsid_mismatch)) {
 			device = find_device(cur_devices, devid, uuid);
 			if (device)
@@ -1966,7 +1986,7 @@ static int open_seed_devices(struct btrfs_fs_info *fs_info, u8 *fsid)
 		fs_devices = fs_devices->seed;
 	}
 
-	fs_devices = find_fsid(fsid);
+	fs_devices = find_fsid(fsid, NULL);
 	if (!fs_devices) {
 		/* missing all seed devices */
 		fs_devices = kzalloc(sizeof(*fs_devices), GFP_NOFS);
@@ -2005,7 +2025,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 			   BTRFS_UUID_SIZE);
 	read_extent_buffer(leaf, fs_uuid,
 			   (unsigned long)btrfs_device_fsid(dev_item),
-			   BTRFS_UUID_SIZE);
+			   BTRFS_FSID_SIZE);
 
 	if (memcmp(fs_uuid, fs_info->fsid, BTRFS_UUID_SIZE)) {
 		ret = open_seed_devices(fs_info, fs_uuid);
diff --git a/volumes.h b/volumes.h
index b4ea93f0bec3..f5732f6a4c0f 100644
--- a/volumes.h
+++ b/volumes.h
@@ -71,6 +71,7 @@ struct btrfs_device {
 
 struct btrfs_fs_devices {
 	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
+	u8 metadata_uuid[BTRFS_FSID_SIZE]; /* FS specific uuid */
 
 	/* the device with this id has the most recent copy of the super */
 	u64 latest_devid;
-- 
2.7.4

