Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40928 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbbKYMIs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 07:08:48 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
Subject: [PATCH 2/7] btrfs-progs: add kernel alias for each of the features in the list
Date: Wed, 25 Nov 2015 20:08:15 +0800
Message-Id: <1448453300-8449-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should have maintained feature's name same across progs UI and sysfs UI.
For example, progs mixed-bg is /sys/fs/btrfs/features/mixed_groups
in sysfs. As these are already released and is UIs, there is nothing much
can be done about it, except for creating the alias and making it aware.

Add kernel alias for each of the features in the list.

eg: The string with in () is the sysfs name for the same feaure

mkfs.btrfs -O list-all
Filesystem features available:
mixed-bg (mixed_groups)           - mixed data and metadata block groups (0x4, 2.7.37)
extref (extended_iref)            - increased hardlink limit per file to 65536 (0x40, 3.7, default)
raid56 (raid56)                   - raid56 extended format (0x80, 3.9)
skinny-metadata (skinny_metadata) - reduced-size metadata extent refs (0x100, 3.10, default)
no-holes (no_holes)               - no explicit hole extents for files (0x200, 3.14)

btrfs-convert -O list-all
Filesystem features available:
extref (extended_iref)            - increased hardlink limit per file to 65536 (0x40, 3.7, default)
skinny-metadata (skinny_metadata) - reduced-size metadata extent refs (0x100, 3.10, default)
no-holes (no_holes)               - no explicit hole extents for files (0x200, 3.14)
---
 utils.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/utils.c b/utils.c
index 0163915..6d2675d 100644
--- a/utils.c
+++ b/utils.c
@@ -648,17 +648,26 @@ void btrfs_process_fs_features(u64 flags)
 void btrfs_list_all_fs_features(u64 mask_disallowed)
 {
 	int i;
+	u64 feature_per_sysfs;
+
+	btrfs_features_allowed_by_sysfs(&feature_per_sysfs);
 
 	fprintf(stderr, "Filesystem features available:\n");
 	for (i = 0; i < ARRAY_SIZE(mkfs_features) - 1; i++) {
 		char *is_default = "";
+		char name[256];
 
 		if (mkfs_features[i].flag & mask_disallowed)
 			continue;
 		if (mkfs_features[i].flag & BTRFS_MKFS_DEFAULT_FEATURES)
 			is_default = ", default";
-		fprintf(stderr, "%-20s- %s (0x%llx, %s%s)\n",
-				mkfs_features[i].name,
+		if (mkfs_features[i].flag & feature_per_sysfs)
+			sprintf(name, "%s (%s)",
+				mkfs_features[i].name, mkfs_features[i].name_ker);
+		else
+			sprintf(name, "%s", mkfs_features[i].name);
+		fprintf(stderr, "%-34s- %s (0x%llx, %s%s)\n",
+				name,
 				mkfs_features[i].desc,
 				mkfs_features[i].flag,
 				mkfs_features[i].min_ker_ver,
-- 
2.6.2

