Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42929 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbcFWN13 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 09:27:29 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, eguan@redhat.com,
        Anand Jain <Anand.Jain@oracle.com>, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 2/6] fstests: btrfs: add functions to get and put a device for replace target
Date: Thu, 23 Jun 2016 21:28:13 +0800
Message-Id: <1466688493-8041-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1465980527-19031-1-git-send-email-anand.jain@oracle.com>
References: <1465980527-19031-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

For the replace tests we need a device as a spare device,
here functions _spare_dev_get() and _spare_dev_put()
will get it from the SCRATCH_DEV_POOL_SAVED, which is set
when _scratch_dev_pool_get() is called, and is based on how
many has already been assigned to SCRATCH_DEV_POOL.

 usage:
   _scratch_dev_pool_get 3
   _spare_dev_get

      SPARE_DEV will have a device set which can be
      used as the replace target device.

   _spare_dev_put
   _scratch_dev_pool_put

_spare_dev_get() will pick the next device after SCRATCH_DEV_POOL
devices, from the SCRATCH_DEV_POOL_SAVED, and assigns it to
SPARE_DEV. _spare_dev_put() will set to SPARE_DEV to null.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2:
  add tmp= and its rm
  add comments to why _reload_btrfs_ko is used
  add missing put and test_mount at notrun exit
  use echo instead of _fail when checkpoints are checked
  .out updated to remove Silence..
v3:
  fix to -ne for integer check

 common/rc | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/common/rc b/common/rc
index 2c3891e4b2c9..2a2079a90e6a 100644
--- a/common/rc
+++ b/common/rc
@@ -802,6 +802,65 @@ _scratch_mkfs()
     esac
 }
 
+# Helper function to get a spare or replace-target device from
+# configured SCRATCH_DEV_POLL, must call _scratch_dev_pool_get()
+# before _spare_dev_get(). Replace-target-device/Spare-device will
+# be assigned to SPARE_DEV.
+# As of now only one replace-target-device/spare-device can be
+# assigned.
+#
+# Usage:
+#  _scratch_dev_pool_get() <ndevs>
+#     _spare_dev_get()
+#     :: do stuff
+#     _spare_dev_put()
+#  _scratch_dev_pool_put()
+#
+_spare_dev_get()
+{
+	typeset -p SCRATCH_DEV_POOL_SAVED >/dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		_fail "Bug: unset val, must call _scratch_dev_pool_get before _spare_dev_get"
+	fi
+
+	if [ -z "$SCRATCH_DEV_POOL_SAVED" ]; then
+		_fail "Bug: str empty, must call _scratch_dev_pool_get before _spare_dev_get"
+	fi
+
+	# Check if the spare is already assigned
+	typeset -p SPARE_DEV >/dev/null 2>&1
+	if [ $? -eq 0 ]; then
+		if [ ! -z "$SPARE_DEV" ]; then
+			_fail "Bug: SPARE_DEV = $SPARE_DEV already assigned"
+		fi
+	fi
+
+	local ndevs=`echo $SCRATCH_DEV_POOL| wc -w`
+	local config_ndevs=`echo $SCRATCH_DEV_POOL_SAVED| wc -w`
+
+	if [ $ndevs -eq $config_ndevs ]; then
+		_notrun "All devs used no spare"
+	fi
+	# Get a dev that is not used
+	local devs[]="( $SCRATCH_DEV_POOL_SAVED )"
+	SPARE_DEV=${devs[@]:$ndevs:1}
+	export SPARE_DEV
+}
+
+_spare_dev_put()
+{
+	typeset -p SPARE_DEV >/dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		_fail "Bug: unset val, must call _spare_dev_get before its put"
+	fi
+
+	if [ -z "$SPARE_DEV" ]; then
+		_fail "Bug: str empty, must call _spare_dev_get before its put"
+	fi
+
+	export SPARE_DEV=""
+}
+
 #
 # Generally test cases will have..
 #   _require_scratch_dev_pool X
-- 
2.7.0

