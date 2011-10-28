From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] btrfs: Avoid creating new file in append-only dir when open(2) return error
Date: Sat, 29 Oct 2011 02:01:47 +0800
Message-ID: <1319824907-5534-1-git-send-email-guaneryu@gmail.com>
Cc: Eryu Guan <guaneryu@gmail.com>,
	Chris Mason <chris.mason@oracle.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Newly created file on btrfs inherits inode flags from parent directory,
so new inode created in append-only directory has S_APPEND flag set,
may_open() called by do_last() checks that flag then returns -EPERM,
but at that time the new inode is already created.

This can be reproduced by:
	# mkdir -p /mnt/btrfs/append-only
	# chattr +a /mnt/btrfs/append-only
	# ./opentest /mnt/btrfs/append-only/newtestfile
	# ls -l /mnt/btrfs/append-only/newtestfile

opentest will return 'Operation not permitted', but the ls shows that
newtestfile is already created.

	# cat opentest.c
	#include <stdio.h>
	#include <sys/types.h>
	#include <fcntl.h>
	#include <sys/stat.h>

	int main(int argc, char *argv[])
	{
		int fd;
		fd = open(argv[1], O_RDWR|O_CREAT, 0666);
		if (fd == -1)
			perror("open failed");
		return 0;
	}

To avoid this, check BTRFS_INODE_APPEND flag first in btrfs_create before
really allocating new inode.

Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/btrfs/inode.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b2d004a..18e9914 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -38,6 +38,7 @@
 #include <linux/falloc.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/namei.h>
 #include "compat.h"
 #include "ctree.h"
 #include "disk-io.h"
@@ -4718,10 +4719,19 @@ static int btrfs_create(struct inode *dir, struct dentry *dentry,
 	struct inode *inode = NULL;
 	int drop_inode = 0;
 	int err;
+	int open_flag = nd->intent.open.file->f_flags;
 	unsigned long nr = 0;
 	u64 objectid;
 	u64 index = 0;
 
+	if (BTRFS_I(dir)->flags & BTRFS_INODE_APPEND) {
+		if ((open_flag & O_ACCMODE) != O_RDONLY &&
+		    !(open_flag & O_APPEND))
+			return -EPERM;
+		if (open_flag & O_TRUNC)
+			return -EPERM;
+	}
+
 	/*
 	 * 2 for inode item and ref
 	 * 2 for dir items
-- 
1.7.7.1

