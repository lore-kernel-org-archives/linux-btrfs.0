Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40164 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753992AbdEIS55 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 May 2017 14:57:57 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@gmail.com>,
        Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/6] fstests: add _get_current_dmesg
Date: Tue,  9 May 2017 11:56:07 -0600
Message-Id: <1494352571-17199-3-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1494352571-17199-1-git-send-email-bo.li.liu@oracle.com>
References: <1494352571-17199-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

_get_current_dmesg can be used to grep customized pattern.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 common/rc | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index 78a2101..111ed69 100644
--- a/common/rc
+++ b/common/rc
@@ -3215,6 +3215,12 @@ _get_device_size()
 	grep `_short_dev $1` /proc/partitions | awk '{print $3}'
 }
 
+# get current dmesg log
+_get_current_dmesg()
+{
+	dmesg | tac | sed -ne "0,\#run fstests $seqnum at $date_time#p" | tac
+}
+
 # check dmesg log for WARNING/Oops/etc.
 _check_dmesg()
 {
@@ -3230,8 +3236,7 @@ _check_dmesg()
 
 	# search the dmesg log of last run of $seqnum for possible failures
 	# use sed \cregexpc address type, since $seqnum contains "/"
-	dmesg | tac | sed -ne "0,\#run fstests $seqnum at $date_time#p" | \
-		tac | $filter >$seqres.dmesg
+	_get_current_dmesg | $filter >$seqres.dmesg
 	grep -q -e "kernel BUG at" \
 	     -e "WARNING:" \
 	     -e "BUG:" \
-- 
2.5.0

