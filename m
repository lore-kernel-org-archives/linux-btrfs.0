From: jim owens <jowens@hp.com>
Subject: [RFC PATCH 03/03] Btrfs: enable direct I/O read support.
Date: Tue, 19 Jan 2010 16:58:51 -0500
Message-ID: <4B562B1B.4010502@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>



Signed-off-by: jim owens <jowens@hp.com>
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
index fbc5bd1..09a4d8e 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4935,12 +4935,9 @@ out:
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
1.5.6.3
