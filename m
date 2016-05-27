Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44720 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbcE0SDA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 14:03:00 -0400
Date: Fri, 27 May 2016 11:02:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH 8/7] xfs/122: don't break on old xfsprogs
Message-ID: <20160527180231.GB5050@birch.djwong.org>
References: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we're running against a old version of xfsprogs that lacks some of
the structures that the golden output knows about, copy the structure
size definition from the golden output to the program output.  This
way we can check for structure size mutations on old xfsprogs without
generating false error reports for structs that don't exist in the
old release.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/122     |    8 ++++++++
 tests/xfs/122.out |    1 +
 2 files changed, 9 insertions(+)

diff --git a/tests/xfs/122 b/tests/xfs/122
index 845cdd2..c944942 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -73,6 +73,7 @@ _attribute_filter()
 cprog=$tmp.get_structs.c
 oprog=$tmp.get_structs
 progout=$tmp.output
+keyfile=$tmp.keys
 
 cat >$cprog <<EOF
 #define _GNU_SOURCE
@@ -239,6 +240,13 @@ if [ $XFSPROGS_VERSION -lt 30000 ]; then
 	echo 'sizeof( xfs_dsb_t ) = 208' >>$progout;
 fi
 
+# Find all the items that only exist in the golden output
+comm -23 <(grep '=' $0.out | sed -e 's/ =.*$//g' | LC_COLLATE=POSIX sort) \
+	 <(sed -e 's/ =.*$//g' < $progout | LC_COLLATE=POSIX sort) > $keyfile
+
+# Copy those items to the program output
+grep -F -f $keyfile $0.out >> $progout
+
 LC_COLLATE=POSIX sort $progout
 
 status=0
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 451871e..46d1dd4 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -147,3 +147,4 @@ sizeof(xfs_lookup_t) = 4
 sizeof(xfs_qoff_logformat_t) = 20
 sizeof(xfs_timestamp_t) = 8
 sizeof(xfs_trans_header_t) = 16
+sizeof(xfs_zzzz_test_the_test_program) = -47
