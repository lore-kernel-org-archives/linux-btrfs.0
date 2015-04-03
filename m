Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49036 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751187AbbDCHDW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 03:03:22 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t3372FAF001961
	for <linux-btrfs@vger.kernel.org>; Fri, 3 Apr 2015 15:02:15 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/6] btrfs-progs: fsck-tests: Remove duplicatesd TEST_MNT setup.
Date: Fri, 3 Apr 2015 15:01:13 +0800
Message-ID: <1428044477-18485-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1428044477-18485-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Since we have already had TEST_MNT fallback setup to $TOP/tests/mnt,
just remove duplicated setting in 012-leaf-corruption/test.sh

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/fsck-tests/012-leaf-corruption/test.sh | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index fe5c226..4db4710 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -85,10 +85,6 @@ check_inode()
 check_leaf_corrupt_no_data_ext()
 {
 	image=$1
-	if [ -z $TEST_MNT ]; then
-		echo "\$TEST_MNT not set, use $(pwd)/tmp as fallback"
-		TEST_MNT="$(pwd)/tmp"
-	fi
 	mkdir -p $TEST_MNT || _fail "failed to create mount point"
 	$SUDO_HELPER mount $image -o ro $TEST_MNT
 
-- 
2.3.5

