From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/5] btrfs: Fix memory leak in a failure path
Date: Mon, 29 Nov 2010 16:03:04 +0800
Message-ID: <4CF35E38.4020606@cn.fujitsu.com>
References: <4CF35E17.6050705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CF35E17.6050705@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

In btrfs_ioctl_snap_create(), vol_args_v2 is not freed if
copy_to_user() returns failure.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 fs/btrfs/ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d3f1a60..ba437ad 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -976,7 +976,7 @@ static noinline int btrfs_ioctl_snap_create(struct file *file,
 		if (copy_to_user(arg +
 				offsetof(struct btrfs_ioctl_vol_args_v2,
 				transid), &transid, sizeof(transid)))
-			return -EFAULT;
+			ret = -EFAULT;
 	}
 out:
 	kfree(vol_args);
-- 
1.6.3

