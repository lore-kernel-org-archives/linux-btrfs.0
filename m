From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 1/5] Btrfs: fix bh leak on __btrfs_open_devices path
Date: Wed, 20 Apr 2011 18:06:40 +0800
Message-ID: <4DAEB030.1070303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: LKML <linux-kernel@vger.kernel.org>,
	BTRFS <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

'bh' is forgot to release if no error is detected

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 fs/btrfs/volumes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 8b9fb8c..69fc902 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -631,6 +631,7 @@ static int __btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 			list_add(&device->dev_alloc_list,
 				 &fs_devices->alloc_list);
 		}
+		brelse(bh);
 		continue;
 
 error_brelse:
-- 
1.7.4.4
