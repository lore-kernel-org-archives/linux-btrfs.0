Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13500 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754992AbbIOJX6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 05:23:58 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t8F9Negh008950
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 17:23:40 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH RESEND] btrfs-progs: tests: Add '-o loop' to mount command line in convert-tests.sh
Date: Tue, 15 Sep 2015 17:22:17 +0800
Message-ID: <b92776bec0a72128214ec931003869a36940e226.1442308835.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To fix following bug:
 # ./convert-tests.sh
     [TEST]   ext2 4k nodesize, btrfs defaults
 failed: mount /root/btrfsprogs/tests/test.img /root/btrfsprogs/tests/mnt
 # tail convert-tests-results.txt
 ...
 ############### mount /root/btrfsprogs/tests/test.img /root/btrfsprogs/tests/mnt
 mount: /root/btrfsprogs/tests/test.img is not a block device (maybe try `-o loop'?)
 failed: mount /root/btrfsprogs/tests/test.img /root/btrfsprogs/tests/mnt

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/convert-tests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/convert-tests.sh b/tests/convert-tests.sh
index 68c03dc..4d99a61 100755
--- a/tests/convert-tests.sh
+++ b/tests/convert-tests.sh
@@ -42,7 +42,7 @@ convert_test() {
 
 	# create a file to check btrfs-convert can convert regular file
 	# correct
-	run_check $SUDO_HELPER mount $IMAGE $TEST_MNT
+	run_check $SUDO_HELPER mount -o loop $IMAGE $TEST_MNT
 	run_check $SUDO_HELPER dd if=/dev/zero of=$TEST_MNT/test bs=$nodesize \
 		count=1 1>/dev/null 2>&1
 	run_check $SUDO_HELPER umount $TEST_MNT
-- 
1.8.5.1

