Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbbC3TLL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 15:11:11 -0400
Message-ID: <55199FCA.9040503@suse.com>
Date: Mon, 30 Mar 2015 15:11:06 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>, fstests@vger.kernel.org
Subject: [PATCH] xfstests: generic: test for discard properly discarding unused
 extents
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This tests tests four conditions where discard can potentially not
discard unused extents completely.

We test, with -o discard and with fstrim, scenarios of removing many
relatively small files and removing several large files.

The important part of the two scenarios is that the large files must be
large enough to span a blockgroup alone. It's possible for an
entire block group to be emptied and dropped without an opportunity to
discard individual extents as would happen with smaller files.

The test confirms the discards have occured by using a sparse file
mounted via loopback to punch holes and then check how many blocks
are still allocated within the file.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 tests/generic/326     | 164 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/326.out |   5 ++
 tests/generic/group   |   1 +
 3 files changed, 170 insertions(+)
 create mode 100644 tests/generic/326
 create mode 100644 tests/generic/326.out

diff --git a/tests/generic/326 b/tests/generic/326
new file mode 100644
index 0000000..923a27f
--- /dev/null
+++ b/tests/generic/326
@@ -0,0 +1,164 @@
+#! /bin/bash
+# FSQA Test No. 326
+#
+# This test uses a loopback mount with PUNCH_HOLE support to test
+# whether discard operations are working as expected.
+#
+# It tests both -odiscard and fstrim.
+#
+# Copyright (C) 2015 SUSE. All Rights Reserved.
+# Author: Jeff Mahoney <jeffm@suse.com>
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+loopdev=
+tmpdir=
+_cleanup()
+{
+	[ -n "$tmpdir" ] && umount $tmpdir
+	[ -n "$loopdev" ] && losetup -d $loopdev
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_fstrim
+
+rm -f $seqres.full
+
+_scratch_mkfs &>> $seqres.full
+_require_fs_space $SCRATCH_MNT $(( 10 * 1024 * 1024 ))
+_scratch_mount
+
+test_discard()
+{
+	discard=$1
+	files=$2
+
+	tmpfile=$SCRATCH_MNT/testfs.img.$$
+	tmpdir=$SCRATCH_MNT/testdir.$$
+	mkdir -p $tmpdir || _fail "!!! failed to create temp mount dir"
+
+	# Create a sparse file to host the file system
+	dd if=/dev/zero of=$tmpfile bs=1M count=1 seek=10240 &> $seqres.full \
+		|| _fail "!!! failed to create fs image file"
+
+	opts=""
+	if [ "$discard" = "discard" ]; then
+		opts="-o discard"
+	fi
+	losetup -f $tmpfile
+	loopdev=$(losetup -j $tmpfile|awk -F: '{print $1}')
+	_mkfs_dev $loopdev &> $seqres.full
+	$MOUNT_PROG $opts $loopdev $tmpdir \
+		|| _fail "!!! failed to loopback mount"
+
+	if [ "$files" = "large" ]; then
+		# Create files larger than 1GB so each one occupies
+		# more than one block group
+		for n in $(seq 1 8); do
+			dd if=/dev/zero of=$tmpdir/file$n bs=1M count=1200 \
+				&> $seqres.full
+		done
+	else
+		# Create up to 40k files sized 32k-1GB.
+		mkdir -p $tmpdir/testdir
+		for ((i = 1; i <= 40000; i++)); do
+			SIZE=$(( $((1024*1024*1024)) / $(( $RANDOM + 1 )) ))
+			$XFS_IO_PROG -f -c "pwrite -S 0xaa 0 $SIZE" \
+				$tmpdir/testdir/"${prefix}_$i" &> /dev/null
+			if [ $? -ne 0 ]; then
+				echo "Failed creating file ${prefix}_$i" \
+					>>$seqres.full
+				break
+			fi
+		done
+	fi
+
+	sync
+	OSIZE="$(du -k $tmpfile|awk '{print $1}')"
+	du -k $tmpfile >> $seqres.full
+
+	if [ "$files" = "large" ]; then
+		rm $tmpdir/file?
+	else
+		rm -rf $tmpdir/testdir
+	fi
+
+	# Ensure everything's actually on the hosted file system
+	if [ "$FSTYP" = "btrfs" ]; then
+		_run_btrfs_util_prog filesystem sync $tmpdir
+	fi
+	sync
+	sync
+	if [ "$discard" = "trim" ]; then
+		$FSTRIM_PROG $tmpdir
+	fi
+
+	$UMOUNT_PROG $tmpdir
+	rmdir $tmpdir
+	tmpdir=
+
+	# Sync the backing file system to ensure the hole punches have
+	# happened and we can trust the result.
+	if [ "$FSTYP" = "btrfs" ]; then
+		_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
+	fi
+	sync
+	sync
+
+	NSIZE="$(du -k $tmpfile|awk '{print $1}')"
+	du -k $tmpfile >> $seqres.full
+
+	# Going from ~ 10GB to 50MB is a good enough test to account for
+	# metadata remaining on different file systems.
+	if [ "$NSIZE" -gt $(( 50 * 1024 )) ]; then
+		_fail "TRIM failed: before rm ${OSIZE}kB, after rm ${NSIZE}kB"
+	fi
+	rm $tmpfile
+	losetup -d $loopdev
+	loopdev=
+}
+
+
+echo "Testing with -odiscard, many small files"
+test_discard discard many
+
+echo "Testing with -odiscard, several large files"
+test_discard discard large
+
+echo "Testing with fstrim, many small files"
+test_discard trim many
+
+echo "Testing with fstrim, several large files"
+test_discard trim large
+
+status=0
+exit
diff --git a/tests/generic/326.out b/tests/generic/326.out
new file mode 100644
index 0000000..37b0f2c
--- /dev/null
+++ b/tests/generic/326.out
@@ -0,0 +1,5 @@
+QA output created by 084
+Testing with -odiscard, many small files
+Testing with -odiscard, several large files
+Testing with fstrim, many small files
+Testing with fstrim, several large files
diff --git a/tests/generic/group b/tests/generic/group
index d56d3ce..75e17fa 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -183,3 +183,4 @@
 323 auto aio stress
 324 auto fsr quick
 325 auto quick data log
+326 auto metadata
-- 
1.8.5.6


-- 
Jeff Mahoney
SUSE Labs
