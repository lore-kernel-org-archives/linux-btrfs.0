From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] btrfs: simplify makefile
Date: Mon, 13 Apr 2009 15:32:28 +0200
Message-ID: <20090413133228.GA11746@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Get rid of the hacks for building out of tree, and always use += for
assigning to the object lists.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/btrfs/Makefile
===================================================================
--- linux-2.6.orig/fs/btrfs/Makefile	2009-04-13 13:18:36.258480097 +0200
+++ linux-2.6/fs/btrfs/Makefile	2009-04-13 13:24:19.297482010 +0200
@@ -1,25 +1,10 @@
-ifneq ($(KERNELRELEASE),)
-# kbuild part of makefile
 
 obj-$(CONFIG_BTRFS_FS) := btrfs.o
-btrfs-y := super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
+
+btrfs-y += super.o ctree.o extent-tree.o print-tree.o root-tree.o dir-item.o \
 	   file-item.o inode-item.o inode-map.o disk-io.o \
 	   transaction.o inode.o file.o tree-defrag.o \
 	   extent_map.o sysfs.o struct-funcs.o xattr.o ordered-data.o \
 	   extent_io.o volumes.o async-thread.o ioctl.o locking.o orphan.o \
 	   ref-cache.o export.o tree-log.o acl.o free-space-cache.o zlib.o \
 	   compression.o delayed-ref.o
-else
-
-# Normal Makefile
-
-KERNELDIR := /lib/modules/`uname -r`/build
-all:
-	$(MAKE) -C $(KERNELDIR) M=`pwd` CONFIG_BTRFS_FS=m modules
-
-modules_install:
-	$(MAKE) -C $(KERNELDIR) M=`pwd` modules_install
-clean:
-	$(MAKE) -C $(KERNELDIR) M=`pwd` clean
-
-endif
