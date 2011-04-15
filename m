From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/3] Btrfs: fix FS_IOC_GETFLAGS ioctl
Date: Fri, 15 Apr 2011 11:03:06 +0800
Message-ID: <4DA7B56A.6080503@cn.fujitsu.com>
References: <4DA7B559.8060800@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4DA7B559.8060800@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

As we've added per file compression/cow support.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 3240dd9..aeabf6b 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -81,6 +81,13 @@ static unsigned int btrfs_flags_to_ioctl(unsigned int flags)
 		iflags |= FS_NOATIME_FL;
 	if (flags & BTRFS_INODE_DIRSYNC)
 		iflags |= FS_DIRSYNC_FL;
+	if (flags & BTRFS_INODE_NODATACOW)
+		iflags |= FS_NOCOW_FL;
+
+	if ((flags & BTRFS_INODE_COMPRESS) && !(flags & BTRFS_INODE_NOCOMPRESS))
+		iflags |= FS_COMPR_FL;
+	else if (flags & BTRFS_INODE_NOCOMPRESS)
+		iflags |= FS_NOCOMP_FL;
 
 	return iflags;
 }
-- 
1.7.3.1
