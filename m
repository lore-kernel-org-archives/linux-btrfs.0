Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46061 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbcFOIrR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 04:47:17 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/6] fstests: btrfs: add helper function to check if btrfs is module
Date: Wed, 15 Jun 2016 16:47:54 +0800
Message-Id: <1465980474-18990-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1463495530-425-4-git-send-email-anand.jain@oracle.com>
References: <1463495530-425-4-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

We need btrfs to be a module so that it can unloaded and reloaded,
so that we can clean up the btrfs internal in memory device list.

This patch adds _require_btrfs_unloadable() and _reload_btrfs_ko()
to help with the same.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2: rename _require_btrfs_unloadable to _require_btrfs_loadable

 common/rc | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/common/rc b/common/rc
index ffdbfcdae68d..89281171365f 100644
--- a/common/rc
+++ b/common/rc
@@ -1441,6 +1441,18 @@ _supported_os()
     _notrun "not suitable for this OS: $HOSTOS"
 }
 
+_require_btrfs_loadable()
+{
+	modprobe -r btrfs || _notrun "btrfs unloadable"
+	modprobe btrfs || _notrun "Can't load btrfs"
+}
+
+_reload_btrfs_ko()
+{
+	modprobe -r btrfs || _fail "btrfs unload failed"
+	modprobe btrfs || _fail "btrfs load failed"
+}
+
 # this test needs a scratch partition - check we're ok & unmount it
 # No post-test check of the device is required. e.g. the test intentionally
 # finishes the test with the filesystem in a corrupt state
-- 
2.7.0

