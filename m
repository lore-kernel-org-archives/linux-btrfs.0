Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49816 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbeIYKaO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 06:30:14 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 5/9] generic/102 open code dev_size _scratch_mkfs_sized()
Date: Tue, 25 Sep 2018 12:24:18 +0800
Message-Id: <1537849462-619-6-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
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
