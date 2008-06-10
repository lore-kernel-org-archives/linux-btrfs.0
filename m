From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: tiny makefile cleanup
Date: Tue, 10 Jun 2008 14:36:33 +0200
Message-ID: <20080610123633.GB31103@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

use normal kbuild syntax to build acl.o conditinally and remove comment
out lines.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: btrfs-unstable/Makefile
===================================================================
--- btrfs-unstable.orig/Makefile	2008-06-10 14:29:20.000000000 +0200
+++ btrfs-unstable/Makefile	2008-06-10 14:29:41.000000000 +0200
@@ -8,13 +8,7 @@ btrfs-y := super.o ctree.o extent-tree.o
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o
 
-ifeq ($(CONFIG_FS_POSIX_ACL),y)
-btrfs-y += acl.o
-endif
-#btrfs-y := ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
-#	  root-tree.o dir-item.o hash.o file-item.o inode-item.o \
-#	  inode-map.o \
-
+btrfs-$(CONFIG_FS_POSIX_ACL)	+= acl.o
 else
 
 # Normal Makefile
