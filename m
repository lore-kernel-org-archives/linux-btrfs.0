Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85590C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 52D982075C
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 10:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfBVKEc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 05:04:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:42498 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725894AbfBVKEc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 05:04:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2C180AC66;
        Fri, 22 Feb 2019 10:04:30 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, guaneryu@gmail.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v3] shared/298: Wire btrfs support in get_free_sectors
Date:   Fri, 22 Feb 2019 12:04:25 +0200
Message-Id: <20190222100425.22433-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Add support for btrfs in shared/298. Achieve this by introducing 2
new awk scripts that parse relevant btrfs structures and print holes.
Additionally modify the test to create larger - 3gb filesystem in the
case of btrfs. This is needed so that distinct block groups are used
for data and metadata.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

Changes since v2: 

 * Moved files to src/ dir
 * Rename spb parameter in both scripts to sectorsize
 * Added comments for function
 * Added spaces after every # of a comment
 * Removed btrfs_Free variable from shared/298, now the awk scripts directly
 print their output

 src/parse-dev-tree.awk    |  64 +++++++++++++++++++++
 src/parse-extent-tree.awk | 144 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/298          |  33 ++++++++++-
 3 files changed, 238 insertions(+), 3 deletions(-)
 create mode 100755 src/parse-dev-tree.awk
 create mode 100755 src/parse-extent-tree.awk

