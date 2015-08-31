Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59954 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751006AbbHaFGY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 01:06:24 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t7V56BNr020012
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Aug 2015 13:06:11 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH v2 4/4] btrfs-progs: tests: Use mount_test_dev for misc-tests/007-subvolume-sync
Date: Mon, 31 Aug 2015 13:04:39 +0800
Message-ID: <c794f1a0289266fbf4eabe0f8d93577c5c9d4b73.1440997237.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
References: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So this test can support both block device and loop device simply.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/misc-tests/007-subvolume-sync/test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/misc-tests/007-subvolume-sync/test.sh b/tests/misc-tests/007-subvolume-sync/test.sh
index d4019f4..1eea098 100755
--- a/tests/misc-tests/007-subvolume-sync/test.sh
+++ b/tests/misc-tests/007-subvolume-sync/test.sh
@@ -13,7 +13,7 @@ setup_root_helper
 prepare_test_dev
 
 run_check $SUDO_HELPER $TOP/mkfs.btrfs -f "$TEST_DEV"
-run_check $SUDO_HELPER mount "$TEST_DEV" "$TEST_MNT"
+run_check $SUDO_HELPER mount_test_dev
 
 # to check following thing in both 1 and multiple subvolume case:
 # 1: is subvolume sync loop indefinetelly
@@ -29,4 +29,4 @@ run_check $SUDO_HELPER $TOP/btrfs subvolume create "$TEST_MNT"/mysubvol
 run_check $SUDO_HELPER $TOP/btrfs subvolume delete "$TEST_MNT"/mysubvol
 run_check $SUDO_HELPER $TOP/btrfs subvolume sync "$TEST_MNT"
 
-run_check $SUDO_HELPER umount $TEST_MNT
+run_check $SUDO_HELPER umount_test_dev
-- 
1.8.5.1

