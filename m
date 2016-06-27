Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbcF0UOR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 16:14:17 -0400
From: jeffm@suse.com
To: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 4/4] btrfs/126,127,128: test feature ioctl and sysfs interfaces
Date: Mon, 27 Jun 2016 16:14:14 -0400
Message-Id: <1467058454-25907-5-git-send-email-jeffm@suse.com>
In-Reply-To: <1467058454-25907-1-git-send-email-jeffm@suse.com>
References: <1467058454-25907-1-git-send-email-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Mahoney <jeffm@suse.com>

This tests the exporting of feature information from the kernel via
sysfs and ioctl. The first test works whether the sysfs permissions
are correct, if the information exported via sysfs matches
what the ioctls are reporting, and if they both match the on-disk
superblock's version of the feature sets. The second and third tests
test online setting and clearing of feature bits via the sysfs and
ioctl interfaces, checking whether they match the on-disk super on
each cycle.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 common/btrfs             | 203 +++++++++++++++++++++++++++++++++++++++
 src/btrfs_ioctl_helper.c |  88 +++++++++++++++++
 tests/btrfs/126          | 244 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/126.out      |   1 +
 tests/btrfs/127          | 166 ++++++++++++++++++++++++++++++++
 tests/btrfs/127.out      |   1 +
 tests/btrfs/128          | 128 +++++++++++++++++++++++++
 tests/btrfs/128.out      |   1 +
 tests/btrfs/group        |   3 +
 9 files changed, 835 insertions(+)
 create mode 100755 tests/btrfs/126
 create mode 100644 tests/btrfs/126.out
 create mode 100755 tests/btrfs/127
 create mode 100644 tests/btrfs/127.out
 create mode 100755 tests/btrfs/128
 create mode 100644 tests/btrfs/128.out

diff --git a/common/btrfs b/common/btrfs
index 5828d0a..2d7d0ce 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -48,3 +48,206 @@ _require_btrfs_raid_dev_pool()
 	_require_scratch_dev_pool 4 # RAID10
 	_require_scratch_dev_pool_equal_size
 }
