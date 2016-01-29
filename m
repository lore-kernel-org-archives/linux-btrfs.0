Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36659 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbcA2Nge (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 08:36:34 -0500
Received: by mail-pf0-f193.google.com with SMTP id n128so3788489pfn.3
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 05:36:34 -0800 (PST)
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
From: Kinglong Mee <kinglongmee@gmail.com>
Subject: [PATCH 2/3] btrfs: fix compile warning of uninitialized value
Cc: miaoxie@huawei.com, kinglongmee@gmail.com
Message-ID: <56AB6AD5.2010403@gmail.com>
Date: Fri, 29 Jan 2016 21:36:21 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

  CC [M]  fs/btrfs/extent-tree.o
fs/btrfs/extent-tree.c: In function 'find_free_extent':
fs/btrfs/extent-tree.c:7021:34: warning: 'used_bg' may be used uninitialized in this function [-Wmaybe-uninitialized]
  struct btrfs_block_group_cache *used_bg;
                                  ^
Fixes: e570fd27f2 ("Btrfs: fix broken free space cache after the system crashed")
Signed-off-by: Kinglong Mee <kinglongmee@gmail.com>
---
 fs/btrfs/extent-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e2287c7..f24e4c3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7018,7 +7018,7 @@ btrfs_lock_cluster(struct btrfs_block_group_cache *block_group,
 		   struct btrfs_free_cluster *cluster,
 		   int delalloc)
 {
-	struct btrfs_block_group_cache *used_bg;
+	struct btrfs_block_group_cache *used_bg = NULL;
 	bool locked = false;
 again:
 	spin_lock(&cluster->refill_lock);
-- 
2.5.0

