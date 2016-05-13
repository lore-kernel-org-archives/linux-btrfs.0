Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29311 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbcEMLvz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 07:51:55 -0400
From: Anand Jain <anand.jain@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/3] [RFC] fstests: btrfs: add functions to get and put a device for replace target
Date: Fri, 13 May 2016 19:21:13 +0800
Message-Id: <1463138474-15990-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1463138474-15990-1-git-send-email-anand.jain@oracle.com>
References: <1463138474-15990-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

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
 common/rc | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/common/rc b/common/rc
index 33632fd8e4a3..f2b39ddbee0c 100644
--- a/common/rc
+++ b/common/rc
@@ -786,6 +786,51 @@ _scratch_mkfs()
     esac
 }
 
+_spare_dev_get()
+{
+	typeset -p SCRATCH_DEV_POOL_SAVED >/dev/null 2>&1
+	if [ $? != 0 ]; then
+		_fail "Bug: unset val, must call _scratch_dev_pool_get before _spare_dev_get"
+	fi
+
+	if [ -z "$SCRATCH_DEV_POOL_SAVED" ]; then
+		_fail "Bug: str empty, must call _scratch_dev_pool_get before _spare_dev_get"
+	fi
+
+	# Check if the spare is already assigned
+	typeset -p SPARE_DEV >/dev/null 2>&1
+	if [ $? == 0 ]; then
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
+	if [ $? != 0 ]; then
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
 # $1 Number of the scratch devs required
 #
-- 
2.7.0

