Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656Ab3CMQBH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 12:01:07 -0400
Message-ID: <5140A2BC.7010800@redhat.com>
Date: Wed, 13 Mar 2013 11:01:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH] xfstests: enable test 032 (mkfs overwrite) for btrfs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now that btrfs has an "-f" arg, we can test that it doesn't
improperly overwrite other filesystems in 032 like we do 
for xfs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/032 b/032
index bf88492..89fb225 100755
--- a/032
+++ b/032
@@ -38,12 +38,18 @@ rm -f $seq.full
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs xfs btrfs
 _supported_os Linux
 
 _require_nobigloopfs
 _require_scratch
 
+# mkfs.btrfs did not have overwrite detection at first
+if [ "$FSTYP" == "btrfs" ]; then
+	grep -q 'force overwrite' `echo $MKFS_BTRFS_PROG | awk '{print $1}'` || \
+		_notrun "Installed mkfs.btrfs does not support -f option"
+fi
+
 echo "Silence is golden."
 for fs in `echo ${MKFS_PROG}.* | sed -e 's/.sbin.mkfs.//g'`
 do
@@ -61,7 +67,7 @@ do
 	[ $fs = gfs2 ] && preop="echo y |" && preargs="-p lock_nolock -j 1"
 	[ $fs = reiserfs ] && preop="echo y |" && preargs="-f"
 	# cramfs mkfs requires a directory argument
-	[ $fs = cramfs ] && preargs=/proc/fs/xfs
+	[ $fs = cramfs ] && preargs=/proc/fs
 	[ $fs = ext2 ] && preargs="-F"
 	[ $fs = ext3 ] && preargs="-F"
 	[ $fs = ext4 ] && preargs="-F"
@@ -77,8 +83,8 @@ do
 
 	if [ $? -eq 0 ] ; then
 		# next, ensure we don't overwrite it
-		echo "=== Attempting XFS overwrite of $fs..." >>$seq.full
-		${MKFS_PROG}.xfs $SCRATCH_DEV >>$seq.full 2>&1
+		echo "=== Attempting $FSTYP overwrite of $fs..." >>$seq.full
+		${MKFS_PROG}.$FSTYP $SCRATCH_DEV >>$seq.full 2>&1
 
 		[ $? -eq 0 ] && echo "Failed - overwrote fs type ${fs}!"
 	else


