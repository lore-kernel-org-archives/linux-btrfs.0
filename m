Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44262 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbbDNJBJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Apr 2015 05:01:09 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] xfstests: make "BTRFS_UTIL_PROG filesystem defragment" work
Date: Tue, 14 Apr 2015 17:01:00 +0800
Message-Id: <1429002060-16597-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

_require_defrag() needs to check if the command is executable, but btrfs has
its subcommand "filesystem defragment", which makes this checking fail.

This workarounds it and now we can run case generic/324, generic/018, btrfs/005.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 common/defrag | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/common/defrag b/common/defrag
index f923dc0..f36a68b 100644
--- a/common/defrag
+++ b/common/defrag
@@ -37,7 +37,11 @@ _require_defrag()
 	;;
     esac
 
-    _require_command "$DEFRAG_PROG" defragment
+    if [ "$FSTYP" == "btrfs" ]; then
+	    _require_command "$BTRFS_UTIL_PROG" defragment
+    else
+	    _require_command "$DEFRAG_PROG" defragment
+    fi
     _require_xfs_io_command "fiemap"
 }
 
-- 
1.8.2.1

