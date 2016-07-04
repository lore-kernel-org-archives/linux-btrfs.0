Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from balrog.mythic-beasts.com ([46.235.227.24]:51005 "EHLO
	balrog.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbcGDX1M (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2016 19:27:12 -0400
Date: Mon, 4 Jul 2016 23:48:47 +0100
From: Luis Henriques <henrix@camandro.org>
To: linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: tests: 006-image-on-missing-device: fix btrfs
 tool path
Message-ID: <20160704224838.GA18686@charon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If btrfs isn't in the path, this test will fail with:

    [TEST/misc]   006-image-on-missing-device
failed: btrfs fi show /dev/loop0
test failed for case 006-image-on-missing-device
Makefile:226: recipe for target 'test-misc' failed
make: *** [test-misc] Error 1

Fix the test script by adding $TOP to the path.

Signed-off-by: Luis Henriques <henrix@camandro.org>
---
 tests/misc-tests/006-image-on-missing-device/test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/misc-tests/006-image-on-missing-device/test.sh b/tests/misc-tests/006-image-on-missing-device/test.sh
index 8680a707afbb..dd02d93e5fdd 100755
--- a/tests/misc-tests/006-image-on-missing-device/test.sh
+++ b/tests/misc-tests/006-image-on-missing-device/test.sh
@@ -61,12 +61,12 @@ test_run()
 	run_check $SUDO_HELPER umount $TEST_MNT
 
 	test_image_dump
-	run_check btrfs fi show $dev1
+	run_check $TOP/btrfs fi show $dev1
 	# create a degraded raid1 filesystem, check must succeed
 	# btrfs-image must not loop
 	run_mayfail wipefs -a $dev2
 	run_check $SUDO_HELPER losetup -d $dev2
-	run_check btrfs fi show $dev1
+	run_check $TOP/btrfs fi show $dev1
 
 	test_image_dump
 }
