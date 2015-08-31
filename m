Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53026 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750934AbbHaFGY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 01:06:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7V56AMe020009
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 13:06:10 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 3/4] btrfs-progs: tests: umount TEST_MNT in clean-tests.sh
Date: Mon, 31 Aug 2015 13:04:38 +0800
Message-ID: <df9f4f0f57be049efe6e5002311b6cbff0fb1167.1440997237.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
References: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If a testcase failed, we can't run it(or other tests needs mount) again,
  # ./misc-tests.sh 007
   [TEST]   007-subvolume-sync
   failed: fail
   test failed for case 007-subvolume-sync
  # ./misc-tests.sh 007
   [TEST]   007-subvolume-sync
   failed: mount /root/btrfs-progs/tests/test.img /root/btrfs-progs/tests/mnt
   test failed for case 007-subvolume-sync
  #

This patch add "umount $TEST_MNT" to clean-tests.sh, to let user
clean mountpoint easily.

After patch:
  # ./misc-tests.sh  007
   [TEST]   007-subvolume-sync
   failed: fail
   test failed for case 007-subvolume-sync
  #
  # clean-tests.sh
  #
  # ./misc-tests.sh  007
   [TEST]   007-subvolume-sync
   failed: fail
   test failed for case 007-subvolume-sync
  #

Changelog v1->v2:
  Put umount command to clean-tests.sh instead of in testscript,
  to keep failed-test stat until user run clean-tests.sh
  explicitly, Suggested-by: David Sterba <dsterba@suse.cz>

Suggested-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/clean-tests.sh | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/clean-tests.sh b/tests/clean-tests.sh
index c1dc56a..19d682d 100755
--- a/tests/clean-tests.sh
+++ b/tests/clean-tests.sh
@@ -1,12 +1,15 @@
 #!/bin/sh
 # remove all intermediate files from tests
 
+SCRIPT_DIR=$(dirname $(readlink -f $0))
+TOP=$(readlink -f $SCRIPT_DIR/../)
+source $TOP/tests/common
+
 if [ "$BUILD_VERBOSE" = 1 ]; then
 	verbose=-print
 fi
 
-SCRIPT_DIR=$(dirname $(readlink -f $0))
-TOP=$(readlink -f $SCRIPT_DIR/../)
+umount "$TEST_MNT" &>/dev/null
 
 if ! cd $TOP/tests; then
 	echo "ERROR: cannot cd to $TOP/tests"
-- 
1.8.5.1

