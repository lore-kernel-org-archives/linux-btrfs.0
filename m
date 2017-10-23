Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26733 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdJWWAO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Oct 2017 18:00:14 -0400
From: Liu Bo <bo.li.liu@oracle.com>
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH] fstests: btrfs/143: make test case more reliable
Date: Mon, 23 Oct 2017 14:57:33 -0600
Message-Id: <20171023205733.14896-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Currently drop_caches is used to invalidate file's page cache so that
buffered read can hit disk, but the problem is that it may also
invalidate metadata's page cache, so the test case may not get read
errors (and repair) if reading metadata has consumed the injected
faults.

This changes it to do 'fadvise -d' to firstly access all metadata it
needs to locate the file and then only drops the test file's page
cache.  Also this changes it to read the file only if pid%2 == 1.

Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
---
 tests/btrfs/143 | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tests/btrfs/143 b/tests/btrfs/143
index da7bfd8..dabd03d 100755
--- a/tests/btrfs/143
+++ b/tests/btrfs/143
@@ -127,16 +127,16 @@ echo "step 3......repair the bad copy" >>$seqres.full
 # since raid1 consists of two copies, and the bad copy was put on stripe #1
 # while the good copy lies on stripe #0, the bad copy only gets access when the
 # reader's pid % 2 == 1 is true
-while true; do
-	# start_fail only fails the following buffered read so the repair is
-	# supposed to work.
-	echo 3 > /proc/sys/vm/drop_caches
-	start_fail
-	$XFS_IO_PROG -c "pread 0 4K" "$SCRATCH_MNT/foobar" > /dev/null &
-	pid=$!
-	wait
-	stop_fail
-	[ $((pid % 2)) == 1 ] && break
+while [[ -z ${result} ]]; do
+    # invalidate the page cache.
+    $XFS_IO_PROG -c "fadvise -d 0 128K" $SCRATCH_MNT/foobar
+
+    start_fail
+    result=$(bash -c "
+        if [[ \$((\$\$ % 2)) -eq 1 ]]; then
+                exec $XFS_IO_PROG -c \"pread 0 4K\" \"$SCRATCH_MNT/foobar\"
+        fi");
+    stop_fail
 done
 
 _scratch_unmount
-- 
2.5.0

