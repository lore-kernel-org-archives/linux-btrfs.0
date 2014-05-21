Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:46054 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbaEURUf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 May 2014 13:20:35 -0400
Received: by mail-pd0-f170.google.com with SMTP id g10so1597406pdj.1
        for <linux-btrfs@vger.kernel.org>; Wed, 21 May 2014 10:20:35 -0700 (PDT)
From: Adam Buchbinder <abuchbinder@google.com>
To: linux-btrfs@vger.kernel.org
Cc: dave@jikos.cz, Adam Buchbinder <abuchbinder@google.com>
Subject: [PATCH] Add some simple end-to-end tests for btrfs-convert.
Date: Wed, 21 May 2014 10:20:27 -0700
Message-Id: <1400692827-14606-1-git-send-email-abuchbinder@google.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

These use the system's mke2fs, and don't require loop devices
or root privileges.

They don't pick up anything with the default flags right now,
but they do pick up some sanitizer issues when the tools are
compiled with any of -fsanitize={address,memory,thread}.

Signed-off-by: Adam Buchbinder <abuchbinder@google.com>
---
 Makefile               |  2 +-
 tests/convert-tests.sh | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+), 1 deletion(-)
 create mode 100644 tests/convert-tests.sh

diff --git a/Makefile b/Makefile
index da05197..8f002f3 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,7 @@ libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
 	       extent_io.h ioctl.h ctree.h btrfsck.h
-TESTS = fsck-tests.sh
+TESTS = fsck-tests.sh convert-tests.sh
 
 INSTALL = install
 prefix ?= /usr/local
diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
new file mode 100644
index 0000000..87369c5
--- /dev/null
+++ b/tests/convert-tests.sh
@@ -0,0 +1,35 @@
+#!/bin/bash
+#
+# convert ext2/3/4 images to btrfs images, and make sure the results are
+# clean.
+#
+
+here=`pwd`
+
+_fail()
+{
+	echo "$*" | tee -a convert-tests-results.txt
+	exit 1
+}
+
+rm -f convert-tests-results.txt
+rm -f test.img
+
+test(){
+	echo "     [TEST]    $1"
+        shift
+        echo "creating ext image with: $*" >> convert-tests-results.txt
+	# 256MB is the smallest acceptable btrfs image.
+	dd if=/dev/zero of=$here/test.img bs=1024 count=$((256*1024)) \
+		>> convert-tests-results.txt 2>&1 || _fail "dd failed"
+	$* -F $here/test.img >> convert-tests-results.txt 2>&1 \
+		|| _fail "filesystem create failed"
+	$here/btrfs-convert $here/test.img >> convert-tests-results.txt 2>&1 \
+		|| _fail "btrfs-convert failed"
+	$here/btrfsck $here/test.img >> convert-tests-results.txt 2>&1 \
+		|| _fail "btrfsck detected errors"
+}
+
+test "ext2, 4k blocksize" mke2fs -b 4096
+test "ext3, 4k blocksize" mke2fs -j -b 4096
+test "ext4, 4k blocksize" mke2fs -t ext4 -b 4096
-- 
1.9.1.423.g4596e3a

