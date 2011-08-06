From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: [PATCH 06/12 v5] Btrfs: still update inode trans stuff when size remains unchanged
Date: Sat, 6 Aug 2011 17:37:41 +0800
Message-ID: <1312623467-31487-7-git-send-email-liubo2009@cn.fujitsu.com>
References: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
Cc: <chris.mason@oracle.com>
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1312623467-31487-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Due to DIO stuff, commit 1ef30be142d2cc60e2687ef267de864cf31be995 makes btrfs
not call btrfs_update_inode when it does not update i_disk_size, but in buffer
write case, we need to update btrfs internal inode's trans stuff, so that the
log code can find the inode's changes.

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
---
 fs/btrfs/inode.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index eb481ea..a30b611 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1789,7 +1789,8 @@ static int btrfs_finish_ordered_io(struct inode *inode, u64 start, u64 end)
 	if (!ret) {
 		ret = btrfs_update_inode(trans, root, inode);
 		BUG_ON(ret);
-	}
+	} else
+		btrfs_set_inode_last_trans(trans, inode);
 	ret = 0;
 out:
 	if (nolock) {
-- 
1.6.5.2

