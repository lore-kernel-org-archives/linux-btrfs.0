Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24076 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751925AbbIIItf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Sep 2015 04:49:35 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t898nHnM006476
	for <linux-btrfs@vger.kernel.org>; Wed, 9 Sep 2015 16:49:17 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/5] btrfs: util: add parameter for btrfs_list_all_fs_features
Date: Wed, 9 Sep 2015 16:49:23 +0800
Message-ID: <1441788564-27382-5-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1441788564-27382-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1441788564-27382-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Even we tried to make mkfs and btrfs-convert use the same features, but
previous patch forced btrfs-convert to use mix-bg feature.

So the default fs features is different for mkfs and btrfs-convert, add
mask_default parameter for btrfs_list_all_fs_features() to handle the
difference.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfs-convert.c | 4 +++-
 mkfs.c          | 3 ++-
 utils.c         | 4 ++--
 utils.h         | 2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/btrfs-convert.c b/btrfs-convert.c
index a60f380..e730e4b 100644
--- a/btrfs-convert.c
+++ b/btrfs-convert.c
@@ -2950,7 +2950,9 @@ int main(int argc, char *argv[])
 	}
 	if (features & BTRFS_FEATURE_LIST_ALL) {
 		btrfs_list_all_fs_features(
-			~BTRFS_CONVERT_ALLOWED_FEATURES);
+			~BTRFS_CONVERT_ALLOWED_FEATURES,
+			BTRFS_MKFS_DEFAULT_FEATURES |
+			BTRFS_CONVERT_FORCE_FEATURES);
 		exit(0);
 	}
 
diff --git a/mkfs.c b/mkfs.c
index b8879fc..56ce381 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1430,7 +1430,8 @@ int main(int ac, char **av)
 				}
 				free(orig);
 				if (features & BTRFS_FEATURE_LIST_ALL) {
-					btrfs_list_all_fs_features(0);
+					btrfs_list_all_fs_features(0,
+						BTRFS_MKFS_DEFAULT_FEATURES);
 					exit(0);
 				}
 				break;
diff --git a/utils.c b/utils.c
index c0d1afa..78ba67b 100644
--- a/utils.c
+++ b/utils.c
@@ -633,7 +633,7 @@ void btrfs_process_fs_features(u64 flags)
 	}
 }
 
-void btrfs_list_all_fs_features(u64 mask_disallowed)
+void btrfs_list_all_fs_features(u64 mask_disallowed, u64 mask_default)
 {
 	int i;
 
@@ -643,7 +643,7 @@ void btrfs_list_all_fs_features(u64 mask_disallowed)
 
 		if (mkfs_features[i].flag & mask_disallowed)
 			continue;
-		if (mkfs_features[i].flag & BTRFS_MKFS_DEFAULT_FEATURES)
+		if (mkfs_features[i].flag & mask_default)
 			is_default = ", default";
 		fprintf(stderr, "%-20s- %s (0x%llx%s)\n",
 				mkfs_features[i].name,
diff --git a/utils.h b/utils.h
index 7f1a128..f8fd745 100644
--- a/utils.h
+++ b/utils.h
@@ -112,7 +112,7 @@ void set_argv0(char **argv);
 void units_set_mode(unsigned *units, unsigned mode);
 void units_set_base(unsigned *units, unsigned base);
 
-void btrfs_list_all_fs_features(u64 mask_disallowed);
+void btrfs_list_all_fs_features(u64 mask_disallowed, u64 mask_default);
 char* btrfs_parse_fs_features(char *namelist, u64 *flags);
 void btrfs_process_fs_features(u64 flags);
 void btrfs_parse_features_to_string(char *buf, u64 flags);
-- 
2.5.1

