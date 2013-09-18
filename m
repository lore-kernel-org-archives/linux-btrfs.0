Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49714 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3IRFSH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 01:18:07 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: xfs@oss.sgi.com
Subject: [PATCH] xfstests/btrfs: do not test btrfs/010 with autodefrag
Date: Wed, 18 Sep 2013 13:17:55 +0800
Message-Id: <1379481475-10842-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs/010 is going to create a fragmented file, however, with autodefrag
this is impossible, so just skip the test when we're with autodefrag.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/010 |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tests/btrfs/010 b/tests/btrfs/010
index 371f1b8..608942d 100755
--- a/tests/btrfs/010
+++ b/tests/btrfs/010
@@ -37,6 +37,14 @@ _cleanup()
     rm -f $tmp.*
 }
 
+is_autodefrag_set()
+{
+	case "$MOUNT_OPTIONS" in
+		*autodefrag*) return 0;;
+	esac
+	return 1
+}
+
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
@@ -49,6 +57,10 @@ _supported_os Linux
 _require_scratch
 _require_command "/usr/sbin/filefrag"
 
+if is_autodefrag_set; then
+	_notrun "this test makes no sense with autodefrag"
+fi
+
 rm -f $seqres.full
 
 _scratch_mkfs > /dev/null 2>&1
-- 
1.7.7