diff --git a/src/parse-dev-tree.awk b/src/parse-dev-tree.awk
new file mode 100755
index 000000000000..9c98402cf66b
--- /dev/null
+++ b/src/parse-dev-tree.awk
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Nikolay Borisov, SUSE LLC.  All Rights Reserved.
+#
+# Parses btrfs' device tree for holes. For example given the followin device extents:
+#	item 3 key (1 DEV_EXTENT 38797312) itemoff 16091 itemsize 48
+#		dev extent chunk_tree 3
+#		chunk_objectid 256 chunk_offset 30408704 length 1073741824
+#		chunk_tree_uuid b8c8f022-452b-4fc1-bf5c-b42d9fba613e
+#	item 4 key (1 DEV_EXTENT 1112539136) itemoff 16043 itemsize 48
+#		dev extent chunk_tree 3
+#		chunk_objectid 256 chunk_offset 30408704 length 1073741824
+#		chunk_tree_uuid b8c8f022-452b-4fc1-bf5c-b42d9fba613e
+#
+# The scripts will find out if there is a hole between 38797312+1073741824 and
+# the start offset of the next extent, in this case 1112539136 so no hole. But
+# if there was it would have printed the size of the hole.
+#
+# Following paramters must be set:
+#    * sectorsize - how many bytes per sector, used to convert script's output
+#    to sectors.
+#    * devsize - size of the device in bytes, used to output the final
+#    hole (if any)
+
+# Given a 'chunk_objectid 256 chunk_offset 22020096 length 8388608' line this
+# function returns 8388608
+function get_extent_size(line,  tmp) {
+	split(line, tmp)
+	return tmp[6]
+}
+
+# Given a '	item 3 key (1 DEV_EXTENT 38797312) itemoff 16091 itemsize 48' line
+# this function returns 38797312
+function get_extent_offset(line,  tmp) {
+	split(line, tmp)
+	gsub(/\)/,"", tmp[6])
+	return tmp[6]
+}
+
+BEGIN {
+	dev_extent_match="^.item [0-9]* key \\([0-9]* DEV_EXTENT [0-9]*\\).*"
+	dev_extent_len_match="^\\s*chunk_objectid [0-9]* chunk_offset [0-9]* length [0-9]*$"
+}
+
+{
+	if (match($0,dev_extent_match)) {
+		extent_offset = get_extent_offset($0)
+		if (prev_extent_end) {
+			hole_size = extent_offset - prev_extent_end
+			if (hole_size > 0) {
+				print prev_extent_end / sectorsize, int((extent_offset - 1) / sectorsize)
+			}
+		}
+	} else if (match($0, dev_extent_len_match)) {
+		extent_size = get_extent_size($0)
+		prev_extent_end = extent_offset + extent_size
+	}
+}
+
+END {
+	if (prev_extent_end) {
+		print prev_extent_end / sectorsize, int((devsize - 1) / sectorsize)
+	}
+}
+
diff --git a/src/parse-extent-tree.awk b/src/parse-extent-tree.awk
new file mode 100755
index 000000000000..09fed61e5b71
--- /dev/null
+++ b/src/parse-extent-tree.awk
@@ -0,0 +1,144 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2019 Nikolay Borisov, SUSE LLC.  All Rights Reserved.
+#
+# Parses btrfs' extent tree for holes. Holes are the ranges between 2 adjacent
+# extent blocks. For example if we have the following 2 metadata items in the
+# extent tree:
+#	item 6 key (30425088 METADATA_ITEM 0) itemoff 16019 itemsize 33
+#	item 7 key (30490624 METADATA_ITEM 0) itemoff 15986 itemsize 33
+#
+# There is a whole of 64k between then - 30490624−30425088 = 65536
+# Same logic applies for adjacent EXTENT_ITEMS.
+#
+# The script requires the following parameters passed on command line:
+#     * sectorsize - how many bytes per sector, used to convert the output of
+#     the script to sectors.
+#     * nodesize - size of metadata extents, used for internal calculations
+
+# Given an extent line "item 2 key (13672448 EXTENT_ITEM 65536) itemoff 16153 itemsize 53"
+# or "item 6 key (30425088 METADATA_ITEM 0) itemoff 16019 itemsize 33" returns
+# either 65536 (for data extents) or the fixes nodesize value for metadata
+# extents.
+function get_extent_size(line,  tmp) {
+	if (line ~ data_match || line ~ bg_match) {
+		split(line, tmp)
+		gsub(/\)/,"", tmp[6])
+		return tmp[6]
+	} else if (line ~ metadata_match) {
+		return nodesize
+	}
+}
+
+# given a 'item 2 key (13672448 EXTENT_ITEM 65536) itemoff 16153 itemsize 53' or
+# returns 13672448.
+function get_extent_offset(line,  tmp) {
+	split(line, tmp)
+	gsub(/\(/,"",tmp[4])
+	return tmp[4]
+}
+
+# This function parse all the extents belonging to a particular block group
+# which are accumulated in lines[] and calculates the offsets of the holes
+# part of this block group.
+#
+# base_offset and bg_line are local variables
+function print_array(         base_offset, bg_line)
+{
+	if (match(lines[0], bg_match)) {
+		# we don't have an extent at the beginning of of blockgroup, so we
+		# have a hole between blockgroup offset and first extent offset
+		bg_line = lines[0]
+		prev_size=0
+		prev_offset=get_extent_offset(bg_line)
+		delete lines[0]
+	} else {
+		# we have an extent at the beginning of block group, so initialize
+		# the prev_* vars correctly
+		bg_line = lines[1]
+		prev_size = get_extent_size(lines[0])
+		prev_offset = get_extent_offset(lines[0])
+		delete lines[1]
+		delete lines[0]
+	}
+
+	bg_offset=get_extent_offset(bg_line)
+	bgend=bg_offset + get_extent_size(bg_line)
+
+	for (i in lines) {
+			cur_size = get_extent_size(lines[i])
+			cur_offset = get_extent_offset(lines[i])
+			if (cur_offset  != prev_offset + prev_size)
+				print int((prev_size + prev_offset) / sectorsize), int((cur_offset-1) / sectorsize)
+			prev_size = cur_size
+			prev_offset = cur_offset
+	}
+
+	print int((prev_size + prev_offset) / sectorsize), int((bgend-1) / sectorsize)
+	total_printed++
+	delete lines
+}
+
+BEGIN {
+	loi_match="^.item [0-9]* key \\([0-9]* (BLOCK_GROUP_ITEM|METADATA_ITEM|EXTENT_ITEM) [0-9]*\\).*"
+	metadata_match="^.item [0-9]* key \\([0-9]* METADATA_ITEM [0-9]*\\).*"
+	data_match="^.item [0-9]* key \\([0-9]* EXTENT_ITEM [0-9]*\\).*"
+	bg_match="^.item [0-9]* key \\([0-9]* BLOCK_GROUP_ITEM [0-9]*\\).*"
+	node_match="^node.*$"
+	leaf_match="^leaf [0-9]* flags"
+	line_count=0
+	total_printed=0
+	skip_lines=0
+}
+
+{
+	# skip lines not belonging to a leaf
+	if (match($0,node_match)) {
+		skip_lines=1
+	} else if (match($0, leaf_match)) {
+		skip_lines=0
+	}
+
+	if (!match($0,loi_match) || skip_lines == 1) next;
+
+	# we have a line of interest, we need to parse it. First check if there is
+	# anything in the array
+	if (line_count==0) {
+		lines[line_count++]=$0;
+	} else {
+		prev_line=lines[line_count-1]
+		split(prev_line, prev_line_fields)
+		prev_objectid=prev_line_fields[4]
+		objectid=$4
+
+		if (objectid == prev_objectid && match($0, bg_match)) {
+			if (total_printed>0) {
+				# We are adding a BG after we have added its first extent
+				# previously, consider this a record ending event and just print
+				# the array
+
+				delete lines[line_count-1]
+				print_array()
+				# we now start a new array with current and previous lines
+				line_count=0
+				lines[line_count++]=prev_line
+				lines[line_count++]=$0
+			} else {
+				# first 2 added lines are EXTENT and BG that match, in this case
+				# just add them
+				lines[line_count++]=$0
+
+			}
+		} else if (match($0, bg_match)) {
+			# ordinary end of record
+			print_array()
+			line_count=0
+			lines[line_count++]=$0
+		} else {
+			lines[line_count++]=$0
+		}
+	}
+}
+
+END {
+	print_array()
+}
diff --git a/tests/shared/298 b/tests/shared/298
index e7b7b233de45..aafdc25f5575 100755
--- a/tests/shared/298
+++ b/tests/shared/298
@@ -15,14 +15,24 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 . ./common/rc
 
-_supported_fs ext4 xfs
+_supported_fs ext4 xfs btrfs
 _supported_os Linux
 _require_test
 _require_loop
 _require_fstrim
 _require_xfs_io_command "fiemap"
-_require_fs_space $TEST_DIR 307200
+if [ "$FSTYP" = "btrfs" ]; then
+	# 3g for btrfs to have distinct bgs
+	_require_fs_space $TEST_DIR 3145728
+	fssize=3000
+else
+	_require_fs_space $TEST_DIR 307200
+	fssize=300
+fi
+
 [ "$FSTYP" = "ext4" ] && _require_dumpe2fs
+[ "$FSTYP" = "btrfs" ] && _require_btrfs_command inspect-internal dump-super
+[ "$FSTYP" = "btrfs" ] && _require_btrfs_command inspect-internal dump-tree
 
 _cleanup()
 {
@@ -61,6 +71,22 @@ get_free_sectors()
 		 $AWK_PROG -v spb=$sectors_per_block -v agsize=$agsize \
 		'{ print spb * ($1 * agsize + $2), spb * ($1 * agsize + $2 + $3) - 1 }'
 	;;
+	btrfs)
+		local device_size=$($BTRFS_UTIL_PROG filesystem show --raw $loop_mnt 2>&1 \
+			| sed -n "s/^.*size \([0-9]*\).*$/\1/p")
+
+		local nodesize=$($BTRFS_UTIL_PROG inspect-internal dump-super $img_file  \
+			| sed -n 's/nodesize\s*\(.*\)/\1/p')
+
+		# Get holes within block groups
+		$BTRFS_UTIL_PROG inspect-internal dump-tree -t extent $img_file \
+			| $AWK_PROG -v sectorsize=512 -v nodesize=$nodesize -f $here/src/parse-extent-tree.awk
+
+		# Get holes within unallocated space on disk
+		$BTRFS_UTIL_PROG inspect-internal dump-tree -t dev $img_file \
+			| $AWK_PROG -v sectorsize=512 -v devsize=$device_size -f $here/src/parse-dev-tree.awk
+
+	;;
 	esac
 }
 
@@ -105,7 +131,7 @@ here=`pwd`
 tmp=`mktemp -d`
 
 img_file=$TEST_DIR/$$.fs
-dd if=/dev/zero of=$img_file bs=1M count=300 &> /dev/null
+dd if=/dev/zero of=$img_file bs=1M count=$fssize &> /dev/null
 
 loop_dev=$(_create_loop_device $img_file)
 loop_mnt=$tmp/loop_mnt
@@ -118,6 +144,7 @@ merged_sectors="$tmp/merged_free_sectors"
 mkdir $loop_mnt
 
 [ "$FSTYP" = "xfs" ] && MKFS_OPTIONS="-f $MKFS_OPTIONS"
+[ "$FSTYP" = "btrfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -f -dsingle -msingle"
 
 _mkfs_dev $loop_dev
 _mount $loop_dev $loop_mnt
-- 
2.7.4

