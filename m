Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30431C4360F
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 11:08:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AB0220870
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 11:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfDALIn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 07:08:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:59832 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725882AbfDALIn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 07:08:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 40690AD84;
        Mon,  1 Apr 2019 11:08:41 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     fstests@vger.kernel.org
Cc:     guaneryu@gmail.com, linux-btrfs@vger.kernel.org,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Enable btrfs/003
Date:   Mon,  1 Apr 2019 14:08:37 +0300
Message-Id: <20190401110837.30231-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For a long time this test has been failing on all kinds of VM configuration,
which are using virtio_blk devices. This is due to the fact that scsi
devices are deletable and virtio_blk are not. However, this only prevents
device replace case to run and has no negative effect on the other
useful test cases.

Re-enable btrfs/003 to run by making _require_deletable_scratch_dev_pool
private to the test case and modifying it to return success (0) or
failure (1) if devices are not deletable. Further modify the replace
test case to check the return value of this function and skip it if
devices are not deletable.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Changes since v1: 
 * Rename the function to deletable_scratch_dev_pool

 common/rc       | 12 ------------
 tests/btrfs/003 | 19 ++++++++++++++++++-
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/common/rc b/common/rc
index 1c42515ff0ea..5693ba3cad18 100644
--- a/common/rc
+++ b/common/rc
@@ -2961,18 +2961,6 @@ _require_scratch_dev_pool_equal_size()
 	done
 }
 
-# We will check if the device is deletable
-_require_deletable_scratch_dev_pool()
-{
-	local i
-	local x
-	for i in $SCRATCH_DEV_POOL; do
-		x=`echo $i | cut -d"/" -f 3`
-		if [ ! -f /sys/class/block/${x}/device/delete ]; then
-			_notrun "$i is a device which is not deletable"
-		fi
-	done
-}
 
 # Check that fio is present, and it is able to execute given jobfile
 _require_fio()
diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 22aa57aad0b9..c72c34290ff0 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -17,6 +17,21 @@ dev_removed=0
 removed_dev_htl=""
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
+# Check if all scratch dev pools are deletable
+deletable_scratch_dev_pool()
+{
+	local i
+	local x
+	for i in $SCRATCH_DEV_POOL; do
+		x=`echo $i | cut -d"/" -f 3`
+		if [ ! -f /sys/class/block/${x}/device/delete ]; then
+			return 1
+		fi
+	done
+
+	return 0
+}
+
 _cleanup()
 {
     cd /
@@ -35,7 +50,6 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 _require_scratch_dev_pool 4
-_require_deletable_scratch_dev_pool
 _require_command "$WIPEFS_PROG" wipefs
 
 rm -f $seqres.full
@@ -111,6 +125,9 @@ _test_replace()
 	local ds
 	local d
 
+	# If scratch devs are not deletable skip this test
+	if ! deletable_scratch_dev_pool; then return 0; fi
+
 	# exclude the first and the last disk in the disk pool
 	n=$(($n-1))
 	ds=${devs[@]:1:$(($n-1))}
-- 
2.7.4

