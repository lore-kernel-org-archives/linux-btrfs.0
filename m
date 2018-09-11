Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57492 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbeIKPGh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 11:06:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8BA4DVS117091
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:08:01 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mc6cpk2cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:08:01 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8BA81te001237
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:08:01 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8BA80Ld031730
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Sep 2018 10:08:00 GMT
From: Anand Jain <anand.jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] fstests: btrfs/149 make it sectorsize independent
Date: Tue, 11 Sep 2018 18:07:54 +0800
Message-Id: <1536660474-21103-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1536129312-18788-1-git-send-email-anand.jain@oracle.com>
References: <1536129312-18788-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally this test case was designed to work with 4K sectorsize.
Now enhance it to work with any sector sizes and makes the following
changes:
.out file not to contain any traces of sector size.
Use max_inline=0 mount option so that it meets the requisite of non inline
regular extent.
Don't log the md5sum results to the output file as the data size vary by
the sectorsize.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
v2->v3: . write md5sum output to full log, drop echo to the out file.
	. drop max_inline=0 for the receive side mount, as at the receive
	  side we are suppose to create inline extent.
	. update references to 4k in the comments.
v1->v2: rename _scratch_sectorsize() to _scratch_btrfs_sectorsize()
	add _require_btrfs_command inspect-internal dump-super

 common/btrfs        |  7 +++++++
 common/filter       |  5 +++++
 tests/btrfs/149     | 46 ++++++++++++++++++++++++++++++----------------
 tests/btrfs/149.out | 11 ++++-------
 4 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/common/btrfs b/common/btrfs
index 79c687f73376..26dc0bb9600f 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -367,3 +367,10 @@ _run_btrfs_balance_start()
 
 	run_check $BTRFS_UTIL_PROG balance start $bal_opt $*
 }
+
+#return the sector size of the btrfs scratch fs
+_scratch_btrfs_sectorsize()
+{
+	$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV |\
+		grep sectorsize | awk '{print $2}'
+}
diff --git a/common/filter b/common/filter
index 3965c2eb752b..e87740ddda3f 100644
--- a/common/filter
+++ b/common/filter
@@ -271,6 +271,11 @@ _filter_xfs_io_pages_modified()
 	_filter_xfs_io_units_modified "Page" $PAGE_SIZE
 }
 
