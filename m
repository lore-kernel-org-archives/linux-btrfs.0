Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24888 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751654AbbG0G3i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 02:29:38 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6R6Rkqe003823
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 14:27:46 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 7/7] btrfs-progs: Introduce a misc test for thread conflict in btrfs-convert
Date: Mon, 27 Jul 2015 14:27:54 +0800
Message-ID: <abc904b9241127365463ce444f918608cca1eefc.1437977968.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1437977968.git.zhaolei@cn.fujitsu.com>
References: <cover.1437977968.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

Current code of btrfs-convert have a bug of thread conflict, which caused
invalid memory accessing between threads, and make program panic.

This patch add a test item for above bug, as:
 # ./misc-tests.sh
    [TEST]   001-btrfstune-features
    [TEST]   002-uuid-rewrite
    [TEST]   003-zero-log
    [TEST]   004-convert-thread-conflict
 failed: btrfs-convert /root/btrfsprogs/tests/test.img
 test failed for case 004-convert-thread-conflict
 #
 # cat misc-tests-results.txt
 ...
 ############### btrfs-convert /root/btrfsprogs/tests/test.img
 trans 7 running 5
 ctree.c:363: btrfs_cow_block: Assertion `1` failed.
 btrfs-convert(btrfs_cow_block+0x92)[0x40acaf]
 btrfs-convert(btrfs_search_slot+0x1cb)[0x40c50f]
 btrfs-convert(btrfs_csum_file_block+0x20f)[0x41d83a]
 btrfs-convert[0x43422d]
 btrfs-convert[0x4342cd]
 btrfs-convert[0x4345ca]
 btrfs-convert[0x434767]
 btrfs-convert[0x435770]
 btrfs-convert[0x439748]
 btrfs-convert(main+0x13f8)[0x43b09d]
 /lib64/libc.so.6(__libc_start_main+0xfd)[0x335e01ecdd]
 btrfs-convert[0x407649]
 create btrfs filesystem:
         blocksize: 4096
         nodesize:  16384
         features:  extref, skinny-metadata (default)
 creating btrfs metadata.

 creating ext2fs image file.
 failed: btrfs-convert /root/btrfsprogs/tests/test.img
 test failed for case 004-convert-thread-conflict
 #

Note that this bug is not happened every time, especilly in slow
device as loop(slow cpu with fast block device is likely to trigger).
I set loop count to 20 to make bug happened in 90% tests.

Suggested-by: David Sterba <dsterba@suse.com>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/misc-tests/004-convert-thread-conflict/test.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100755 tests/misc-tests/004-convert-thread-conflict/test.sh

diff --git a/tests/misc-tests/004-convert-thread-conflict/test.sh b/tests/misc-tests/004-convert-thread-conflict/test.sh
new file mode 100755
index 0000000..d02e766
--- /dev/null
+++ b/tests/misc-tests/004-convert-thread-conflict/test.sh
@@ -0,0 +1,14 @@
+#!/bin/bash
+# test convert-thread-conflict
+
+source $TOP/tests/common
+
+check_prereq btrfs
+mkfs.ext4 -V &>/dev/null || _not_run "mkfs.ext4 not found"
+prepare_test_dev 1G
+
+for ((i = 0; i < 20; i++)); do
+	echo "loop $i" >>$RESULTS
+	mkfs.ext4 -F "$TEST_DEV" &>>$RESULTS || _not_run "mkfs.ext4 failed"
+	run_check btrfs-convert "$TEST_DEV"
+done
-- 
1.8.5.1

