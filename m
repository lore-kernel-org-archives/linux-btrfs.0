Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27817 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753514AbdG2Jn0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 05:43:26 -0400
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs: use appropriate define for the fsid
Date: Sat, 29 Jul 2017 17:50:09 +0800
Message-Id: <20170729095009.1361-1-anand.jain@oracle.com>
In-Reply-To: <20170727152103.GM2866@twin.jikos.cz>
References: <20170727152103.GM2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Though BTRFS_FSID_SIZE and BTRFS_UUID_SIZE or of same size,
for the purpose of doing it correctly use BTRFS_FSID_SIZE instead.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: Fix this for all remaining files.

 fs/btrfs/check-integrity.c |  2 +-
 fs/btrfs/disk-io.c         |  6 +++---
 fs/btrfs/scrub.c           |  2 +-
 fs/btrfs/volumes.c         | 16 ++++++++--------
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 11d37c94ce05..0ab7f7fa1b5f 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1732,7 +1732,7 @@ static int btrfsic_test_for_metadata(struct btrfsic_state *state,
 	num_pages = state->metablock_size >> PAGE_SHIFT;
 	h = (struct btrfs_header *)datav[0];
 
-	if (memcmp(h->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
+	if (memcmp(h->fsid, fs_info->fsid, BTRFS_FSID_SIZE))
 		return 1;
 
 	for (i = 0; i < num_pages; i++) {
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 086dcbadce09..ed840e0cabc5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -529,7 +529,7 @@ static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
 				 struct extent_buffer *eb)
 {
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
-	u8 fsid[BTRFS_UUID_SIZE];
+	u8 fsid[BTRFS_FSID_SIZE];
 	int ret = 1;
 
 	read_extent_buffer(eb, fsid, btrfs_header_fsid(), BTRFS_FSID_SIZE);
@@ -3731,7 +3731,7 @@ int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors)
 		btrfs_set_stack_device_io_width(dev_item, dev->io_width);
 		btrfs_set_stack_device_sector_size(dev_item, dev->sector_size);
 		memcpy(dev_item->uuid, dev->uuid, BTRFS_UUID_SIZE);
-		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_UUID_SIZE);
+		memcpy(dev_item->fsid, dev->fs_devices->fsid, BTRFS_FSID_SIZE);
 
 		flags = btrfs_super_flags(sb);
 		btrfs_set_super_flags(sb, flags | BTRFS_HEADER_FLAG_WRITTEN);
@@ -4172,7 +4172,7 @@ static int btrfs_check_super_valid(struct btrfs_fs_info *fs_info)
 		ret = -EINVAL;
 	}
 
-	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_UUID_SIZE) != 0) {
+	if (memcmp(fs_info->fsid, sb->dev_item.fsid, BTRFS_FSID_SIZE) != 0) {
 		btrfs_err(fs_info,
 			   "dev_item UUID does not match fsid: %pU != %pU",
 			   fs_info->fsid, sb->dev_item.fsid);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 6f1e4c984b94..51a5a14f4c0b 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1769,7 +1769,7 @@ static inline int scrub_check_fsid(u8 fsid[],
 	struct btrfs_fs_devices *fs_devices = spage->dev->fs_devices;
 	int ret;
 
-	ret = memcmp(fsid, fs_devices->fsid, BTRFS_UUID_SIZE);
+	ret = memcmp(fsid, fs_devices->fsid, BTRFS_FSID_SIZE);
 	return !ret;
 }
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 5eb7217738ed..c705ea563c60 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1726,7 +1726,7 @@ static int btrfs_add_device(struct btrfs_trans_handle *trans,
 	ptr = btrfs_device_uuid(dev_item);
 	write_extent_buffer(leaf, device->uuid, ptr, BTRFS_UUID_SIZE);
 	ptr = btrfs_device_fsid(dev_item);
-	write_extent_buffer(leaf, fs_info->fsid, ptr, BTRFS_UUID_SIZE);
+	write_extent_buffer(leaf, fs_info->fsid, ptr, BTRFS_FSID_SIZE);
 	btrfs_mark_buffer_dirty(leaf);
 
 	ret = 0;
@@ -2261,7 +2261,7 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 	struct btrfs_dev_item *dev_item;
 	struct btrfs_device *device;
 	struct btrfs_key key;
-	u8 fs_uuid[BTRFS_UUID_SIZE];
+	u8 fs_uuid[BTRFS_FSID_SIZE];
 	u8 dev_uuid[BTRFS_UUID_SIZE];
 	u64 devid;
 	int ret;
@@ -2304,7 +2304,7 @@ static int btrfs_finish_sprout(struct btrfs_trans_handle *trans,
 		read_extent_buffer(leaf, dev_uuid, btrfs_device_uuid(dev_item),
 				   BTRFS_UUID_SIZE);
 		read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
-				   BTRFS_UUID_SIZE);
+				   BTRFS_FSID_SIZE);
 		device = btrfs_find_device(fs_info, devid, dev_uuid, fs_uuid);
 		BUG_ON(!device); /* Logic error */
 
@@ -6295,7 +6295,7 @@ struct btrfs_device *btrfs_find_device(struct btrfs_fs_info *fs_info, u64 devid,
 	cur_devices = fs_info->fs_devices;
 	while (cur_devices) {
 		if (!fsid ||
-		    !memcmp(cur_devices->fsid, fsid, BTRFS_UUID_SIZE)) {
+		    !memcmp(cur_devices->fsid, fsid, BTRFS_FSID_SIZE)) {
 			device = __find_device(&cur_devices->devices,
 					       devid, uuid);
 			if (device)
@@ -6572,7 +6572,7 @@ static struct btrfs_fs_devices *open_seed_devices(struct btrfs_fs_info *fs_info,
 
 	fs_devices = fs_info->fs_devices->seed;
 	while (fs_devices) {
-		if (!memcmp(fs_devices->fsid, fsid, BTRFS_UUID_SIZE))
+		if (!memcmp(fs_devices->fsid, fsid, BTRFS_FSID_SIZE))
 			return fs_devices;
 
 		fs_devices = fs_devices->seed;
@@ -6625,16 +6625,16 @@ static int read_one_dev(struct btrfs_fs_info *fs_info,
 	struct btrfs_device *device;
 	u64 devid;
 	int ret;
-	u8 fs_uuid[BTRFS_UUID_SIZE];
+	u8 fs_uuid[BTRFS_FSID_SIZE];
 	u8 dev_uuid[BTRFS_UUID_SIZE];
 
 	devid = btrfs_device_id(leaf, dev_item);
 	read_extent_buffer(leaf, dev_uuid, btrfs_device_uuid(dev_item),
 			   BTRFS_UUID_SIZE);
 	read_extent_buffer(leaf, fs_uuid, btrfs_device_fsid(dev_item),
-			   BTRFS_UUID_SIZE);
+			   BTRFS_FSID_SIZE);
 
-	if (memcmp(fs_uuid, fs_info->fsid, BTRFS_UUID_SIZE)) {
+	if (memcmp(fs_uuid, fs_info->fsid, BTRFS_FSID_SIZE)) {
 		fs_devices = open_seed_devices(fs_info, fs_uuid);
 		if (IS_ERR(fs_devices))
 			return PTR_ERR(fs_devices);
-- 
2.13.1

