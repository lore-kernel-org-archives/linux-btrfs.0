Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42555 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbcEaQok (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 12:44:40 -0400
Date: Tue, 31 May 2016 09:43:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com
Cc: Xiao Yang <yangx.jy@cn.fujitsu.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org
Subject: [PATCH v2 8/7] xfs/122: don't break on old xfsprogs
Message-ID: <20160531164352.GC5053@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
 <20160527180231.GB5050@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160527180231.GB5050@birch.djwong.org>
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
