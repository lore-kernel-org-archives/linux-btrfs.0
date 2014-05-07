Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60548 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbaEGMZV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 May 2014 08:25:21 -0400
From: David Disseldorp <ddiss@suse.de>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, bo.li.liu@oracle.com,
        David Disseldorp <ddiss@suse.de>
Subject: [PATCH] btrfs/035: update clone test to expect EOPNOTSUPP
Date: Wed,  7 May 2014 14:33:18 +0200
Message-Id: <1399465998-26545-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With kernel commit 00fdf13a2e9f313a044288aa59d3b8ec29ff904a, the first
clone-range overwrite attempt now fails with EOPNOTSUPP, rather than
tripping a Btrfs BUG_ON().

This test now trips a new Btrfs bug, in which EIO is returned for
subsequent reads following the second clone range ioctl.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 tests/btrfs/035     | 11 +++++++++++
 tests/btrfs/035.out |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/tests/btrfs/035 b/tests/btrfs/035
index 6808179..c9530f6 100755
--- a/tests/btrfs/035
+++ b/tests/btrfs/035
@@ -57,21 +57,32 @@ src_str="aaaaaaaaaa"
 echo -n "$src_str" > $SCRATCH_MNT/src
 
 $CLONER_PROG $SCRATCH_MNT/src  $SCRATCH_MNT/src.clone1
+cat $SCRATCH_MNT/src.clone1
+echo
 
 src_str="bbbbbbbbbbcccccccccc"
 
 echo -n "$src_str" > $SCRATCH_MNT/src
 
 $CLONER_PROG $SCRATCH_MNT/src $SCRATCH_MNT/src.clone2
+cat $SCRATCH_MNT/src.clone2
+echo
 
+# Prior to kernel commit 00fdf13a2e9f313a044288aa59d3b8ec29ff904a, this clone
+# resulted in a BUG_ON in __btrfs_drop_extents(). The kernel now returns
+# EOPNOTSUPP up to userspace.
 snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone1 | awk '{print $5}'`
 echo "attempting ioctl (src.clone1 src)"
 $CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
 	$SCRATCH_MNT/src.clone1 $SCRATCH_MNT/src
+cat $SCRATCH_MNT/src
+echo
 
 snap_src_sz=`ls -lah $SCRATCH_MNT/src.clone2 | awk '{print $5}'`
 echo "attempting ioctl (src.clone2 src)"
 $CLONER_PROG -s 0 -d 0 -l ${snap_src_sz} \
 	$SCRATCH_MNT/src.clone2 $SCRATCH_MNT/src
+# BUG: subsequent access attempts currently result in EIO...
+cat $SCRATCH_MNT/src
 
 status=0 ; exit
diff --git a/tests/btrfs/035.out b/tests/btrfs/035.out
index f86cadf..0ea2c4f 100644
--- a/tests/btrfs/035.out
+++ b/tests/btrfs/035.out
@@ -1,3 +1,8 @@
 QA output created by 035
+aaaaaaaaaa
+bbbbbbbbbbcccccccccc
 attempting ioctl (src.clone1 src)
+clone failed: Operation not supported
+bbbbbbbbbbcccccccccc
 attempting ioctl (src.clone2 src)
+bbbbbbbbbbcccccccccc
-- 
1.8.4.5

