From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 3/3] Btrfs: fix FS_IOC_SETFLAGS ioctl
Date: Fri, 15 Apr 2011 11:03:17 +0800
Message-ID: <4DA7B575.7090805@cn.fujitsu.com>
References: <4DA7B559.8060800@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DA7B559.8060800@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce the bug:

  - Call FS_IOC_SETLFAGS ioctl with flags=FS_COMPR_FL
  - Call FS_IOC_SETFLAGS ioctl with flags=0
  - Call FS_IOC_GETFLAGS ioctl, and you'll see FS_COMPR_FL is still set!

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index aeabf6b..3e7031d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -238,6 +238,8 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	} else if (flags & FS_COMPR_FL) {
 		ip->flags |= BTRFS_INODE_COMPRESS;
 		ip->flags &= ~BTRFS_INODE_NOCOMPRESS;
+	} else {
+		ip->flags &= ~(BTRFS_INODE_COMPRESS | BTRFS_INODE_NOCOMPRESS);
 	}
 
 	trans = btrfs_join_transaction(root, 1);
-- 
1.7.3.1
