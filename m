Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:33749 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbdHBSvz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 14:51:55 -0400
Received: by mail-pf0-f172.google.com with SMTP id d67so24498778pfc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 11:51:55 -0700 (PDT)
From: filipbystricky@google.com
To: linux-btrfs@vger.kernel.org
Cc: salyzyn@android.com, Filip Bystricky <filipbystricky@google.com>
Subject: [PATCH 1/3] copied android.mk from devel branch
Date: Wed,  2 Aug 2017 11:51:09 -0700
Message-Id: <20170802185111.187922-1-filipbystricky@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filip Bystricky <filipbystricky@google.com>

This series of patches fixes some compile errors that trigger when
compiling to android devices.

This first patch just brings in devel's Android.mk, to which
kdave@ added a few fixes recently.

Signed-off-by: Filip Bystricky <filipbystricky@google.com>
Reviewed-by: Mark Salyzyn <salyzyn@android.com>
---
 Android.mk | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/Android.mk b/Android.mk
index fe3209b6..52fe9ab4 100644
--- a/Android.mk
+++ b/Android.mk
@@ -17,22 +17,27 @@ STATIC_LIBS := -luuid   -lblkid -luuid -lz   -llzo2 -L. -pthread
 btrfs_shared_libraries := libext2_uuid \
 			libext2_blkid
 
-objects := ctree.c disk-io.c radix-tree.c extent-tree.c print-tree.c \
+objects := ctree.c disk-io.c kernel-lib/radix-tree.c extent-tree.c print-tree.c \
           root-tree.c dir-item.c file-item.c inode-item.c inode-map.c \
           extent-cache.c extent_io.c volumes.c utils.c repair.c \
-          qgroup.c raid6.c free-space-cache.c list_sort.c props.c \
-          ulist.c qgroup-verify.c backref.c string-table.c task-utils.c \
-          inode.c file.c find-root.c
+          qgroup.c free-space-cache.c kernel-lib/list_sort.c props.c \
+          kernel-shared/ulist.c qgroup-verify.c backref.c string-table.c task-utils.c \
+          inode.c file.c find-root.c free-space-tree.c help.c send-dump.c \
+          fsfeatures.c kernel-lib/tables.c kernel-lib/raid56.c
 cmds_objects := cmds-subvolume.c cmds-filesystem.c cmds-device.c cmds-scrub.c \
                cmds-inspect.c cmds-balance.c cmds-send.c cmds-receive.c \
                cmds-quota.c cmds-qgroup.c cmds-replace.c cmds-check.c \
                cmds-restore.c cmds-rescue.c chunk-recover.c super-recover.c \
-               cmds-property.c cmds-fi-usage.c
-libbtrfs_objects := send-stream.c send-utils.c rbtree.c btrfs-list.c crc32c.c \
+               cmds-property.c cmds-fi-usage.c cmds-inspect-dump-tree.c \
+               cmds-inspect-dump-super.c cmds-inspect-tree-stats.c cmds-fi-du.c \
+               mkfs/common.c
+libbtrfs_objects := send-stream.c send-utils.c kernel-lib/rbtree.c btrfs-list.c \
+                   kernel-lib/crc32c.c messages.c \
                    uuid-tree.c utils-lib.c rbtree-utils.c
-libbtrfs_headers := send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
-                   crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
-                   extent_io.h ioctl.h ctree.h btrfsck.h version.h
+libbtrfs_headers := send-stream.h send-utils.h send.h kernel-lib/rbtree.h btrfs-list.h \
+                   kernel-lib/crc32c.h kernel-lib/list.h kerncompat.h \
+                   kernel-lib/radix-tree.h kernel-lib/sizes.h kernel-lib/raid56.h \
+                   extent-cache.h extent_io.h ioctl.h ctree.h btrfsck.h version.h
 TESTS := fsck-tests.sh convert-tests.sh
 blkid_objects := partition/ superblocks/ topology/
 
@@ -75,7 +80,8 @@ include $(CLEAR_VARS)
 LOCAL_MODULE := mkfs.btrfs
 LOCAL_SRC_FILES := \
                 $(objects) \
-                mkfs.c
+                mkfs/common.c \
+                mkfs/main.c
 
 LOCAL_C_INCLUDES := $(common_C_INCLUDES)
 LOCAL_CFLAGS := $(STATIC_CFLAGS)
@@ -108,4 +114,4 @@ LOCAL_SYSTEM_SHARED_LIBRARIES := libc libcutils
 LOCAL_EXPORT_C_INCLUDES := $(common_C_INCLUDES)
 LOCAL_MODULE_TAGS := optional
 include $(BUILD_EXECUTABLE)
-#--------------------------------------------------------------
+#--------------------------------------------------------------
\ No newline at end of file
-- 
2.14.0.rc1.383.gd1ce394fe2-goog

