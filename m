Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36641 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab3IIUmM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Sep 2013 16:42:12 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 621A69A04FA
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Sep 2013 14:42:12 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id oDZwB9qp5O75VpFu (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Mon, 09 Sep 2013 14:42:11 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 5/5] Btrfs-progs: add make test framework
Date: Mon, 9 Sep 2013 16:41:58 -0400
Message-ID: <1378759318-3305-5-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1378759318-3305-1-git-send-email-jbacik@fusionio.com>
References: <1378759318-3305-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We need to start adding some sanity tests to btrfs-progs to make sure we aren't
breaking things with our patches.  The most important of these tools is btrfsck.
This patch gets things started by adding a basic btrfsck test that makes sure we
can fix a corruption problem we know we can fix.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 Makefile                                        |    7 +++++
 tests/fsck-tests.sh                             |   31 +++++++++++++++++++++++
 tests/fsck-tests/001-bad-file-extent-bytenr.img |  Bin 0 -> 4096 bytes
 3 files changed, 38 insertions(+), 0 deletions(-)
 create mode 100644 tests/fsck-tests.sh
 create mode 100644 tests/fsck-tests/001-bad-file-extent-bytenr.img

diff --git a/Makefile b/Makefile
index 3fade14..0e812cc 100644
--- a/Makefile
+++ b/Makefile
@@ -19,6 +19,7 @@ libbtrfs_objects = send-stream.o send-utils.o rbtree.o btrfs-list.o crc32c.o \
 libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
 	       crc32c.h list.h kerncompat.h radix-tree.h extent-cache.h \
 	       extent_io.h ioctl.h ctree.h btrfsck.h
+TESTS = fsck-tests.sh
 
 INSTALL = install
 prefix ?= /usr/local
@@ -123,6 +124,12 @@ $(BUILDDIRS):
 	@echo "Making all in $(patsubst build-%,%,$@)"
 	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst build-%,%,$@)
 
+test:
+	$(Q)for t in $(TESTS); do \
+		echo "     [TEST]    $$t"; \
+		bash tests/$$t || exit 1; \
+	done
+
 #
 # NOTE: For static compiles, you need to have all the required libs
 # 	static equivalent available
diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
new file mode 100644
index 0000000..c1490bf
--- /dev/null
+++ b/tests/fsck-tests.sh
@@ -0,0 +1,31 @@
+#!/bin/bash
+#
+# loop through all of our bad images and make sure fsck repairs them properly
+#
+# It's GPL, same as everything else in this tree.
+#
+
+here=`pwd`
+
+_fail()
+{
+	echo "$*" | tee -a fsck-tests-results.txt
+	exit 1
+}
+
+rm -f fsck-tests-results.txt
+
+for i in $(find $here/tests/fsck-tests -name '*.img')
+do
+	echo "testing image $i" >> fsck-tests-results.txt
+	$here/btrfs-image -r $i test.img >> fsck-tests-results.txt 2>&1 \
+		|| _fail "restore failed"
+	$here/btrfsck test.img >> fsck-test-results.txt 2>&1
+	[ $? -eq 0 ] && _fail "btrfsck should have detected corruption"
+
+	$here/btrfsck --repair test.img >> fsck-test-results.txt 2>&1 || \
+		_fail "btrfsck should have repaired the image"
+
+	$here/btrfsck test.img >> fsck-test-results.txt 2>&1 || \
+		_fail "btrfsck did not correct corruption"
+done
diff --git a/tests/fsck-tests/001-bad-file-extent-bytenr.img b/tests/fsck-tests/001-bad-file-extent-bytenr.img
new file mode 100644
index 0000000000000000000000000000000000000000..d2a05bb8f83d7f1bdc4be1441d3d8d35a89e142e
GIT binary patch
literal 4096
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

literal 0
HcmV?d00001

-- 
1.7.7.6

