Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291AbaDIReb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Apr 2014 13:34:31 -0400
From: David Disseldorp <ddiss@suse.de>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Disseldorp <ddiss@suse.de>
Subject: [PATCH] btrfs/035: update clone test to expect EOPNOTSUPP
Date: Wed,  9 Apr 2014 19:42:51 +0200
Message-Id: <1397065371-22085-2-git-send-email-ddiss@suse.de>
In-Reply-To: <1397065371-22085-1-git-send-email-ddiss@suse.de>
References: <1394448967-14128-1-git-send-email-bo.li.liu@oracle.com>
 <1397065371-22085-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

With kernel commit 00fdf13a2e9f313a044288aa59d3b8ec29ff904a, the first
clone-range overwrite attempt now fails with EOPNOTSUPP.

FIXME: The second clone-range causes EIO on subsequent read attempts.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 tests/btrfs/035     | 10 ++++++++++
 tests/btrfs/035.out |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/tests/btrfs/035 b/tests/btrfs/035
index 6808179..21a9059 100755
--- a/tests/btrfs/035
+++ b/tests/btrfs/035
@@ -57,21 +57,31 @@ src_str="aaaaaaaaaa"
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
+# resulted in a BUG_ON in __btrfs_drop_extents(). The kernel now returns EINVAL
+# up to userspace.
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

