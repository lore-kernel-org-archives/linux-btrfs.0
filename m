Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:19084 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752382AbeEPIGy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 May 2018 04:06:54 -0400
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id EF1CDAC059C
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 17:06:47 +0900 (JST)
Received: from G01JPEXCHKW18.g01.fujitsu.local (G01JPEXCHKW18.g01.fujitsu.local [10.0.194.57])
        by g01jpfmpwkw03.exch.g01.fujitsu.local (Postfix) with ESMTP id 290A8BD67F1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 May 2018 17:06:47 +0900 (JST)
From: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/2] btrfs: sysfs: Use enum/define value intead of magic number
Date: Wed, 16 May 2018 17:09:26 +0900
Message-ID: <f0d930caa735030887feddfe58faef393d4204da.1526457206.git.misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <cover.1526457206.git.misono.tomohiro@jp.fujitsu.com>
References: <cover.1526457206.git.misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
---
 fs/btrfs/sysfs.c | 11 ++++++-----
 fs/btrfs/sysfs.h |  4 ++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
index fa6c8c88b250..217d401fe8ae 100644
--- a/fs/btrfs/sysfs.c
+++ b/fs/btrfs/sysfs.c
@@ -514,10 +514,11 @@ static inline struct btrfs_fs_info *to_fs_info(struct kobject *kobj)
 }
 
 #define NUM_FEATURE_BITS 64
-static char btrfs_unknown_feature_names[3][NUM_FEATURE_BITS][13];
-static struct btrfs_feature_attr btrfs_feature_attrs[3][NUM_FEATURE_BITS];
+#define BTRFS_FEATURE_NAME_MAX 13
+static char btrfs_unknown_feature_names[FEAT_MAX][NUM_FEATURE_BITS][BTRFS_FEATURE_NAME_MAX];
+static struct btrfs_feature_attr btrfs_feature_attrs[FEAT_MAX][NUM_FEATURE_BITS];
 
-static const u64 supported_feature_masks[3] = {
+static const u64 supported_feature_masks[FEAT_MAX] = {
 	[FEAT_COMPAT]    = BTRFS_FEATURE_COMPAT_SUPP,
 	[FEAT_COMPAT_RO] = BTRFS_FEATURE_COMPAT_RO_SUPP,
 	[FEAT_INCOMPAT]  = BTRFS_FEATURE_INCOMPAT_SUPP,
@@ -609,7 +610,7 @@ void btrfs_sysfs_remove_mounted(struct btrfs_fs_info *fs_info)
 	btrfs_sysfs_rm_device_link(fs_info->fs_devices, NULL);
 }
 
-const char * const btrfs_feature_set_names[3] = {
+const char * const btrfs_feature_set_names[FEAT_MAX] = {
 	[FEAT_COMPAT]	 = "compat",
 	[FEAT_COMPAT_RO] = "compat_ro",
 	[FEAT_INCOMPAT]	 = "incompat",
@@ -673,7 +674,7 @@ static void init_feature_attrs(void)
 			if (fa->kobj_attr.attr.name)
 				continue;
 
-			snprintf(name, 13, "%s:%u",
+			snprintf(name, BTRFS_FEATURE_NAME_MAX, "%s:%u",
 				 btrfs_feature_set_names[set], i);
 
 			fa->kobj_attr.attr.name = name;
diff --git a/fs/btrfs/sysfs.h b/fs/btrfs/sysfs.h
index b567560d9aa9..c6ee600aff89 100644
--- a/fs/btrfs/sysfs.h
+++ b/fs/btrfs/sysfs.h
@@ -9,7 +9,7 @@
 extern u64 btrfs_debugfs_test;
 
 enum btrfs_feature_set {
-	FEAT_COMPAT,
+	FEAT_COMPAT = 0,
 	FEAT_COMPAT_RO,
 	FEAT_INCOMPAT,
 	FEAT_MAX
@@ -77,7 +77,7 @@ attr_to_btrfs_feature_attr(struct attribute *attr)
 }
 
 char *btrfs_printable_features(enum btrfs_feature_set set, u64 flags);
-extern const char * const btrfs_feature_set_names[3];
+extern const char * const btrfs_feature_set_names[FEAT_MAX];
 extern struct kobj_type space_info_ktype;
 extern struct kobj_type btrfs_raid_ktype;
 int btrfs_sysfs_add_device_link(struct btrfs_fs_devices *fs_devices,
-- 
2.14.3


