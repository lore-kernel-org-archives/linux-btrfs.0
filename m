Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:18876 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751024AbdJaJXM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Oct 2017 05:23:12 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 8F04B481847F
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Oct 2017 17:23:09 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/2] btrfs-progs: Remove unused variable
Date: Tue, 31 Oct 2017 17:23:04 +0800
Message-ID: <1509441784-52316-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1509441784-52316-1-git-send-email-gujx@cn.fujitsu.com>
References: <1509441784-52316-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some variable is never used.
Remove them.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 Android.mk | 1 -
 Makefile   | 2 --
 2 files changed, 3 deletions(-)

diff --git a/Android.mk b/Android.mk
index 958b8bd7..de71a5d1 100644
--- a/Android.mk
+++ b/Android.mk
@@ -38,7 +38,6 @@ libbtrfs_headers := send-stream.h send-utils.h send.h kernel-lib/rbtree.h btrfs-
                    kernel-lib/crc32c.h kernel-lib/list.h kerncompat.h \
                    kernel-lib/radix-tree.h kernel-lib/sizes.h kernel-lib/raid56.h \
                    extent-cache.h extent_io.h ioctl.h ctree.h btrfsck.h version.h
-TESTS := fsck-tests.sh convert-tests.sh
 blkid_objects := partition/ superblocks/ topology/
 
 
diff --git a/Makefile b/Makefile
index 8ca5e63f..7c12f222 100644
--- a/Makefile
+++ b/Makefile
@@ -129,8 +129,6 @@ image_objects = image/main.o image/sanitize.o
 all_objects = $(objects) $(cmds_objects) $(libbtrfs_objects) $(convert_objects) \
 	      $(mkfs_objects) $(image_objects)
 
-TESTS = fsck-tests.sh convert-tests.sh
-
 udev_rules = 64-btrfs-dm.rules
 
 ifeq ("$(origin V)", "command line")
-- 
2.13.6



