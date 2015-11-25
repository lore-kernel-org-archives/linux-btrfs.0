Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49763 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbbKYLEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 06:04:39 -0500
Received: from localhost
	by e23smtp01.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 25 Nov 2015 21:04:37 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 01/12] Filter xfs_io and od's output in units of FS block size and the CPU's page size
Date: Wed, 25 Nov 2015 16:32:55 +0530
Message-Id: <1448449386-4186-2-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448449386-4186-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helpers will be used to make btrfs tests that assume 4k as the block size
to work on non-4k blocksized filesystem instances as well.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 common/filter | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc     |  5 +++++
 2 files changed, 57 insertions(+)

diff --git a/common/filter b/common/filter
index af456c9..faa6f82 100644
--- a/common/filter
+++ b/common/filter
@@ -229,6 +229,45 @@ _filter_xfs_io_unique()
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
+_filter_xfs_io_pages_modified()
+{
+	PAGE_SIZE=$(get_page_size)
+
+	_filter_xfs_io_units_modified "Page" $PAGE_SIZE
+}
+
 _filter_test_dir()
 {
 	sed -e "s,$TEST_DEV,TEST_DEV,g" -e "s,$TEST_DIR,TEST_DIR,g"
@@ -323,5 +362,18 @@ _filter_ro_mount() {
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
diff --git a/common/rc b/common/rc
index 4c2f42c..acda6cb 100644
--- a/common/rc
+++ b/common/rc
@@ -3151,6 +3151,11 @@ get_block_size()
 	echo `stat -f -c %S $1`
 }
 
+get_page_size()
+{
+	echo $(getconf PAGE_SIZE)
+}
+
 init_rc
 
 ################################################################################
-- 
2.1.0

