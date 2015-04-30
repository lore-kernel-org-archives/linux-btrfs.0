Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28157 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbbD3KLj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 06:11:39 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] xfstests: btrfs: add functions to create dm-error device
Date: Thu, 30 Apr 2015 18:08:45 +0800
Message-Id: <1430388527-16700-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Controlled EIO from the device is achieved using the dm device.
Helper functions are at common/dmerror.

Broadly steps will include calling _init_dm_error_dev() with a blk
device as an argument, typically this device can be a device pealed
from the SCRATCH_DEV_POOL, and init_dm_error_dev() will use
this blk device as backing store of dm linear device and assign
DM_ERROR_DEV to /dev/mapper/error-dev, which then can be assigned back
to the SCRATCH_DEV_POOL.

When test script is read to get EIO, the test cases can call
_load_dm_error_table() which then it will load the dm error.
so that reading DM_ERROR_DEV will cause EIO. After the test case is
complete, cleanup must be done by calling _cleanup_dm_error_dev().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/dmerror | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc      | 18 ++++++++++++++++
 2 files changed, 83 insertions(+)
 create mode 100644 common/dmerror

diff --git a/common/dmerror b/common/dmerror
new file mode 100644
index 0000000..e1f92e6
--- /dev/null
+++ b/common/dmerror
@@ -0,0 +1,65 @@
+##/bin/bash
+#
+# Copyright (c) 2015 Oracle.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#
+# common functions for setting up and tearing down a dmerror device
+
+_init_dm_error_dev()
+{
+	DM_ERROR_DEV=''
+	$DMSETUP_PROG remove error-dev > /dev/null 2>&1
+	DM_BLK_DEV=$1
+	[ -b $DM_BLK_DEV ] || _fatal "$DM_BLK_DEV is not a block device"
+
+	DM_DEV_SIZE=`blockdev --getsz $DM_BLK_DEV`
+	[ $? -ne 0 ] && _fatal  "failed to failed to read block dev size"
+
+	LINEAR_TABLE="0 $DM_DEV_SIZE linear $DM_BLK_DEV 0"
+	$DMSETUP_PROG create error-dev --table "$LINEAR_TABLE" || \
+		_fatal "failed to create dm linear device"
+
+	DM_ERROR_DEV='/dev/mapper/error-dev'
+	blockdev --setra 0 $DM_ERROR_DEV
+	[ $? -ne 0 ] && _fatal  "failed to failed to setra  for $DM_ERROR_DEV"
+}
+
+_cleanup_dm_error_dev()
+{
+	DM_ERROR_DEV=''
+	$DMSETUP_PROG remove error-dev > /dev/null 2>&1
+}
+
+_load_dm_error_table()
+{
+	[ -z $DM_BLK_DEV ] && _fatal "DM_BLK_DEV is not set"
+	[ -z $DM_ERROR_DEV ] && _fatal "DM_ERROR_DEV is not set"
+	[ -z $DM_DEV_SIZE ] && _fatal "DM_DEV_SIZE is not set call init_error_dev first"
+
+	echo 3 > /proc/sys/vm/drop_caches
+	$DMSETUP_PROG suspend error-dev
+	[ $? -ne 0 ] && _fatal  "failed to suspend error-dev"
+
+	ERROR_TABLE="0 $DM_DEV_SIZE error $DM_BLK_DEV 0"
+	$DMSETUP_PROG load error-dev --table "$ERROR_TABLE"
+	[ $? -ne 0 ] && _fatal "failed to load table into error-dev"
+
+	$DMSETUP_PROG resume error-dev
+	[ $? -ne 0 ] && _fatal  "failed to resume error-dev"
+
+	dd if=$DM_ERROR_DEV of=/dev/null count=1 > /dev/null 2>&1
+	[ $? -ne 0 ] || _fatal  "failed to fail IO to $DM_ERROR_DEV"
+}
diff --git a/common/rc b/common/rc
index c5db0dd..2a50491 100644
--- a/common/rc
+++ b/common/rc
@@ -1305,6 +1305,24 @@ _require_block_device()
 	fi
 }
 
+# this test requires the device mapper error target
+#
+_require_dm_error()
+{
+    DM_BACKSTORE_DEV=$1
+    # require SCRATCH_DEV to be a valid block device
+    _require_block_device $DM_BACKSTORE_DEV
+    _require_command "$DMSETUP_PROG" dmsetup
+
+    $DMSETUP_PROG targets | grep error >/dev/null 2>&1
+    if [ $? -eq 0 ]
+    then
+	:
+    else
+	_notrun "This test requires dm error support"
+    fi
+}
+
 # this test requires the device mapper flakey target
 #
 _require_dm_flakey()
-- 
2.0.0.153.g79dcccc

