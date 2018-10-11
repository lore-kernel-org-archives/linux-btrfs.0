Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E1A1C4161D
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 079192075C
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 15:03:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 079192075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbeJKWbG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 18:31:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:49680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727846AbeJKWbF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 18:31:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 352FDB632
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Oct 2018 15:03:29 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/6] btrfs: Introduce support for FSID change without metadata rewrite
Date:   Thu, 11 Oct 2018 18:03:21 +0300
Message-Id: <1539270206-27005-2-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539270206-27005-1-git-send-email-nborisov@suse.com>
References: <1539270206-27005-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This field is going to be used when the user wants to change the UUID
of the filesystem without having to rewrite all metadata blocks. This
field adds another level of indirection such that when the FSID is
changed what really happens is the current uuid (the one with which the
fs was created) is copied to the 'metadata_uuid' field in the superblock
as well as a new incompat flag is set METADATA_UUID. When the kernel
detects this flag is set it knows that the superblock in fact has 2
uuids:

1. Is the UUID which is user-visible, currently known as FSID.
2. Metadata UUID - this is the UUID which is stamped into all on-disk
datastructures belonging to this file system.

When the new incompat flag is present device scaning checks whether
both fsid/metadata_uuid of the scanned device match to any of the
registed filesystems. When the flag is not set then both UUIDs are
equal and only the FSID is retained on disk, metadata_uuid is set only
in-memory during mount.

Additionally a new metadata_uuid field is also added to the fs_info
struct. It's initialised either with the FSID in case METADATA_UUID
incompat flag is not set or with the metdata_uuid of the superblock
otherwise.

This commit introduces the new fields as well as the new incompat flag
and switches all users of the fsid to the new logic.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/ctree.c                |  4 +--
 fs/btrfs/ctree.h                | 12 ++++---
 fs/btrfs/disk-io.c              | 32 ++++++++++++++----
 fs/btrfs/extent-tree.c          |  2 +-
 fs/btrfs/volumes.c              | 72 ++++++++++++++++++++++++++++++++---------
 fs/btrfs/volumes.h              |  1 +
 include/uapi/linux/btrfs.h      |  1 +
 include/uapi/linux/btrfs_tree.h |  1 +
 8 files changed, 97 insertions(+), 28 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 2ee43b6a4f09..11b5c2abeddc 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -224,7 +224,7 @@ int btrfs_copy_root(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, new_root_objectid);
 
-	write_extent_buffer_fsid(cow, fs_info->fsid);
+	write_extent_buffer_fsid(cow, fs_info->metadata_fsid);
 
 	WARN_ON(btrfs_header_generation(buf) > trans->transid);
 	if (new_root_objectid == BTRFS_TREE_RELOC_OBJECTID)
@@ -1033,7 +1033,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	else
 		btrfs_set_header_owner(cow, root->root_key.objectid);
 
