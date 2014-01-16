Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48473 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAPCzY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 21:55:24 -0500
From: Anand Jain <anand.jain@oracle.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, wangshilong1991@gmail.com, dsterba@suse.cz
Subject: [PATCH 1/2 v3] xfstests: make btrfs/001.out in line with subvol delete output
Date: Thu, 16 Jan 2014 11:04:36 +0800
Message-Id: <1389841476-8985-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
References: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

btrfs/001 is failing as the below btrfs-progs patch changed the
output during subvol delete.
Patch :
btrfs-progs: add options to set commit mode after subvol delete

adding it to the filter

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 v3: takes in David suggested
 v2: accepts Wang suggested

 common/filter.btrfs |   10 ++++++++++
 tests/btrfs/001     |    3 ++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/common/filter.btrfs b/common/filter.btrfs
index 29512cd..b81ac49 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -56,5 +56,15 @@ _filter_btrfs_device_stats()
 	sed -e "s/ *$NUMDEVS /<NUMDEVS> /g"
 }
 
+_filter_transcation_commit_default() {
+	sed -e "/Transaction commit: none (default)/d"
+}
+
+_filter_btrfs_subvol_delete()
+{
+	_filter_scratch | _filter_transcation_commit_default
+
+}
+
 # make sure this script returns success
 /bin/true
diff --git a/tests/btrfs/001 b/tests/btrfs/001
index c05d772..8258d06 100755
--- a/tests/btrfs/001
+++ b/tests/btrfs/001
@@ -40,6 +40,7 @@ trap "_cleanup ; exit \$status" 0 1 2 3 15
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/filter.btrfs
 
 # real QA test starts here
 _supported_fs btrfs
@@ -98,7 +99,7 @@ echo "Listing subvolumes"
 $BTRFS_UTIL_PROG subvolume list $SCRATCH_MNT | awk '{ print $NF }'
 
 # Delete the snapshot
-$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/snap | _filter_scratch
+$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/snap | _filter_btrfs_subvol_delete
 echo "List root dir"
 ls $SCRATCH_MNT
 _scratch_remount
-- 
1.7.1