+
+# TODO Add tool to enable and test unknown feature bits
+_btrfs_feature_lookup() {
+	local name=$1
+	class=""
+	case "$name" in
+	mixed_backref)	class=incompat; bit=0x1 ;;
+	default_subvol)	class=incompat; bit=0x2 ;;
+	mixed_groups)	class=incompat; bit=0x4 ;;
+	compress_lzo)	class=incompat; bit=0x8 ;;
+	compress_lsov2)	class=incompat; bit=0x10 ;;
+	big_metadata)	class=incompat; bit=0x20 ;;
+	extended_iref)	class=incompat; bit=0x40 ;;
+	raid56)		class=incompat; bit=0x80 ;;
+	skinny_metadata)class=incompat; bit=0x100 ;;
+	compat:*)	class=compat; bit=${name##compat:} ;;
+	compat_ro:*)	class=compat_ro; bit=${name##compat_ro:} ;;
+	incompat:*)	class=incompat; bit=${name##incompat:} ;;
+	esac
+	if [ -z "$class" ]; then
+		echo "Unknown feature name $name. xfstests needs updating." \
+		     " Skipping the test of sysfs values to superblock values" \
+		     >&2
+	fi
+
+	echo "$class/$bit"
+}
+
+_btrfs_feature_get_class() {
+	bits=$(_btrfs_feature_lookup $1)
+	echo ${bits%/*}
+}
+
+_btrfs_feature_get_bit() {
+	bits=$(_btrfs_feature_lookup $1)
+	echo ${bits#*/}
+}
+
+_btrfs_feature_class_to_index()
+{
+	local class=$1
+	local index=0
+
+	case "$class" in
+	compat) index=0 ;;
+	compat_ro) index=1 ;;
+	incompat) index=2 ;;
+	*) echo "Invalid class name $class" >&2
+	esac
+
+	echo $index
+}
+
+# The ioctl helper outputs the supported feature flags as a series of
+# 9 hex numbers, which represent bitfields.
+# These 9 values represent 3 sets of 3 values.
+# supported flags: compat compat_ro incompat, starting at index 0
+# settable online: compat compat_ro incompat, starting at index 3
+# clearable online: compat compat_ro incompat, starting at index 6
+# The returned mask is: 0x1 settable | 0x2 clearable
+_btrfs_feature_ioctl_writeable_mask()
+{
+	local feature=$1
+	local mnt=$2
+	local index=0
+
+	# This usually won't matter.  The supported bits are fs-module global.
+	if [ -z "$mnt" ]; then
+		mnt=$TEST_DIR
+	fi
+
+	class=$(_btrfs_feature_get_class $1)
+	bit=$(_btrfs_feature_get_bit $1)
+	index=$(_btrfs_feature_class_to_index $class)
+
+	local set_index=$(( $index + 3 ))
+	local clear_index=$(( $index + 6 ))
+
+	out=$(src/btrfs_ioctl_helper $mnt GET_SUPPORTED_FEATURES)
+	set -- $out
+	supp_features=($@)
+
+	settable=$(( ${supp_features[$set_index]} & $bit ))
+	clearable=$(( ${supp_features[$clear_index]} & $bit ))
+
+	val=0
+	if [ "$settable" -ne 0 ]; then
+		val=$(( $val | 1 ))
+	fi
+	if [ "$clearable" -ne 0 ]; then
+		val=$(( $val | 2 ))
+	fi
+
+	echo $val
+}
+
+_btrfs_feature_ioctl_index_settable_mask()
+{
+	local class_index=$1
+	local mnt=$2
+
+	# This usually won't matter.  The supported bits are fs-module global.
+	if [ -z "$mnt" ]; then
+		mnt=$TEST_DIR
+	fi
+
+	local set_index=$(( $class_index + 3 ))
+
+	out=$(src/btrfs_ioctl_helper $mnt GET_SUPPORTED_FEATURES)
+	set -- $out
+	supp_features=($@)
+
+	echo $(( ${supp_features[$set_index]} ))
+}
+
+_btrfs_feature_ioctl_index_clearable_mask()
+{
+	local class_index=$1
+	local mnt=$2
+	local index=0
+
+	# This usually won't matter.  The supported bits are fs-module global.
+	if [ -z "$mnt" ]; then
+		mnt=$TEST_DIR
+	fi
+
+	local set_index=$(( $class_index + 6 ))
+
+	out=$(src/btrfs_ioctl_helper $mnt GET_SUPPORTED_FEATURES)
+	set -- $out
+	supp_features=($@)
+
+	echo $(( ${supp_features[$clear_index]} ))
+}
+
+_btrfs_feature_ioctl_is_writeable()
+{
+	local feature=$1
+	local mnt=$2
+	local mask=$(_btrfs_feature_ioctl_writeable_mask $feature $2)
+
+	test "$mask" -ne 0
+	return $?
+}
+
+_btrfs_feature_ioctl_is_settable()
+{
+	local feature=$1
+	local mnt=$2
+	local mask=$(_btrfs_feature_ioctl_writeable_mask $feature $2)
+
+	if [ "$(( $mask & 1 ))" -ne 0 ]; then
+		echo "true"
+	else
+		echo "false"
+	fi
+}
+
+_btrfs_feature_ioctl_is_settable()
+{
+	local feature=$1
+	local mnt=$2
+	local mask=$(_btrfs_feature_ioctl_writeable_mask $feature $2)
+
+	if [ "$(( $mask & 2 ))" -ne 0 ]; then
+		echo "true"
+	else
+		echo "false"
+	fi
+}
+
+_btrfs_feature_sysfs_is_settable()
+{
+	local feature=$1
+
+	val=$(cat /sys/fs/btrfs/features/$feature)
+
+	if [ "$(( $val & 2 ))" -eq 2 ]; then
+		echo "true"
+	else
+		echo "false"
+	fi
+}
+
+_btrfs_feature_sysfs_is_clearable()
+{
+	local feature=$1
+
+	val=$(cat /sys/fs/btrfs/features/$feature)
+
+	if [ "$(( $val & 2 ))" -eq 2 ]; then
+		echo "true"
+	else
+		echo "false"
+	fi
+}
+
+_btrfs_feature_disk_get_flags()
+{
+	local dev=$1
+	local class=$2
+	$BTRFS_SHOW_SUPER_PROG $dev | grep ^${class}_flags | awk '{print $NF}'
+}
diff --git a/src/btrfs_ioctl_helper.c b/src/btrfs_ioctl_helper.c
index b6eb924..4344bdc 100644
--- a/src/btrfs_ioctl_helper.c
+++ b/src/btrfs_ioctl_helper.c
@@ -30,6 +30,21 @@ struct btrfs_ioctl_space_args {
 #define BTRFS_SPACE_INFO_GLOBAL_RSV    (1ULL << 49)
 #endif
 
+#ifndef BTRFS_IOC_GET_FEATURES
+struct btrfs_ioctl_feature_flags {
+	uint64_t compat_flags;
+	uint64_t compat_ro_flags;
+	uint64_t incompat_flags;
+};
+
+#define BTRFS_IOC_GET_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
+                                   struct btrfs_ioctl_feature_flags)
+#define BTRFS_IOC_SET_FEATURES _IOW(BTRFS_IOCTL_MAGIC, 57, \
+                                   struct btrfs_ioctl_feature_flags[2])
+#define BTRFS_IOC_GET_SUPPORTED_FEATURES _IOR(BTRFS_IOCTL_MAGIC, 57, \
+                                   struct btrfs_ioctl_feature_flags[3])
+#endif
+
 static int global_rsv_ioctl(int fd, int argc, char *argv[])
 {
 	struct btrfs_ioctl_space_args arg;
@@ -67,6 +82,76 @@ static int global_rsv_ioctl(int fd, int argc, char *argv[])
 	return -ENOENT;
 }
 
