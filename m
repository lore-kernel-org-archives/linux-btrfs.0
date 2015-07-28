Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19006 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754483AbbG1C3v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 22:29:51 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t6S2RwDw018725
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2015 10:27:58 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Zhao Lei <zhaolei@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs-tests: Avoid outputting useless warning in ./fsck-tests.sh
Date: Tue, 28 Jul 2015 10:28:13 +0800
Message-ID: <da33d0fb2b6ac7f8a52a4550ec74293f9e2f1af9.1438050482.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Zhao Lei <zhaolei@cn.fujitsu.com>

002-bad-transid outout 'transid verify failed' message in screen
which is just a warning in btrfs-image in normal condition of this
test.

This patch move above warning into $RESULTS, to:
1: Avoid trouble screen output
2: Let user known detail if other error happened in btrfs-image

Before patch:
  # ./fsck-tests.sh
    [TEST]   001-bad-file-extent-bytenr
    [TEST]   002-bad-transid
  parent transid verify failed on 29360128 wanted 9 found 755944791
  parent transid verify failed on 29360128 wanted 9 found 755944791
  Ignoring transid failure
    [TEST]   003-shift-offsets
    [TEST]   004-no-dir-index
  ...

After patch:
  # ./fsck-tests.sh
  [TEST]   001-bad-file-extent-bytenr
  [TEST]   002-bad-transid
  [TEST]   003-shift-offsets
  [TEST]   004-no-dir-index
  ...

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 tests/common | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/common b/tests/common
index 381ff96..4d03ed8 100644
--- a/tests/common
+++ b/tests/common
@@ -87,8 +87,9 @@ check_all_images()
 
 		if ! [ -f $image.restored ]; then
 			echo "restoring image $(basename $image)" >> $RESULTS
-			$TOP/btrfs-image -r $image $image.restored || \
-				_fail "failed to restore image $image"
+			$TOP/btrfs-image -r $image $image.restored \
+				&>> $RESULTS \
+				|| _fail "failed to restore image $image"
 		fi
 
 		check_image $image.restored
-- 
1.8.5.1

