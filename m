Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbcDAUOl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Apr 2016 16:14:41 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id B0754AC8D
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Apr 2016 20:14:38 +0000 (UTC)
From: Jeff Mahoney <jeffm@suse.com>
To: Btrfs Development List <linux-btrfs@vger.kernel.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Subject: [PATCH 8/8] btrfs: uapi/linux/btrfs_tree.h, use __u8 and __u64
Date: Fri,  1 Apr 2016 16:14:30 -0400
Message-Id: <1459541670-4097-9-git-send-email-jeffm@suse.com>
In-Reply-To: <1459541670-4097-1-git-send-email-jeffm@suse.com>
References: <1459541670-4097-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

u8 and u64 aren't exported to userspace, while __u8 and __u64 are.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 include/uapi/linux/btrfs_tree.h | 52 ++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/uapi/linux/btrfs_tree.h b/include/uapi/linux/btrfs_tree.h
index 1e87505..d5ad15a 100644
--- a/include/uapi/linux/btrfs_tree.h
+++ b/include/uapi/linux/btrfs_tree.h
@@ -334,14 +334,14 @@
  */
 struct btrfs_disk_key {
 	__le64 objectid;
-	u8 type;
+	__u8 type;
 	__le64 offset;
 } __attribute__ ((__packed__));
 
 struct btrfs_key {
-	u64 objectid;
-	u8 type;
-	u64 offset;
+	__u64 objectid;
+	__u8 type;
+	__u64 offset;
 } __attribute__ ((__packed__));
 
 struct btrfs_dev_item {
@@ -379,22 +379,22 @@ struct btrfs_dev_item {
 	__le32 dev_group;
 
 	/* seek speed 0-100 where 100 is fastest */
-	u8 seek_speed;
+	__u8 seek_speed;
 
 	/* bandwidth 0-100 where 100 is fastest */
-	u8 bandwidth;
+	__u8 bandwidth;
 
 	/* btrfs generated uuid for this device */
-	u8 uuid[BTRFS_UUID_SIZE];
+	__u8 uuid[BTRFS_UUID_SIZE];
 
 	/* uuid of FS who owns this device */
-	u8 fsid[BTRFS_UUID_SIZE];
+	__u8 fsid[BTRFS_UUID_SIZE];
 } __attribute__ ((__packed__));
 
 struct btrfs_stripe {
 	__le64 devid;
 	__le64 offset;
-	u8 dev_uuid[BTRFS_UUID_SIZE];
+	__u8 dev_uuid[BTRFS_UUID_SIZE];
 } __attribute__ ((__packed__));
 
 struct btrfs_chunk {
@@ -433,7 +433,7 @@ struct btrfs_chunk {
 struct btrfs_free_space_entry {
 	__le64 offset;
 	__le64 bytes;
-	u8 type;
+	__u8 type;
 } __attribute__ ((__packed__));
 
 struct btrfs_free_space_header {
@@ -486,7 +486,7 @@ struct btrfs_extent_item_v0 {
 
 struct btrfs_tree_block_info {
 	struct btrfs_disk_key key;
-	u8 level;
+	__u8 level;
 } __attribute__ ((__packed__));
 
 struct btrfs_extent_data_ref {
@@ -501,7 +501,7 @@ struct btrfs_shared_data_ref {
 } __attribute__ ((__packed__));
 
 struct btrfs_extent_inline_ref {
-	u8 type;
+	__u8 type;
 	__le64 offset;
 } __attribute__ ((__packed__));
 
@@ -523,7 +523,7 @@ struct btrfs_dev_extent {
 	__le64 chunk_objectid;
 	__le64 chunk_offset;
 	__le64 length;
-	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
+	__u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
 } __attribute__ ((__packed__));
 
 struct btrfs_inode_ref {
@@ -583,7 +583,7 @@ struct btrfs_dir_item {
 	__le64 transid;
 	__le16 data_len;
 	__le16 name_len;
-	u8 type;
+	__u8 type;
 } __attribute__ ((__packed__));
 
 #define BTRFS_ROOT_SUBVOL_RDONLY	(1ULL << 0)
@@ -605,8 +605,8 @@ struct btrfs_root_item {
 	__le64 flags;
 	__le32 refs;
 	struct btrfs_disk_key drop_progress;
-	u8 drop_level;
-	u8 level;
+	__u8 drop_level;
+	__u8 level;
 
 	/*
 	 * The following fields appear after subvol_uuids+subvol_times
@@ -625,9 +625,9 @@ struct btrfs_root_item {
 	 * when invalidating the fields.
 	 */
 	__le64 generation_v2;
-	u8 uuid[BTRFS_UUID_SIZE];
-	u8 parent_uuid[BTRFS_UUID_SIZE];
-	u8 received_uuid[BTRFS_UUID_SIZE];
+	__u8 uuid[BTRFS_UUID_SIZE];
+	__u8 parent_uuid[BTRFS_UUID_SIZE];
+	__u8 received_uuid[BTRFS_UUID_SIZE];
 	__le64 ctransid; /* updated when an inode changes */
 	__le64 otransid; /* trans when created */
 	__le64 stransid; /* trans when sent. non-zero for received subvol */
@@ -751,12 +751,12 @@ struct btrfs_file_extent_item {
 	 * it is treated like an incompat flag for reading and writing,
 	 * but not for stat.
 	 */
-	u8 compression;
-	u8 encryption;
+	__u8 compression;
+	__u8 encryption;
 	__le16 other_encoding; /* spare for later use */
 
 	/* are we inline data or a real extent? */
-	u8 type;
+	__u8 type;
 
 	/*
 	 * disk space consumed by the extent, checksum blocks are included
@@ -783,7 +783,7 @@ struct btrfs_file_extent_item {
 } __attribute__ ((__packed__));
 
 struct btrfs_csum_item {
-	u8 csum;
+	__u8 csum;
 } __attribute__ ((__packed__));
 
 struct btrfs_dev_stats_item {
@@ -874,14 +874,14 @@ enum btrfs_raid_types {
 #define BTRFS_EXTENDED_PROFILE_MASK	(BTRFS_BLOCK_GROUP_PROFILE_MASK | \
 					 BTRFS_AVAIL_ALLOC_BIT_SINGLE)
 
-static inline u64 chunk_to_extended(u64 flags)
+static inline __u64 chunk_to_extended(__u64 flags)
 {
 	if ((flags & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0)
 		flags |= BTRFS_AVAIL_ALLOC_BIT_SINGLE;
 
 	return flags;
 }
-static inline u64 extended_to_chunk(u64 flags)
+static inline __u64 extended_to_chunk(__u64 flags)
 {
 	return flags & ~BTRFS_AVAIL_ALLOC_BIT_SINGLE;
 }
@@ -900,7 +900,7 @@ struct btrfs_free_space_info {
 #define BTRFS_FREE_SPACE_USING_BITMAPS (1ULL << 0)
 
 #define BTRFS_QGROUP_LEVEL_SHIFT		48
-static inline u64 btrfs_qgroup_level(u64 qgroupid)
+static inline __u64 btrfs_qgroup_level(__u64 qgroupid)
 {
 	return qgroupid >> BTRFS_QGROUP_LEVEL_SHIFT;
 }
-- 
2.7.1

