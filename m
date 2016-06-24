Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbcFXPIh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 11:08:37 -0400
From: jeffm@suse.com
To: fstests@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 3/4] fstests: btrfs/125: test sysfs exports of allocation and device membership info
Date: Fri, 24 Jun 2016 11:08:33 -0400
Message-Id: <1466780914-23884-3-git-send-email-jeffm@suse.com>
In-Reply-To: <1466780914-23884-1-git-send-email-jeffm@suse.com>
References: <1466780914-23884-1-git-send-email-jeffm@suse.com>
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

It passes on kernels without a /sys/fs/btrfs/<fsid> directory.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 common/config       |   4 +-
 common/rc           |   7 ++
 tests/btrfs/125     | 193 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/125.out |   2 +
 tests/btrfs/group   |   1 +
 5 files changed, 205 insertions(+), 2 deletions(-)
 create mode 100755 tests/btrfs/125
 create mode 100644 tests/btrfs/125.out

diff --git a/common/config b/common/config
index c25b1ec..c5e65f7 100644
--- a/common/config
+++ b/common/config
@@ -201,13 +201,13 @@ export DEBUGFS_PROG="`set_prog_path debugfs`"
 # newer systems have udevadm command but older systems like RHEL5 don't.
 # But if neither one is available, just set it to "sleep 1" to wait for lv to
 # be settled
-UDEV_SETTLE_PROG="`set_prog_path udevadm`"
+UDEVADM_PROG="`set_prog_path udevadm`"
 if [ "$UDEV_SETTLE_PROG" == "" ]; then
 	# try udevsettle command
 	UDEV_SETTLE_PROG="`set_prog_path udevsettle`"
 else
 	# udevadm is available, add 'settle' as subcommand
-	UDEV_SETTLE_PROG="$UDEV_SETTLE_PROG settle"
+	UDEV_SETTLE_PROG="$UDEVADM_PROG settle"
 fi
 # neither command is available, use sleep 1
 if [ "$UDEV_SETTLE_PROG" == "" ]; then
diff --git a/common/rc b/common/rc
index 4b05fcf..f4c4312 100644
--- a/common/rc
+++ b/common/rc
@@ -76,6 +76,13 @@ _btrfs_get_subvolid()
 	$BTRFS_UTIL_PROG sub list $mnt | grep $name | awk '{ print $2 }'
 }
 
+_btrfs_get_feature_flags()
+{
+	local dev=$1
+	local class=$2
+	$BTRFS_SHOW_SUPER_PROG $dev | grep ^${class}_flags | awk '{print $NF}'
+}
+
 _btrfs_get_fsid()
 {
 	local dev=$1
diff --git a/tests/btrfs/125 b/tests/btrfs/125
new file mode 100755
index 0000000..83f1921
--- /dev/null
+++ b/tests/btrfs/125
@@ -0,0 +1,193 @@
+#! /bin/bash
+# FS QA Test No. 125
+#
+# Test of the btrfs sysfs publishing
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2013-2016 SUSE.  All rights reserved.
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
+echo "== QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_require_scratch
+_require_scratch_dev_pool
+_require_command "$UDEVADM_PROG"
+
+rm -f $seqres.full
+rm -f $tmp.tmp
+
+check_file() {
+	local file=$1
+	base="$(echo "$file" | sed -e 's#/sys/fs/btrfs/[0-9a-f-][0-9a-f-]*/##')"
+	if [ ! -f "$file" ]; then
+		echo "$base missing."
+		return 0
+	else
+		value="$(cat $file)"
+		if [ -n "$(echo $value | tr -d 0-9)" ]; then
+			echo "ERROR: $base: numerical value expected" \
+			     "(got $value)"
+			return 0
+		fi
+	fi
+	return 1
+}
+
+check_chunk() {
+	path=$1
+	mkfs_options=$2
+	error=false
+
+	chunktype=$(basename $path)
+	if [ ! -d "$path" ]; then
+		echo "No $chunktype directory."
+		exit 1
+	fi
+
+	for file in bytes_may_use bytes_pinned bytes_reserved bytes_used \
+		    disk_total disk_used flags total_bytes \
+		    total_bytes_pinned; do
+		if check_file "$path/$file"; then
+			error=true
+		fi
+	done
+
+	if [ "$chunktype" = "data" -o "$chunktype" = "mixed" ]; then
+		opt="-d"
+	elif [ "$chunktype" = "metadata" -o "$chunktype" = "system" ]; then
+		opt="-m"
+	fi
+
+	profile=$(echo $mkfs_options | sed -e "s/.*$opt \([[:alnum:]]*\).*/\1/")
+	if [ ! -d "$path/$profile" ]; then
+		echo "No $profile dir for $chunktype"
+		exit 1
+	fi
+
+	for file in total_bytes used_bytes; do
+		if check_file $path/$profile/$file; then
+			error=true
+		fi
+	done
+
+	$error && exit 1
+}
+
+check_dev_link() {
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
+		return 1
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
+	if [ "`echo $SCRATCH_DEV_POOL | wc -w`" -lt $num_devs4raid ]; then
+		echo "Skip workout $1 $2 $3 $4"
+		echo "Too few devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL," \
+		     "required: $num_devs4raid"
+		echo "Skip workout $1 $2 $3 $4" >> $seqres.full
+		echo "Too few devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL," \
+		     "required: $num_devs4raid" >> $seqres.full
+		return 0
+	fi
+
+	if [ "$num_devs4raid" -gt 1 ]; then
+		used_devs=$(echo $SCRATCH_DEV_POOL|tr '\t' ' '| \
+			    cut -d ' ' -f 2-$num_devs4raid)
+	fi
+
+	_scratch_mkfs $mkfs_options $used_devs >> $seqres.full 2>&1 || \
+	_fail "mkfs failed"
+
+	_scratch_mount
+
+	# Check allocation
+	sysfs_base="/sys/fs/btrfs/$(_btrfs_get_fsid $SCRATCH_DEV)"
+
+	# Feature isn't present for testing
+	if [ ! -d "$sysfs_base" ]; then
+		echo "Skipping sysfs test: $sysfs_base not found." \
+		     >> $seqres.full
+		return
+	fi
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
+		check_dev_link $dev || exit 1
+	done
+
+	umount $SCRATCH_MNT > /dev/null 2>&1
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
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/125.out b/tests/btrfs/125.out
new file mode 100644
index 0000000..91f76e8
--- /dev/null
+++ b/tests/btrfs/125.out
@@ -0,0 +1,2 @@
+== QA output created by 125
+Silence is golden
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

