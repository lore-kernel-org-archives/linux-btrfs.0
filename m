Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31310 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaICD0c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Sep 2014 23:26:32 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] xfstests: remove check_scratch_fs in btrfs/012
Date: Wed,  3 Sep 2014 11:25:59 +0800
Message-Id: <1409714759-9805-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Liu Bo <liub.liubo@gmail.com>

btrfs/012 is a case to verify btrfs-convert feature, it converts an ext4 to
btrfs firstly and do something, then rolls back to ext4.

So at last we have a ext4 on the scratch device, but setting _require_scratch
will force a btrfsck on a ext4 fs because $FSTYP here is btrfs, and it ends up
with a failure report of _check_btrfs_filesystem.

Now that we have deliberately check the final ext4 fs in btrfs/012, just do not
set _require_scratch in this case.

Signed-off-by: Liu Bo <liub.liubo@gmail.com>
---
 tests/btrfs/012 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/btrfs/012 b/tests/btrfs/012
index f7e5da5..12f6462 100755
--- a/tests/btrfs/012
+++ b/tests/btrfs/012
@@ -52,7 +52,6 @@ _cleanup()
 # Modify as appropriate.
 _supported_fs btrfs
 _supported_os Linux
-_require_scratch
 
 BTRFS_CONVERT_PROG="`set_prog_path btrfs-convert`"
 MKFS_EXT4_PROG="`set_prog_path mkfs.ext4`"
-- 
1.8.1.4

