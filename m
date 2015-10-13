Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:37643 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbbJMOaV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 10:30:21 -0400
From: fdmanana@kernel.org
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH 2/2] fstests: update btrfs/035 to check for data loss
Date: Tue, 13 Oct 2015 15:30:11 +0100
Message-Id: <1444746611-20931-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@suse.com>

The test currently verifies that cloning one file with an inline extent
with a size of 10 bytes into a file with an inline extent that has a size
of 20 bytes succeeds. But this results in data loss, because the btrfs
clone operation drops the 20 bytes inline extent from the destination
inode and then copies the 10 bytes inline extent from the source file
into the destination file, resulting in data loss of the last 10 bytes
of data that the destination file had.

Fixing btrfs to correctly operate for this case (not resulting in data
loss) is actually a lot of work and brings a lot of complexity, specially
considering that any of the inline extents can be compressed. For the
moment there's a fix to make the clone operation return the errno
EOPNOTSUPP and not touch any of the inodes. This is the same approach
we do for other cases involving operation against inline extents, so
this just adds one more case that should have never been allowed.
Cloning inline extents is a rare operation and pointless, since it
involves copying them and not doing any actual deduplication or saving
space.

The btrfs patch for the linux kernel that prevents this data loss,
and fixes some file corruption cases, is titled:

  "Btrfs: fix file corruption and data loss after cloning inline extents"

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/035     | 14 ++++++++++++++
 tests/btrfs/035.out |  9 +++++++++
 2 files changed, 23 insertions(+)

diff --git a/tests/btrfs/035 b/tests/btrfs/035
index 35ddfce..0f8a70d 100755
--- a/tests/btrfs/035
+++ b/tests/btrfs/035
@@ -67,9 +67,23 @@ echo "attempting ioctl (src.clone1 src)"
 $CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
 	$SCRATCH_MNT/src.clone1 $SCRATCH_MNT/src
 
+# The clone operation should have failed. If it did not it meant we had data
+# loss, because file "src.clone1" has an inline extent which is 10 bytes long
+# while file "src" has an inline extent which is 20 bytes long. The clone
+# operation would remove the inline extent of "src" and then copy the inline
+# extent from "src.clone1" into "src", which means we would lose the last 10
+# bytes of data from "src" (on read we would get 0x00 as the value for any
+# of those 10 bytes, because the file's size remains as 20 bytes).
+echo "File src data after attempt to clone from src.clone1 into src:"
+od -t x1 $SCRATCH_MNT/src
+
 snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone2 | awk '{print $5}'`
 echo "attempting ioctl (src.clone2 src)"
 $CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
 	$SCRATCH_MNT/src.clone2 $SCRATCH_MNT/src
 
+# The clone operation should have succeeded.
+echo "File src data after attempt to clone from src.clone2 into src:"
+od -t x1 $SCRATCH_MNT/src
+
 status=0 ; exit
diff --git a/tests/btrfs/035.out b/tests/btrfs/035.out
index f86cadf..3ea7d77 100644
--- a/tests/btrfs/035.out
+++ b/tests/btrfs/035.out
@@ -1,3 +1,12 @@
 QA output created by 035
 attempting ioctl (src.clone1 src)
+clone failed: Operation not supported
+File src data after attempt to clone from src.clone1 into src:
+0000000 62 62 62 62 62 62 62 62 62 62 63 63 63 63 63 63
+0000020 63 63 63 63
+0000024
 attempting ioctl (src.clone2 src)
+File src data after attempt to clone from src.clone2 into src:
+0000000 62 62 62 62 62 62 62 62 62 62 63 63 63 63 63 63
+0000020 63 63 63 63
+0000024
-- 
2.1.3

