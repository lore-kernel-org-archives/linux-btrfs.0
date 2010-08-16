From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 5/16] fs/btrfs: Use available error codes
Date: Mon, 16 Aug 2010 18:25:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1008161825390.19313@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Error codes are stored in ret, but the return value is always 0.  Return
ret instead.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
This changes the semantics and has not been tested.

 fs/btrfs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9254b3d..bc7e9c5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -212,7 +212,7 @@ static int btrfs_ioctl_setflags(struct file *file, void __user *arg)
 	mnt_drop_write(file->f_path.mnt);
  out_unlock:
 	mutex_unlock(&inode->i_mutex);
-	return 0;
+	return ret;
 }
 
 static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
