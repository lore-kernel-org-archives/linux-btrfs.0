Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728482AbeIXQSO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 12:18:14 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 9/9] generic/387 fix _scratch_mkfs_sized option for btrfs
Date: Mon, 24 Sep 2018 18:16:33 +0800
Message-Id: <1537784193-24431-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs needs 200mb to create a fs with default block group which is non
mixed, so pass 200mb to _scratch_mkfs_sized().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/387 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/generic/387 b/tests/generic/387
index 68a48012faa5..9d9d65d222c8 100755
--- a/tests/generic/387
+++ b/tests/generic/387
@@ -35,7 +35,8 @@ _supported_fs generic
 _supported_os Linux
 _require_scratch_reflink
 
-_scratch_mkfs_sized $((32 * 1024 * 1024)) >> $seqres.full 2>&1
+#btrfs needs ~200mb to create default blockgroup fs
+_scratch_mkfs_sized $((200 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount
 
 testfile=$SCRATCH_MNT/testfile
-- 
1.8.3.1
