Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbcF0UOR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 16:14:17 -0400
From: jeffm@suse.com
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 3/4] btrfs/125: test sysfs exports of allocation and device membership info
Date: Mon, 27 Jun 2016 16:14:13 -0400
Message-Id: <1467058454-25907-4-git-send-email-jeffm@suse.com>
In-Reply-To: <1467058454-25907-1-git-send-email-jeffm@suse.com>
References: <1467058454-25907-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This tests the sysfs publishing for btrfs allocation and device
membership info under a number of different layouts, similar to the
btrfs replace test. We test the allocation files only for existence and
that they contain numerical values. We test the device membership
by mapping the devices used to create the file system to sysfs paths
and matching them against the paths used for the device membership
symlinks.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 common/btrfs        |   7 +++
 common/config       |   7 ++-
 tests/btrfs/125     | 177 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/125.out |   1 +
 tests/btrfs/group   |   1 +
 5 files changed, 190 insertions(+), 3 deletions(-)
 create mode 100755 tests/btrfs/125
 create mode 100644 tests/btrfs/125.out

diff --git a/common/btrfs b/common/btrfs
index b972b13..5828d0a 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -41,3 +41,10 @@ _require_btrfs_ioctl()
 		_notrun "btrfs ioctl $ioctl not implemented."
 	fi
 }
+
+# Requires the minimum size pool for largest btrfs RAID test
+_require_btrfs_raid_dev_pool()
+{
+	_require_scratch_dev_pool 4 # RAID10
+	_require_scratch_dev_pool_equal_size
+}
diff --git a/common/config b/common/config
index c25b1ec..8577924 100644
--- a/common/config
+++ b/common/config
@@ -201,13 +201,14 @@ export DEBUGFS_PROG="`set_prog_path debugfs`"
 # newer systems have udevadm command but older systems like RHEL5 don't.
 # But if neither one is available, just set it to "sleep 1" to wait for lv to
 # be settled
-UDEV_SETTLE_PROG="`set_prog_path udevadm`"
-if [ "$UDEV_SETTLE_PROG" == "" ]; then
+UDEVADM_PROG="`set_prog_path udevadm`"
+if [ "$UDEVADM_PROG" == "" ]; then
 	# try udevsettle command
 	UDEV_SETTLE_PROG="`set_prog_path udevsettle`"
 else
 	# udevadm is available, add 'settle' as subcommand
-	UDEV_SETTLE_PROG="$UDEV_SETTLE_PROG settle"
+	UDEV_SETTLE_PROG="$UDEVADM_PROG settle"
+	export UDEVADM_PROG
 fi
 # neither command is available, use sleep 1
 if [ "$UDEV_SETTLE_PROG" == "" ]; then
diff --git a/tests/btrfs/125 b/tests/btrfs/125
new file mode 100755
index 0000000..999a10e
--- /dev/null
+++ b/tests/btrfs/125
@@ -0,0 +1,177 @@
+#! /bin/bash
+# FS QA Test No. 125
+#
+# Test of the btrfs sysfs publishing
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2016 SUSE.  All rights reserved.
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
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1
+
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/btrfs
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_command "$UDEVADM_PROG" udevadm
+_require_test
+_require_btrfs_sysfs
+_require_btrfs_raid_dev_pool
+
+sysfs_root=$(_btrfs_get_sysfs $TEST_DIR)
+
+[ -d "$sysfs_root/allocation" ] || _notrun "sysfs allocation dir not found"
+[ -d "$sysfs_root/devices" ] || _notrun "sysfs devices dir not found"
+
+check_file()
+{
+	local file=$1
+	base="$(basename $(dirname $file))/$(basename $file)"
+	value="$(cat $file)"
+	if [ -n "$(echo $value | tr -d 0-9)" ]; then
+		echo "ERROR: $base: numerical value expected" \
+		     "(got $value)"
+	fi
+}
+
+check_chunk()
+{
+	path=$1
+	mkfs_options=$2
+
+	chunktype=$(basename $path)
+	[ -d "$path" ] || echo "No $chunktype directory."
+
+	for file in bytes_may_use bytes_pinned bytes_reserved bytes_used \
+		    disk_total disk_used flags total_bytes \
+		    total_bytes_pinned; do
+		check_file "$path/$file"
+	done
+
+	if [ "$chunktype" = "data" -o "$chunktype" = "mixed" ]; then
+		opt="-d"
+	elif [ "$chunktype" = "metadata" -o "$chunktype" = "system" ]; then
+		opt="-m"
+	fi
+
+	profile=$(echo $mkfs_options | sed -e "s/.*$opt \([[:alnum:]]*\).*/\1/")
+	[ -d "$path/$profile" ] || echo "No $profile dir for $chunktype"
+
+	for file in total_bytes used_bytes; do
+		check_file $path/$profile/$file
+	done
+}
+
+check_dev_link()
+{
+	local dev=$1
+	DEV="/sys/$($UDEVADM_PROG info --query=path $dev)"
+	DEV="$(readlink -f $DEV)"
+	found=false
+	for link in $sysfs_base/devices/*; do
+		LINK="$(readlink -f $link)"
+		if [ "$LINK" = "$DEV" ]; then
+			found=true
+			break
+		fi
+	done
+	if ! $found; then
+		echo "Symlink for $dev missing in $sysfs_base/devices"
+	fi
+	return 0
+}
+
+workout()
+{
+	local mkfs_options="$1"
+	local num_devs4raid="$2"
+	local fssize
+	local used_devs=""
+
+	if [ "$num_devs4raid" -gt 1 ]; then
+		used_devs=$(echo $SCRATCH_DEV_POOL|tr '\t' ' '| \
+			    cut -d ' ' -f 2-$num_devs4raid)
+	fi
+
+	# We check the error code since mkfs can fail if the devices
+	# are specified incorrectly but we may still have a file system
+	# from a prior run.
+	_scratch_mkfs $mkfs_options $used_devs 2>> $seqres.full || \
+		_fail "mkfs failed"
+
+	_scratch_mount
+
+	# Check allocation
+	sysfs_base="$(_btrfs_get_sysfs $SCRATCH_MNT)"
+
+	mixed=false
+	case "$mkfs_options" in
+	*-M*)
+		mixed=true;
+		;;
+	esac
+
+	check_chunk "$sysfs_base/allocation/system" "$mkfs_options"
+	if $mixed; then
+		check_chunk "$sysfs_base/allocation/mixed" "$mkfs_options"
+	else
+		check_chunk "$sysfs_base/allocation/data" "$mkfs_options"
+		check_chunk "$sysfs_base/allocation/metadata" "$mkfs_options"
+	fi
+
+	for dev in $used_devs; do
+		check_dev_link $dev
+	done
+
+	_scratch_unmount
+}
+
+workout "-m single -d single" 1
+workout "-m single -d single -M" 1
+workout "-m dup -d single" 1
+workout "-m dup -d dup -M" 1
+workout "-m raid0 -d raid0" 2
+workout "-m raid1 -d raid1" 2
+workout "-m raid5 -d raid5" 2
+workout "-m raid6 -d raid6" 3
+workout "-m raid10 -d raid10" 4
+
+status=0
+exit
diff --git a/tests/btrfs/125.out b/tests/btrfs/125.out
new file mode 100644
index 0000000..4f22ab0
--- /dev/null
+++ b/tests/btrfs/125.out
@@ -0,0 +1 @@
+QA output created by 125
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 8b5050e..3535f02 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -127,3 +127,4 @@
 122 auto quick snapshot qgroup
 123 auto quick qgroup
 124 auto quick metadata
+125 auto quick metadata
-- 
1.8.5.6

