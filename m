Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:58049 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752366AbeEOJRT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 May 2018 05:17:19 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id E7BE44B34D47
        for <linux-btrfs@vger.kernel.org>; Tue, 15 May 2018 17:17:15 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: remove BTRFS_LIST_LAYOUT_RAW
Date: Tue, 15 May 2018 17:17:14 +0800
Message-ID: <1526375834-28486-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since
commit 9005b603d723 ("btrfs-progs: use libbtrfsutil for subvol show"),
BTRFS_LIST_LAYOUT_RAW has no usage.
So, remove it.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 btrfs-list.c | 20 --------------------
 btrfs-list.h |  3 +--
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/btrfs-list.c b/btrfs-list.c
index e01c5899..16be6b2f 100644
--- a/btrfs-list.c
+++ b/btrfs-list.c
@@ -1374,23 +1374,6 @@ static void print_subvolume_column(struct root_info *subv,
 	}
 }
 
-static void print_one_subvol_info_raw(struct root_info *subv,
-		const char *raw_prefix)
-{
-	int i;
-
-	for (i = 0; i < BTRFS_LIST_ALL; i++) {
-		if (!btrfs_list_columns[i].need_print)
-			continue;
-
-		if (raw_prefix)
-			printf("%s",raw_prefix);
-
-		print_subvolume_column(subv, i);
-	}
-	printf("\n");
-}
-
 static void print_one_subvol_info_table(struct root_info *subv)
 {
 	int i;
@@ -1480,9 +1463,6 @@ static void print_all_subvol_info(struct root_lookup *sorted_tree,
 		case BTRFS_LIST_LAYOUT_TABLE:
 			print_one_subvol_info_table(entry);
 			break;
-		case BTRFS_LIST_LAYOUT_RAW:
-			print_one_subvol_info_raw(entry, raw_prefix);
-			break;
 		}
 next:
 		n = rb_next(n);
diff --git a/btrfs-list.h b/btrfs-list.h
index 6e5fc778..299e3122 100644
--- a/btrfs-list.h
+++ b/btrfs-list.h
@@ -33,8 +33,7 @@
 
 enum btrfs_list_layout {
 	BTRFS_LIST_LAYOUT_DEFAULT = 0,
-	BTRFS_LIST_LAYOUT_TABLE,
-	BTRFS_LIST_LAYOUT_RAW
+	BTRFS_LIST_LAYOUT_TABLE
 };
 
 /*
-- 
2.17.0



