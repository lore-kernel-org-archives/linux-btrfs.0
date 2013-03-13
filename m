Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nat-pool-rdu.redhat.com ([66.187.233.202]:18465 "EHLO
	bp-05.lab.msp.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754543Ab3CMN5t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 09:57:49 -0400
From: Eric Sandeen <sandeen@redhat.com>
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] xfstests: keep newlines out of SCRATCH_DEV_POOL
Date: Wed, 13 Mar 2013 09:57:02 -0500
Message-Id: <1363186623-1378-3-git-send-email-sandeen@redhat.com>
In-Reply-To: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
References: <1363186623-1378-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

SCRATCH_DEV_POOL processing actually takes the first
device out for SCRATCH_DEV and leaves the rest in
SCRATCH_DEV_POOL.

I'm not totally sold on that behavior, but for now,
at least don't populate SCRATCH_DEV_POOL with newlines.

Cc: linux-btrfs@vger.kernel.org
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 common.config |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/common.config b/common.config
index ed0f44c..5ac58bf 100644
--- a/common.config
+++ b/common.config
@@ -258,7 +258,7 @@ if [ ! -z "$SCRATCH_DEV_POOL" ]; then
         exit 1
     fi
     SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
-    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ for (i = 2; i <= NF; i++) print $i}'`
+    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ ORS=" "; for (i = 2; i <= NF; i++) print $i}'`
 fi
 
 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
-- 
1.7.1

