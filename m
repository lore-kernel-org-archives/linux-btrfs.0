Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52777 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887AbbG0Ghb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 02:37:31 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6R6ZdEd004385
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 14:35:39 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs-tests: Add '-o loop' to mount command line in convert-tests.sh
Date: Mon, 27 Jul 2015 14:35:54 +0800
Message-ID: <76b81aa654ad49579fd9be352c0be71314e510fd.1437978914.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

To fix following bug:
 # ./convert-tests.sh
     [TEST]   ext2 4k nodesize, btrfs defaults
 failed: mount /root/btrfsprogs/tests/test.img /root/btrfsprogs/tests/mnt
 # tail convert-tests-results.txt
 ...
 ############### mount /root/btrfsprogs/tests/test.img /root/btrfsprogs/tests/mnt
 mount: /root/btrfsprogs/tests/test.img is not a block device (maybe try `-o loop'?)
 failed: mount /root/btrfsprogs/tests/test.img /root/btrfsprogs/tests/mnt
 #

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/convert-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 14dde1f..efed90b 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -43,7 +43,7 @@ convert_test() {
 
 	# create a file to check btrfs-convert can convert regular file
 	# correct
-	run_check $SUDO_HELPER mount $IMAGE $TEST_MNT
+	run_check $SUDO_HELPER mount -o loop $IMAGE $TEST_MNT
 	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/test bs=$nodesize \
 		count=1 1>/dev/null 2>&1
 	run_check $SUDO_HELPER umount $TEST_MNT
-- 
1.8.5.1

