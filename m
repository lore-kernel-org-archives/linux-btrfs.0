Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:37269 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759495Ab2HXN7H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 09:59:07 -0400
Received: from venice.bhome (151.24.44.165) by smtp206.alice.it (8.6.023.02) (authenticated as kreijack@alice.it)
        id 500F3F95054669C2 for linux-btrfs@vger.kernel.org; Fri, 24 Aug 2012 15:59:06 +0200
Subject: [PATCH v1 4/4] Btrfs sysfs support documentation.
To: linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Fri, 24 Aug 2012 15:59:50 +0200
Message-ID: <20120824135935.20478.6629.stgit@venice.bhome>
In-Reply-To: <20120824135322.20478.88578.stgit@venice.bhome>
References: <20120824135322.20478.88578.stgit@venice.bhome>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Update of the Documentation/filesystes/btrfs.txt file.

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
---
 0 files changed

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 7671352..35840ab 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -89,3 +89,78 @@ btrfsck: do a limited check of the FS extent trees.
 btrfs-debug-tree: print all of the FS metadata in text form.  Example:
 
 	btrfs-debug-tree /dev/sda2 >& big_output_file
+
+
+
+	SYSFS SUPPORT
+	=============
+
+If the option CONFIG_BTRFS_FS_SYSFS is enabled, BTRFS exports some 
+information via the sysfs filesystem.
+Todate these information are read-only.
+
+The information exported are related to both the devices and the filesystems.
+When a devices is registred (for example via the btrfs filesystem scan 
+command), BTRFS creates the following entries under /sys/fs/btrfs:
+
+/sys/fs/btrfs:
+
+	- devices			-> information per device basis
+	- filesystem			-> information per filesystem basis
+
+/sys/fs/btrfs/devices/<device-UUID>:
+
+	- bytes_used
+	- devid
+	- disk_total_bytes
+	- fsid				-> fielsystem UUID
+	- generation
+	- major				[*]
+	- minor				[*]
+	- missing
+	- name				-> device name (eg: /dev/sda)
+	- total_bytes
+	- write_errors			-> error info
+	- corruption_errors		-> error info
+	- read_errors			-> error info
+	- generation_errors		-> error info
+	- flush_errors			-> error info
+	- writeable
+
+[*] These information are available only after the mounting of the
+filesystem.
+
+/sys/fs/btrfs/filesystem/<filesystem-UUID>/fs_info:
+
+	- balance_cancel_req		-> balance status information
+	- balance_pause_req		-> balance status information
+	- balance_running		-> balance status information
+	- fs_state
+	- generation
+	- label				-> label of the filesystem
+	- last_trans_committed
+	- scrub_cancel_req		-> scrub status information
+	- scrub_pause_req		-> scrub status information
+	- scrubs_paused			-> scrub status information
+	- scrubs_running		-> scrub status information
+
+/sys/fs/btrfs/filesystem/<filesystem-UUID>/fs_devices:
+
+	- latest_devid
+	- latest_trans
+	- missing_devices
+	- num_can_discard
+	- open_devices
+	- opened
+	- rw_devices
+	- seeding
+	- total_rw_bytes
+
+The filesystems information are split in two section (fs_info and fs_devices)
+because the fs_devices entries are available after the scan of the device(s),
+but the fs_info entries are available only after the mount of the 
+filesystem.
+
+The link between the filesystem and the device(s) is the fsid == 
+filesystem-UUID.
+

