Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60600 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730017AbeGMTCm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Jul 2018 15:02:42 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1100FAD0C
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Jul 2018 18:46:52 +0000 (UTC)
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
Subject: [PATCH 4/4] btrfs: add incompatibility bit for extended raid features
Date: Fri, 13 Jul 2018 20:46:33 +0200
Message-Id: <dde6771cc629b39f8073cf979e6e05ecb06841cc.1531503452.git.dsterba@suse.com>
In-Reply-To: <cover.1531503452.git.dsterba@suse.com>
References: <cover.1531503452.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This bit will cover all newly added features of RAID:

- 3 copy replication
- 4 copy replication
- configurable stripe length
- triple parity
- raid56 log

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/ctree.h           | 1 +
 fs/btrfs/sysfs.c           | 2 ++
 fs/btrfs/volumes.c         | 9 +++++++++
 include/uapi/linux/btrfs.h | 8 ++++++++
 4 files changed, 20 insertions(+)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 118346aceea9..d734a0d7a3a9 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -265,6 +265,7 @@ struct btrfs_super_block {
 	 BTRFS_FEATURE_INCOMPAT_RAID56 |		\
 	 BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF |		\
 	 BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA |	\
+	 BTRFS_FEATURE_INCOMPAT_EXTENDED_RAID |		\
 	 BTRFS_FEATURE_INCOMPAT_NO_HOLES)
 
 #define BTRFS_FEATURE_INCOMPAT_SAFE_SET			\
diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index 4a4e960c7c66..f67824fbbab4 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -194,6 +194,7 @@ BTRFS_FEAT_ATTR_INCOMPAT(raid56, RAID56);
 BTRFS_FEAT_ATTR_INCOMPAT(skinny_metadata, SKINNY_METADATA);
 BTRFS_FEAT_ATTR_INCOMPAT(no_holes, NO_HOLES);
 BTRFS_FEAT_ATTR_COMPAT_RO(free_space_tree, FREE_SPACE_TREE);
+BTRFS_FEAT_ATTR_INCOMPAT(extended_raid, EXTENDED_RAID);
 
 static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(mixed_backref),
@@ -207,6 +208,7 @@ static struct attribute *btrfs_supported_feature_attrs[] = {
 	BTRFS_FEAT_ATTR_PTR(skinny_metadata),
 	BTRFS_FEAT_ATTR_PTR(no_holes),
 	BTRFS_FEAT_ATTR_PTR(free_space_tree),
+	BTRFS_FEAT_ATTR_PTR(extended_raid),
 	NULL
 };
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 62a8d8844dd4..bf52b2b4c6a4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4663,6 +4663,14 @@ static void check_raid56_incompat_flag(struct btrfs_fs_info *info, u64 type)
 	btrfs_set_fs_incompat(info, RAID56);
 }
 
+static void check_extended_raid_incompat_flag(struct btrfs_fs_info *info, u64 type)
+{
+	if (!(type & (BTRFS_BLOCK_GROUP_RAID1C3 | BTRFS_BLOCK_GROUP_RAID1C4)))
+		return;
+
+	btrfs_set_fs_incompat(info, EXTENDED_RAID);
+}
+
 #define BTRFS_MAX_DEVS(info) ((BTRFS_MAX_ITEM_SIZE(info)	\
 			- sizeof(struct btrfs_chunk))		\
 			/ sizeof(struct btrfs_stripe) + 1)
@@ -4945,6 +4953,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 
 	free_extent_map(em);
 	check_raid56_incompat_flag(info, type);
+	check_extended_raid_incompat_flag(info, type);
 
 	kfree(devices_info);
 	return 0;
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 229ef2e135ac..490cc3e66b94 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -270,6 +270,14 @@ struct btrfs_ioctl_fs_info_args {
 #define BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA	(1ULL << 8)
 #define BTRFS_FEATURE_INCOMPAT_NO_HOLES		(1ULL << 9)
 
+/*
+ * More RAID features:
+ * - RAID1C3 - 3-copy mirroring
+ * - RAID1C4 - 4-copy mirroring
+ * - ...
+ */
+#define BTRFS_FEATURE_INCOMPAT_EXTENDED_RAID	(1ULL << 10)
+
 struct btrfs_ioctl_feature_flags {
 	__u64 compat_flags;
 	__u64 compat_ro_flags;
-- 
2.18.0

