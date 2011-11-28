From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH 1/2] Btrfs: adjust the variables indentation to TAB
Date: Mon, 28 Nov 2011 15:45:33 +0800
Message-ID: <4ED33C1D.3060804@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 fs/btrfs/ioctl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4a34c47..795c415 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1689,9 +1689,9 @@ err:
 static noinline int btrfs_ioctl_tree_search(struct file *file,
 					   void __user *argp)
 {
-	 struct btrfs_ioctl_search_args *args;
-	 struct inode *inode;
-	 int ret;
+	struct btrfs_ioctl_search_args *args;
+	struct inode *inode;
+	int ret;

 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-- 
1.7.4.1
