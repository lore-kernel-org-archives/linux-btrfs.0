Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38358 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756920Ab3JRS0d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 14:26:33 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C64E47C0428
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 12:26:32 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: [PATCH 1/8] xfstests: fix btrfs/002 to not use the scratch dev pool
Date: Fri, 18 Oct 2013 14:26:23 -0400
Message-ID: <1382120790-31060-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test doesn't need the scratch dev pool and it also doesn't call
_require_scratch_dev_pool, so just kick out the scratch dev pool part of the
test.  Thanks,

Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/002 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/btrfs/002 b/tests/btrfs/002
index f4389ae..19a62c6 100755
--- a/tests/btrfs/002
+++ b/tests/btrfs/002
@@ -45,9 +45,8 @@ _need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-_require_scratch_dev_pool
 
-_scratch_pool_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount
 
 # Create and save sha256sum
-- 
1.8.3.1

