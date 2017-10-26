Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39247 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932286AbdJZIda (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 26 Oct 2017 04:33:30 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id B612347F13C2
        for <linux-btrfs@vger.kernel.org>; Thu, 26 Oct 2017 16:33:24 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: qgroup: fix qgroup show sort by multi items
Date: Thu, 26 Oct 2017 16:32:51 +0800
Message-ID: <20171026083251.13454-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We should not free the string until we don't call strtok any longer.

If the string is freed in advance, in fact, the second and subsequent
sort items will be ignored.

Fixes: 9fcdf8f8945b ("btrfs-progs: don't write to optarg in btrfs_qgroup_parse_sort_string")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 qgroup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/qgroup.c b/qgroup.c
index fffdbb12..7e8ef079 100644
--- a/qgroup.c
+++ b/qgroup.c
@@ -1222,7 +1222,8 @@ int btrfs_qgroup_parse_sort_string(const char *opt_arg,
 	if (!opt_tmp)
 		return -ENOMEM;
 
-	while ((p = strtok(opt_tmp, ",")) != NULL) {
+	p = strtok(opt_tmp, ",");
+	while (p) {
 		flag = 0;
 		ptr_argv = all_sort_items;
 
@@ -1262,8 +1263,7 @@ int btrfs_qgroup_parse_sort_string(const char *opt_arg,
 			}
 			btrfs_qgroup_setup_comparer(comps, what_to_sort, order);
 		}
-		free(opt_tmp);
-		opt_tmp = NULL;
+		p = strtok(NULL, ",");
 	}
 
 out:
-- 
2.14.3



