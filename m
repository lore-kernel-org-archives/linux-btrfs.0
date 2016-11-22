Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:63936 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755546AbcKVIia (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 03:38:30 -0500
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [RFC PATCH 2/3] fstests: common/ondisk.btrfs: Introduce function to get btrfs ondisk info
Date: Tue, 22 Nov 2016 16:38:10 +0800
Message-Id: <20161122083811.12636-3-quwenruo@cn.fujitsu.com>
In-Reply-To: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
References: <20161122083811.12636-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Introduce a new common header, ondisk.btrfs, to allow we manipulate
btrfs on-disk data directly, to corrupt or verify data.

Since the designed tool, btrfs-corrupt-block is no longer default
installed, and furthermore it doesn't support to corrupt given mirror or
stripe, it's near useless for later scrub verification test cases.

Not to mention its parameter is not updated and there is no man page for
it.

So here what we can do is, either wait for years for a reliable
corrupter and see btrfs scrub never get verified for its basic function.
Or use existing tools like btrfs-debug-tree
(btrfs inspect-internal dump-tree) and bash to build a basic tool.

I choose the later one, which is not perfect, only support one data
chunk, hard to maintain(why we are using bash?!), but is good enough for
RAID1/DUP testing.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 common/ondisk.btrfs | 113 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)
 create mode 100644 common/ondisk.btrfs

diff --git a/common/ondisk.btrfs b/common/ondisk.btrfs
new file mode 100644
index 0000000..df87a08
--- /dev/null
+++ b/common/ondisk.btrfs
@@ -0,0 +1,113 @@
+#!/bin/bash
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Fujitsu.  All Rights Reserved.
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
+# Helper functions to manipulate btrfs ondisk data, for scrub verification
+
+# Get the logical bytenr of the first block group matches the @profile
+# @1: device contains the btrfs, mandatory 
+# @2: type, must be one of "DATA", "SYSTEM" or "METADATA", ignore case, mandatory
+# @3: profile, must be one of the support profile, ignore case, optional,
+#     default to any profile
+# Output "logical length" into stdout for usage.
+# If failed, nothing is outputted, so caller should check the output
+_btrfs_get_first_bg_by_type()
+{
+	local dev=$1
+	local chunk_type=$(echo $2 | awk '{print toupper($0)}')
+	local profile=$(echo $3 | awk '{print toupper($0)}')
+
+	_require_btrfs_subcommand inspect-internal
+
+	echo "_btrfs_get_first_bg_by_type: dev=$dev type=$chunk_type profile=$profile" \
+		>> $seqres.full
+
+	if [ -z "$dev" -o -z "$chunk_type" ]; then
+		_fail "Missing device or chunk type argument for _btrfs_get_first_bg_by_type"
+	fi
+
+	if [ ! -z $profile ]; then
+		if [ $profile == "SINGLE" ]; then
+			full_profile="$chunk_type"
+		else
+			full_profile="$chunk_type|$profile"
+		fi
+	else
+		full_profile="$chunk_type"
+	fi
+
+	logical=$($BTRFS_UTIL_PROG inspect-internal dump-tree $dev -t chunk |\
+		grep "type $full_profile" -m1 -B2 |\
+		grep "CHUNK_ITEM [[:digit:]]*" -o | awk '{print $2}')
+	length=$($BTRFS_UTIL_PROG inspect-internal dump-tree $dev -t chunk |\
+		grep "type $full_profile" -m1 -B2 |\
+		egrep "chunk length [[:digit:]]*" -o | awk '{print $3}')
+	if [ -z "$logical" -o -z "$length" ]; then
+		return;
+	fi
+	echo "found bg logical=$logical length=$length" >> $seqres.full
+	echo "$logical $length"
+}
+
+# Get the stripe map for chunk specified by @logical parameter
+# @1: device contains the btrfs, mandatory
+# @2: logical bytenr of the chunk, mandatory
+# @3: stripe number, optional, default to 0(first stripe)
+# Output "devid dev_offset" into stdout for usage
+# If failed, nothing is outputed, so caller should check the output
+_btrfs_get_chunk_stripe()
+{
+	local dev=$1
+	local logical=$2
+	local stripenr=$3
+
+	_require_btrfs_subcommand inspect-internal
+
+	echo "_btrfs_get_chunk_stripe: dev=$dev logical=$logical stripenr=$stripenr" \
+		>> $seqres.full
+	if [ -z "$dev" -o -z "$logical" ]; then
+		_fail "Missing device or logical argument for _btrfs_get_chunk_stripe"
+	fi
+
+	if [ -z $stripenr ]; then
+		stripenr=0
+	fi
+
+	stripes=$($BTRFS_UTIL_PROG inspect-internal dump-tree $dev -t chunk |\
+		grep "CHUNK_ITEM $logical" -A 2 |\
+		grep -o "num_stripes [[:digit:]]*" |\
+		awk '{print $2}')
+	if [ -z $stripes ]; then
+		return
+	fi
+
+	# For CHUNK_ITEM it takes 3 lines(Hit line includes), follows with
+	# stripe info, each stripe takes 2 lines
+	nr_lines=$((2 + 2 * $stripes))
+	devid=$($BTRFS_UTIL_PROG inspect-internal dump-tree $dev -t chunk |\
+		grep "CHUNK_ITEM $logical" -A $nr_lines |\
+		grep "stripe $stripenr" | awk '{print $4}')
+	dev_offset=$($BTRFS_UTIL_PROG inspect-internal dump-tree $dev -t chunk |\
+		grep "CHUNK_ITEM $logical" -A $nr_lines |\
+		grep "stripe $stripenr" | awk '{print $6}')
+	if [ -z "$devid" -o -z "$dev_offset" ]; then
+		return;
+	fi
+	echo "found stripe=$stripenr devid=$devid dev_offset=$dev_offset" \
+		>> $seqres.full
+	echo "$devid $dev_offset"
+}
-- 
2.7.4



