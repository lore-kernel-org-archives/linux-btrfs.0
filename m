Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13739 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750735AbbAUGKo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Jan 2015 01:10:44 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <fstests@vger.kernel.org>
Subject: [PATCH v2] fstests: btrfs/079: Fix wrong value passed to available space check.
Date: Wed, 21 Jan 2015 14:08:37 +0800
Message-ID: <1421820518-27797-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wrong value is passed to _require_fs_space, which should be in unit of
kilobyte(1024), but passed in unit of gigabyte(1024^3).

Fix it.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 tests/btrfs/079 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/079 b/tests/btrfs/079
index 202d3e6..b4a4189 100755
--- a/tests/btrfs/079
+++ b/tests/btrfs/079
@@ -73,7 +73,7 @@ rm -f $seqres.full
 
 _scratch_mkfs >>$seqres.full 2>&1
 _scratch_mount
-_require_fs_space $SCRATCH_MNT $(($filesize / 1024 / 1024 / 1024))
+_require_fs_space $SCRATCH_MNT $(($filesize / 1024))
 $XFS_IO_PROG -f -c "falloc 0 $filesize" $testfile
 
 dd_work() {
-- 
2.2.2

