Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8074 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757639AbeD0IWQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 04:22:16 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
        by cn.fujitsu.com (Postfix) with ESMTP id 1A0C548AE929
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 16:22:12 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs: modify path->reada in btrfs_shrink_device to READA_BACK
Date: Fri, 27 Apr 2018 16:22:07 +0800
Message-ID: <1524817327-32038-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_shrink_device, before btrfs_search_slot, path->reada is
set to READA_FORWARD. But I think READA_BACK is correct.
Since,
 1.key.offset is set to (u64)-1
 2.After btrfs_search_slot, btrfs_previous_item is called.
So, for readahead previous items, READA_BACK is correct one.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 292266f6ab9c..1a3506a3003d 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4473,7 +4473,7 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
 	if (!path)
 		return -ENOMEM;
 
-	path->reada = READA_FORWARD;
+	path->reada = READA_BACK;
 
 	mutex_lock(&fs_info->chunk_mutex);
 
-- 
1.9.1



