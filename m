Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18539 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbcFQBrt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jun 2016 21:47:49 -0400
Subject: [PATCH 15/20] xfstests: fix unreferenced variables in generic/186
 and generic/187
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Thu, 16 Jun 2016 18:47:36 -0700
Message-ID: <146612805661.25024.577635269102170354.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Christoph Hellwig <hch@lst.de>

There is not i variable in scope, and the comments suggest the operation
is to be done on ${file}.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/186 |    2 +-
 tests/generic/187 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/generic/186 b/tests/generic/186
index 70a0280..5de120a 100755
--- a/tests/generic/186
+++ b/tests/generic/186
@@ -87,7 +87,7 @@ _fragment_freesp()
 
 	# Try again anyway
 	avail=`_get_available_space $SCRATCH_MNT`
-	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}.${i}
+	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}
 
 	# Punch out whatever we need
 	seq 1 $((nr * 4)) | while read f; do
diff --git a/tests/generic/187 b/tests/generic/187
index 25cbcd9..3f534c8 100755
--- a/tests/generic/187
+++ b/tests/generic/187
@@ -88,7 +88,7 @@ _fragment_freesp()
 
 	# Try again anyway
 	avail=`_get_available_space $SCRATCH_MNT`
-	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}.${i}
+	$XFS_IO_PROG -fc "pwrite -S 0x65 0 $avail" ${file}
 
 	# Punch out whatever we need
 	seq 1 $((nr * 4)) | while read f; do

