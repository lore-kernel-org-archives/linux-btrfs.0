Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59507 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbcJZH34 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 03:29:56 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v2] btrfs: cleanup: use already calculated value in btrfs_should_throttle_delayed_refs()
Date: Wed, 26 Oct 2016 15:23:01 +0800
Message-Id: <20161026072301.6748-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
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



