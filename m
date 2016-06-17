Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35580 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066AbcFQBry (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:47:54 -0400
Subject: [PATCH 17/20] generic/204: increase log size for rmap/reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:47:49 -0700
Message-ID: <146612806917.25024.2970222019985115835.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We're going to need a bigger log for rmap & reflink on XFS, so
increase the size of the log and the fs appropriately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/204 |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/204 b/tests/generic/204
index 42985ab..7b0dc2a 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -55,9 +55,9 @@ _scratch_mkfs 2> /dev/null | _filter_mkfs 2> $tmp.mkfs > /dev/null
 # versions of mkfs create. All should be valid with a 7MB log, so use that.
 # And v4/512 v5/1k xfs don't have enough free inodes, set imaxpct=50 at mkfs
 # time solves this problem.
-[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=7m -i maxpct=50"
+[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=16m -i maxpct=50"
 
-SIZE=`expr 106 \* 1024 \* 1024`
+SIZE=`expr 115 \* 1024 \* 1024`
 _scratch_mkfs_sized $SIZE $dbsize 2> /dev/null \
 		| _filter_mkfs 2> $tmp.mkfs > /dev/null
 _scratch_mount