+_filter_xfs_io_numbers()
+{
+        _filter_xfs_io | sed -E 's/[0-9]+/XXXX/g'
+}
+
 _filter_test_dir()
 {
 	# TEST_DEV may be a prefix of TEST_DIR (e.g. /mnt, /mnt/ovl-mnt)
diff --git a/tests/btrfs/149 b/tests/btrfs/149
index 3e955a305e0f..bf5e16962876 100755
--- a/tests/btrfs/149
+++ b/tests/btrfs/149
@@ -6,7 +6,7 @@
 #
 # Test that an incremental send/receive operation will not fail when the
 # destination filesystem has compression enabled and the source filesystem
-# has a 4K extent at a file offset 0 that is not compressed and that is
+# has an extent at a file offset 0 that is not compressed and that is
 # shared.
 #
 seq=`basename $0`
@@ -36,6 +36,7 @@ _require_test
 _require_scratch
 _require_scratch_reflink
 _require_odirect
+_require_btrfs_command inspect-internal dump-super
 
 send_files_dir=$TEST_DIR/btrfs-test-$seq
 
@@ -44,21 +45,27 @@ rm -fr $send_files_dir
 mkdir $send_files_dir
 
 _scratch_mkfs >>$seqres.full 2>&1
-_scratch_mount "-o compress"
+# On 64K pagesize systems the compression is more efficient, so max_inline
+# helps to create regular (non inline) extent irrespective of the final
+# write size.
+_scratch_mount "-o compress -o max_inline=0"
 
 # Write to our file using direct IO, so that this way the write ends up not
 # getting compressed, that is, we get a regular extent which is neither
 # inlined nor compressed.
 # Alternatively, we could have mounted the fs without compression enabled,
 # which would result as well in an uncompressed regular extent.
-$XFS_IO_PROG -f -d -c "pwrite -S 0xab 0 4K" $SCRATCH_MNT/foobar | _filter_xfs_io
+sectorsize=$(_scratch_btrfs_sectorsize)
+$XFS_IO_PROG -f -d -c "pwrite -S 0xab 0 $sectorsize" $SCRATCH_MNT/foobar |\
+	_filter_xfs_io_numbers
 
 $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
 	$SCRATCH_MNT/mysnap1 > /dev/null
 
 # Clone the regular (not inlined) extent.
-$XFS_IO_PROG -c "reflink $SCRATCH_MNT/foobar 0 8K 4K" $SCRATCH_MNT/foobar \
-	| _filter_xfs_io
+$XFS_IO_PROG -c \
+	"reflink $SCRATCH_MNT/foobar 0 $((2 * $sectorsize)) $sectorsize" \
+	$SCRATCH_MNT/foobar | _filter_xfs_io_numbers
 
 $BTRFS_UTIL_PROG subvolume snapshot -r $SCRATCH_MNT \
 	$SCRATCH_MNT/mysnap2 > /dev/null
@@ -67,17 +74,19 @@ $BTRFS_UTIL_PROG send -f $send_files_dir/1.snap \
 		 $SCRATCH_MNT/mysnap1 2>&1 >/dev/null | _filter_scratch
 
 # Now do an incremental send of the second snapshot. The send stream can have
-# a clone operation to clone the extent at offset 0 to offset 8K. This operation
-# would fail on the receiver if it has compression enabled, since the write
-# operation of the extent at offset 0 was compressed because it was a buffered
-# write operation, and btrfs' clone implementation does not allow cloning inline
-# extents to offsets different from 0.
+# a clone operation to clone the extent at offset 0 to offset (2 x sectorsize).
+# This operation would fail on the receiver if it has compression enabled, since
+# the write operation of the extent at offset 0 was compressed because it was a
+# buffered write operation, and btrfs' clone implementation does not allow
+# cloning inline extents to offsets different from 0.
 $BTRFS_UTIL_PROG send -p $SCRATCH_MNT/mysnap1 -f $send_files_dir/2.snap \
 		 $SCRATCH_MNT/mysnap2 2>&1 >/dev/null | _filter_scratch
 
-echo "File digests in the original filesystem:"
-md5sum $SCRATCH_MNT/mysnap1/foobar | _filter_scratch
-md5sum $SCRATCH_MNT/mysnap2/foobar | _filter_scratch
+sum_src_snap1=$(md5sum $SCRATCH_MNT/mysnap1/foobar | awk '{print $1}')
+sum_src_snap2=$(md5sum $SCRATCH_MNT/mysnap2/foobar | awk '{print $1}')
+echo "File digests in the original filesystem:" >> $seqres.full
+echo "md5sum $SCRATCH_MNT/mysnap1/foobar " $sum_src_snap1 >> $seqres.full
+echo "md5sum $SCRATCH_MNT/mysnap2/foobar " $sum_src_snap2 >> $seqres.full
 
 # Now recreate the filesystem by receiving both send streams and verify we get
 # the same file content that the original filesystem had.
@@ -88,9 +97,14 @@ _scratch_mount "-o compress"
 $BTRFS_UTIL_PROG receive -f $send_files_dir/1.snap $SCRATCH_MNT > /dev/null
 $BTRFS_UTIL_PROG receive -f $send_files_dir/2.snap $SCRATCH_MNT > /dev/null
 
-echo "File digests in the new filesystem:"
-md5sum $SCRATCH_MNT/mysnap1/foobar | _filter_scratch
-md5sum $SCRATCH_MNT/mysnap2/foobar | _filter_scratch
+sum_dest_snap1=$(md5sum $SCRATCH_MNT/mysnap1/foobar | awk '{print $1}')
+sum_dest_snap2=$(md5sum $SCRATCH_MNT/mysnap2/foobar | awk '{print $1}')
+echo "File digests in the new filesystem:" | tee -a $seqres.full
+echo "md5sum $SCRATCH_MNT/mysnap1/foobar " $sum_src_snap1 >> $seqres.full
+echo "md5sum $SCRATCH_MNT/mysnap2/foobar " $sum_src_snap2 >> $seqres.full
+
+[[ $sum_src_snap1 == $sum_dest_snap1 ]] && echo "src and dest 'mysnap1' checksum matched"
+[[ $sum_src_snap2 == $sum_dest_snap2 ]] && echo "src and dest 'mysnap2' checksum matched"
 
 status=0
 exit
diff --git a/tests/btrfs/149.out b/tests/btrfs/149.out
index 303de928d35a..13bcd5c99733 100644
--- a/tests/btrfs/149.out
+++ b/tests/btrfs/149.out
@@ -1,14 +1,11 @@
 QA output created by 149
-wrote 4096/4096 bytes at offset 0
+wrote XXXX/XXXX bytes at offset XXXX
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-linked 4096/4096 bytes at offset 8192
+linked XXXX/XXXX bytes at offset XXXX
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 At subvol SCRATCH_MNT/mysnap1
 At subvol SCRATCH_MNT/mysnap2
-File digests in the original filesystem:
-1696b8fe138e867797eb6683cf13d99c  SCRATCH_MNT/mysnap1/foobar
-28feb14349a6f6c67a11967278ed7359  SCRATCH_MNT/mysnap2/foobar
 At subvol mysnap1
 File digests in the new filesystem:
-1696b8fe138e867797eb6683cf13d99c  SCRATCH_MNT/mysnap1/foobar
-28feb14349a6f6c67a11967278ed7359  SCRATCH_MNT/mysnap2/foobar
+src and dest 'mysnap1' checksum matched
+src and dest 'mysnap2' checksum matched
-- 
1.8.3.1
