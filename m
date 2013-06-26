Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59541 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3FZPxH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Jun 2013 11:53:07 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4311A7C0423
	for <linux-btrfs@vger.kernel.org>; Wed, 26 Jun 2013 09:53:07 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
Subject: [PATCH] xfstests: fix btrfs/264 to not use the scratch dev pool
Date: Wed, 26 Jun 2013 11:52:56 -0400
Message-ID: <1372261976-11426-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This test doesn't need the scratch dev pool and it also doesn't call
_require_scratch_dev_pool, so just kick out the scratch dev pool part of the
test.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 tests/btrfs/264 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/btrfs/264 b/tests/btrfs/264
index b08667a..8eef43b 100755
--- a/tests/btrfs/264
+++ b/tests/btrfs/264
@@ -46,7 +46,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 
-_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount
 
 # Create and save sha256sum
-- 
1.7.7.6

