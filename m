Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26005 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751819AbbJMKbZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 06:31:25 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t9DAUpBr014836
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Oct 2015 18:30:51 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: mkfs: Enable -d dup for single device
Date: Tue, 13 Oct 2015 18:29:41 +0800
Message-ID: <fff170b03b5707d4b4457f36da271fadf4bdeade.1444732174.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Current code don't support dup profile in single device, except it
is in mixed mode, because following reason:
1: In some ssd with deduplication function, it have no effect.
2: For a physical device, it the entire disk broken, -d dup can
   not help.
3: Half performance comparing with single profile.
4: We have a workaround: Create multi-partition in single device,
   and btefs will treat them as multi device.

Instead of refuse -d dup, we have a better choise:
Give user a chance to select, and output a warning to notice above
problem.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 mkfs.c  |  2 +-
 utils.c | 10 ++++------
 utils.h |  2 +-
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index ecd6fbf..7fa7cfc 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1578,7 +1578,7 @@ int main(int ac, char **av)
 		}
 	}
 	ret = test_num_disk_vs_raid(metadata_profile, data_profile,
-			dev_cnt, mixed);
+			dev_cnt, mixed, ssd);
 	if (ret)
 		exit(1);
 
diff --git a/utils.c b/utils.c
index f1e3248..d81c2d9 100644
--- a/utils.c
+++ b/utils.c
@@ -2425,7 +2425,7 @@ static int group_profile_devs_min(u64 flag)
 }
 
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
-	u64 dev_cnt, int mixed)
+	u64 dev_cnt, int mixed, int ssd)
 {
 	u64 allowed = 0;
 
@@ -2466,11 +2466,9 @@ int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
 		return 1;
 	}
 
-	if (!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP)) {
-		fprintf(stderr,
-			"ERROR: DUP for data is allowed only in mixed mode\n");
-		return 1;
-	}
+	warning_on(!mixed && (data_profile & BTRFS_BLOCK_GROUP_DUP) && ssd,
+		   "DUP have no effect if your SSD have deduplication function");
+
 	return 0;
 }
 
diff --git a/utils.h b/utils.h
index 044ea15..b85f3fe 100644
--- a/utils.h
+++ b/utils.h
@@ -167,7 +167,7 @@ int test_dev_for_mkfs(char *file, int force_overwrite);
 int get_label_mounted(const char *mount_path, char *labelp);
 int get_label_unmounted(const char *dev, char *label);
 int test_num_disk_vs_raid(u64 metadata_profile, u64 data_profile,
-	u64 dev_cnt, int mixed);
+	u64 dev_cnt, int mixed, int ssd);
 int group_profile_max_safe_loss(u64 flags);
 int is_vol_small(char *file);
 int csum_tree_block(struct btrfs_root *root, struct extent_buffer *buf,
-- 
1.8.5.1

