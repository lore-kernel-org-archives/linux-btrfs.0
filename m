Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29299 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbcEMLvx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 07:51:53 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] [RFC] fstests: btrfs: add functions to set and reset required number of SCRATCH_DEV_POOL
Date: Fri, 13 May 2016 19:21:12 +0800
Message-Id: <1463138474-15990-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch provides functions
 _scratch_dev_pool_get()
 _scratch_dev_pool_put()

Which will help to set/reset SCRATCH_DEV_POOL with the required
number of devices. SCRATCH_DEV_POOL_SAVED will hold all the devices.

Usage:
  _scratch_dev_pool_get() <ndevs>
  :: do stuff

  _scratch_dev_pool_put()

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 common/rc | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/common/rc b/common/rc
index 91e8f1c8e693..33632fd8e4a3 100644
--- a/common/rc
+++ b/common/rc
@@ -786,6 +786,53 @@ _scratch_mkfs()
     esac
 }
 
+#
+# $1 Number of the scratch devs required
+#
+_scratch_dev_pool_get()
+{
+	if [ $# != 1 ]; then
+		_fail "Usage: _scratch_dev_pool_get ndevs"
+	fi
+
+	local test_ndevs=$1
+	local config_ndevs=`echo $SCRATCH_DEV_POOL| wc -w`
+	local devs[]="( $SCRATCH_DEV_POOL )"
+
+	typeset -p config_ndevs >/dev/null 2>&1
+	if [ $? != 0 ]; then
+		_fail "Bug: unset val, must call _scratch_dev_pool_get before _scratch_dev_pool_put"
+	fi
+
+	# _require_scratch_dev_pool $test_ndevs
+	# must have already checked the min required devices
+	# but just in case, trap here for any potential bugs
+	# perpetuating any further
+	if [ $config_ndevs -lt $test_ndevs ]; then
+		_notrun "Need at least test requested number of ndevs $test_ndevs"
+	fi
+
+	SCRATCH_DEV_POOL_SAVED=${SCRATCH_DEV_POOL}
+	export SCRATCH_DEV_POOL_SAVED
+	SCRATCH_DEV_POOL=${devs[@]:0:$test_ndevs}
+	export SCRATCH_DEV_POOL
+}
+
+_scratch_dev_pool_put()
+{
+	typeset -p SCRATCH_DEV_POOL_SAVED >/dev/null 2>&1
+	if [ $? != 0 ]; then
+		_fail "Bug: unset val, must call _scratch_dev_pool_get before _scratch_dev_pool_put"
+	fi
+
+	if [ -z "$SCRATCH_DEV_POOL_SAVED" ]; then
+		_fail "Bug: str empty, must call _scratch_dev_pool_get before _scratch_dev_pool_put"
+	fi
+
+	export SCRATCH_DEV_POOL=$SCRATCH_DEV_POOL_SAVED
+	export SCRATCH_DEV_POOL_SAVED=""
+}
+
 _scratch_pool_mkfs()
 {
     case $FSTYP in
-- 
2.7.0

