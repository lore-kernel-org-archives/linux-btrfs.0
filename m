From: Miao Xie <miaox@cn.fujitsu.com>
Subject: [PATCH] xfstests: open btrfsck to check the btrfs filesystem
Date: Wed, 14 Dec 2011 15:35:20 +0800
Message-ID: <4EE851B8.8010505@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

We failed to get fsck program to check the btrfs file system, it is
because btrfs uses its independent check tool which is named btrfsck
to check the file system, so the common checker -- fsck -- could not
find it, and reported there is no checker.

This patch fix it by using btrfsck directly. 

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 common.rc |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index cab0b64..b42e46d 100644
--- a/common.rc
+++ b/common.rc
@@ -1299,6 +1299,54 @@ _check_xfs_test_fs()
     fi
 }
 
+_check_btrfs_filesystem()
+{
+    device=$1
+
+    # If type is set, we're mounted
+    type=`_fs_type $device`
+    ok=1
+
+    if [ "$type" = "$FSTYP" ]
+    then
+        # mounted ...
+        mountpoint=`_umount_or_remount_ro $device`
+    fi
+
+    btrfsck $device >$tmp.fsck 2>&1
+    if [ $? -ne 0 ]
+    then
+        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent (see $seq.full)"
+
+        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
+        echo "*** fsck.$FSTYP output ***"                     >>$here/$seq.full
+        cat $tmp.fsck                                         >>$here/$seq.full
+        echo "*** end fsck.$FSTYP output"                     >>$here/$seq.full
+
+        ok=0
+    fi
+    rm -f $tmp.fsck
+
+    if [ $ok -eq 0 ]
+    then
+        echo "*** mount output ***"                             >>$here/$seq.full
+        _mount                                                  >>$here/$seq.full
+        echo "*** end mount output"                             >>$here/$seq.full
+    elif [ "$type" = "$FSTYP" ]
+    then
+	# was mounted ...
+	_mount_or_remount_rw "$MOUNT_OPTIONS" $device $mountpoint
+	ok=$?
+    fi
+
+    if [ $ok -eq 0 ]; then
+	status=1
+	exit 1
+    fi
+
+    return 0
+}
+
 _check_test_fs()
 {
     case $FSTYP in
@@ -1311,6 +1359,9 @@ _check_test_fs()
     udf)
 	# do nothing for now
 	;;
+    btrfs)
+	_check_btrfs_filesystem $TEST_DEV
+	;;
     *)
 	_check_generic_filesystem $TEST_DEV
 	;;
@@ -1337,6 +1388,9 @@ _check_scratch_fs()
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
+    btrfs)
+	_check_btrfs_filesystem $SCRATCH_DEV
+	;;
     *)
 	_check_generic_filesystem $SCRATCH_DEV
 	;;
-- 
1.7.6.4
