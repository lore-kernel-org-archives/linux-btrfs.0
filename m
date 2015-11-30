Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:56167 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbbK3KR0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:17:26 -0500
Received: from localhost
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 15:47:24 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH V2 1/5] Filter xfs_io and od's output in units of FS block size
Date: Mon, 30 Nov 2015 15:46:56 +0530
Message-Id: <1448878620-16382-2-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448878620-16382-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878620-16382-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helpers introduced in this commit will be used to make btrfs tests that
assume 4k as the block size to work on non-4k blocksized filesystem instances
as well.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 common/filter | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/common/filter b/common/filter
index af456c9..05f2fab 100644
--- a/common/filter
+++ b/common/filter
@@ -229,6 +229,38 @@ _filter_xfs_io_unique()
     common_line_filter | _filter_xfs_io
 }
 
+_filter_xfs_io_units_modified()
+{
+	UNIT=$1
+	UNIT_SIZE=$2
+
+	$AWK_PROG -v unit="$UNIT" -v unit_size=$UNIT_SIZE '
+		/wrote/ {
+			split($2, bytes, "/")
+
+			bytes_written = strtonum(bytes[1])
+
+			offset = strtonum($NF)
+
+			unit_start = offset / unit_size
+			unit_start = int(unit_start)
+			unit_end = (offset + bytes_written - 1) / unit_size
+			unit_end = int(unit_end)
+
+			printf("%ss modified: [%d - %d]\n", unit, unit_start, unit_end)
+
+			next
+		}
+	'
+}
+
+_filter_xfs_io_blocks_modified()
+{
+	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+
+	_filter_xfs_io_units_modified "Block" $BLOCK_SIZE
+}
+
 _filter_test_dir()
 {
 	sed -e "s,$TEST_DEV,TEST_DEV,g" -e "s,$TEST_DIR,TEST_DIR,g"
@@ -323,5 +355,18 @@ _filter_ro_mount() {
 	    -e "s/mount: cannot mount block device/mount: cannot mount/g"
 }
 
+_filter_od()
+{
+	BLOCK_SIZE=$(get_block_size $SCRATCH_MNT)
+	$AWK_PROG -v block_size=$BLOCK_SIZE '
+		/^[0-9]+/ {
+			offset = strtonum("0"$1);
+			$1 = sprintf("%o", offset / block_size);
+			print $0;
+		}
+		/\*/
+	'
+}
+
 # make sure this script returns success
 /bin/true
-- 
2.1.0

