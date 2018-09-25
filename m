Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:54960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbeIYKaR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Sep 2018 06:30:17 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 7/9] generic/312 open code fs_size _scratch_mkfs_sized()
Date: Tue, 25 Sep 2018 12:24:20 +0800
Message-Id: <1537849462-619-8-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fs_size isn't used anywhere else further more now grep tells what size
is being used.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/generic/312 | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tests/generic/312 b/tests/generic/312
index 756f5c3e4c5a..465009c8d184 100755
--- a/tests/generic/312
+++ b/tests/generic/312
@@ -34,11 +34,10 @@ _supported_os Linux
 _require_xfs_io_command "falloc"
 _require_scratch
 
-# 5G in byte
-fssize=$((2**30 * 5))
-
 rm -f $seqres.full
-_scratch_mkfs_sized $fssize >>$seqres.full 2>&1
+
+# 5G FS
+_scratch_mkfs_sized $((2**30 * 5)) >>$seqres.full 2>&1
 _scratch_mount >>$seqres.full 2>&1
 
 echo "Silence is golden"
-- 
1.8.3.1
