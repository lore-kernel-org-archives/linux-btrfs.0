From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/27] fs/btrfs: Use memdup_user
Date: Sat, 22 May 2010 10:19:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1005221018590.13021@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

Use memdup_user when user data is immediately copied into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to,size,flag;
position p;
identifier l1,l2;
@@

-  to = \(kmalloc@p\|kzalloc@p\)(size,flag);
+  to = memdup_user(from,size);
   if (
-      to==NULL
+      IS_ERR(to)
                 || ...) {
   <+... when != goto l1;
-  -ENOMEM
+  PTR_ERR(to)
   ...+>
   }
-  if (copy_from_user(to, from, size) != 0) {
-    <+... when != goto l2;
-    -EFAULT
-    ...+>
-  }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/btrfs/ioctl.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 97a9783..5301d78 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1096,14 +1096,10 @@ static noinline int btrfs_ioctl_tree_search(struct file *file,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	args = kmalloc(sizeof(*args), GFP_KERNEL);
-	if (!args)
-		return -ENOMEM;
+	args = memdup_user(argp, sizeof(*args));
+	if (IS_ERR(args))
+		return PTR_ERR(args);
 
-	if (copy_from_user(args, argp, sizeof(*args))) {
-		kfree(args);
-		return -EFAULT;
-	}
 	inode = fdentry(file)->d_inode;
 	ret = search_ioctl(inode, args);
 	if (ret == 0 && copy_to_user(argp, args, sizeof(*args)))
@@ -1211,14 +1207,10 @@ static noinline int btrfs_ioctl_ino_lookup(struct file *file,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	args = kmalloc(sizeof(*args), GFP_KERNEL);
-	if (!args)
-		return -ENOMEM;
+	args = memdup_user(argp, sizeof(*args));
+	if (IS_ERR(args))
+		return PTR_ERR(args);
 
-	if (copy_from_user(args, argp, sizeof(*args))) {
-		kfree(args);
-		return -EFAULT;
-	}
 	inode = fdentry(file)->d_inode;
 
 	if (args->treeid == 0)
