Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26130 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaAMNHU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 08:07:20 -0500
From: Anand Jain <anand.jain@oracle.com>
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] xfstest: tests btrfs/006 fails with mixed-mode/small disks
Date: Mon, 13 Jan 2014 21:16:30 +0800
Message-Id: <1389618990-24544-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
References: <1389618990-24544-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <Anand.Jain@oracle.com>

as of now the script does not filter 0.00 size  in the
filesystem show output, which is the case in multi-disk
mixed-mode (that is default group type for small disks)

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 common/filter       | 6 ++++++
 common/filter.btrfs | 1 +
 2 files changed, 7 insertions(+)

diff --git a/common/filter b/common/filter
index c872a27..04d12c4 100644
--- a/common/filter
+++ b/common/filter
@@ -277,6 +277,12 @@ _filter_uuid()
 	fi
 }
 
+# In mixed group the added disks may have zero used size
+_filter_zero_size()
+{
+	sed -e "s/0\.00/<SIZE>/g"
+}
+
 # Filter out sizes like 6.14MB etc
 _filter_size()
 {
diff --git a/common/filter.btrfs b/common/filter.btrfs
index 29512cd..75853f2 100644
--- a/common/filter.btrfs
+++ b/common/filter.btrfs
@@ -33,6 +33,7 @@ _filter_btrfs_filesystem_show()
 	# the uniq collapses all device lines into 1
 	_filter_uuid $UUID | _filter_scratch | _filter_scratch_pool | \
 	_filter_size | _filter_btrfs_version | _filter_devid | \
+	_filter_zero_size | \
 	sed -e "s/\(Total devices\) $NUMDEVS/\1 $NUM_SUBST/g" | \
 	uniq
 }
-- 
1.8.4.2

