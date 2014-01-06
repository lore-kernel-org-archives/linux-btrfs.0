Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9148 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbaAFIKI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 03:10:08 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Josef Bacik <jbacik@fb.com>
Subject: [PATCH] xfstests: fix wrong return check for case 022
Date: Mon, 6 Jan 2014 16:08:57 +0800
Message-Id: <1388995737-3480-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here we expect 0 as return value, fix it.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>
---
 tests/btrfs/022 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 mode change 100644 => 100755 tests/btrfs/022

diff --git a/tests/btrfs/022 b/tests/btrfs/022
old mode 100644
new mode 100755
index 5b18643..142aaf9
--- a/tests/btrfs/022
+++ b/tests/btrfs/022
@@ -106,7 +106,7 @@ _limit_test()
 	[ $? -ne 0 ] || _fail "quota should have limited us"
 	dd if=/dev/urandom of=$SCRATCH_MNT/a/file bs=4M count=1 >> \
 		$seqres.full 2>&1
-	[ $? -eq 0 ] || _fail "should have been allowed to write"
+	[ $? -ne 0 ] || _fail "should have been allowed to write"
 }
 
 _scratch_mkfs > /dev/null 2>&1
-- 
1.8.3.1

