Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:51150 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728225AbeIYKaT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 06:30:19 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 9/9] generic/387 fix _scratch_mkfs_sized option for btrfs
Date: Tue, 25 Sep 2018 12:24:22 +0800
Message-Id: <1537849462-619-10-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfs needs 256mb to create a fs with default block group which is non
mixed, so pass 256mb to _scratch_mkfs_sized().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/387 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/generic/387 b/tests/generic/387
index 68a48012faa5..54a782bba3bc 100755
--- a/tests/generic/387
+++ b/tests/generic/387
@@ -35,7 +35,8 @@ _supported_fs generic
 _supported_os Linux
 _require_scratch_reflink
 
-_scratch_mkfs_sized $((32 * 1024 * 1024)) >> $seqres.full 2>&1
+#btrfs needs 256mb to create default blockgroup fs
+_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
 _scratch_mount
 
 testfile=$SCRATCH_MNT/testfile
-- 
1.8.3.1
