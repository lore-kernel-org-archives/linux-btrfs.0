Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:42850 "EHLO
	prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751221AbbANXV6 (ORCPT
	<rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
	Wed, 14 Jan 2015 18:21:58 -0500
From: Filipe Manana <fdmanana@suse.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: [PATCH] fstests: fix test btrfs/017 (qgroup shared extent accounting test)
Date: Wed, 14 Jan 2015 23:21:43 +0000
Message-Id: <1421277703-32154-1-git-send-email-fdmanana@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently this test fails on 2 situations:

1) The scratch device supports trim/discard. In this case any modern
   version of mkfs.btrfs outputs a message (to stderr) informing that
   a trim is performed, which the golden output doesn't expect:

   btrfs/017	 - output mismatch (see /git/xfstests/results//btrfs/017.out.bad)
       --- tests/btrfs/017.out	2015-01-06 11:14:22.730143144 +0000
       +++ /git/xfstests/results//btrfs/017.out.bad	2015-01-14 22:33:01.582195719 +0000
       @@ -1,4 +1,5 @@
        QA output created by 017
       +Performing full device TRIM (100.00GiB) ...
        wrote 8192/8192 bytes at offset 0
          XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
        4096 4096
        ...
        (Run 'diff -u tests/btrfs/017.out /git/xfstests/results//btrfs/017.out.bad'  to see the entire diff)

    So like others tests do, just redirect mkfs' standard error.

2) On platforms with a page size greater than 4Kb. At the moment btrfs
   doesn't support a node/leaf size smaller than the page size, but it
   supports a larger one. So use the max supported node size (64Kb) so
   that the test runs on any platform currently supported by Linux.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 tests/btrfs/017     | 6 +++++-
 tests/btrfs/017.out | 4 ++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tests/btrfs/017 b/tests/btrfs/017
index 7937607..d00d7c8 100755
--- a/tests/btrfs/017
+++ b/tests/btrfs/017
@@ -56,7 +56,11 @@ _require_cloner
 
 rm -f $seqres.full
 
-_scratch_mkfs "--nodesize 4096"
+# Currently in btrfs the node/leaf size can not be smaller than the page
+# size (but it can be greater than the page size). So use the largest
+# supported node/leaf size (64Kb) so that the test can run on any platform
+# that Linux supports.
+_scratch_mkfs "--nodesize 65536" >>$seqres.full 2>&1
 _scratch_mount
 
 $XFS_IO_PROG -f -d -c "pwrite 0 8K" $SCRATCH_MNT/foo | _filter_xfs_io
diff --git a/tests/btrfs/017.out b/tests/btrfs/017.out
index 7658e2e..f940f3a 100644
--- a/tests/btrfs/017.out
+++ b/tests/btrfs/017.out
@@ -1,5 +1,5 @@
 QA output created by 017
 wrote 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-4096 4096
-4096 4096
+65536 65536
+65536 65536
-- 
2.1.3

