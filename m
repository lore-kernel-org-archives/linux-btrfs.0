Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:17803 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751155AbcCOHzA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 03:55:00 -0400
From: Xiaoguang Wang <wangxg.fnst@cn.fujitsu.com>
To: <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs/059: add a filter for btrfs compression property
Date: Tue, 15 Mar 2016 15:28:44 +0800
Message-ID: <1458026924-24194-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>

btrfs/059.out should not be hardcoded to zlib, if compression method
is lzo, this case will fail wrongly, so here add a filter.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 common/filter.btrfs |  4 ++++
 tests/btrfs/059     | 16 +++++++++++-----
 tests/btrfs/059.out |  6 +++---
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/common/filter.btrfs b/common/filter.btrfs
index 9bb6479..56cf4b2 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -65,7 +65,11 @@ _filter_transaction_commit() {
 _filter_btrfs_subvol_delete()
 {
 	_filter_scratch | _filter_transaction_commit
+}
 
+_filter_btrfs_compress_property()
+{
+	sed -e "s/compression=\(lzo\|zlib\)/COMPRESSION=XXX/g"
 }
 
 # make sure this script returns success
diff --git a/tests/btrfs/059 b/tests/btrfs/059
index f6c2e27..d7db1df 100755
--- a/tests/btrfs/059
+++ b/tests/btrfs/059
@@ -44,6 +44,7 @@ _cleanup()
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/filter.btrfs
 
 # real QA test starts here
 _supported_fs btrfs
@@ -61,24 +62,29 @@ mkdir $SCRATCH_MNT/testdir
 echo "Setting compression flag in the directory..."
 chattr +c $SCRATCH_MNT/testdir
 echo "Directory compression property value:"
-$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir compression | \
+	_filter_btrfs_compress_property
 
 touch $SCRATCH_MNT/testdir/file1
 echo "file1 compression property value:"
-$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression | \
+	_filter_btrfs_compress_property
 
 echo "Clearing compression flag from directory..."
 chattr -c $SCRATCH_MNT/testdir
 echo "Directory compression property value:"
-$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir compression | \
+	_filter_btrfs_compress_property
 
 touch $SCRATCH_MNT/testdir/file2
 echo "file2 compression property value:"
-$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file2 compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file2 compression | \
+	_filter_btrfs_compress_property
 
 touch $SCRATCH_MNT/testdir/file1
 echo "file1 compression property value:"
-$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression
+$BTRFS_UTIL_PROG property get $SCRATCH_MNT/testdir/file1 compression | \
+	_filter_btrfs_compress_property
 
 status=0
 exit
diff --git a/tests/btrfs/059.out b/tests/btrfs/059.out
index 9ec9a53..4e7539a 100644
--- a/tests/btrfs/059.out
+++ b/tests/btrfs/059.out
@@ -1,11 +1,11 @@
 QA output created by 059
 Setting compression flag in the directory...
 Directory compression property value:
-compression=zlib
+COMPRESSION=XXX
 file1 compression property value:
-compression=zlib
+COMPRESSION=XXX
 Clearing compression flag from directory...
 Directory compression property value:
 file2 compression property value:
 file1 compression property value:
-compression=zlib
+COMPRESSION=XXX
-- 
1.8.3.1



