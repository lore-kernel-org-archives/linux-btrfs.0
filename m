From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] btrfsctl.c: fix the definition of struct
	btrfs_ioctl_vol_args
Date: Mon, 19 Jan 2009 21:02:08 +0800
Message-ID: <20090119130208.GB7424@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


According to the definition in kernel space, this one should be changed.

Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
diff --git a/btrfsctl.c b/btrfsctl.c
index e049799..5ff7f69 100644
--- a/btrfsctl.c
+++ b/btrfsctl.c
@@ -39,7 +39,7 @@
 #define BLKGETSIZE64 0
 #define BTRFS_IOC_SNAP_CREATE 0
 #define BTRFS_VOL_NAME_MAX 255
-struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX]; };
+struct btrfs_ioctl_vol_args { char name[BTRFS_VOL_NAME_MAX+1]; int fd;};
 static inline int ioctl(int fd, int define, void *arg) { return 0; }
 #endif
 


