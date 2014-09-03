Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3895 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932354AbaICNeU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Sep 2014 09:34:20 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s83DYG89006698
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Sep 2014 21:34:16 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 16/18] Btrfs: stop mounting the fs if the non-ENOENT errors happen when opening seed fs
Date: Wed, 3 Sep 2014 21:35:45 +0800
Message-ID: <1409751347-5296-16-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
References: <1409751347-5296-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

When we open a seed filesystem, if the degraded mount option is set, we continue to
mount the fs if we don't find some devices in the seed filesystem. But we should stop
mounting if other errors happen. Fix it

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/volumes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fd8141e..cc59fcb 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6093,7 +6093,7 @@ static int read_one_dev(struct btrfs_root *root,
 
 	if (memcmp(fs_uuid, root->fs_info->fsid, BTRFS_UUID_SIZE)) {
 		ret = open_seed_devices(root, fs_uuid);
-		if (ret && !btrfs_test_opt(root, DEGRADED))
+		if (ret && !(ret == -ENOENT && btrfs_test_opt(root, DEGRADED)))
 			return ret;
 	}
 
-- 
1.9.3

