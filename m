Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:64589 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755346Ab2HXBmK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Aug 2012 21:42:10 -0400
Message-ID: <5036DBD6.4040301@cn.fujitsu.com>
Date: Fri, 24 Aug 2012 09:41:42 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
CC: anand.jain@oracle.com
Subject: [PATCH 2/3] xfstests: fix double set for SCRATCH_DEV when SCRATCH_DEV_POOL
 is set
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

check script has moved the first device of SCRATCH_DEV_POOL and used it to set
SCRATCH_DEV. But the case 265 does the same thing again when it includes
common.rc. Fix it by setting SCRATCH_DEV just by check script.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 common.config |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/common.config b/common.config
index 7bed1c5..a35954b 100644
--- a/common.config
+++ b/common.config
@@ -232,12 +232,13 @@ fi
 
 # a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
 # to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
-if [ ! -z "$SCRATCH_DEV_POOL" ]; then
+if [ "$iam" == "check" -a ! -z "$SCRATCH_DEV_POOL" ]; then
     if [ ! -z "$SCRATCH_DEV" ]; then
         echo "common.config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
         exit 1
     fi
-    SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
+    # the user may forget to export SCRATCH_DEV when he/she set SCRATCH_DEV_POOL.
+    export SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
     SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ for (i = 2; i <= NF; i++) print $i}'`
 fi
 
-- 
1.7.6.5
