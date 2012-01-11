From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 05/11] Btrfs: reserve metadata space in btrfs_ioctl_setflags()
Date: Wed, 11 Jan 2012 13:53:17 +0800
Message-ID: <4F0D23CD.2090802@cn.fujitsu.com>
References: <4F0D236E.2010306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0D236E.2010306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Check and reserve space for btrfs_update_inode().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9619fb0..fe8a60c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -254,7 +254,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 		ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
 
-	trans = btrfs_join_transaction(root);
+	trans = btrfs_start_transaction(root, 1);
 	if (IS_ERR(trans)) {
 		ret = PTR_ERR(trans);
 		goto out_drop;
-- 
1.7.3.1
