Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19358 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754659AbbIAKEx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Sep 2015 06:04:53 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t81A4f8v032596
	for <linux-btrfs@vger.kernel.org>; Tue, 1 Sep 2015 18:04:41 +0800
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: tests: Use --no-same-owner option for tar
Date: Tue, 1 Sep 2015 18:03:14 +0800
Message-ID: <11005b0b3385117fa772b223513cea16920ec7b9.1441101154.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some test failed in my nfs dir:
  ...
    [TEST]   006-bad-root-items
  tar: test.img: Cannot change ownership to uid 1000, gid 1000: Invalid argument
  tar: Exiting with failure status due to previous errors
  failed to extract default_case.tar.xz
  test failed for case 006-bad-root-items

It is because the image file's owner is:
 # tar tvf default_case.tar.xz
 -rw-r--r-- fdmanana/fdmanana 2147483648 2014-10-17 17:59 test.img

And make tar failed in chown in nfs.

It is not a big issue because we don't use nfs commonly, but extract
the image file with ownership of current user will be a better choice.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/fsck-tests/006-bad-root-items/test.sh  | 4 ++--
 tests/fsck-tests/012-leaf-corruption/test.sh | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/fsck-tests/006-bad-root-items/test.sh b/tests/fsck-tests/006-bad-root-items/test.sh
index bfbfcfc..421e225 100755
--- a/tests/fsck-tests/006-bad-root-items/test.sh
+++ b/tests/fsck-tests/006-bad-root-items/test.sh
@@ -3,12 +3,12 @@
 source $TOP/tests/common
 
 echo "extracting image default_case.tar.xz" >> $RESULTS
-tar xJf default_case.tar.xz || \
+tar --no-same-owner -xJf default_case.tar.xz || \
 	_fail "failed to extract default_case.tar.xz"
 check_image test.img
 
 echo "extracting image skinny_case.tar.xz" >> $RESULTS
-tar xJf skinny_case.tar.xz || \
+tar --no-same-owner -xJf skinny_case.tar.xz || \
 	_fail "failed to extract skinny_case.tar.xz"
 check_image test.img
 
diff --git a/tests/fsck-tests/012-leaf-corruption/test.sh b/tests/fsck-tests/012-leaf-corruption/test.sh
index a37ceda..6e23145 100755
--- a/tests/fsck-tests/012-leaf-corruption/test.sh
+++ b/tests/fsck-tests/012-leaf-corruption/test.sh
@@ -35,7 +35,7 @@ generate_leaf_corrupt_no_data_ext()
 {
 	dest=$1
 	echo "generating leaf_corrupt_no_data_ext.btrfs-image" >> $RESULTS
-	tar xJf ./no_data_extent.tar.xz || \
+	tar --no-same-owner -xJf ./no_data_extent.tar.xz || \
 		_fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"
 	$TOP/btrfs-image -r test.img.btrfs-image $dest || \
 		_fail "failed to extract leaf_corrupt_no_data_ext.btrfs-image"
-- 
1.8.5.1

