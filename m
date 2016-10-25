Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7440 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S965719AbcJYLCo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 07:02:44 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
        by cn.fujitsu.com (Postfix) with ESMTP id 8B11D41B4BC5
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Oct 2016 19:02:29 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: minor codes cleanup
Date: Tue, 25 Oct 2016 18:56:07 +0800
Message-Id: <20161025105607.17476-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
V1: Just one small codes cleanup, if you think it's not appropriate to
    make a individual patch for it, please ignore it :)
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 9aa6d2c..3c8f0ec 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2823,7 +2823,7 @@ int btrfs_should_throttle_delayed_refs(struct btrfs_trans_handle *trans,
 	smp_mb();
 	avg_runtime = fs_info->avg_delayed_ref_runtime;
 	val = num_entries * avg_runtime;
-	if (num_entries * avg_runtime >= NSEC_PER_SEC)
+	if (val >= NSEC_PER_SEC)
 		return 1;
 	if (val >= NSEC_PER_SEC / 2)
 		return 2;
-- 
2.9.0



