Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:59771 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaBXKvi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 05:51:38 -0500
Message-ID: <530B2418.20905@huawei.com>
Date: Mon, 24 Feb 2014 18:51:04 +0800
From: ZhangZhen <zhenzhang.zhang@huawei.com>
MIME-Version: 1.0
To: <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: [PATCH for xfstests] xfstests: fix to make tests/btrfs/013 really
 work
References: <530AF3E3.9060202@huawei.com>
In-Reply-To: <530AF3E3.9060202@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The test 013 couldn't work because here lacked "start".
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
-- 
1.8.1.4


.




_______________________________________________
kernel.openeuler mailing list
kernel.openeuler@huawei.com
http://rnd-openeuler.huawei.com/mailman/listinfo/kernel.openeuler





