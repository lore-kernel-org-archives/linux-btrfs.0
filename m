Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45374 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721AbbLXMOI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Dec 2015 07:14:08 -0500
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 4/4 v2] fstests: fix cleanup of test btrfs/003
Date: Wed, 23 Dec 2015 04:43:15 +0000
Message-Id: <1450845795-18729-4-git-send-email-fdmanana@kernel.org>
In-Reply-To: <1450845795-18729-1-git-send-email-fdmanana@kernel.org>
References: <1450845795-18729-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

If the test fails after removing a device and before adding it back, it
attempts to add back the device in its _cleanup() function. However this
is broken because the device identifier is stored in a variable local to
the function _test_replace() and not in a global variable. So make the
variable global instead of local.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: No changes from v1. Only added to V2 of the corresponding patchset.

 tests/btrfs/003 | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 353cb48..ae7e377 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -29,6 +29,7 @@ here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
 dev_removed=0
+removed_dev_htl=""
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
@@ -37,7 +38,7 @@ _cleanup()
     rm -f $tmp.*
     if [ $dev_removed == 1 ]; then
 	_scratch_unmount
-        _devmgt_add "${DEVHTL}"
+	_devmgt_add "${removed_dev_htl}"
     fi
 }
 
@@ -125,7 +126,6 @@ _test_replace()
 	local n=${#devs[@]}
 	local ds
 	local d
-	local DEVHTL=""
 
 	# exclude the first and the last disk in the disk pool
 	n=$(($n-1))
@@ -142,10 +142,10 @@ _test_replace()
 
 	# retrive the HTL for this scsi disk
 	d=`echo $ds|cut -d"/" -f3`
-	DEVHTL=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
+	removed_dev_htl=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
 
 	#fail disk
-	_devmgt_remove ${DEVHTL} $ds
+	_devmgt_remove ${removed_dev_htl} $ds
 	dev_removed=1
 
 	$BTRFS_UTIL_PROG filesystem show $SCRATCH_DEV | grep "Some devices missing" >> $seqres.full || _fail \
@@ -162,7 +162,7 @@ _test_replace()
 
 	# cleaup. add the removed disk
 	_scratch_unmount
-	_devmgt_add "${DEVHTL}"
+	_devmgt_add "${removed_dev_htl}"
 	dev_removed=0
 }
 
-- 
2.1.3

