Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61924 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752383AbbJMMyB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 08:54:01 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9DCrUV3019605
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 20:53:30 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 1/3] btrfs-progs: mkfs: Remove saved_optind in mkfs.btrfs
Date: Tue, 13 Oct 2015 20:52:17 +0800
Message-ID: <681908a6a06b67212a4be5868a682a793585e7e7.1444740703.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1444740703.git.zhaolei@cn.fujitsu.com>
References: <cover.1444740703.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No need to use complex logic for iter devs in mkfs.c,
as backup optind, increase/decrease optind and reset dev_cnt.

A simple for() loop is enough for above request.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 mkfs.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index 7fa7cfc..cdae94d 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1354,7 +1354,6 @@ int main(int ac, char **av)
 	u64 size_of_data = 0;
 	u64 source_dir_size = 0;
 	int dev_cnt = 0;
-	int saved_optind;
 	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE] = { 0 };
 	u64 features = BTRFS_MKFS_DEFAULT_FEATURES;
 	struct mkfs_allocation allocation = { 0 };
@@ -1467,7 +1466,6 @@ int main(int ac, char **av)
 	}
 
 	sectorsize = max(sectorsize, (u32)sysconf(_SC_PAGESIZE));
-	saved_optind = optind;
 	dev_cnt = ac - optind;
 	if (dev_cnt == 0)
 		print_usage(1);
@@ -1490,18 +1488,15 @@ int main(int ac, char **av)
 			exit(1);
 		}
 	}
-	
-	while (dev_cnt-- > 0) {
-		file = av[optind++];
+
+	for (i = optind; i < optind + dev_cnt; i++) {
+		file = av[i];
 		if (is_block_device(file) == 1)
 			if (test_dev_for_mkfs(file, force_overwrite))
 				exit(1);
 	}
 
-	optind = saved_optind;
-	dev_cnt = ac - optind;
-
-	file = av[optind++];
+	file = av[optind];
 	ssd = is_ssd(file);
 
 	if (is_vol_small(file) || mixed) {
@@ -1557,7 +1552,7 @@ int main(int ac, char **av)
 			btrfs_min_dev_size(nodesize));
 		exit(1);
 	}
-	for (i = saved_optind; i < saved_optind + dev_cnt; i++) {
+	for (i = optind; i < optind + dev_cnt; i++) {
 		char *path;
 
 		path = av[i];
@@ -1588,8 +1583,6 @@ int main(int ac, char **av)
 		printf("See %s for more information.\n\n", PACKAGE_URL);
 	}
 
-	dev_cnt--;
-
 	if (!source_dir_set) {
 		/*
 		 * open without O_EXCL so that the problem should not
@@ -1720,13 +1713,10 @@ int main(int ac, char **av)
 	if (is_block_device(file) == 1)
 		btrfs_register_one_device(file);
 
-	if (dev_cnt == 0)
-		goto raid_groups;
-
-	while (dev_cnt-- > 0) {
+	for (i = optind + 1; i < optind + dev_cnt; i++) {
 		int old_mixed = mixed;
 
-		file = av[optind++];
+		file = av[i];
 
 		/*
 		 * open without O_EXCL so that the problem should not
@@ -1771,7 +1761,6 @@ int main(int ac, char **av)
 			btrfs_register_one_device(file);
 	}
 
-raid_groups:
 	if (!source_dir_set) {
 		ret = create_raid_groups(trans, root, data_profile,
 				 metadata_profile, mixed, &allocation);
-- 
1.8.5.1