+static int get_features_ioctl(int fd, int argc, char *argv[])
+{
+	struct btrfs_ioctl_feature_flags flags;
+	int ret = ioctl(fd, BTRFS_IOC_GET_FEATURES, &flags);
+	if (ret)
+		return -errno;
+
+	printf("0x%llx 0x%llx 0x%llx\n",
+	       (unsigned long long)flags.compat_flags,
+	       (unsigned long long)flags.compat_ro_flags,
+	       (unsigned long long)flags.incompat_flags);
+	return 0;
+}
+
+static int set_features_ioctl(int fd, int argc, char *argv[])
+{
+	struct btrfs_ioctl_feature_flags flags[2];
+	uint64_t bit, *bits, *mask;
+	if (argc != 3)
+		goto usage;
+
+	memset(flags, 0, sizeof(flags));
+
+	errno = 0;
+	bit = strtoull(argv[2], NULL, 10);
+	if (errno)
+		goto usage;
+
+	if (strcmp(argv[1], "compat") == 0) {
+		mask = &flags[0].compat_flags;
+		bits = &flags[1].compat_flags;
+	} else if (strcmp(argv[1], "compat_ro") == 0) {
+		mask = &flags[0].compat_ro_flags;
+		bits = &flags[1].compat_ro_flags;
+	} else if (strcmp(argv[1], "incompat") == 0) {
+		mask = &flags[0].incompat_flags;
+		bits = &flags[1].incompat_flags;
+	} else
+		goto usage;
+
+	*mask |= bit;
+
+	if (strcmp(argv[0], "set") == 0)
+		*bits |= bit;
+
+	return ioctl(fd, BTRFS_IOC_SET_FEATURES, &flags);
+usage:
+	fprintf(stderr, "usage: SET_FEATURES <set|clear> <compat|compat_ro|incompat> <base-10 bitmask>\n");
+	return -EINVAL;
+}
+
+static int get_supported_features_ioctl(int fd, int argc, char *argv[])
+{
+	struct btrfs_ioctl_feature_flags flags[3];
+	int ret;
+	int i;
+
+	ret = ioctl(fd, BTRFS_IOC_GET_SUPPORTED_FEATURES, &flags);
+	if (ret)
+		return -errno;
+
+	for (i = 0; i < 3; i++)
+		printf("0x%llx 0x%llx 0x%llx ",
+		       (unsigned long long)flags[i].compat_flags,
+		       (unsigned long long)flags[i].compat_ro_flags,
+		       (unsigned long long)flags[i].incompat_flags);
+
+	printf("\n");
+	return 0;
+}
 #define IOCTL_TABLE_ENTRY(_ioctl_name, _handler) \
 	{ .name = #_ioctl_name, .ioctl_cmd = BTRFS_IOC_##_ioctl_name, \
 	  .handler = _handler, }
