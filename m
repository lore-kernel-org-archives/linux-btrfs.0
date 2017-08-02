Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36662 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbdHBSwW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 14:52:22 -0400
Received: by mail-pf0-f176.google.com with SMTP id z129so24428734pfb.3
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 11:52:22 -0700 (PDT)
From: filipbystricky@google.com
To: linux-btrfs@vger.kernel.org
Cc: salyzyn@android.com, Filip Bystricky <filipbystricky@google.com>
Subject: [PATCH 2/3] fixed android.mk
Date: Wed,  2 Aug 2017 11:51:10 -0700
Message-Id: <20170802185111.187922-2-filipbystricky@google.com>
In-Reply-To: <20170802185111.187922-1-filipbystricky@google.com>
References: <20170802185111.187922-1-filipbystricky@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filip Bystricky <filipbystricky@google.com>

Signed-off-by: Filip Bystricky <filipbystricky@google.com>
Reviewed-by: Mark Salyzyn <salyzyn@android.com>
---
 Android.mk | 53 +++++++++++++++++++++--------------------------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/Android.mk b/Android.mk
index 52fe9ab4..9516c2d1 100644
--- a/Android.mk
+++ b/Android.mk
@@ -1,18 +1,19 @@
 LOCAL_PATH:= $(call my-dir)
 
-#include $(call all-subdir-makefiles)
+# temporary flags to reduce the number of emitted warnings until they can be
+# fixed properly
+TEMP_CFLAGS := -Wno-pointer-arith -Wno-tautological-constant-out-of-range-compare \
+	-Wno-sign-compare -Wno-format -Wno-unused-parameter
 
 CFLAGS := -g -O1 -Wall -D_FORTIFY_SOURCE=2 -include config.h \
-	-DBTRFS_FLAT_INCLUDES -D_XOPEN_SOURCE=700 -fno-strict-aliasing -fPIC
+	-DBTRFS_FLAT_INCLUDES -D_XOPEN_SOURCE=700 -fno-strict-aliasing -fPIC \
+	-Wno-macro-redefined -Wno-typedef-redefinition -Wno-address-of-packed-member \
+	-Wno-missing-field-initializers $(TEMP_CFLAGS)
 
-LDFLAGS := -static -rdynamic
-
-LIBS := -luuid   -lblkid   -lz   -llzo2 -L. -lpthread
-LIBBTRFS_LIBS := $(LIBS)
-
-STATIC_CFLAGS := $(CFLAGS) -ffunction-sections -fdata-sections
-STATIC_LDFLAGS := -static -Wl,--gc-sections
-STATIC_LIBS := -luuid   -lblkid -luuid -lz   -llzo2 -L. -pthread
+STATIC_CFLAGS := $(CFLAGS) -ffunction-sections -fdata-sections \
+	-D_GNU_SOURCE=1 \
+	-DPACKAGE_STRING=\"btrfs\" \
+	-DPACKAGE_URL=\"http://btrfs.wiki.kernel.org\"
 
 btrfs_shared_libraries := libext2_uuid \
 			libext2_blkid
@@ -23,7 +24,8 @@ objects := ctree.c disk-io.c kernel-lib/radix-tree.c extent-tree.c print-tree.c
           qgroup.c free-space-cache.c kernel-lib/list_sort.c props.c \
           kernel-shared/ulist.c qgroup-verify.c backref.c string-table.c task-utils.c \
           inode.c file.c find-root.c free-space-tree.c help.c send-dump.c \
-          fsfeatures.c kernel-lib/tables.c kernel-lib/raid56.c
+          fsfeatures.c raid56.c
+
 cmds_objects := cmds-subvolume.c cmds-filesystem.c cmds-device.c cmds-scrub.c \
                cmds-inspect.c cmds-balance.c cmds-send.c cmds-receive.c \
                cmds-quota.c cmds-qgroup.c cmds-replace.c cmds-check.c \
