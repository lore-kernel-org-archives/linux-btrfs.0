From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] btrfs: cleanup fs/btrfs/super.c::btrfs_control_ioctl()
Date: Mon, 19 Jan 2009 21:36:31 +0800
Message-ID: <20090119133631.GA7863@hack.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


- Remove the unused local variable 'len';
- Check return value of kmalloc().

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Chris Mason <chris.mason@oracle.com>

---
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index db9fb3b..0e9d259 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -583,17 +583,18 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	struct btrfs_ioctl_vol_args *vol;
 	struct btrfs_fs_devices *fs_devices;
 	int ret = -ENOTTY;
-	int len;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	vol = kmalloc(sizeof(*vol), GFP_KERNEL);
+	if (!vol)
+		return -ENOMEM;
+
 	if (copy_from_user(vol, (void __user *)arg, sizeof(*vol))) {
 		ret = -EFAULT;
 		goto out;
 	}
-	len = strnlen(vol->name, BTRFS_PATH_NAME_MAX);
 
 	switch (cmd) {
 	case BTRFS_IOC_SCAN_DEV:

