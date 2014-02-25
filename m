Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:55278 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaBYC5l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 21:57:41 -0500
Message-ID: <530C069A.8060800@huawei.com>
Date: Tue, 25 Feb 2014 10:57:30 +0800
From: ZhangZhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
To: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
CC: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <du.duyongfeng@huawei.com>
Subject: [PATCH v2] xfstests: fix to make tests/btrfs/013 work using all version
 btrfs progs
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The test 013 couldn't work using some old version btrfs progs
e.g.(btrfs progs v0.19 openSUSE 12.3)because here lacked "start".
This patch fix it.

Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
---
 tests/btrfs/013 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/btrfs/013 b/tests/btrfs/013
index 7620fcc..fb81663 100644
--- a/tests/btrfs/013
+++ b/tests/btrfs/013
@@ -72,7 +72,7 @@ _check_csum_error()
 }
 $XFS_IO_PROG -f -c "falloc 0 1M" -c "pwrite 16k 8k" -c "fsync" \
 	$SCRATCH_MNT/foo > $seqres.full 2>&1
-$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT >> $seqres.full 2>&1 || \
+$BTRFS_UTIL_PROG filesystem balance start $SCRATCH_MNT >> $seqres.full 2>&1 || \
 	_fail "balance failed"
 _scratch_unmount
 _scratch_mount

