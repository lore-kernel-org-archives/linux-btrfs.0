Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43527 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbbK3KRs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:17:48 -0500
Received: from localhost
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 30 Nov 2015 15:47:47 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        fdmanana@gmail.com, chandan@mykolab.com
Subject: [PATCH 1/8] Filter xfs_io's output in units of page size
Date: Mon, 30 Nov 2015 15:47:17 +0530
Message-Id: <1448878644-16503-2-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1448878644-16503-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The helpers introduced in this commit will be used to make btrfs tests that
assume 4k as the page size to work on non-4k page-sized systems as well.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 common/filter | 8 ++++++++
 common/rc     | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/common/filter b/common/filter
index 05f2fab..1be377c 100644
--- a/common/filter
+++ b/common/filter
@@ -261,6 +261,14 @@ _filter_xfs_io_blocks_modified()
 	_filter_xfs_io_units_modified "Block" $BLOCK_SIZE
 }
 
+_filter_xfs_io_pages_modified()
+{
+	PAGE_SIZE=$(get_page_size)
+
+	_filter_xfs_io_units_modified "Page" $PAGE_SIZE
+}
+
+
 _filter_test_dir()
 {
 	sed -e "s,$TEST_DEV,TEST_DEV,g" -e "s,$TEST_DIR,TEST_DIR,g"
diff --git a/common/rc b/common/rc
index 4c2f42c..82c1bbb 100644
--- a/common/rc
+++ b/common/rc
@@ -3151,6 +3151,12 @@ get_block_size()
 	echo `stat -f -c %S $1`
 }
 
+get_page_size()
+{
+	echo $(getconf PAGE_SIZE)
+}
+
+
 init_rc
 
 ################################################################################
-- 
2.1.0

