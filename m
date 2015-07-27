Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17879 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753175AbbG0ND2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 09:03:28 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6RD1Z3p024040
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2015 21:01:35 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs-tests: Add -o loop to fsck-tests/012-leaf-corruption for loop device
Date: Mon, 27 Jul 2015 21:01:50 +0800
Message-ID: <7d731282f5ddb1a3f1baedf6586772c4fe8838b9.1438002072.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

To avoid following mount error in test:
  mount: /root/btrfs/progs/tests/fsck-tests/012-leaf-corruption/test.img
  is not a block device (maybe try `-o loop'?)

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/fsck-tests/012-leaf-corruption/test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index 98e3185..f8701ad 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -86,7 +86,7 @@ check_leaf_corrupt_no_data_ext()
 {
 	image=$1
 	mkdir -p $TEST_MNT || _fail "failed to create mount point"
-	$SUDO_HELPER mount $image -o ro $TEST_MNT
+	$SUDO_HELPER mount -o loop $image -o ro $TEST_MNT
 
 	i=0
 	while [ $i -lt ${#leaf_no_data_ext_list[@]} ]; do
-- 
1.8.5.1