@@ -38,12 +40,11 @@ libbtrfs_headers := send-stream.h send-utils.h send.h kernel-lib/rbtree.h btrfs-
                    kernel-lib/crc32c.h kernel-lib/list.h kerncompat.h \
                    kernel-lib/radix-tree.h kernel-lib/sizes.h kernel-lib/raid56.h \
                    extent-cache.h extent_io.h ioctl.h ctree.h btrfsck.h version.h
-TESTS := fsck-tests.sh convert-tests.sh
-blkid_objects := partition/ superblocks/ topology/
-
 
 # external/e2fsprogs/lib is needed for uuid/uuid.h
-common_C_INCLUDES := $(LOCAL_PATH) external/e2fsprogs/lib/ external/lzo/include/ external/zlib/
+common_C_INCLUDES := $(LOCAL_PATH) external/e2fsprogs/lib/ external/lzo/include/ external/zlib/ \
+		$(LOCAL_PATH)/kernel-lib
+
 
 #----------------------------------------------------------
 include $(CLEAR_VARS)
@@ -56,23 +57,18 @@ include $(BUILD_STATIC_LIBRARY)
 #----------------------------------------------------------
 include $(CLEAR_VARS)
 LOCAL_MODULE := btrfs
-#LOCAL_FORCE_STATIC_EXECUTABLE := true
 LOCAL_SRC_FILES := \
 		$(objects) \
 		$(cmds_objects) \
-		btrfs.c \
-		help.c \
+		btrfs.c
 
 LOCAL_C_INCLUDES := $(common_C_INCLUDES)
 LOCAL_CFLAGS := $(STATIC_CFLAGS)
-#LOCAL_LDLIBS := $(LIBBTRFS_LIBS)
-#LOCAL_LDFLAGS := $(STATIC_LDFLAGS)
 LOCAL_SHARED_LIBRARIES := $(btrfs_shared_libraries)
 LOCAL_STATIC_LIBRARIES := libbtrfs liblzo-static libz
 LOCAL_SYSTEM_SHARED_LIBRARIES := libc libcutils
-
 LOCAL_EXPORT_C_INCLUDES := $(common_C_INCLUDES)
-#LOCAL_MODULE_TAGS := optional
+
 include $(BUILD_EXECUTABLE)
 
 #----------------------------------------------------------
@@ -85,14 +81,11 @@ LOCAL_SRC_FILES := \
 
 LOCAL_C_INCLUDES := $(common_C_INCLUDES)
 LOCAL_CFLAGS := $(STATIC_CFLAGS)
-#LOCAL_LDLIBS := $(LIBBTRFS_LIBS)
-#LOCAL_LDFLAGS := $(STATIC_LDFLAGS)
 LOCAL_SHARED_LIBRARIES := $(btrfs_shared_libraries)
 LOCAL_STATIC_LIBRARIES := libbtrfs liblzo-static
 LOCAL_SYSTEM_SHARED_LIBRARIES := libc libcutils
-
 LOCAL_EXPORT_C_INCLUDES := $(common_C_INCLUDES)
-#LOCAL_MODULE_TAGS := optional
+
 include $(BUILD_EXECUTABLE)
 
 #---------------------------------------------------------------
@@ -105,13 +98,9 @@ LOCAL_SRC_FILES := \
 LOCAL_C_INCLUDES := $(common_C_INCLUDES)
 LOCAL_CFLAGS := $(STATIC_CFLAGS)
 LOCAL_SHARED_LIBRARIES := $(btrfs_shared_libraries)
-#LOCAL_LDLIBS := $(LIBBTRFS_LIBS)
-#LOCAL_LDFLAGS := $(STATIC_LDFLAGS)
-LOCAL_SHARED_LIBRARIES := $(btrfs_shared_libraries)
 LOCAL_STATIC_LIBRARIES := libbtrfs liblzo-static
 LOCAL_SYSTEM_SHARED_LIBRARIES := libc libcutils
-
 LOCAL_EXPORT_C_INCLUDES := $(common_C_INCLUDES)
-LOCAL_MODULE_TAGS := optional
+
 include $(BUILD_EXECUTABLE)
-#--------------------------------------------------------------
\ No newline at end of file
+#--------------------------------------------------------------
-- 
2.14.0.rc1.383.gd1ce394fe2-goog

