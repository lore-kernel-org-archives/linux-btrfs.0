Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41980 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbbHYEm6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 00:42:58 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: Anand Jain <Anand.Jain@oracle.com>, david@fromorbit.com,
        linux-btrfs@vger.kernel.org, eguan@redhat.com, fdmanana@gmail.com
Subject: [PATCH v8 1/3] xfstests: btrfs: add functions to create dm-error device
Date: Tue, 25 Aug 2015 12:39:26 +0800
Message-Id: <1440477568-4614-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1440477568-4614-1-git-send-email-anand.jain@oracle.com>
References: <1440477568-4614-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

Controlled EIO from the device is achieved using the dm device.
Helper functions are at common/dmerror.

Broadly steps will include calling _dmerror_init().
_dmerror_init() will use SCRATCH_DEV to create dm linear device and assign
DMERROR_DEV to /dev/mapper/error-test.

When test script is ready to get EIO, the test cases can call
_dmerror_load_table() which then it will load the dm error.
so that reading DMERROR_DEV will cause EIO. After the test case is
complete, cleanup must be done by calling _dmerror_cleanup().

Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>
---
v7->v8:
 . Mainly avoid duplicate lines of code, create reusable functions
  _common_dev_mount_options(), dmerror_mount_options(),
  _dmerror_mount()
 . Update _scratch_mount_option() to use _common_dev_mount_options()

v6->v7:
 rename _init_dmerror() to _dmerror_init()
 remove _scratch_mkfs_dmerror()
 rename _mount_dmerror() to _dmerror_mount()
 rename _cleaup_dmerror() to _dmerror_cleanup()
 rename _load_dmerror_table() to _dmerror_load_table()
 rename BLK_DEV_SIZE to blk_dev_size
 remove _unmount_dmerror there were no consumer of it
 use _fail instead of _fatal in rc/dmerror
 update error log to make crisp sense
 move _require_dmerror() from common/rc to common/dmerror and rename
   it to dmerror_required() so that its consistent with other function
   names with in the file

v5->v6: accepts Eryu's comments, thanks
 . added missing $MKFS_OPTIONS at _scratch_mkfs_dmerror()
 . used $MOUNT_PROG instead of mount at _mount_dmerror()
 . correct typo $UMOUNT_PROG, no S at the end in _unmount_dmerror()

v4->v5: No Change. keep up with the patch set

v3->v4: rebase on latest xfstests code

v2.1->v3: accepts Filipe Manana's review comments, thanks
 . correct if else statement in _require_dm_error()
 . fix indent 
   (a missed Dave comment in v1. looks like I goofed with git cli)

v2->v2.1: fixed missed typo error fixup in the commit.

v1->v2: accepts Dave Chinner's review comments, thanks
 . use SCRATCH_DEV for dmerror backing device
 . remove duplicate check of DM_BLK_DEV in _init_dm_error_dev()
 . remove a wrong check when reading block size in _init_dm_error_dev()
 . remove a wrong check with blockdev --setra in _init_dm_error_dev()
 . remove unnecessary check in _load_dm_error_table()
 . remove unnecessary dmerror device test by using dd

 common/dmerror | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc      | 13 +++++++++--
 2 files changed, 85 insertions(+), 2 deletions(-)
 create mode 100644 common/dmerror

diff --git a/common/dmerror b/common/dmerror
new file mode 100644
index 0000000..8ba2262
--- /dev/null
+++ b/common/dmerror
@@ -0,0 +1,74 @@
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
+# this test requires the device mapper error target
+#
+_dmerror_required()
+{
+	_require_command "$DMSETUP_PROG" dmsetup
+	$DMSETUP_PROG targets | grep error >/dev/null 2>&1
+	[ $? -ne 0 ] && _notrun "This test requires dm error support"
+}
+
+_dmerror_init()
+{
+	local dm_backing_dev=$SCRATCH_DEV
+
+	$DMSETUP_PROG remove error-test > /dev/null 2>&1
+
+	local blk_dev_size=`blockdev --getsz $dm_backing_dev`
+
+	DMERROR_DEV='/dev/mapper/error-test'
+
+	DMLINEAR_TABLE="0 $blk_dev_size linear $dm_backing_dev 0"
+
+	$DMSETUP_PROG create error-test --table "$DMLINEAR_TABLE" || \
+		_fatal "failed to create dm linear device"
+
+	DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
+}
+
+_dmerror_mount_options()
+{
+	echo `_common_dev_mount_options $*` $DMERROR_DEV $SCRATCH_MNT
+}
+
+_dmerror_mount()
+{
+	_mount -t $FSTYP `_dmerror_mount_options $*`
+}
+
+_dmerror_cleanup()
+{
+	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
+	$DMSETUP_PROG remove error-test > /dev/null 2>&1
+}
+
+_dmerror_load_table()
+{
+	$DMSETUP_PROG suspend error-test
+	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
+
+	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
+	[ $? -ne 0 ] && _fail "dmsetup failed to load error table"
+
+	$DMSETUP_PROG resume error-test
+	[ $? -ne 0 ] && _fail  "dmsetup resume failed"
+}
diff --git a/common/rc b/common/rc
index 70d2fa8..7befa09 100644
--- a/common/rc
+++ b/common/rc
@@ -211,11 +211,20 @@ _mount_ops_filter()
 
 }
 
+# Used for mounting non-scratch devices (e.g. loop, dm constructs)
+# with the safe set of scratch mount options (e.g. loop image may be
+# hosted on $SCRATCH_DEV, so can't use external scratch devices).
+_common_dev_mount_options()
+{
+	echo $MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS $*
+}
+
 _scratch_mount_options()
 {
-    _scratch_options mount
+	_scratch_options mount
 
-    echo $SCRATCH_OPTIONS $MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS $* $SCRATCH_DEV $SCRATCH_MNT
+	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
+					$SCRATCH_DEV $SCRATCH_MNT
 }
 
 _scratch_mount()
-- 
2.4.1

