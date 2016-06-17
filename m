Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35332 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbcFQBrG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:47:06 -0400
Subject: [PATCH 08/20] xfs/122: don't break on old xfsprogs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:46:52 -0700
Message-ID: <146612801269.25024.6120665241562735488.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we're running against a old version of xfsprogs that lacks some of
the structures that the golden output knows about, copy the structure
size definition from the golden output to the program output.  This
way we can check for structure size mutations on old xfsprogs without
generating false error reports for structs that don't exist in the
old release.

v2: Remove the xfsprogs 2.9.8 compatibility cruft.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122     |   17 ++++++-----------
 tests/xfs/122.out |    1 +
 2 files changed, 7 insertions(+), 11 deletions(-)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 845cdd2..330d3ac 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -73,6 +73,7 @@ _attribute_filter()
 cprog=$tmp.get_structs.c
 oprog=$tmp.get_structs
 progout=$tmp.output
+keyfile=$tmp.keys
 
 cat >$cprog <<EOF
 #define _GNU_SOURCE
@@ -226,18 +227,12 @@ cc -o $oprog $cprog >> $seqres.full 2>&1 || \
   _notrun "Could not compile test program (see end of $seqres.full)"
 $oprog | _type_size_filter | _type_name_filter > $progout
 
-#
-# add addition sizes and xfs_sb_t fields that don't exist in the version
-# being tested.
-#
+# Find all the items that only exist in the golden output
+comm -23 <(grep '=' $0.out | sed -e 's/ =.*$//g' | LC_COLLATE=POSIX sort) \
+	 <(sed -e 's/ =.*$//g' < $progout | LC_COLLATE=POSIX sort) > $keyfile
 
-# xfsprogs 2.9.8: sb_bad_features2 in pv 978822
-if [ $XFSPROGS_VERSION -lt 20908 ]; then
-	echo 'offsetof(xfs_sb_t, sb_bad_features2 ) = 204' >>$progout
-fi
-if [ $XFSPROGS_VERSION -lt 30000 ]; then
-	echo 'sizeof( xfs_dsb_t ) = 208' >>$progout;
-fi
+# Copy those items to the program output
+grep -F -f $keyfile $0.out >> $progout
 
 LC_COLLATE=POSIX sort $progout
 
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 451871e..46d1dd4 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -147,3 +147,4 @@ sizeof(xfs_lookup_t) = 4
 sizeof(xfs_qoff_logformat_t) = 20
 sizeof(xfs_timestamp_t) = 8
 sizeof(xfs_trans_header_t) = 16
+sizeof(xfs_zzzz_test_the_test_program) = -47

