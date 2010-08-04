From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH] btrfs: fix memory leak at umount
Date: Wed, 04 Aug 2010 09:41:43 +0800
Message-ID: <4C58C557.4090503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

fs_info, which is allocated in open_ctree(), should be freed
in close_ctree().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

candidate for stable ?

---
 fs/btrfs/disk-io.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 280de15..199cc26 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2469,6 +2469,8 @@ int close_ctree(struct btrfs_root *root)
 	kfree(fs_info->chunk_root);
 	kfree(fs_info->dev_root);
 	kfree(fs_info->csum_root);
+	kfree(fs_info);
+
 	return 0;
 }
 
-- 
1.6.3