@@ -79,6 +164,9 @@ struct ioctl_table_entry {
 
 static struct ioctl_table_entry ioctls[] = {
 	IOCTL_TABLE_ENTRY(SPACE_INFO, global_rsv_ioctl),
+	IOCTL_TABLE_ENTRY(GET_FEATURES, get_features_ioctl),
+	IOCTL_TABLE_ENTRY(SET_FEATURES, set_features_ioctl),
+	IOCTL_TABLE_ENTRY(GET_SUPPORTED_FEATURES, get_supported_features_ioctl),
 };
 
 int
diff --git a/tests/btrfs/126 b/tests/btrfs/126
new file mode 100755
index 0000000..71307a3
--- /dev/null
+++ b/tests/btrfs/126
@@ -0,0 +1,244 @@
+#!/bin/bash
+# FA QA Test No. 126
+#
+# Test online feature publishing
+#
+# This test doesn't test the changing of features. It does test that
+# the proper publishing bits and permissions match up with
+# the expected values.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 SUSE, All Rights Reserved.
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
+
+seq=$(basename $0)
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=$(pwd)
+tmp=/tmp/$$
+status=1
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+        cd /
+        rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/btrfs
+. ./common/filter.btrfs
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_command "$BTRFS_SHOW_SUPER_PROG" btrfs-show-super
+_require_test_program btrfs_ioctl_helper
+_require_test
+_require_btrfs_ioctl GET_FEATURES $TEST_DIR
+_require_btrfs_ioctl GET_SUPPORTED_FEATURES $TEST_DIR
+_require_btrfs_sysfs
+
+IOCTL="src/btrfs_ioctl_helper"
+
+sysfs_root="/sys/fs/btrfs"
+[ -d "$sysfs_root/features" ] || _notrun "sysfs features dir not found"
+[ -d "$(_btrfs_get_sysfs)/features" ] || _notrun "sysfs per-fs features dir not found"
+
+_scratch_mkfs 2>> $seqres.full
+_scratch_mount
+sysfs_fsroot=$(_btrfs_get_sysfs $SCRATCH_MNT)
+
+
+# test -w will always return true if root is making the call.
+# This would be true in most cases, but for sysfs files, the permissions
+# are enforced even for root.
+is_writeable()
+{
+	local file=$1
+	mode=$(stat -c "0%a" "$file")
+	mode=$(( $mode & 0200 ))
+
+	[ "$mode" -eq 0 ] && return 1
+	return 0
+}
+
+# Check enabled features in sysfs vs what the superblock claims
+sysfs_features=(0 0 0)
+
+for file in $sysfs_fsroot/features/*; do
+	feature=$(basename $file)
+	supported=$(cat $sysfs_root/features/$feature)
+
+	case "$supported" in
+	0|1|2|3) ;;
+	*)
+		echo "Invalid value $supported in features/$feature"
+		continue
+	esac
+
+	if [ ! -e "$sysfs_root/features/$feature" ]; then
+		echo "fsid/features/$feature exists but features/$feature does not."
+		continue
+	fi
+
+	val=$(cat $file)
+
+	if [ -n "$(echo -n $supported| tr -d 0-9)" ]; then
+		echo "features/$feature has invalid contents $supported"
+		continue
+	fi
+	if [ -n "$(echo -n $val| tr -d 0-9)" ]; then
+		echo "fsid/features/$feature has invalid contents $val"
+		continue
+	fi
+	val=$(( $val ))
+
+	if [ "$supported" -eq 0 ]; then
+		if is_writeable "$file"; then
+			echo "fsid/features/$feature is writable but features/$feature has a 0 value."
+		fi
+
+		if _btrfs_feature_ioctl_is_writeable $feature; then
+			echo "fsid/features/$feature is not writeable but ioctl says it is"
+		fi
+	else
+		if ! is_writeable "$file"; then
+			echo "fsid/features/$feature is not writable but features/$feature has a nonzero value $val."
+		fi
+
+		if ! _btrfs_feature_ioctl_is_writeable $feature; then
+			echo "fsid/features/$feature is writeable but ioctl says it isn't"
+		fi
+	fi
+
+	bit=$(_btrfs_feature_get_bit $feature)
+	class=$(_btrfs_feature_get_class $feature)
+	if [ "$class" = "compat" ]; then
+		sysfs_features[0]=$(( ${sysfs_features[0]} | $bit ))
+	elif [ "$class" = "compat_ro" ]; then
+		sysfs_features[1]=$(( ${sysfs_features[1]} | $bit ))
+	elif [ "$class" = "incompat" ]; then
+		sysfs_features[2]=$(( ${sysfs_features[2]} | $bit ))
+	fi
+done
+
+for file in $sysfs_root/features/*; do
+	feature=$(basename $file)
+	val=$(cat $file)
+	if [ "$val" -gt 0 ]; then
+		if [ ! -e "$sysfs_fsroot/features/$feature" ]; then
+			echo "features/$feature has a nonzero value ($val)" \
+			     "but fsid/features/$feature doesn't exist"
+		fi
+		if ! is_writeable "$sysfs_fsroot/features/$feature"; then
+			echo "features/$feature has a nonzero value ($val)" \
+			     "but fsid/features/$feature is not writable"
+		fi
+		if ! _btrfs_feature_ioctl_is_writeable $feature; then
+			echo "features/$feature has a nonzero value ($val) " \
+			     "but ioctl says it is not writeable."
+		fi
+
+		ioctl_settable=$(_btrfs_feature_ioctl_is_settable $feature)
+		sysfs_settable=$(_btrfs_feature_sysfs_is_settable $feature)
+
+		if $sysfs_settable && ! $ioctl_settable; then
+			echo "features/$feature exports settable " \
+			      "but ioctl does not"
+		fi
+		if ! $sysfs_settable && $ioctl_settable; then
+			echo "features/$feature does not export settable " \
+			      "but ioctl does"
+		fi
+
+		ioctl_clearable=$(_btrfs_feature_ioctl_is_settable $feature)
+		sysfs_clearable=$(_btrfs_feature_sysfs_is_settable $feature)
+
+		if $sysfs_clearable && ! $ioctl_clearable; then
+			echo "features/$feature exports clearable " \
+			      "but ioctl does not"
+		fi
+		if ! $sysfs_clearable && $ioctl_clearable; then
+			echo "features/$feature does not export clearable " \
+			      "but ioctl does"
+		fi
+		continue
+	fi
+
+	# This is ok; The file system supports this feature but the mounted
+	# file system doesn't enable it.
+	[ -e "$sysfs_fsroot/features/$feature" ] || continue
+
+	if is_writeable "$sysfs_fsroot/features/$feature"; then
+		echo "features/$feature has a zero value but" \
+		     "fsid/features/$feature is writable."
+	fi
+
+	if _btrfs_feature_ioctl_is_writeable $feature; then
+		echo "$feature isn't writable but ioctl says it is"
+	fi
+done
+
+fields=("compat" "compat_ro" "incompat")
+
+check_ioctl_flags()
+{
+	local class=$1
+	local flags=$(( $2 ))
+	local disk_flags=$(( $3 ))
+
+	if [ "$flags" -ne "$disk_flags" ]; then
+		echo "ioctl returned different $class flags" \
+		     "($flags) than those contained in superblock" \
+		     "($disk_flags)"
+	fi
+}
+
+check_sysfs_flags()
+{
+	local class=$1
+	local sysfs_flags=$(( $2 ))
+	local disk_flags=$(( $3 ))
+
+	if [ "$sysfs_flags" -ne "$disk_flags" ]; then
+		echo "sysfs returned different $class" \
+		     "flags ($flags) than those contained in" \
+		     "superblock ($disk_flags)" >&2
+	fi
+}
+
+# ioctl
+out=$($IOCTL $SCRATCH_MNT GET_FEATURES)
+set -- $out
+ioctl_features=($@)
+
+for index in $(seq 0 2); do
+	class=${fields[$index]}
+	disk_flags=$(_btrfs_feature_disk_get_flags $SCRATCH_DEV $class)
+	check_ioctl_flags "$class" "${ioctl_features[$index]}" "$disk_flags"
+	check_sysfs_flags "$class" "${sysfs_features[$index]}" "$disk_flags"
+done
+
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/btrfs/126.out b/tests/btrfs/126.out
new file mode 100644
index 0000000..f162d8b
--- /dev/null
+++ b/tests/btrfs/126.out
@@ -0,0 +1 @@
+QA output created by 126
diff --git a/tests/btrfs/127 b/tests/btrfs/127
new file mode 100755
index 0000000..191beff
--- /dev/null
+++ b/tests/btrfs/127
@@ -0,0 +1,166 @@
+#!/bin/bash
+# FA QA Test No. 127
+#
+# Test online feature changing via ioctl
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 SUSE, All Rights Reserved.
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
+
+seq=$(basename $0)
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=$(pwd)
+tmp=/tmp/$$
+status=1
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+        cd /
+        rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/btrfs
+. ./common/filter.btrfs
+
+rm -f $seqres.full
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_command "$BTRFS_SHOW_SUPER_PROG" btrfs-show-super
+_require_test_program btrfs_ioctl_helper
+
+IOCTL=src/btrfs_ioctl_helper
+
+# 3 values, one for each each of the fields
+update_features()
+{
+	local ioctl_values=$($IOCTL $SCRATCH_MNT GET_FEATURES)
+	set -- $ioctl_values
+	features=($@)
+}
+
+test_set_feature()
+{
+	local field=$1
+	local bits=$2
+	local class=${fields[$field]}
+	local old=${features[$field]}
+	msg=$($IOCTL $SCRATCH_MNT SET_FEATURES set $class $bits)
+	update_features
+	local new=${features[$field]}
+
+	expected=$(( $old | $bits ))
+	new=$(( $new ))
+	if [ "$expected" -ne "$new" ]; then
+		echo "Feature setting failed; Got $new, expected $expected"
+		return 1
+	fi
+}
+
+test_clear_feature()
+{
+	local field=$1
+	local bits=$2
+	local class=${fields[$field]}
+	local old=${features[$field]}
+	msg=$($IOCTL $SCRATCH_MNT SET_FEATURES clear $class $bits)
+	update_features
+	local new="${features[$field]}"
+
+	expected=$(( $old & ~$bits ))
+	new=$(( $new ))
+	if [ "$expected" -ne "$new" ]; then
+		echo "Feature clearing failed; Got $new, expected $expected"
+	fi
+	return 0
+}
+
+fields=("compat" "compat_ro" "incompat")
+
+check_flags()
+{
+	local index=$1
+	local expected=$(( $2 ))
+	local class=${fields[$index]}
+
+	local disk_flags=$(_btrfs_feature_disk_get_flags $SCRATCH_DEV $class)
+
+	disk_flags=$(( $disk_flags ))
+
+	if [ "$disk_flags" -ne "$expected" ]; then
+		echo "mismatch: $disk_flags != $expected"
+	fi
+}
+
+_scratch_mkfs 2>> $seqres.full
+_scratch_mount
+
+update_features
+
+
+# Cycle through settable features.
+# Set the feature
+# Reload ioctl version and test against expected new value
+# Unmount and test against expected new value
+# Remount
+did_set=false
+
+for field in $(seq 0 2); do
+	fset="$(_btrfs_feature_ioctl_index_settable_mask $field)"
+	[ -z "$fset" ] && break
+	for n in $(seq 0 63); do
+		old="${features[$field]}"
+		v="$(( $fset & (1 << $n) ))"
+		[ "$v" -eq 0 ] && continue
+		test_set_feature $field $v
+		_scratch_unmount
+		expected="$(( $old | $v ))"
+		check_flags "$field" "$expected"
+		_scratch_mount
+		did_set=true
+	done
+done
+$did_set || echo "No online-settable features to test." >> $seqres.full
+
+# Repeat with clearing features
+id_clear=false
+for field in $(seq 0 2); do
+	fclear="$(_btrfs_feature_ioctl_index_clearable_mask $field)"
+	[ -z "$fclear" ] && break
+	for n in $(seq 0 63); do
+		v="$(( $fclear & (1 << $n) ))"
+		[ "$v" -eq 0 ] && continue
+
+		test_clear_feature $field $v
+		_scratch_unmount
+		expected=$(( $old &~ $v ))
+		check_flags $field $expected
+		_scratch_mount
+		did_clear=true
+	done
+done
+$did_clear || echo "No online-clearable features to test." >> $seqres.full
+
+_scratch_unmount
+
+status=0
+exit
diff --git a/tests/btrfs/127.out b/tests/btrfs/127.out
new file mode 100644
index 0000000..09d2be1
--- /dev/null
+++ b/tests/btrfs/127.out
@@ -0,0 +1 @@
+QA output created by 127
diff --git a/tests/btrfs/128 b/tests/btrfs/128
new file mode 100755
index 0000000..46160d9
--- /dev/null
+++ b/tests/btrfs/128
@@ -0,0 +1,128 @@
+#!/bin/bash
+# FA QA Test No. 128
+#
+# Test online feature changing via sysfs
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 SUSE, All Rights Reserved.
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
+
+seq=$(basename $0)
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=$(pwd)
+tmp=/tmp/$$
+status=1
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+        cd /
+        rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/btrfs
+. ./common/filter.btrfs
+
+rm -f $seqres.full
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_command $BTRFS_SHOW_SUPER_PROG
+_require_test
+_require_btrfs_sysfs
+
+sysfs_root="/sys/fs/btrfs"
+[ -d "$sysfs_root/features" ] || _notrun "sysfs features dir not found"
+sysfs_fsroot=$(_btrfs_get_sysfs)
+[ -d "$sysfs_fsroot/features" ] || _notrun "sysfs per-fs features dir not found"
+
+check_flags() {
+	local class=$1
+	local expected=$(( $2 ))
+	disk_flags="$(_btrfs_feature_disk_get_flags $SCRATCH_DEV $class)"
+	disk_flags=$(( $disk_flags ))
+	if [ "$disk_flags" != "$expected" ]; then
+		echo "mismatch: $disk_flags-$expected"
+	fi
+}
+
+_scratch_mkfs 2>> $seqres.full
+fields=("compat" "compat_ro" "incompat")
+sysfs_base="/sys/fs/btrfs"
+settable=""
+clearable=""
+
+# Gather up the features the kernel knows about
+_scratch_mount
+
+sysfs_fsroot=$(_btrfs_get_sysfs $SCRATCH_MNT)
+
+for file in $sysfs_base/features/*; do
+	feature=$(basename $file)
+	val=$(cat $file)
+	if [ "$(( $val & 0x1 ))" -eq 1 ]; then
+		settable="$settable $feature"
+	fi
+	if [ "$(( $val & 0x2 ))" -eq 2 ]; then
+		clearable="$clearable $feature"
+	fi
+done
+_scratch_unmount
+
+did_set=false
+for feature in $settable; do
+	class=$(_btrfs_feature_get_class $feature)
+	bit=$(_btrfs_feature_get_bit $feature)
+	flags=$(_btrfs_feature_disk_get_flags $SCRATCH_DEV $class)
+	flags=$(( $flags ))
+	_scratch_mount
+	val=$(cat $sysfs_fsroot/features/$feature)
+	echo 1 > $sysfs_fsroot/features/$feature
+	newval=$(cat $sysfs_fsroot/features/$feature)
+	[ "$newval" -ne 1 ] && echo "Setting feature $feature failed"
+	_scratch_unmount
+	check_flags $class $(( $flags | $bit ))
+	did_set=true
+done
+$did_set || echo "No online-settable features to test." >> $seqres.full
+
+did_clear=false
+for feature in $clearable; do
+	class=$(_btrfs_feature_get_class $feature)
+	bit=$(_btrfs_feature_get_bit $feature)
+	flags=$(_btrfs_feature_disk_get_flags $SCRATCH_DEV $class)
+	flags=$(( $flags ))
+
+	_scratch_mount
+	val=$(cat $sysfs_fsroot/features/$feature)
+	[ "$val" -ne 1 ] && continue
+	echo 0 > $sysfs_fsroot/features/$feature
+	newval=$(cat $sysfs_fsroot/features/$feature)
+	[ "$newval" -ne 0 ] && echo "Clearing feature $feature was ignored."
+	_scratch_unmount
+	check_flags $class $(( $flags & ~$bit ))
+	did_clear=true
+done
+$did_clear || echo "No online-clearable features to test." >> $seqres.full
+
+# Still unmounted from set/clear tests
+status=0
+exit
diff --git a/tests/btrfs/128.out b/tests/btrfs/128.out
new file mode 100644
index 0000000..34f24a3
--- /dev/null
+++ b/tests/btrfs/128.out
@@ -0,0 +1 @@
+QA output created by 128
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 3535f02..e76265d 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -128,3 +128,6 @@
 123 auto quick qgroup
 124 auto quick metadata
 125 auto quick metadata
+126 auto quick metadata
+127 auto quick metadata
+128 auto quick metadata
-- 
1.8.5.6

