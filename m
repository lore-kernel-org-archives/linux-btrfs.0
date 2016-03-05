Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55675 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcCEUZD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 15:25:03 -0500
Date: Sat, 5 Mar 2016 12:25:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: [PATCH 13/12] xfs/209: filter scratch dir properly
Message-ID: <20160305202502.GI10245@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160305003717.28738.98818.stgit@birch.djwong.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/tests/xfs/209 b/tests/xfs/209
index cecd9c7..9bf1f12 100755
--- a/tests/xfs/209
+++ b/tests/xfs/209
@@ -73,7 +73,7 @@ echo "Check cowextsize settings"
 seq 1 2 | while read nr; do
 	seq 1 4 | while read nnr; do
 		file="$testdir/dir-$nr/file-$nnr"
-		$XFS_IO_PROG -c "cowextsize" $file
+		$XFS_IO_PROG -c "cowextsize" $file | _filter_scratch
 	done
 done
 
diff --git a/tests/xfs/209.out b/tests/xfs/209.out
index 109af34..b97fa96 100644
--- a/tests/xfs/209.out
+++ b/tests/xfs/209.out
@@ -3,11 +3,11 @@ Format and mount
 Set extsz and cowextsz on directory
 Create a fake tree structure
 Check cowextsize settings
-[1048576] /opt/test-209/dir-1/file-1
-[1048576] /opt/test-209/dir-1/file-2
-[1048576] /opt/test-209/dir-1/file-3
-[1048576] /opt/test-209/dir-1/file-4
-[1048576] /opt/test-209/dir-2/file-1
-[1048576] /opt/test-209/dir-2/file-2
-[1048576] /opt/test-209/dir-2/file-3
-[1048576] /opt/test-209/dir-2/file-4
+[1048576] SCRATCH_MNT/test-209/dir-1/file-1
+[1048576] SCRATCH_MNT/test-209/dir-1/file-2
+[1048576] SCRATCH_MNT/test-209/dir-1/file-3
+[1048576] SCRATCH_MNT/test-209/dir-1/file-4
+[1048576] SCRATCH_MNT/test-209/dir-2/file-1
+[1048576] SCRATCH_MNT/test-209/dir-2/file-2
+[1048576] SCRATCH_MNT/test-209/dir-2/file-3
+[1048576] SCRATCH_MNT/test-209/dir-2/file-4
