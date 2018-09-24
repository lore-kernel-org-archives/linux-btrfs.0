Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36422 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727567AbeIXQSP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 12:18:15 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 5/9] generic/102 open code dev_size _scratch_mkfs_sized()
Date: Mon, 24 Sep 2018 18:16:29 +0800
Message-Id: <1537784193-24431-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Open code helps to grep and find out parameter sent to the
_scratch_mkfs_sized here.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/102 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tests/generic/102 b/tests/generic/102
index faf940ac5070..aad496a5bc69 100755
--- a/tests/generic/102
+++ b/tests/generic/102
@@ -31,8 +31,7 @@ _require_scratch
 
 rm -f $seqres.full
 
-dev_size=$((512 * 1024 * 1024))     # 512MB filesystem
-_scratch_mkfs_sized $dev_size >>$seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) >>$seqres.full 2>&1
 _scratch_mount
 
 for ((i = 0; i < 10; i++)); do
-- 
1.8.3.1
