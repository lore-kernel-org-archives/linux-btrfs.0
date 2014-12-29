Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53091 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750934AbaL2HTW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 02:19:22 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
Subject: [PATCH] fstests: btrfs/079: Fix wrong value passed to available space check.
Date: Mon, 29 Dec 2014 15:17:18 +0800
Message-ID: <1419837438-13771-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before the patch, we passed wrong value to _require_fs_space, which
should be in unit of 1024, but passed in unit of GB.

Fix it and add better prompt for falloc failure.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/079 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/btrfs/079 b/tests/btrfs/079
index 202d3e6..99d0187 100755
--- a/tests/btrfs/079
+++ b/tests/btrfs/079
@@ -73,8 +73,9 @@ rm -f $seqres.full
 
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
-_require_fs_space $SCRATCH_MNT $(($filesize / 1024 / 1024 / 1024))
-$XFS_IO_PROG -f -c "falloc 0 $filesize" $testfile
+_require_fs_space $SCRATCH_MNT $(($filesize / 1024))
+$XFS_IO_PROG -f -c "falloc 0 $filesize" $testfile || \
+	_fail "falloc failed"
 
 dd_work() {
 	out=$1
-- 
2.2.1

