From: jim owens <owens6336@gmail.com>
Subject: [PATCH V3 18/18] Btrfs: enable direct I/O read support.
Date: Sun, 21 Mar 2010 23:36:00 -0400
Message-ID: <4BA6E5A0.8040802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


Signed-off-by: jim owens <owens6336@gmail.com>
---
 fs/btrfs/Makefile |    2 +-
 fs/btrfs/inode.c  |    7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/Makefile b/fs/btrfs/Makefile
index a35eb36..5cbe798 100644
--- a/fs/btrfs/Makefile
+++ b/fs/btrfs/Makefile
@@ -7,4 +7,4 @@ btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   export.o tree-log.o acl.o free-space-cache.o zlib.o \
-	   compression.o delayed-ref.o relocation.o
+	   compression.o delayed-ref.o relocation.o dio.o
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b704f49..c15fad6 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4890,12 +4890,9 @@ out:
 	return em;
 }
 
-static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
+extern ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
-{
-	return -EINVAL;
-}
+			unsigned long nr_segs);
 
 static int btrfs_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		__u64 start, __u64 len)
-- 
1.6.3.3
