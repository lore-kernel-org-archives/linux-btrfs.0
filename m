From: Shen Feng <shen@cn.fujitsu.com>
Subject: [PATCH] Btrfs: check return of kmalloc in btrfs_control_ioctl
Date: Mon, 29 Dec 2008 11:43:39 +0800
Message-ID: <4958476B.5090105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


The memory allocated by kmalloc should be checked before using it.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 fs/btrfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 84c3b66..d0e8dce 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -590,6 +590,8 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
 	int len;
 
 	vol = kmalloc(sizeof(*vol), GFP_KERNEL);
+	if (!vol)
+		return -ENOMEM;
 	if (copy_from_user(vol, (void __user *)arg, sizeof(*vol))) {
 		ret = -EFAULT;
 		goto out;
-- 
1.6.0.6