-	write_extent_buffer_fsid(cow, fs_info->fsid);
+	write_extent_buffer_fsid(cow, fs_info->metadata_fsid);
 
 	ret = update_ref_for_cow(trans, root, buf, cow, &last_ref);
 	if (ret) {
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 15c659f23411..afa55f524a49 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -197,7 +197,7 @@ struct btrfs_root_backup {
 struct btrfs_super_block {
 	u8 csum[BTRFS_CSUM_SIZE];
 	/* the first 4 fields must match struct btrfs_header */
-	u8 fsid[BTRFS_FSID_SIZE];    /* FS specific uuid */
+	u8 fsid[BTRFS_FSID_SIZE];    /* userfacing FS specific uuid */
 	__le64 bytenr; /* this block number */
 	__le64 flags;
 
@@ -234,8 +234,10 @@ struct btrfs_super_block {
 	__le64 cache_generation;
 	__le64 uuid_tree_generation;
 
+	u8 metadata_uuid[BTRFS_FSID_SIZE]; /* The uuid written into btree blocks */
+
 	/* future expansion */
-	__le64 reserved[30];
+	__le64 reserved[28];
 	u8 sys_chunk_array[BTRFS_SYSTEM_CHUNK_ARRAY_SIZE];
 	struct btrfs_root_backup super_roots[BTRFS_NUM_BACKUP_ROOTS];
 } __attribute__ ((__packed__));
@@ -265,7 +267,8 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
-	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
+	 BTRFS_FEATURE_INCOMPAT_NO_HOLES	|	\
+	 BTRFS_FEATURE_INCOMPAT_METADATA_UUID)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
 	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF)
@@ -746,7 +749,8 @@ struct btrfs_delayed_root;
 #define BTRFS_FS_BALANCE_RUNNING		18
 
 struct btrfs_fs_info {
-	u8 fsid[BTRFS_FSID_SIZE];
+	u8 fsid[BTRFS_FSID_SIZE]; /* User-visible fs UUID */
+	u8 metadata_fsid[BTRFS_FSID_SIZE]; /* UUID written to btree blocks */
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
 	unsigned long flags;
 	struct btrfs_root *extent_root;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 27f6a3348f94..b61e4d47e316 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -551,7 +551,7 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 	if (WARN_ON(!PageUptodate(page)))
 		return -EUCLEAN;
 
-	ASSERT(memcmp_extent_buffer(eb, fs_info->fsid,
+	ASSERT(memcmp_extent_buffer(eb, fs_info->metadata_fsid,
 			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
 
 	return csum_tree_block(fs_info, eb, 0);
@@ -566,7 +566,19 @@ static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
 
 	read_extent_buffer(eb, fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
 	while (fs_devices) {
-		if (!memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE)) {
+		u8 *metadata_uuid;
+		/*
+		 * Checking the incompat flag is only valid for the current
+		 * fs. For seed devices it's forbidden to have their uuid
+		 * changed so reading ->fsid in this case is fine
+		 */
+		if (fs_devices == fs_info->fs_devices &&
+		    btrfs_fs_incompat(fs_info, METADATA_UUID))
+			metadata_uuid = fs_devices->metadata_uuid;
+		else
+			metadata_uuid = fs_devices->fsid;
+
+		if (!memcmp(fsid, metadata_uuid, BTRFS_FSID_SIZE)) {
 			ret = 0;
 			break;
 		}
@@ -2478,10 +2490,11 @@ static int validate_super(struct btrfs_fs_info *fs_info,
 		ret = -EINVAL;
 	}
 
-	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_FSID_SIZE) != 0) {
+	if (memcmp(fs_info->metadata_fsid, sb->dev_item.fsid,
+		   BTRFS_FSID_SIZE) != 0) {
 		btrfs_err(fs_info,
-			   "dev_item UUID does not match fsid: %pU != %pU",
-			   fs_info->fsid, sb->dev_item.fsid);
+			   "dev_item UUID does not match metadata fsid: %pU != %pU",
+			   fs_info->metadata_fsid, sb->dev_item.fsid);
 		ret = -EINVAL;
 	}
 
@@ -2822,6 +2835,12 @@ int open_ctree(struct super_block *sb,
 	brelse(bh);
 
 	memcpy(fs_info->fsid, fs_info->super_copy->fsid, BTRFS_FSID_SIZE);
+	if (btrfs_fs_incompat(fs_info, METADATA_UUID)) {
+		memcpy(fs_info->metadata_fsid,
+		       fs_info->super_copy->metadata_uuid, BTRFS_FSID_SIZE);
+	} else {
+		memcpy(fs_info->metadata_fsid, fs_info->fsid, BTRFS_FSID_SIZE);
+	}
 
 	ret = btrfs_validate_mount_super(fs_info);
 	if (ret) {
@@ -3760,7 +3779,8 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 		btrfs_set_stack_device_io_width(dev_item, dev->io_width);
 		btrfs_set_stack_device_sector_size(dev_item, dev->sector_size);
 		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
-		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_FSID_SIZE);
+		memcpy(dev_item->fsid, dev->fs_devices->metadata_uuid,
+		       BTRFS_FSID_SIZE);
 
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 97cb2c17802e..4926d0975242 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -8174,7 +8174,7 @@ btrfs_init_new_buffer(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 	btrfs_set_header_generation(buf, trans->transid);
 	btrfs_set_header_backref_rev(buf, BTRFS_MIXED_BACKREF_REV);
 	btrfs_set_header_owner(buf, owner);
-	write_extent_buffer_fsid(buf, fs_info->fsid);
+	write_extent_buffer_fsid(buf, fs_info->metadata_fsid);
 	write_extent_buffer_chunk_tree_uuid(buf, fs_info->chunk_tree_uuid);
 	if (root->root_key.objectid == BTRFS_TREE_LOG_OBJECTID) {
 		buf->log_index = root->log_transid % 2;
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f435d397019e..e3e12c94834f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -238,13 +238,15 @@ struct list_head *btrfs_get_fs_uuids(void)
 
 /*
  * alloc_fs_devices - allocate struct btrfs_fs_devices
- * @fsid:	if not NULL, copy the uuid to fs_devices::fsid
+ * @fsid:		if not NULL, copy the uuid to fs_devices::fsid
+ * @metadata_fsid:	if not NULL, copy the uuid to fs_devices::metadata_fsid
  *
  * Return a pointer to a new struct btrfs_fs_devices on success, or ERR_PTR().
  * The returned struct is not linked onto any lists and can be destroyed with
  * kfree() right away.
  */
-static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
+static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid,
+						 const u8 *metadata_fsid)
 {
 	struct btrfs_fs_devices *fs_devs;
 
@@ -261,6 +263,11 @@ static struct btrfs_fs_devices *alloc_fs_devices(const u8 *fsid)
 	if (fsid)
 		memcpy(fs_devs->fsid, fsid, BTRFS_FSID_SIZE);
 
+	if (metadata_fsid)
+		memcpy(fs_devs->metadata_uuid, metadata_fsid, BTRFS_FSID_SIZE);
+	else if (fsid)
+		memcpy(fs_devs->metadata_uuid, fsid, BTRFS_FSID_SIZE);
+
 	return fs_devs;
 }
 
@@ -368,13 +375,24 @@ static struct btrfs_device *find_device(struct btrfs_fs_devices *fs_devices,
 	return NULL;
 }
 
-static noinline struct btrfs_fs_devices *find_fsid(u8 *fsid)
+static noinline struct btrfs_fs_devices *
+find_fsid(const u8 *fsid, const u8 *metadata_fsid)
 {
 	struct btrfs_fs_devices *fs_devices;
 
+	ASSERT(fsid);
+
 	list_for_each_entry(fs_devices, &fs_uuids, fs_list) {
-		if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) == 0)
-			return fs_devices;
+		if (metadata_fsid) {
+			if (memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE) == 0
+			    && memcmp(metadata_fsid, fs_devices->metadata_uuid,
+				      BTRFS_FSID_SIZE) == 0)
+				return fs_devices;
+		} else {
+			if (memcmp(fsid, fs_devices->fsid,
+				   BTRFS_FSID_SIZE) == 0)
+				return fs_devices;
+		}
 	}
 	return NULL;
 }
@@ -709,6 +727,12 @@ static int btrfs_open_one_device(struct btrfs_fs_devices *fs_devices,
 	device->generation = btrfs_super_generation(disk_super);
 
 	if (btrfs_super_flags(disk_super) & BTRFS_SUPER_FLAG_SEEDING) {
+		if (btrfs_super_incompat_flags(disk_super) &
+		    BTRFS_FEATURE_INCOMPAT_METADATA_UUID) {
+			pr_err("BTRFS: Invalid seeding and uuid-changed device detected\n");
+			goto error_brelse;
+		}
+
 		clear_bit(BTRFS_DEV_STATE_WRITEABLE, &device->dev_state);
 		fs_devices->seeding = 1;
 	} else {
@@ -759,10 +783,21 @@ static noinline struct btrfs_device *device_list_add(const char *path,
 	struct rcu_string *name;
 	u64 found_transid = btrfs_super_generation(disk_super);
 	u64 devid = btrfs_stack_device_id(&disk_super->dev_item);
+	bool has_metadata_uuid = (btrfs_super_incompat_flags(disk_super) &
+		BTRFS_FEATURE_INCOMPAT_METADATA_UUID);
+
+	if (has_metadata_uuid)
+		fs_devices = find_fsid(disk_super->fsid, disk_super->metadata_uuid);
+	else
+		fs_devices = find_fsid(disk_super->fsid, NULL);
 
-	fs_devices = find_fsid(disk_super->fsid);
 	if (!fs_devices) {
-		fs_devices = alloc_fs_devices(disk_super->fsid);
+		if (has_metadata_uuid)
+			fs_devices = alloc_fs_devices(disk_super->fsid,
+						      disk_super->metadata_uuid);
+		else
+			fs_devices = alloc_fs_devices(disk_super->fsid, NULL);
+
 		if (IS_ERR(fs_devices))
 			return ERR_CAST(fs_devices);
 
@@ -884,7 +919,7 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 	struct btrfs_device *device;
 	struct btrfs_device *orig_dev;
 
-	fs_devices = alloc_fs_devices(orig->fsid);
+	fs_devices = alloc_fs_devices(orig->fsid, NULL);
 	if (IS_ERR(fs_devices))
 		return fs_devices;
 
@@ -1709,7 +1744,8 @@ static int btrfs_add_dev_item(struct btrfs_trans_handle *trans,
 	ptr = btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
 	ptr = btrfs_device_fsid(dev_item);
-	write_extent_buffer(leaf, trans->fs_info->fsid, ptr, BTRFS_FSID_SIZE);
+	write_extent_buffer(leaf, trans->fs_info->metadata_fsid, ptr,
+			    BTRFS_FSID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 
 	ret = 0;
@@ -2132,7 +2168,11 @@ static struct btrfs_device *btrfs_find_device_by_path(
 	disk_super = (struct btrfs_super_block *)bh->b_data;
 	devid = btrfs_stack_device_id(&disk_super->dev_item);
 	dev_uuid = disk_super->dev_item.uuid;
-	device = btrfs_find_device(fs_info, devid, dev_uuid, disk_super->fsid);
+	if (btrfs_fs_incompat(fs_info, METADATA_UUID))
+		device = btrfs_find_device(fs_info, devid, dev_uuid, disk_super->metadata_uuid);
+	else
+		device = btrfs_find_device(fs_info, devid, dev_uuid, disk_super->fsid);
+
 	brelse(bh);
 	if (!device)
 		device = ERR_PTR(-ENOENT);
@@ -2202,7 +2242,7 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 	if (!fs_devices->seeding)
 		return -EINVAL;
 
-	seed_devices = alloc_fs_devices(NULL);
+	seed_devices = alloc_fs_devices(NULL, NULL);
 	if (IS_ERR(seed_devices))
 		return PTR_ERR(seed_devices);
 
@@ -2239,6 +2279,8 @@ static int btrfs_prepare_sprout(struct btrfs_fs_info *fs_info)
 
 	generate_random_uuid(fs_devices->fsid);
 	memcpy(fs_info->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
+	memcpy(fs_devices->metadata_uuid, fs_devices->fsid, BTRFS_FSID_SIZE);
+	memcpy(fs_info->metadata_fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	memcpy(disk_super->fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	mutex_unlock(&fs_devices->device_list_mutex);
 
@@ -6245,7 +6287,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 	cur_devices = fs_info->fs_devices;
 	while (cur_devices) {
 		if (!fsid ||
-		    !memcmp(cur_devices->fsid, fsid, BTRFS_FSID_SIZE)) {
+		    !memcmp(cur_devices->metadata_uuid, fsid, BTRFS_FSID_SIZE)) {
 			device = find_device(cur_devices, devid, uuid);
 			if (device)
 				return device;
@@ -6574,12 +6616,12 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 		fs_devices = fs_devices->seed;
 	}
 
-	fs_devices = find_fsid(fsid);
+	fs_devices = find_fsid(fsid, NULL);
 	if (!fs_devices) {
 		if (!btrfs_test_opt(fs_info, DEGRADED))
 			return ERR_PTR(-ENOENT);
 
-		fs_devices = alloc_fs_devices(fsid);
+		fs_devices = alloc_fs_devices(fsid, NULL);
 		if (IS_ERR(fs_devices))
 			return fs_devices;
 
@@ -6629,7 +6671,7 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
 			   BTRFS_FSID_SIZE);
 
-	if (memcmp(fs_uuid, fs_info->fsid, BTRFS_FSID_SIZE)) {
+	if (memcmp(fs_uuid, fs_info->metadata_fsid, BTRFS_FSID_SIZE)) {
 		fs_devices = open_seed_devices(fs_info, fs_uuid);
 		if (IS_ERR(fs_devices))
 			return PTR_ERR(fs_devices);
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index aefce895e994..04860497b33c 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -210,6 +210,7 @@ BTRFS_DEVICE_GETSET_FUNCS(bytes_used);
 
 struct btrfs_fs_devices {
 	u8 fsid[BTRFS_FSID_SIZE]; /* FS specific uuid */
+	u8 metadata_uuid[BTRFS_FSID_SIZE];
 	struct list_head fs_list;
 
 	u64 num_devices;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 5ca1d21fc4a7..e0763bc4158e 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -269,6 +269,7 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_RAID56		(1ULL << 7)
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
+#define BTRFS_FEATURE_INCOMPAT_METADATA_UUID	(1ULL << 10)
 
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index aff1356c2bb8..22f9299ba7d9 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -458,6 +458,7 @@ struct btrfs_free_space_header {
 #define BTRFS_SUPER_FLAG_METADUMP	(1ULL << 33)
 #define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
 #define BTRFS_SUPER_FLAG_CHANGING_FSID	(1ULL << 35)
+#define BTRFS_SUPER_FLAG_CHANGING_FSID_v2 (1ULL << 36)
 
 
 /*
-- 
2.7.4

