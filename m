Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64059 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaJHCgK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 22:36:10 -0400
From: Wang Shilong <wangshilong1991@gmail.com>
To: fstests@vger.kernel.org
Cc: david@fromorbit.com, linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] xfstests,btrfs/010: use _extent_count() helper
Date: Wed,  8 Oct 2014 06:35:21 -0400
Message-Id: <1412764522-15754-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

cleanup to swith _extent_count(), this way we remove a
dependence on filefrag.

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
 tests/btrfs/010 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)
 mode change 100755 => 100644 tests/btrfs/010

diff --git a/tests/btrfs/010 b/tests/btrfs/010
old mode 100755
new mode 100644
index 371f1b8..6cfc561
--- a/tests/btrfs/010
+++ b/tests/btrfs/010
@@ -40,6 +40,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/defrag
 
 # real QA test starts here
 
@@ -47,7 +48,6 @@ _cleanup()
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-_require_command "/usr/sbin/filefrag"
 
 rm -f $seqres.full
 
@@ -71,9 +71,9 @@ done
 
 $BTRFS_UTIL_PROG filesystem defrag $subvol/foobar && sync
 
-num_extent_orig=`filefrag $subvol/foobar | awk -F ' ' '{print $2}'`
-num_extent_snap1=`filefrag $SCRATCH_MNT/snap-1/foobar | awk -F ' ' '{print $2}'`
-num_extent_snap2=`filefrag $SCRATCH_MNT/snap-2/foobar | awk -F ' ' '{print $2}'`
+num_extent_orig=`_extent_count $subvol/foobar`
+num_extent_snap1=`_extent_count $SCRATCH_MNT/snap-1/foobar`
+num_extent_snap2=`_extent_count $SCRATCH_MNT/snap-2/foobar`
 
 echo "$num_extent_orig $num_extent_snap1 $num_extent_snap2" >> $seqres.full
 
-- 
1.8.3.1

