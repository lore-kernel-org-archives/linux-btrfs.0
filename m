Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:17789 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbBIHGH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 02:06:07 -0500
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, clm@fb.com
Subject: [PATCH 2/4] Btrfs-progs: adds simple to use seed test for test-btrfs-devmgt.sh
Date: Mon,  9 Feb 2015 15:05:04 +0800
Message-Id: <1423465506-30934-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1423465506-30934-1-git-send-email-anand.jain@oracle.com>
References: <1423465506-30934-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 tests/test-btrfs-devmgt.sh | 76 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

diff --git a/tests/test-btrfs-devmgt.sh b/tests/test-btrfs-devmgt.sh
index 2f75200..5facbdb 100755
--- a/tests/test-btrfs-devmgt.sh
+++ b/tests/test-btrfs-devmgt.sh
@@ -66,7 +66,10 @@
 		#remount test:
  #test32: mount, remount
 
-
+		#add sprout test:
+ #test33: add sprout
+ #test34: raid1 seed, add sprout
+ #test35: add sprout, umount, mount seed, mount sprout
 
 
 # Devices are hard coded. sorry
@@ -814,6 +817,73 @@ clean
 	ent_cont
 }
 
+test33()
+{
+	TEST="test33" && erase && echo -e "\n$TEST"
+clean
+	collect_sysfs "$TEST"
+_mkfs.btrfs -L $TEST -U $TEST_FSID $DEV1 -f
+	collect_sysfs "$TEST"
+btrfstune -S 1 $DEV1
+mount $DEV1 /btrfs
+	collect_sysfs "$TEST"
+btrfs dev add $DEV2 /btrfs
+	collect_sysfs "$TEST"
+umount /btrfs
+	collect_sysfs "$TEST"
+clean
+	collect_sysfs "$TEST"
+
+	ent_cont
+}
+
+test34()
+{
+	TEST="test34" && erase && echo -e "\n$TEST"
+clean
+	collect_sysfs "$TEST"
+_mkfs.btrfs -draid1 -mraid1 -L $TEST -U $TEST_FSID $DEV1 $DEV2 -f
+	collect_sysfs "$TEST"
+btrfstune -S 1 $DEV1
+mount $DEV1 /btrfs
+	collect_sysfs "$TEST"
+btrfs dev add $DEV3 /btrfs
+	collect_sysfs "$TEST"
+umount /btrfs
+	collect_sysfs "$TEST"
+clean
+	collect_sysfs "$TEST"
+
+	ent_cont
+}
+
+test35()
+{
+	TEST="test35" && erase && echo -e "\n$TEST"
+clean
+	collect_sysfs "$TEST"
+_mkfs.btrfs -L $TEST -U $TEST_FSID $DEV1 -f
+	collect_sysfs "$TEST"
+btrfstune -S 1 $DEV1
+mount $DEV1 /btrfs
+	collect_sysfs "$TEST"
+btrfs dev add $DEV2 /btrfs
+	collect_sysfs "$TEST"
+umount /btrfs
+	collect_sysfs "$TEST"
+mount $DEV1 /btrfs
+	collect_sysfs "$TEST"
+mount $DEV2 /btrfs1
+	collect_sysfs "$TEST"
+umount /btrfs
+	collect_sysfs "$TEST"
+umount /btrfs1
+clean
+	collect_sysfs "$TEST"
+
+	ent_cont
+}
+
 test0()
 {
   echo "Have you tested with btrfs boot, you can't do that here\n"
@@ -860,4 +930,8 @@ sleep 2; test30
 sleep 2; test31
 sleep 2; test32
 
+sleep 2; test33
+sleep 2; test34
+sleep 2; test35
+
 [[ -z $TMP_FILE ]] || echo -e "\nTMP_FILE= $TMP_FILE"
-- 
1.9.1

