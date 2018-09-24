Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36328 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728229AbeIXQSF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 12:18:05 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/9] fstests: btrfs: _scratch_mkfs_sized fix min size without mixed option
Date: Mon, 24 Sep 2018 18:16:25 +0800
Message-Id: <1537784193-24431-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
References: <1537784193-24431-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As of now _scratch_mkfs_sized check if the requested size is below 1G
and forces the --mixed option for the mkfs.btrfs. Well the correct size
at which we need to force the mixed option is 114294784bytes. Fix that.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/rc | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index d5bb1feee2c3..bcdbf03e1bf0 100644
--- a/common/rc
+++ b/common/rc
@@ -969,7 +969,9 @@ _scratch_mkfs_sized()
 	;;
     btrfs)
 	local mixed_opt=
-	(( fssize <= 1024 * 1024 * 1024 )) && mixed_opt='--mixed'
+	# minimum size that's needed without the mixed option.
+	# Non mixed mode is also the default option.
+	(( fssize < 114294784 )) && mixed_opt='--mixed'
 	$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
 	;;
     jfs)
-- 
1.8.3.1
